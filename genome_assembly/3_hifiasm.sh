#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name POG_hifiasm
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=32
#SBATCH --time=36:00:00
#SBATCH -o hifiasm.%j.out
#SBATCH -A lp_svbelleghem

cd /scratch/leuven/357/vsc35707/pogonus/hifiasm

#assembly
#homozygous coverage obtained from second peak of the k-mer plot (twice the heterozygous peak) generated by jellyfish
hifiasm -o Pogonus_hifiasm.asm --n-hap 2 --hom-cov 50 -t 32 --h1 GC143248_ACTCTCGA-TGGTACAG_S65_L001_R1_001.fastq.gz --h2 GC143248_ACTCTCGA-TGGTACAG_S65_L001_R2_001.fastq.gz POG_HiFi_reads.fastq.gz

#gfa_to_fasta
awk '/^S/{print ">"$2"\n"$3}' Pogonus_hifiasm.asm.hic.p_ctg.gfa | fold > Pogonus_hifiasm.asm.hic.p_ctg.fa
