#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
%prog <REF> <BAM> <INT q> <INT n> 

Discover Context-Specific Sequencing Errors.

<REF>        Reference genome 
<BAM>        BAM file
<INT q>      Length of <q>-gram to search for
<INT n>      Maximal allowed number of Ns that the <q>-gram contains

For more details, see:

Manuel Allhoff, Alexander Schoenhuth, Marcel Martin, Ivan G. Costa, 
Sven Rahmann and Tobias Marschall.
Discovering Context-Specific Sequencing Errors. 
BMC Bioinformatics, 2013. Accepted, in press

Author: Manuel Allhoff
"""

from __future__ import print_function
from optparse import OptionParser
import math, sys, HTSeq, pysam, re
import scipy.misc as sc
import rpy2.robjects as robjects


class HelpfulOptionParser(OptionParser):
    """An OptionParser that prints full help on errors."""
    def error(self, msg):
        self.print_help(sys.stderr)
        self.exit(2, "\n%s: error: %s\n" % (self.get_prog_name(), msg))


def get_annotate_qgram(genome, genome_annotate, q):
    """Compute for each q-gram in the genome its (composed) strand bias table. 
    Consider therefore the q-gram as well as its reverse complement."""
    #consider separately pileups of q-grams last and first positions
    qgram_last = {}
    qgram_first = {}
    j = 0 #counter for status info

    #pass through entire genome to analyse each q-grams' pileup
    for i in range(len(genome) - q):
        j += 1
        if j % 20000000 == 0: 
            print('%s / %s positions considered for q-gram annotation' %(j, len(genome)), file=sys.stderr)
        
        qgram = genome [i : i+q]
        
        qgram_effect_last = genome_annotate[i + q][:] 
        
        #q-grams on forward direction, analyse therefore their last positions
        qgram_last[qgram] = _add_listelements(qgram_last[qgram], qgram_effect_last) if qgram_last.has_key(qgram) else qgram_effect_last
        
        #q-gram on reverse strand, analyse therefore their first positions. Furthermore, switch read direction
        tmp = genome_annotate[i][:]
        qgram_effect_first = [tmp[1], tmp[0], tmp[3], tmp[2]]  
        qgram_first[qgram] = _add_listelements(qgram_first[qgram], qgram_effect_first) if qgram_first.has_key(qgram) else qgram_effect_first
        
    #combine the q-grams on the forward and reverse strand
    qgram_annotate = {}
    for qgram in qgram_last:
        qgram_annotate[qgram] = qgram_last[qgram]
        qgram_rev = reverse_complement(qgram)
        if qgram_rev in qgram_first:
            result = qgram_annotate[qgram][:]
            result = _add_listelements(result, qgram_first[qgram_rev])
            qgram_annotate[qgram] = result
    
    return qgram_annotate


def reverse_complement(s, rev=True):
    """Return the reverse complement of a DNA sequence s"""
    _complement = dict(A="T", T="A", C="G", G="C", N="N")
    t = reversed(s) if rev else s
    try:
        rc = (_complement[x] for x in t)  # lazy generator expression
    except KeyError:
        return s
        
    return "".join(rc)  # join the elements into a string


def get_pvalue(forward_match, reverse_match, forward_mismatch, reverse_mismatch):
    """Return p-value of given Strand Bias Table"""
        #decide whether Fisher's exact Test or ChiSq-Test should be used
    if forward_match > 5000 or reverse_match > 5000 or forward_mismatch > 5000 or reverse_mismatch > 5000:
        f = robjects.r['chisq.test']
        test = 'chisq'
    else:
        f = robjects.r['fisher.test']
        test = 'fisher'
    
    matrix = [forward_match, reverse_match, forward_mismatch, reverse_mismatch]
    table = robjects.r.matrix(robjects.IntVector(matrix), nrow=2)
    p_value_tmp = f(table)[0] if test == 'fisher' else f(table)[2]
    p_value = tuple(p_value_tmp)[0] #some necessary magic for r object
    return p_value


def get_genome(ref_path):
    """Return genome for random access"""
    fasta_dict = dict( (s.name, s) for s in HTSeq.FastaReader(ref_path))
    keys = fasta_dict.keys()
    genome = fasta_dict[keys[0]]
    return str(genome)


def get_annotate_genome(genome, bampath):
    """Return strand bias table for each genome position on the base of the alignment. 
    The table is represented as a list: 
    [forward match, reverse match, forward mismatch, reverse mismatch]."""
    cigar_codes = {'M':0, 'I':1, 'D':2, 'N':3, 'S':4, 'H':5, 'P':6}
    samfile = pysam.Samfile(bampath, "rb")
    g_annotate = [] #list of strand bias tables for each genome position

    #initialize
    for i in range(len(genome)):
        g_annotate.append([0,0,0,0]) #mf, mr, mmf, mmr
    
    j = 0 #counter for status info
    #consider each read
    for read in samfile.fetch():
        if read.is_unmapped:
            continue
        j += 1
        ref_pos = read.pos
        if j % 100000 == 0: 
            print('%s reads considered for genome annotation ' %j, file=sys.stderr)

#        if ref_pos > 9000: break
        
        #analyse CIGAR string to consecutively compute strand bias tables
        if read.cigar is not None:
            bias, current_pos_ref, current_pos_read = 0, 0, 0 
            for code, length in read.cigar:
                if code is cigar_codes['S']:
                    current_pos_read += length
                elif code is cigar_codes['M']:
                    if read.is_reverse:
                        for i in range(length):
                            pos = ref_pos + bias + current_pos_ref + i
                            if read.seq[i + current_pos_read + bias] == genome[pos]:
                                g_annotate[pos][1] += 1
                            else:
                                g_annotate[pos][3] += 1
                    else:
                        for i in range(length):
                            pos = ref_pos + bias + current_pos_ref + i
                            if read.seq[i + current_pos_read + bias] == genome[pos]:
                                g_annotate[pos][0] += 1
                            else:
                                g_annotate[pos][2] += 1
                    bias += length
                elif code is cigar_codes['I']: 
                    current_pos_read += length
                elif code is cigar_codes['D']: 
                    current_pos_ref += length
                else:
                    print(code, length, file=sys.stderr)
                    
    return g_annotate


def add_n(qgram_annotate, n, q):
    """Extend qgram_annotate by adding q-grams which contain Ns."""
    to_add = {}
    if n == 0:
        print('No q-grams with Ns to add' , file = sys.stderr)
        return qgram_annotate

    i = 0 #counter for status info    
    #consider each possible q-gram for the given length q and number n
    for qgram_with_n in _get_all_qgrams(['A','C','G','T','N'], ['A','C','G','T','N'], q, 1, n):
        qgram_with_n = qgram_with_n[0] #q-gram that contain at least one and at most n Ns
        i += 1
        if i % 20000000 == 0: 
            print(' %s q-grams with N considered' %(i), file = sys.stderr)

        #compute all concrete q-grams of n_qgram
        possible_qgrams = get_qgramlist(qgram_with_n)
        sb_table = [0,0,0,0] #initialize strand bias table
        for p_qgram in possible_qgrams:
            if qgram_annotate.has_key(p_qgram):
                sb_table = _add_listelements(sb_table, qgram_annotate[p_qgram][:])
        
        #does n containing q-gram corresponds to a combosed strand bias table?
        if sb_table != [0,0,0,0]: 
            to_add[qgram_with_n] = sb_table

    #extend qgram_annotate
    qgram_annotate.update(to_add)
    
    return qgram_annotate


def _add_listelements(a, b):
    """Add i-th element of list a and list b"""
    for i in range(len(a)):
        a[i] += b[i]
    
    return a


def get_qgramlist(qgram_with_n):
    """Return list of all possible q-grams for q-grams which contain Ns"""
    if qgram_with_n.count("N")==0:
        return [qgram_with_n]
    return _get_qgramlist_help(qgram_with_n, [])


def _get_qgramlist_help(qgram, result):
    """Substitute N with A, C, G or T and return resulting q-grams"""
    if qgram.count('N') == 0:
        result.append(qgram)
    else:
        i = qgram.index("N")
        for n in ['A','C','G','T']:
            new_qgram = qgram[:i] + n + qgram[i+1:]
            _get_qgramlist_help(new_qgram, result)
        return result


def _get_all_qgrams(alphabet, erg, length, level, n):
    """Return all possible q-grams of the given length, over the given alphabet
    and with at least one and at most n Ns"""
    if length == level:
        yield erg
    else:
        for letter in alphabet:
            for el in erg:
                #not too many Ns
                if letter == 'N' and el.count('N') >= n:
                    continue
                #not too less Ns
                if length - level <= 1 and el.count('N') == 0 and letter != 'N':
                    continue

                for r in _get_all_qgrams(alphabet, [el + letter], length, level+1, n):
                    yield r


def get_sb_score(qgram_annotate):
    """Calculate Strand Bias score (based on p-value) for each q-gram"""
    results = []
    i = 0 #counter for status info
    print('Start Strand Bias Score calculation', file=sys.stderr)
    for k in qgram_annotate.keys():
        i += 1
        if i % 1000000 == 0: 
            print(" %s / %s Strand Bias Scores calculated" %(i, len(qgram_annotate.keys())))
        
        #get p-value for the strand bias table of q-gram k
        p_value = get_pvalue(qgram_annotate[k][0], qgram_annotate[k][1], qgram_annotate[k][2], qgram_annotate[k][3])
        
        #compute negative logarithm (base 10) of p-value or, if necessary, set to maxint
        strand_bias_score = sys.maxint if p_value < 1/10.0**300 else -math.log(p_value, 10)
        
        results.append((k, qgram_annotate[k][0], qgram_annotate[k][1], qgram_annotate[k][2], qgram_annotate[k][3], strand_bias_score))
    
    return results


def output(results, genome):
    """Output the results"""
    print("#Sequence", "Occurrence", "Forward Match", "Backward Match", "Forward Mismatch", "Backward Mismatch", "Strand Bias Score", "FER (Forward Error Rate)",
          "RER (Reverse Error Rate), ERD (Error rate Difference)", sep = '\t')
    
    for seq, forward_match, reverse_match, forward_mismatch, reverse_mismatch, sb_score, fer, rer, erd in results:
        occ = count(seq, genome)
        print(seq, occ, forward_match, reverse_match, forward_mismatch, reverse_mismatch, sb_score, fer, rer, erd, sep = '\t')


def get_motifspace_size(q,n):
    """return length of search space according to equation which is mentioned in Section 3.1 of the paper"""
    return reduce(lambda x, y: x + (int(sc.comb(q, y, exact=True)) * 4**(q-y)), [i for i in range(1, n+1)], int(sc.comb(q, 0, exact=True)) * 4**(q-0))

def count(qgram, genome):
    """Count number of q-grams and its reverse complement in genome"""
    rev = reverse_complement(qgram)
    rev = rev.replace('N', '.')
    qgram = qgram.replace('N', '.')
    
    return  len([m.start() for m in re.finditer(r'(?=(%s))' %qgram, genome)] + [m.start() for m in re.finditer(r'(?=(%s))' %rev, genome)])

def ident(genome, genome_annotate, q, n, alpha=0.05, epsilon=0.03, delta=0.05):
    """Identify critical <q>-grams (with <n> Ns) with reference to significance and error rate"""
    results = []
    
    motifspacesize_log = math.log(get_motifspace_size(q, n), 10)
    alpha_log = math.log(alpha, 10)
    
    qgram_annotate = get_annotate_qgram(genome, genome_annotate, q) #annotate each q-gram with Strand Bias Table
    add_n(qgram_annotate, n, q) #extend set of q-grams with q-grams containing Ns
    
    all_results = get_sb_score(qgram_annotate) #annotate each q-gram with Strand Bias Score

    sig_results = filter(lambda x: x[5] > motifspacesize_log - alpha_log, all_results) #filter statistically significant motifs (Bonferroni Correction)

    #filter motifs with regards to background error rate (epsilon) error rate difference (delta)
    for seq, forward_match, reverse_match, forward_mismatch, reverse_mismatch, p_value_score in sig_results:
        fer = float(forward_mismatch) / (forward_match + forward_mismatch) #forward error rate
        rer = float(reverse_mismatch) / (reverse_match + reverse_mismatch) #reverse error rate
        if rer < epsilon: #filter sequences with too high epsilon (background error rate)
            erd = fer - rer #error rate difference
            if erd >= delta: #filter sequences with too low delta (error rate difference cutoff)
                results.append((seq, forward_match, reverse_match, forward_mismatch, reverse_mismatch, p_value_score, fer, rer, erd)) 
            
    results.sort(key=lambda x: x[8],reverse=True) #sort by erd (error rate difference)
    
    output(results, genome)


if __name__ == '__main__':
    parser = HelpfulOptionParser(usage=__doc__)    
    
    parser.add_option("-a", dest="alpha", default=0.05, help="FWER (family-wise error rate) alpha, default: 0.05")
    parser.add_option("-e", dest="epsilon", default=0.03, help="Background error rate cutoff epsilon, default: 0.03")
    parser.add_option("-d", dest="delta", default=0.05, help="Error rate difference cutoff delta, default: 0.05")
    
    (options, args) = parser.parse_args()

    if len(args) != 4:
        parser.error("Sorry, exactly four parameters are required.")  
    
    refpath = args[0]
    bampath = args[1]
    q = int(args[2])
    n = int(args[3])

    genome = get_genome(refpath)
    genome_annotate = get_annotate_genome(genome, bampath)

    ident(genome, genome_annotate, q, n, options.alpha, options.epsilon, options.delta)

