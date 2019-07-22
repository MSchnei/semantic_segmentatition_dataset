#!/bin/bash

#### Description: Add up WM, GM, ventricle, binarize sum image, invert, mask with brain_nosub_mask
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -WM image
####    -GM image
####    -CSF image
####    -ventricle image
####    -brain_nosub_mask
#### Output:
####    -Mask for vessel and dura mater
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
analysis_path="${parent_path}/data/shared_data/data_mprage"

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
	# add WM
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_WM_v* "
  # add GM
  command+="-add ${analysis_path}/derivatives/${subj}/ground_truth/${subj}_gm_v* "
  # add ventricle
  command+="-add ${analysis_path}/derivatives/${subj}/segmentations/${subj}_ventricle_mask_v* "
  # binv
  command+="-binv "
  # mask
  command+="-mas ${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_nosub_mask "
  # output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_spaceholder"
	# run mask command
  echo "${command}"
  ${command}
done
