#!usr/bin/bash

#$ -cwd
#$ -q batchq
#$ -M rschwess
#$ -m eas
#$ -e /t1-data1/WTSA_Dev/rschwess/clustereo
#$ -o /t1-data1/WTSA_Dev/rschwess/clustereo
#$ -N vocab_gm12878_duke

#qsub /t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/pipeline/runscript_make_vocabulary.sh

SCRIPT_DIR=/t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/scripts		
COMMON_FUNCTIONS=${SCRIPT_DIR}/common_functions.R

#input possible kmers
KMER_IN=/t1-data1/WTSA_Dev/rschwess/Sasquatch_offline/Sasquatch/data_processing_pipeline/kmers/Kmers_5_6_7_combined.txt

ORGANISM="human"

FRAG_TYPE="DNase"

#I use the following to create tissue specific sub directories and name the files accordingly when creating the tissue specific data,
#so that by setting a data directory and the correct tag you get access to the tissue specific count files later.
TISSUE="ENCODE_Duke_GM12878_merged"

# currently available "laza" (human fibroblast) "h_ery_1" (human erythroid 60% mapped)  "atac" for atac;  mm9 --> atac= atac_mm9
NORM_TYPE="h_ery_1"

#define DATA directory
DATA_DIR=/t1-data1/WTSA_Dev/rschwess/database_assembly/idx_correct_assembly/${ORGANISM}/${FRAG_TYPE}/
OUTPUT_DIR=${DATA_DIR}/${TISSUE}
#vocabularyfile definition
VOCAB=${OUTPUT_DIR}/vocabulary_${TISSUE}.txt

#override existing
rm -f ${VOCAB}

#go through all possible kmers
for kmer in `cat ${KMER_IN}`
do

#get & store kmer length
kl=`expr length $kmer`	

### Select kl matching file
case "${ORGANISM}" in 

human)
case "${FRAG_TYPE}" in 
DNase)	
infile_plus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_${NORM_TYPE}_plus.txt
infile_minus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_${NORM_TYPE}_minus.txt
;;
ATAC)
infile_plus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_atac_plus.txt
infile_minus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_atac_minus.txt
;;
esac
;;

mouse)
case "${FRAG_TYPE}" in
DNase)	
infile_plus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_mm9_plus.txt
infile_minus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_mm9_minus.txt
;;
ATAC)
infile_plus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_atac_mm9_plus.txt
infile_minus=${DATA_DIR}/${TISSUE}/counts/kmers_${kl}_count_${TISSUE}_pnorm_atac_mm9_minus.txt
;;
esac
;;
esac

###############################
# 1 retrieve & store profiles #
###############################
#get the plus (sense) strand profile for the kmer from the tissue specific dnase footprint counts
profile_plus_out=`Rscript ${SCRIPT_DIR}/retrieve_profile.R ${kmer} ${infile_plus} ${COMMON_FUNCTIONS}`
profile_plus=`echo ${profile_plus_out} | perl -ne '/:::(.+)/; print $1;'`
#same for antisense, minus strand, query from the tissue specific dnase footprint counts
profile_minus_out=`Rscript ${SCRIPT_DIR}/retrieve_profile.R ${kmer} ${infile_minus} ${COMMON_FUNCTIONS}`
profile_minus=`echo ${profile_minus_out} | perl -ne '/:::(.+)/; print $1;'`
#################
#merge profiles #
#################
profile_merged=`Rscript ${SCRIPT_DIR}/merge_profiles.R ${profile_plus} ${profile_minus} ${FRAG_TYPE} ${kl}`
#####################
# 2 calc SFR(FSR)   #
#####################
fsr_out=`Rscript ${SCRIPT_DIR}/fsr_calculation_pnorm_merge.R ${kmer} ${profile_merged} ${profile_plus} ${profile_minus} ${COMMON_FUNCTIONS}`
#output is again a string like: fsr_plus=x fsr_minus=x scale_plus=x scale_minus=x
fsr_merged=`echo $fsr_out} | perl -ne '/fsr_merged=(\d+\.?\d*)\s+/; print $1;'`	

################################
# 3 STore in Vocabulary File   #
################################
echo -ne "$kmer\t${fsr_merged}\n" >>${VOCAB}


done
