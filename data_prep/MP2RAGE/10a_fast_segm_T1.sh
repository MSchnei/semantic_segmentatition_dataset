#!/bin/bash

#### Description: Perform fsl fast segmentation
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -masked, unbiased T1 image.nii.gz for all subjects
#### Output:
####    -segmentation labels for all subjects
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
  # create target directory for segmented images
  mkdir -p "${analysis_path}/derivatives/${subj}/segmentations/t1_segm"
  # specify segmentation comman
  command="/usr/share/fsl/5.0/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 "
  command+="-o ${analysis_path}/derivatives/${subj}/segmentations/t1_segm/${subj}_t1_unbiased_mas "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_t1_unbiased_mas"

	# run segmentation command
  echo "${command}"
  ${command}
done
