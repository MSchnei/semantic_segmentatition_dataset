#!/bin/bash

#### Description: Perform fsl fast segmentation
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -masked, unbiased T1wDivPD image.nii.gz for all subjects
#### Output:
####    -segmentation labels for all subjects
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

# create division images for all subjects
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
  # create target directory for segmented images
  mkdir -p "${parent_path}/derivatives/${subj}/segmentations/fast"

  # specify segmentation comman
  command="/usr/share/fsl/5.0/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 "
  command+="-o ${parent_path}/derivatives/${subj}/segmentations/fast/${subj}_T1w "
  command+="${parent_path}/derivatives/${subj}/bet/${subj}_T1w_bet"

	# run segmentation command
  echo "${command}"
  ${command}
done
