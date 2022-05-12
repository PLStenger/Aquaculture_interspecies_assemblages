#!/usr/bin/env bash

WORKING_DIRECTORY=/scratch_vol1/fungi/Rhabdastrella_globostellata_microbiome/05_QIIME2
OUTPUT=/scratch_vol1/fungi/Rhabdastrella_globostellata_microbiome/05_QIIME2/visual

DATABASE=/scratch_vol1/fungi/Rhabdastrella_globostellata_microbiome/98_database_files

cd $WORKING_DIRECTORY

eval "$(conda shell.bash hook)"
conda activate qiime2-2021.4


qiime taxa barplot \
  --i-table core/Table.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv

qiime taxa barplot \
  --i-table core/ConTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_ConRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv
  
qiime taxa barplot \
  --i-table core/RarTable.qza \
  --i-taxonomy taxonomy/taxonomy_reads-per-batch_RarRepSeq.qza \
  --m-metadata-file $DATABASE/sample-metadata.tsv \
  --o-visualization taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq.qzv  
  
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RarRepSeq
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_ConRepSeq
qiime tools export --input-path taxonomy/taxa-bar-plots_reads-per-batch_RepSeq.qzv --output-path export/taxonomy/taxa-bar-plots_reads-per-batch_RepSeq

