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
analysis_path="${parent_path}/data/shared_data/data_mp2rage"

# list all subject names
declare -a app=(
  "sub-001"
  "sub-013"
  "sub-014"
  "sub-019"
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
  input="${analysis_path}/derivatives/${subj}/unbiased/${subj}_inv2_unbiased"
  output="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_mask"
	command="bet ${input} ${output} -f 0.2"
	echo "${command}"
	${command}
	# binarize
  fslmaths ${output} -bin ${output}
done
