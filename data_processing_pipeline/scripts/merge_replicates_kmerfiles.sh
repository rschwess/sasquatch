#!usr/bin/bash

datadir="/t1-data1/WTSA_Dev/rschwess/database_assembly/idx_correct_assembly/human/DNase"

rep1="ENCODE_UW_Monocytes_CD14plus_RO1746_rep1"
rep2="ENCODE_UW_Monocytes_CD14plus_RO1746_rep2"

merged="ENCODE_UW_Monocytes_CD14plus_RO1746_merged"

mkdir -p ${datadir}/${merged}/counts

cd ${datadir}/${merged}/counts

for i in 5 6 7
do

perl /t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/scripts/merge_replicates_kmerfiles.pl ${datadir}/${rep1}/counts/kmers_${i}_count_${rep1}_pnorm_h_ery_1_plus.txt ${datadir}/${rep2}/counts/kmers_${i}_count_${rep2}_pnorm_JH60_plus.txt >kmers_${i}_count_${merged}_pnorm_JH60_plus.txt

echo "... $i plus done"

perl /t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/scripts/merge_replicates_kmerfiles.pl ${datadir}/${rep1}/counts/kmers_${i}_count_${rep1}_pnorm_h_ery_1_minus.txt ${datadir}/${rep2}/counts/kmers_${i}_count_${rep2}_pnorm_JH60_minus.txt >kmers_${i}_count_${merged}_pnorm_JH60_minus.txt

echo "... $i minus done"

done

perl /t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/scripts/merge_read_stats.pl ${datadir}/${rep1}/read_stats.txt ${datadir}/${rep2}/read_stats.txt | tee ${datadir}/${merged}/read_stats.txt

cd $datadir


### ====== ###
### 3 reps ###
### ====== ###

datadir="/t1-data1/WTSA_Dev/rschwess/database_assembly/idx_correct_assembly/human/DNase"

rep1="ENCODE_Duke_HeLa_S3_rep1"
rep2="ENCODE_Duke_HeLa_S3_rep2"
rep3="ENCODE_Duke_HeLa_S3_rep3"

merged="ENCODE_Duke_HeLa_S3_merged"

mkdir -p ${datadir}/${merged}/counts

cd ${datadir}/${merged}/counts

for i in 5 6 7
do

perl /t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/scripts/merge_replicates_kmerfiles.pl ${datadir}/${rep1}/counts/kmers_${i}_count_${rep1}_pnorm_h_ery_1_plus.txt ${datadir}/${rep2}/counts/kmers_${i}_count_${rep2}_pnorm_JH60_plus.txt  ${datadir}/${rep3}/counts/kmers_${i}_count_${rep3}_pnorm_JH60_plus.txt >kmers_${i}_count_${merged}_pnorm_JH60_plus.txt

echo "... $i plus done"

perl /t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/scripts/merge_replicates_kmerfiles.pl ${datadir}/${rep1}/counts/kmers_${i}_count_${rep1}_pnorm_h_ery_1_minus.txt ${datadir}/${rep2}/counts/kmers_${i}_count_${rep2}_pnorm_JH60_minus.txt ${datadir}/${rep3}/counts/kmers_${i}_count_${rep3}_pnorm_JH60_minus.txt >kmers_${i}_count_${merged}_pnorm_JH60_minus.txt

echo "... $i minus done"

done

perl /t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/scripts/merge_read_stats.pl ${datadir}/${rep1}/read_stats.txt ${datadir}/${rep2}/read_stats.txt ${datadir}/${rep3}/read_stats.txt | tee ${datadir}/${merged}/read_stats.txt

cd  $datadir



