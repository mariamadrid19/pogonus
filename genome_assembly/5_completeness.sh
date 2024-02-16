#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name compleasm_quast
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=24:00:00
#SBATCH -o compleasm_quast.%j.out
#SBATCH -A lp_svbelleghem

conda activate compleasm 
module load BUSCO/3.0.2-foss-2018a-Python-2.7.14
module load HMMER/3.2.1-foss-2018a

compleasm run -a /scratch/leuven/357/vsc35707/dudzele_pogonus/hifiasm/Pogonus_hifiasm.asm.hic.p_ctg.fa -o results/ -l insecta_odb10 -t 32

conda activate thesis

quast /scratch/leuven/357/vsc35707/dudzele_pogonus/hifiasm/Pogonus_hifiasm.asm.hic.p_ctg.fa -t 12
