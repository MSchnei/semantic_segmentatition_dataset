#!/bin/bash

#### Description: Move files to new directory
#### To be set:
####    -path to parent directory,
####    -subject names
####    -2D histogram properties:
####    -ncut_prepare properties
#### Input:
####    -ilr1 image
####    -ilr2 image
#### Output:
####    -2D histogram.npy file
####    -ncut.npy file
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
analysis_path="${parent_path}/data/shared_data/data_mprage"

declare -a arr_t1=(
  "sub-02"
  "sub-03"
  "sub-05"
  "sub-06"
  "sub-07"
    )

tLen=${#arr_t1[@]}
for (( i=0; i<${tLen}; i++ )); do
  subj=${arr_t1[i]}
  # mask with placeholder
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/vessels/${subj}_T1wDivPD_unbiased_mas_labels_0_close_open "
  command+="-mas ${analysis_path}/derivatives/${subj}/segmentations/${subj}_spaceholder "
  command+="${analysis_path}/derivatives/${subj}/vessels/${subj}_T1wDivPD_unbiased_mas_labels_0_close_open_mas"
  # run mask command
  echo "${command}"
  ${command}

done
