#!/bin/bash

#### Description: Erode brain mask for all subjects
#### To be set:
####    -path to parent directory,
####    -subject names
####    -image names
#### Input:
####    -images.nii.gz for all subjects
#### Output:
####    -images.nii for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set analysis path
analysis_path="${parent_path}/data/shared_data/data_mprage"

# list all subject names
declare -a app=(
		"sub-02"
		"sub-03"
		"sub-05"
		"sub-06"
		"sub-07"
                )

# get number of subjects
subjLen=${#app[@]}

# Loop over subjects
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
  # perform brain extraction
  ima="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_mask"
	command="fslmaths ${ima} -ero ${ima}"
	echo "${command}"
	${command}
done
