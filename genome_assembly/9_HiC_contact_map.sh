#! /bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name PretextMap
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --time=12:00:00
#SBATCH -o pretext.%j.out
#SBATCH -A lp_svbelleghem

conda activate thesis

# this uses the final bam file produced by the second mapping (to the scaffolded assembly) to produce a PRETEXT map that will be visualized in PretextView
samtools view -h deduplicated_files/Pogonus_chalceus_map_scaffolds_r.bam | PretextMap -o Pogonus_mapped.pretext --sortby length --mapq 20 --highRes
