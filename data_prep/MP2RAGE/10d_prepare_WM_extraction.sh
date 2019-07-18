#!/bin/bash

#### Description: Perform fsl fast segmentation
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -prep_WM_extract.nii.gz for all subjects
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

  # for convenience later, combine thresholded+fillh csf image with brain_nosub_mask
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_vessels_man "
  # binarize
  command+="-bin "
  # mask
  command+="-add "
	# set path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_nosub_mask "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_brain_nosub"
	# run mask command
  echo "${command}"
  ${command}

done
