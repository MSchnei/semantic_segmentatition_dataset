#!/bin/bash

#### Description: Fill in missing vessels
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
analysis_path="${parent_path}/data/shared_data/data_mp2rage"
cluster_file="/home/marian/Documents/Git/unet/data_prep/connected_clusters.py"

declare -a arr_t1=(
  "sub-001"
  "sub-013"
  "sub-014"
  "sub-019"
  )

tLen=${#arr_t1[@]}
for (( i=0; i<${tLen}; i++ )); do
  subj=${arr_t1[i]}
  echo "Working on ${subj}"

  # binarize labels the holes
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01 "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01_bin"
  ${command}

  # fill the holes
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01_bin "
  command+="-fillh "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01_bin_fillh"
  ${command}

  # get filled holes
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01_bin_fillh "
  command+="-sub "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01_bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_vessel_filler"
  ${command}

  # get threshold image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased_mas "
  command+="-thr 1500 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_thresh1500"
  ${command}
  # binarize threshold image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_thresh1500 "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_thresh1500"
  ${command}

  # combine threshold and vessel filler
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_vessel_filler "
  command+="-min "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_thresh1500 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_vessel_guess"
  ${command}

  # get old vessels
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01 "
  command+="-thr 6 -uthr 6 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_vessels"
  ${command}

  # binarize old vessels
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_vessels "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_vessels_bin"
  ${command}

  # combine new and old vessels
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_vessel_guess "
  command+="-max "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_vessels_bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_new_vessels"
  ${command}

  # perform clustering
  python $cluster_file "${analysis_path}/derivatives/${subj}/labels/${subj}_new_vessels.nii.gz"

  # subtract old vessels from labels
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01 "
  command+="-sub "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_vessels "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v02"
  ${command}

  # add new vessels to labels
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_new_vessels_thrNone_c26_bin "
  command+="-mul 6 -add "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v02 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v02"
  ${command}

  # remove inbetween images
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01_bin.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v01_bin_fillh.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_vessel_filler.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_thresh1500.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_vessel_guess.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_old_vessels.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_old_vessels_bin.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_new_vessels.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_new_vessels_thrNone_c26_bin.nii.gz"

done
