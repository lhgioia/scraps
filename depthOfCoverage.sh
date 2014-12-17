!#/bin/bash
#PBS -l nodes=1:ppn=4
#PBS -l mem=7gb
#PBS -l walltime=2:00:00
#PBS -m abe
#PBS -M lhgioia@scripps.edu

# Calculate depth of coverage for many sequencing samples

## i didnt even write the bulk of this...
## thanks to rbagnall of Sydney, Australia who posted the samtools magic and awk one-liner on seqanswers 
## thread: http://seqanswers.com/forums/showthread.php?t=27651
## note: i've had difficulties with just using coverageBed

samtools view -b $sample.bam | coverageBed -abam stdin -b intervals.bed -d > $sample\_per_base_coverage.txt;  ## get number of reads mapped to each base
TOTAL_LENGTH=`wc -l $sample\_per_base_coverage.txt`
echo "Total length of targeted intervals = $TOTAL_LENGTH" > $sample\_depth_of_coverage.txt;
echo -e Number of Reads '\t' Percent Coverage '\t' Number of bases with that many reads mapped >> $sample\_depth_of_coverage.txt;

for i in {1..150};do

BASES_COVERED=`awk '{FS="\t"}{if($5 > "$i") print $0}' per_base_coverage.txt | wc -l`
PERCENT_COVERED=$BASES_COVERED/$TOTAL_LENGTH
echo -e $i '\t' $PERCENT_COVERED '\t' $BASES_COVERED >> $sample\_depth_of_coverage.txt;  ## print number of bases with more than i reads

done
