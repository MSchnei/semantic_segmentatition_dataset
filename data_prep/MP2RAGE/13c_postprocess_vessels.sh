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
  # make directory for files
  mkdir -p ${analysis_path}/derivatives/${subj}/vessels
  # move files to new directory
  mv ${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased_mas_volHist_pMax99pt9_pMin0pt1_sc400.npy ${analysis_path}/derivatives/${subj}/vessels/${subj}_uni_unbiased_mas_volHist_pMax99pt9_pMin0pt1_sc400.npy
  mv ${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased_mas_volHist_pMax99pt9_pMin0pt1_sc400_ncut_sp2500_c2pt0.npy ${analysis_path}/derivatives/${subj}/vessels/${subj}_uni_unbiased_mas_volHist_pMax99pt9_pMin0pt1_sc400_ncut_sp2500_c2pt0.npy
  mv ${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased_mas_labels_0.nii.gz ${analysis_path}/derivatives/${subj}/vessels/${subj}_uni_unbiased_mas_labels_0.nii.gz

done
