#!/bin/bash

#### Description: Mask T1 image with polished brain_nosub_mask
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -polished brain_nosub_mask.nii.gz for all subjects
####    -unbiased T1 image.nii.gz for all subjects
#### Output:
####    -brain_nosub_mask.nii.gz for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
analysis_path="${parent_path}/data/shared_data/data_mprage"

# list all subject names
declare -a app=(
  "sub-02"
  "sub-03"
  "sub-05"
  "sub-06"
  "sub-07"
                )

# create division images for all subjects
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
	# call to fslmaths
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased "
  # mask
  command+="-mas "
	# set path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_nosub_mask "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased_mas"
	# run mask command
  echo "${command}"
  ${command}
done
