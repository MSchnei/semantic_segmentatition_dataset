#!/bin/bash

#### Description: Fill holes using fsl fillh command
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
	# call to fslmaths
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close "
  # fill holes
  command+="-fillh "
  command+="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh"

  # run mask command
  echo "${command}"
  ${command}

  # prepare correct image for region growing
  cp ${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh.nii.gz ${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected.nii.gz
  gunzip ${analysis_path}/derivatives/${subj}/composition/ilr_coord_1_labels_0_open_close_fillh_corrected.nii.gz

done
