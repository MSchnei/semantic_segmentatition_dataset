#!/bin/bash

#### Description: Map files from BIDS format to analysis directory tree
#### To be set:
####    -path to designated analysis folder,
####    -list with subject names
#### Input:
####    -files in BIDS format
#### Output:
####    -files in analysis directory tree format
#### Written by: Marian Schneider, Faruk Gulban

# set path to source and target folder
source_folder_path="${parent_path}/data/shared_data"
target_folder_path="${parent_path}/data/segmentation_data"

# list all subject names
declare -a subjects=(
	"sub-001"
	"sub-013"
	"sub-014"
	"sub-019"
        )

# deduce path to mp2rage folder
source_mp2rage_folder="${source_folder_path}/data_mp2rage"
target_mp2rage_folder="${target_folder_path}/data_mp2rage"

# deduce number of subjects
subjLen=${#subjects[@]}

# move files from data to analysis folder
for (( j=0; j<${subjLen}; j++ )); do
  # deduce subject name
  subj=${subjects[j]}
  # copy anatomy files files
  cp ${source_mp2rage_folder}/${subj}/anat/${subj}_inv1_defaced.nii.gz ${target_mp2rage_folder}/${subj}/anat/${subj}_inv1_defaced.nii.gz
  cp ${source_mp2rage_folder}/${subj}/anat/${subj}_inv2_defaced.nii.gz ${target_mp2rage_folder}/${subj}/anat/${subj}_inv2_defaced.nii.gz
  cp ${source_mp2rage_folder}/${subj}/anat/${subj}_t1_defaced2.nii.gz ${target_mp2rage_folder}/${subj}/anat/${subj}_t1_defaced.nii.gz
	cp ${source_mp2rage_folder}/${subj}/anat/${subj}_uni_defaced.nii.gz ${target_mp2rage_folder}/${subj}/anat/${subj}_uni_defaced.nii.gz
	cp ${source_mp2rage_folder}/${subj}/anat/${subj}_me_gre_defaced.nii.gz ${target_mp2rage_folder}/${subj}/anat/${subj}_me_gre_defaced.nii.gz

  # copy masks
  cp ${source_mp2rage_folder}/derivatives/${subj}/masks/${subj}_brain_mask.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/masks/${subj}_brain_mask.nii.gz
  cp ${source_mp2rage_folder}/derivatives/${subj}/masks/${subj}_brain_mask_nosub.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/masks/${subj}_brain_mask_nosub.nii.gz
  cp ${source_mp2rage_folder}/derivatives/${subj}/masks/${subj}_nosub_mask.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/masks/${subj}_nosub_mask.nii.gz

  # copy ground truth labels
	cp ${source_mp2rage_folder}/derivatives/${subj}/labels/${subj}_all_labels_v04.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/labeled/${subj}_labels_v01.nii.gz

	# copy bias-correct images
	cp ${source_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_inv1_unbiased.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_inv1_unbiased.nii.gz
  cp ${source_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_inv2_unbiased.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_inv2_unbiased.nii.gz
	cp ${source_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_uni_unbiased.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_uni_unbiased.nii.gz
  cp ${source_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_t1_unbiased.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_t1_unbiased.nii.gz
	cp ${source_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_t2s_unbiased.nii.gz ${target_mp2rage_folder}/derivatives/${subj}/unbiased/${subj}_t2s_unbiased.nii.gz

done
