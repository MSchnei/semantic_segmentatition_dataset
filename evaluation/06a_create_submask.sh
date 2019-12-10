#!/bin/bash

#### Description: Create subcortical mask for all subjects
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
parent_path="${parent_path}/data/segmentation_data/data_mprage"

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
	mkdir -p "${parent_path}/derivatives/${subj}/segm4eval"
  # get subcortical mask
  input="${parent_path}/derivatives/${subj}/labeled/${subj}_labels_v01.nii.gz"
  output="${parent_path}/derivatives/${subj}/segm4eval/${subj}_submask"

  # threshold the image
  command="fslmaths ${input} "
  command+="-thr 5 -uthr 5 "
  command+="${output}"
  echo "${command}"
  ${command}

  # binarise the image
  command="fslmaths ${output} -binv "
  command+="${output}"
  echo "${command}"
  ${command}
done
