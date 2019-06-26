#!/bin/bash

#### Description: Combine brain masks for all subjects
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
  # perform brain extraction
  ima1="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_mask"
  ima2="${analysis_path}/derivatives/${subj}/masks/${subj}_brain_mask"
	command="fslmaths ${ima1} -max ${ima2} ${ima1}"
	echo "${command}"
	${command}
done
