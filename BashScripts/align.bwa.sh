#Avinash Ramu, Conrad Lab, WUSTL
#Pipeline for aligning paired end reads using BWA, the reference is hs37d5.fa which is the reference used in the 1000 genomes project phase 2. The number of threads is set to $nthreads so request resources accordingly with qsub. Also the memory required has to be atleast 1.25 * N bytes where N is the length of the reference(see sampe -P). 
#Arg1 - first paired end fastq file(fwd ?)
#Arg1 - second paired end fastq file(rev ?)
#Arg3 - name of the sample, used to name output file and also sample information tag in the alignment. GATK requires RG information.
#Output - Arg[1,2].sai files for each of the fastq files
#         Arg3.sam file from the sampe command
#         Arg3.bam from samtools view
#         Arg3.sorted.bam from samtools sort, the final output.
bwa=~/bin/bwa

fastqp1=$1
fastqp2=$2
sampleName=$3
sai1=$fastqp1".sai"
sai2=$fastqp2".sai"
nthreads=8
ref=~/Dat/ref/hs37d5.fa
sampeOptions=-P #reduces number of disk i/o, requires 1.25 * N bytes of memory, N is the length of the reference the reads are being aligned to.
RGinfo='@RG\tID:'$sampleName'\tSM:'$sampleName

echo $fastqp1
echo $fastqp2
echo $RGinfo


$bwa aln -t $nthreads $ref $fastqp1 > $sai1
$bwa aln -t $nthreads $ref $fastqp2 > $sai2

$bwa sampe $sampeOptions $index $sai1 $sai2 $fastqp1 $fastqp2 -r $RGinfo  > $sampleName".sam"

samtools view -bS $sampleName".sam" > $sampleName".bam"

samtools sort $sampleName".bam" > $sampleName".sorted"