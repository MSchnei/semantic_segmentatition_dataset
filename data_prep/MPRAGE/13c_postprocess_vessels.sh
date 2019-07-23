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
  # make directory for files
  mkdir -p ${analysis_path}/derivatives/${subj}/vessels
  # move files to new directory
  mv ${analysis_path}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased_mas_volHist_pMax97pt5_pMin2pt5_sc400.npy ${analysis_path}/derivatives/${subj}/vessels/${subj}_T1wDivPD_unbiased_mas_volHist_pMax97pt5_pMin2pt5_sc400.npy
  mv ${analysis_path}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased_mas_volHist_pMax97pt5_pMin2pt5_sc400_ncut_sp2500_c2pt0.npy ${analysis_path}/derivatives/${subj}/vessels/${subj}_T1wDivPD_unbiased_mas_volHist_pMax97pt5_pMin2pt5_sc400_ncut_sp2500_c2pt0.npy
  mv ${analysis_path}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased_mas_labels_0.nii.gz ${analysis_path}/derivatives/${subj}/vessels/${subj}_T1wDivPD_unbiased_mas_labels_0.nii.gz

done
