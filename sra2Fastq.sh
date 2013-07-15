mkdir /tmp/aramu
~/bin/fastq-dump --split-3 $1 -O /tmp/aramu
mv /tmp/aramu/* .
rm -r /tmp/aramu