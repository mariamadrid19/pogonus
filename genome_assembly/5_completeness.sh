#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name compleasm
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=24:00:00
#SBATCH -o compleasm.%j.out
#SBATCH -A lp_svbelleghem

conda activate compleasm 

compleasm run -a /scratch/leuven/357/vsc35707/pogonus/hifiasm/Pogonus_hifiasm.asm.hic.p_ctg.fa -o results/ -l insecta_odb10 -t 32

conda activate thesis

quast /scratch/leuven/357/vsc35707/pogonus/hifiasm/Pogonus_hifiasm.asm.hic.p_ctg.fa -t 12
