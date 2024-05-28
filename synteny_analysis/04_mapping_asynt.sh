#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name asynt_map
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=48:00:00
#SBATCH -o asynt_map.%j.out
#SBATCH -A lp_svbelleghem

module load SAMtools/1.13-GCC-10.3.0
conda activate thesis

samtools faidx LG01_dud.fasta
samtools faidx LG02_dud.fasta
samtools faidx LG03_dud.fasta
samtools faidx LG04_dud.fasta
samtools faidx LG05_dud.fasta
samtools faidx LG10_dud.fasta

samtools faidx LG01_nieu.fasta
samtools faidx LG02_nieu.fasta
samtools faidx LG03_nieu.fasta
samtools faidx LG04_nieu.fasta
samtools faidx LG05_nieu.fasta
samtools faidx LG10_nieu.fasta

#extract regions Dudzele
samtools faidx LG01_dud.fasta CM008230.1_RagTag:74064473-103390037 > scaffold_B_dud.fasta
samtools faidx LG02_dud.fasta CM008233.1_RagTag:3681807-34037187 > scaffold_C_dud.fasta
samtools faidx LG02_dud.fasta CM008233.1_RagTag:34117388-72878678 > scaffold_D_dud.fasta
samtools faidx LG03_dud.fasta CM008234.1_RagTag:22340581-46000200 > scaffold_E_dud.fasta
samtools faidx LG04_dud.fasta CM008235.1_RagTag:13335419-33377731 > scaffold_F_dud.fasta
samtools faidx LG05_dud.fasta CM008236.1_RagTag:24993515-44107433 > scaffold_G_dud.fasta
samtools faidx LG10_dud.fasta CM008231.1_RagTag:3638244-23453803 > scaffold_H_dud.fasta

#extract regions Nieuwpoort
samtools faidx LG01_nieu.fasta CM008230.1_RagTag:54672198-93883070 > scaffold_A_nieu.fasta
samtools faidx LG01_nieu.fasta CM008230.1_RagTag:120572473-153501276 > scaffold_B_nieu.fasta
samtools faidx LG02_nieu.fasta CM008233.1_RagTag:7103728-45349787 > scaffold_C_nieu.fasta
samtools faidx LG02_nieu.fasta CM008233.1_RagTag:45472388-79512942 > scaffold_D_nieu.fasta
samtools faidx LG03_nieu.fasta CM008234.1_RagTag:43076330-84460820 > scaffold_E_nieu.fasta
samtools faidx LG04_nieu.fasta CM008235.1_RagTag:24298258-52146979 > scaffold_F_nieu.fasta
samtools faidx LG05_nieu.fasta CM008236.1_RagTag:26270178-54329264 > scaffold_G_nieu.fasta
samtools faidx LG10_nieu.fasta CM008231.1_RagTag:957591-23831487 > scaffold_H_nieu.fasta

samtools faidx scaffold_A_dud.fa 
samtools faidx scaffold_B_dud.fa 
samtools faidx scaffold_C_dud.fa 
samtools faidx scaffold_D_dud.fa 
samtools faidx scaffold_E_dud.fa 
samtools faidx scaffold_F_dud.fa
samtools faidx scaffold_G_dud.fa 
samtools faidx scaffold_H_dud.fa 

samtools faidx scaffold_A_nieu.fa
samtools faidx scaffold_B_nieu.fa
samtools faidx scaffold_C_nieu.fa
samtools faidx scaffold_D_nieu.fa
samtools faidx scaffold_E_nieu.fa
samtools faidx scaffold_F_nieu.fa
samtools faidx scaffold_G_nieu.fa
samtools faidx scaffold_H_nieu.fa

minimap2 -x asm10 scaffold_A_dud.fa scaffold_A_nieu.fa | gzip > scaffold_A.paf.gz
minimap2 -x asm10 scaffold_B_dud.fa scaffold_A_nieu.fa | gzip > scaffold_B.paf.gz
minimap2 -x asm10 scaffold_C_dud.fa scaffold_A_nieu.fa | gzip > scaffold_C.paf.gz
minimap2 -x asm10 scaffold_D_dud.fa scaffold_A_nieu.fa | gzip > scaffold_D.paf.gz
minimap2 -x asm10 scaffold_E_dud.fa scaffold_A_nieu.fa | gzip > scaffold_E.paf.gz
minimap2 -x asm10 scaffold_F_dud.fa scaffold_A_nieu.fa | gzip > scaffold_F.paf.gz
minimap2 -x asm10 scaffold_G_dud.fa scaffold_A_nieu.fa | gzip > scaffold_G.paf.gz
minimap2 -x asm10 scaffold_H_dud.fa scaffold_A_nieu.fa | gzip > scaffold_H.paf.gz
