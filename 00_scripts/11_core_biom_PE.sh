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
        --p-where "[#SampleID] IN ('Bourake_Rhabdastrella_globostellata_2019_1_V1V3', 'Bourake_Rhabdastrella_globostellata_2019_2_V1V3', 'Bourake_Rhabdastrella_globostellata_2019_3_V1V3', 'Bourake_Mycale_2019_1_V1V3', 'Bourake_Mycale_2019_2_V1V3', 'Bourake_Mycale_2019_3_V1V3', 'Bourake_SeaWater_downstream_0_2micro_V1V3', 'Bourake_SeaWater_downstream_3micro_V1V3', 'Bourake_SeaWater_upstream_0_2micro_V1V3', 'Bourake_SeaWater_upstream_3micro_V1V3', 'Bourake_sediment_1_V1V3', 'Bourake_sediment_2_V1V3', 'Bourake_sediment_3_V1V3', 'Bourake_silt_1_V1V3', 'Bourake_silt_2_V1V3', 'Bourake_silt_3_V1V3', 'Cafard_island_SeaWater1_3micro_V1V3', 'Cafard_island_transplant_Rhabdastrella_globostellata_2019_12weeks_V1V3', 'Cafard_island_transplant_Rhabdastrella_globostellata_2019_06weeks_V1V3', 'Cafard_island_autochtone_Rhabdastrella_globostellata_2019_V1V3', 'Yate_Rhabdastrella_globostellata_2019_1_V1V3', 'Yate_Rhabdastrella_globostellata_2019_2_V1V3', 'Yate_Rhabdastrella_globostellata_2019_3_V1V3', 'Bourake_Rhabdastrella_globostellata_2019_1_V4', 'Bourake_Rhabdastrella_globostellata_2019_2_V4', 'Bourake_Rhabdastrella_globostellata_2019_3_V4', 'Bourake_Rhabdastrella_globostellata_2019_1_Chimeric_V1V3V4', 'Bourake_Rhabdastrella_globostellata_2019_2_Chimeric_V1V3V4', 'Bourake_Rhabdastrella_globostellata_2019_3_Chimeric_V1V3V4', 'Bourake_Rhabdastrella_globostellata_2018_1_A_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_1_B_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_1_C_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_2_A_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_2_B_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_2_C_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_3_A_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_3_B_V1V3', 'Bourake_Rhabdastrella_globostellata_2018_3_C_V1V3')"  \
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
