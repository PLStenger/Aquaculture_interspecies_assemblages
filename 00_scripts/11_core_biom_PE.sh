#!/usr/bin/env bash

WORKING_DIRECTORY=/scratch_vol1/fungi/Aquaculture_interspecies_assemblages/05_QIIME2
OUTPUT=/scratch_vol1/fungi/Aquaculture_interspecies_assemblages/05_QIIME2/visual

DATABASE=/scratch_vol1/fungi/Aquaculture_interspecies_assemblages/98_database_files
TMPDIR=/scratch_vol1

###############################################################
### For Bacteria
###############################################################

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p subtables
mkdir -p export/subtables

# I'm doing this step in order to deal the no space left in cluster :
export TMPDIR='/scratch_vol1/fungi'
echo $TMPDIR

# Aim: Filter sample from table based on a feature table or metadata

qiime feature-table filter-samples \
        --i-table core/RarTable.qza \
        --m-metadata-file $DATABASE/sample-metadata.tsv \
        --p-where "[#SampleID] IN ('Hm105', 'Hm106', 'Hm107', 'Hm108', 'Hm109', 'Hm110', 'Hm112', 'Hm113', 'Hm114', 'Hm115', 'Hm11', 'Hm12', 'Hm13', 'Hm14', 'Hm15', 'Hm16', 'Hm18', 'Hm1', 'Hm20', 'Hm21', 'Hm22', 'Hm23', 'Hm26', 'Hm27', 'Hm28', 'Hm2', 'Hm30', 'Hm31', 'Hm32', 'Hm33', 'Hm34', 'Hm35', 'Hm36', 'Hm37', 'Hm39', 'Hm3', 'Hm40', 'Hm41', 'Hm43', 'Hm44', 'Hm45', 'Hm46', 'Hm47', 'Hm48', 'Hm49', 'Hm4', 'Hm50', 'Hm51', 'Hm52', 'Hm53', 'Hm54', 'Hm55', 'Hm56', 'Hm57', 'Hm5', 'Hm68', 'Hm69', 'Hm6', 'Hm70', 'Hm71', 'Hm72', 'Hm73', 'Hm74', 'Hm75', 'Hm85', 'Hm86', 'Hm87', 'Hm88', 'Hm89', 'Hm8', 'Hm90', 'Hm91', 'Hm92', 'Hm93', 'Hm94', 'Hm9', 'Hm', 'LC10', 'LC11', 'LC12', 'LC13', 'LC14', 'LC15', 'LC16', 'LC17', 'LC18', 'LC19', 'LC20', 'LC21', 'LC22', 'LC23', 'LC24', 'LC25', 'LC26', 'LC27', 'LC28', 'LC29', 'LC2', 'LC30', 'LC3', 'LC4', 'LC5', 'LC6', 'LC8', 'LC9', 'T1-B-BMa01', 'T1-B-BMa02', 'T1-B-BMa03', 'T1-B-BMa04', 'T1-B-BMa06', 'T1-B-BMa07', 'T1-B-BMa08', 'T1-B-BMa09', 'T1-B-BMa10', 'T1-CB-BMa01', 'T1-CB-BMa03', 'T1-CB-BMa04', 'T1-CB-BMa06', 'T1-CB-BMa07', 'T1-CB-BMa08', 'T1-CB-BMa09', 'T1-CHB-BMa01', 'T1-CHB-BMa02', 'T1-CHB-BMa03', 'T1-CHB-BMa04', 'T1-CHB-BMa06', 'T1-CHB-BMa07', 'T1-CHB-BMa08', 'T1-CHB-BMa09', 'T1-CHB-BMa10')"  \
        --o-filtered-table subtables/RarTable-all.qza
 
# Aim: Identify "core" features, which are features observed,
     # in a user-defined fraction of the samples
        
qiime feature-table core-features \
        --i-table subtables/RarTable-all.qza \
        --p-min-fraction 0.1 \
        --p-max-fraction 1.0 \
        --p-steps 10 \
        --o-visualization visual/CoreBiom-all.qzv  
        
qiime tools export --input-path subtables/RarTable-all.qza --output-path export/subtables/RarTable-all    
qiime tools export --input-path visual/CoreBiom-all.qzv --output-path export/visual/CoreBiom-all
biom convert -i export/subtables/RarTable-all/feature-table.biom -o export/subtables/RarTable-all/table-from-biom.tsv --to-tsv
sed '1d ; s/\#OTU ID/ASV_ID/' export/subtables/RarTable-all/table-from-biom.tsv > export/subtables/RarTable-all/ASV.tsv
