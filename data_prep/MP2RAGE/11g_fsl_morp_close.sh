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
analysis_path="${parent_path}/data/shared_data/data_mp2rage"

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
	# erode, then dilate
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected "
  command+="-dilM -ero "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected_fslclose"
	# run mask command
  echo "${command}"
  ${command}

  # mask with placeholder
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected_fslclose "
  command+="-mas ${analysis_path}/derivatives/${subj}/segmentations/${subj}_spaceholder "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected_fslclose_mas"
  # run mask command
  echo "${command}"
  ${command}

  # combine with brain_mask_nosub
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected_fslclose_mas "
  command+="-add ${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_nosub_mask "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected_fslclose_mas_brain"
	# run mask command
  echo "${command}"
  ${command}

done
