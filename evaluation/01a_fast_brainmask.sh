#!/bin/bash

#### Description: Generate brain mask with bet for FSL FAST
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -T1wDivPD.nii.gz for all subjects
####    -brain masks for all subjects
#### Output:
####    -T1wDivPD_bet.nii.gz for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
parent_path="${parent_path}/data/segmentation_data/data_mprage"

# list all subject names
declare -a app=(
				"sub-02"
        "sub-03"
        "sub-05"
        "sub-06"
        "sub-07"
                )

# mask all images with brain mask
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
	# specify input and output tasks
  input="${parent_path}/${subj}/anat/${subj}_T1w_defaced"
  output="${parent_path}/derivatives/${subj}/bet/${subj}_T1w_bet"
	# create target directory for segmented images
	mkdir -p "${parent_path}/derivatives/${subj}/bet"
	# perform brain extraction
	command="bet ${input} ${output} -f 0.5"
  echo "${command}"
  ${command}

	# binarize images
	

done
