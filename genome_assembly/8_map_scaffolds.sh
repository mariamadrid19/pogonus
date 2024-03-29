#! /bin/bash -l
#SBATCH --cluster=genius
#SBATCH --job-name map_scaffolds
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=20
#SBATCH --time=48:00:00
#SBATCH -o map_scaffolds.%j.out
#SBATCH -A lp_svbelleghem

# This pipeline is modified from ArimaGenomics (arima_mapping_pipeline.sh)
# https://github.com/ArimaGenomics/mapping_pipeline/blob/master/arima_mapping_pipeline.sh

##############################################
# ARIMA GENOMICS MAPPING PIPELINE 07/26/2023 #
##############################################

# Below find the commands used to map HiC data to the scaffolds (output from yahs)
# This bash script will map one paired end HiC dataset (read1 & R) to the output of the scaffolding step (yahs.out_scaffolds_final.fa)

##########################################
# Commands #
##########################################

SRA='GC143248_ACTCTCGA-TGGTACAG_S65'
LABEL='Pogonus_chalceus_map_scaffolds'
IN_DIR='/scratch/leuven/357/vsc35707/dudzele_pogonus/hifiasm/'
REF='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/yahs.out_scaffolds_final.fa'
FAIDX='$REF.fai'
PREFIX='yahs.out_scaffolds_final.fa'
RAW_DIR='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/bams'
FILT_DIR='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/filtered_bams'
FILTER='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/filter_five_end.pl'
COMBINER='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/two_read_bam_combiner.pl'
STATS='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/get_stats.pl'
TMP_DIR='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/temporary_files'
PAIR_DIR='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/paired_bams'
REP_DIR='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/deduplicated_files'
REP_LABEL=${LABEL}_r
MERGE_DIR='/scratch/leuven/357/vsc35707/dudzele_pogonus/map_scaffolds/final_merged_alignments'
MAPQ_FILTER=10
CPU=20

# Important to first activate the conda environment where bwa and samtools are installed
# /data/leuven/357/vsc35707/miniconda3/envs/thesis/bin/
source /data/leuven/357/vsc35707/miniconda3/etc/profile.d/conda.sh
conda activate thesis 

#load picard module
module load picard/2.18.23-Java-1.8.0_171
#to run picard, use java -jar $EBROOTPICARD/picard.jar

echo "### Step 0: Check output directories' existence & create them as needed"
[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $FILT_DIR ] || mkdir -p $FILT_DIR
[ -d $TMP_DIR ] || mkdir -p $TMP_DIR
[ -d $PAIR_DIR ] || mkdir -p $PAIR_DIR
[ -d $REP_DIR ] || mkdir -p $REP_DIR
[ -d $MERGE_DIR ] || mkdir -p $MERGE_DIR

echo "### Step 0: Index reference" # Run only once! Skip this step if you have already generated BWA index files
bwa index -a bwtsw -p $PREFIX $REF

#debugged using strace bwa mem -t $CPU $REF $IN_DIR/${SRA}_R1.fastq
#error was coming from a wrongly named file (was .bwt should've been .fa.bwt)
echo "### Step 1.A: FASTQ to BAM (1st)"
bwa mem -t $CPU $REF $IN_DIR/${SRA}_R1.fastq | samtools view -@ $CPU -Sb - > $RAW_DIR/${SRA}_1.bam

echo "### Step 1.B: FASTQ to BAM (2nd)"
bwa mem -t $CPU $REF $IN_DIR/${SRA}_R2.fastq | samtools view -@ $CPU -Sb - > $RAW_DIR/${SRA}_2.bam

echo "### Step 2.A: Filter 5' end (1st)"
samtools view -h $RAW_DIR/${SRA}_1.bam | perl $FILTER | samtools view -Sb - > $FILT_DIR/${SRA}_1.bam

echo "### Step 2.B: Filter 5' end (2nd)"
samtools view -h $RAW_DIR/${SRA}_2.bam | perl $FILTER | samtools view -Sb - > $FILT_DIR/${SRA}_2.bam

echo "### Step 3A: Pair reads & mapping quality filter"
perl $COMBINER $FILT_DIR/${SRA}_1.bam $FILT_DIR/${SRA}_2.bam samtools $MAPQ_FILTER | samtools view -bS -t $FAIDX - | samtools sort -@ $CPU -o $TMP_DIR/$SRA.bam -

echo "### Step 3.B: Add read group"
java -Xmx4G -Djava.io.tmpdir=temp/ -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups INPUT=$TMP_DIR/$SRA.bam OUTPUT=$PAIR_DIR/$SRA.bam ID=$SRA LB=$SRA SM=$LABEL PL=PACBIO PU=none

echo "### Step 4: Mark duplicates"
java -Xmx30G -XX:-UseGCOverheadLimit -Djava.io.tmpdir=temp/ -jar $EBROOTPICARD/picard.jar MarkDuplicates INPUT=$PAIR_DIR/$SRA.bam OUTPUT=$REP_DIR/$REP_LABEL.bam METRICS_FILE=$REP_DIR/metrics.$REP_LABEL.txt TMP_DIR=$TMP_DIR ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT REMOVE_DUPLICATES=TRUE

samtools index $REP_DIR/$REP_LABEL.bam

perl $STATS $REP_DIR/$REP_LABEL.bam > $REP_DIR/$REP_LABEL.bam.stats

echo "Finished Mapping Pipeline through Duplicate Removal"
