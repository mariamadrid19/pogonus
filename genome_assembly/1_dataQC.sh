#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name dataqc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=10:00:00
#SBATCH -o qc.%j.out
#SBATCH -A lp_svbelleghem

cd /scratch/leuven/357/vsc35707/pogonus/reads/Pogonus_PACBIO_DNA/Dudzele_PacBio_D002_L13

conda activate thesis

#this will generate a HiFi-only BAM from a reads.bam file since the current reads.bam file still has many copies of each fragment from the circular sequencing
extracthifi m64279e_231107_135307.reads.bam POG_HiFi_reads.bam

#this generate an index file that enables random access into PacBio BAM files. This index is needed to generate the fastq.gz file
pbindex POG_HiFi_reads.bam

#this will generate a fastq.gz file from the hifi_reads.bam file
bam2fastq -o POG_HiFi_reads POG_HiFi_reads.bam

#reads.bam is 200Gb
#HiFi_reads.bam is 100Gb

module load FastQC/0.11.8-Java-1.8.0_162

#this will run fastqc on the newly extracted HiFi reads
fastqc POG_HiFi_reads.fastq.gz -t 32

#takes between 3 and 4 hours to run
