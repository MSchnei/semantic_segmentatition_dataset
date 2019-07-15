#!/bin/bash

#### Description: Create brain mask for all subjects
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
	# create target directory
	mkdir -p "${analysis_path}/derivatives/${subj}/segmentations"
  # perform brain extraction
  input="${analysis_path}/derivatives/${subj}/unbiased/${subj}_PD_unbiased"
  output="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_mask"
	command="bet ${input} ${output} -f 0.5"
	echo "${command}"
	${command}
	# binarize
  fslmaths ${output} -bin ${output}
done
