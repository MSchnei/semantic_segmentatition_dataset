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
analysis_path="${parent_path}/data/shared_data/data_mp2rage"

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
  # make directory for labels
  mkdir -p ${analysis_path}/derivatives/${subj}/labels

  # correct header of GM and copy to labels directory
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased "
  command+="-mul 0 -add ${analysis_path}/derivatives/${subj}/ground_truth/${subj}_gm_v* "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_gm"
  echo "... copy gm image"
  ${command}
  # binarize GM image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_gm "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_gm"
  echo "... binarize gm image"
  ${command}

  # copy WM image to labels directory
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_WM_v* "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_wm"
  echo "... copy wm image"
  ${command}
  # binarize WM image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_wm "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_wm"
  echo "... binarize wm image"
  ${command}

  # copy CSF image to labels directory
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_CSF_vessels_v* "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_csf"
  echo "... copy csf image"
  ${command}
  # binarize CSF image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_csf "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_csf"
  echo "... binarize csf image"
  ${command}

  # copy ventricle image to labels directory
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_ventricle_mask_v* "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_ventricles"
  echo "... copy ventricles image"
  ${command}
  # binarize ventricle image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_ventricles "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_ventricles"
  echo "... binarize ventricles image"
  ${command}

  # copy sinus image to labels directory
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_dura_mater_v* "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_sinus"
  echo "... copy sinus image"
  ${command}
  # binarize sinus image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_sinus "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_sinus"
  echo "... binarize sinus image"
  ${command}

  # copy subcortical image to labels directory
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_sub_mask_v* "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_subcortical"
  echo "... copy subcortical image"
  ${command}
  # binarize subcortical image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_subcortical "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_subcortical"
  echo "... binarize subcortical image"
  ${command}

  # copy vessels image to labels directory
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/segmentations/${subj}_vessels_v* "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_vessels"
  echo "... copy vessels image"
  ${command}
  # binarize vessels image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_vessels "
  command+="-bin "
  command+="${analysis_path}/derivatives/${subj}/labels/${subj}_vessels"
  echo "... binarize vessels image"
  ${command}

done
