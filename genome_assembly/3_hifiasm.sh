#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name POG_hifiasm
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=32
#SBATCH --time=36:00:00
#SBATCH -o hifiasm.%j.out
#SBATCH -A lp_svbelleghem

cd /scratch/leuven/357/vsc35707/dudzele_pogonus/Omni_C

mv GC144661_TGAGCTAG-AACCGTTC_S219_L002_R1_001.fastq.gz /scratch/leuven/357/vsc35707/dudzele_pogonus/hifiasm
mv GC144661_TGAGCTAG-AACCGTTC_S219_L002_R2_001.fastq.gz /scratch/leuven/357/vsc35707/dudzele_pogonus/hifiasm

cd /scratch/leuven/357/vsc35707/dudzele_pogonus/hifiasm

gunzip *.fastq.gz

#assembly
#homozygous coverage obtained from second peak of the k-mer plot (twice the heterozygous peak) generated by jellyfish
hifiasm -o Pogonus_hifiasm.asm --n-hap 2 --hom-cov 34 -t 32 --h1 GC144661_TGAGCTAG-AACCGTTC_S219_L002_R1_001.fastq --h2 GC144661_TGAGCTAG-AACCGTTC_S219_L002_R2_001.fastq POG_Nieuwpoort_HiFi_reads.fastq

#gfa_to_fasta
awk '/^S/{print ">"$2;print $3}' Pogonus_hifiasm.asm.hic.p_ctg.gfa > Pogonus_hifiasm.asm.hic.p_ctg.fa
