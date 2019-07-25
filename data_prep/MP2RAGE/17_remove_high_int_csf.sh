#!/bin/bash

#### Description: Remove high intensity CSF vessels
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

  # extract old csf
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v02 "
  command+="-thr 3 -uthr 3 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_csf"
  ${command}
  # binarize old csf
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_csf "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_csf_bin"
  ${command}

  # get threshold image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased_mas "
  command+="-uthr 1500 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_uthresh1500"
  ${command}
  # binarize threshold image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_uthresh1500 "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_uthresh1500"
  ${command}

  # combine thresh image with csf
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_csf_bin "
  command+="-min "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_uthresh1500 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_new_csf_bin"
  ${command}

  # perform clustering
  python $cluster_file "${analysis_path}/derivatives/${subj}/labels/${subj}_new_csf_bin.nii.gz"

  # subtract old vessels from labels
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v02 "
  command+="-sub "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_old_csf "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v03"
  ${command}

  # add new csf to labels
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_new_csf_bin_thrNone_c26_bin "
  command+="-mul 3 -add "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v03 "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_all_labels_v03"
  ${command}

  # # remove inbetween images
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_old_csf.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_old_csf_bin.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_new_csf_bin.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_new_csf_bin_thrNone_c26_bin.nii.gz"
  rm -rf "${analysis_path}/derivatives/${subj}/labels/${subj}_uthresh1500.nii.gz"

done
