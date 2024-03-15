#!/bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name synteny_ntsynt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --time=24:00:00
#SBATCH -o ntsynt_all.%j.out
#SBATCH -A lp_svbelleghem

conda activate ntsynt 

#Multi-genome synteny detection using minimizer graphs
ntSynt -d 20 dh1_50_scaffolds.fasta sorted_dh2.fasta sorted_nh1.fasta sorted_nh2.fasta -p synteny_all_haps -t 24 

# Sort the blocks based on the specified order
python sort_ntsynt_blocks.py --synteny_blocks synteny_all_haps.synteny_blocks.tsv --sort_order dh1_50_scaffolds.fasta.fai sorted_dh1.fasta.fai sorted_nh1.fasta.fai sorted_nh2.fasta.fai --fais > synteny_all_haps.synteny_blocks.sorted.tsv

# Generate the files needed for plotting with gggenomes
python format_blocks_gggenomes.py --fai dh1_50_scaffolds.fasta.fai  sorted_nh1.fasta.fai --prefix ragtag_dh1_nh1 --blocks ragtag_dh1_nh1.synteny_blocks.sorted.tsv --length 100 --colour dh1_50_scaffolds.fasta

cat ragtag_dh1_nh1.links.tsv  | mlr --tsv sort -f strand -n block_id > ragtag_dh1_nh1.links.sorted.tsv && mv ragtag_dh1_nh1.links.sorted.tsv ragtag_dh1_nh1.links.tsv
cat ragtag_dh1_nh1.sequence_lengths.tsv | mlr --tsv sort -f seq_id > ragtag_dh1_nh1.sequence_lengths.sorted.tsv && mv ragtag_dh1_nh1.sequence_lengths.sorted.tsv ragtag_dh1_nh1.sequence_lengths.tsv

#run R script to generate plots
Rscript plot_synteny_blocks_gggenomes.R -s ragtag_dh1_nh1.sequence_lengths.tsv -l ragtag_dh1_nh1.links.tsv --scale 20000000 --p ragtag_dh1_nh1
