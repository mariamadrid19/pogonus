#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name sort_map
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH -o sort_map.%j.out
#SBATCH -A lp_svbelleghem

cd /scratch/leuven/357/vsc35707/dudzele_pogonus/HAP-1

conda activate thesis #this is where seqkit is 

#sort the scaffolds by size
seqkit sort --by-length --reverse yahs.out_scaffolds_final.fa > dh1_sorted_scaffolds.fasta

#obtain the first 50 scaffolds 
awk '/^>/ { if (count++ >= 50) exit } { print }' dh1_sorted_scaffolds.fasta > dh1_50_scaffolds.fasta

#check how many scaffolds were extracted
grep -c "^>" dh1_50_scaffolds.fasta
