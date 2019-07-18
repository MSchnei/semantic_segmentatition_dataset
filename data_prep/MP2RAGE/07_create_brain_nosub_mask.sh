#!/bin/bash

#### Description: Subtract polished sub_mask from polisched brain_mask
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -polished brain mask.nii.gz for all subjects
####    -polished nosub.nii.gz for all subjects
#### Output:
####    -brain_nosub_mask.nii.gz for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
analysis_path="${parent_path}/data/shared_data/data_mp2rage"

# list all subject names
declare -a app=(
    "sub-001"
    "sub-013"
    "sub-014"
    "sub-019"
                )

# create division images for all subjects
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
	# call to fslmaths
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_mask_v* "
  # subtract
  command+="-sub "
	# set path to sub-mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_sub_mask_v* "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_nosub_mask"
	# run subtraction command
  echo "${command}"
  ${command}
done
