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
	"sub-02"
	"sub-03"
	"sub-05"
	"sub-06"
	"sub-07"
        )

# deduce path to mprage folder
source_mprage_folder="${source_folder_path}/data_mprage"
target_mprage_folder="${target_folder_path}/data_mprage"

# deduce number of subjects
subjLen=${#subjects[@]}

# move files from data to analysis folder
for (( j=0; j<${subjLen}; j++ )); do
  # deduce subject name
  subj=${subjects[j]}
  # copy anatomy files files
  cp ${source_mprage_folder}/${subj}/anat/${subj}_PD_defaced.nii.gz ${target_mprage_folder}/${subj}/anat/${subj}_PD_defaced.nii.gz
  cp ${source_mprage_folder}/${subj}/anat/${subj}_T1w_defaced.nii.gz ${target_mprage_folder}/${subj}/anat/${subj}_T1w_defaced.nii.gz
  cp ${source_mprage_folder}/${subj}/anat/${subj}_T2star_defaced.nii.gz ${target_mprage_folder}/${subj}/anat/${subj}_T2star_defaced.nii.gz

  # copy masks
  cp ${source_mprage_folder}/derivatives/${subj}/masks/${subj}_brain_mask.nii.gz ${target_mprage_folder}/derivatives/${subj}/masks/${subj}_brain_mask.nii.gz
  cp ${source_mprage_folder}/derivatives/${subj}/masks/${subj}_brain_mask_nosub.nii.gz ${target_mprage_folder}/derivatives/${subj}/masks/${subj}_brain_mask_nosub.nii.gz
  cp ${source_mprage_folder}/derivatives/${subj}/masks/${subj}_nosub_mask.nii.gz ${target_mprage_folder}/derivatives/${subj}/masks/${subj}_nosub_mask.nii.gz

  # copy ground truth labels
	cp ${source_mprage_folder}/derivatives/${subj}/labels/${subj}_all_labels_v04.nii.gz ${target_mprage_folder}/derivatives/${subj}/labeled/${subj}_labels_v01.nii.gz

	# copy bias-correct images
	cp ${source_mprage_folder}/derivatives/${subj}/unbiased/${subj}_T1w_unbiased.nii.gz ${target_mprage_folder}/derivatives/${subj}/unbiased/${subj}_T1w_unbiased.nii.gz
  cp ${source_mprage_folder}/derivatives/${subj}/unbiased/${subj}_PD_unbiased.nii.gz ${target_mprage_folder}/derivatives/${subj}/unbiased/${subj}_PD_unbiased.nii.gz
  cp ${source_mprage_folder}/derivatives/${subj}/unbiased/${subj}_T2star_unbiased.nii.gz ${target_mprage_folder}/derivatives/${subj}/unbiased/${subj}_T2star_unbiased.nii.gz
	cp ${source_mprage_folder}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased.nii.gz ${target_mprage_folder}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased.nii.gz

done
