#!/bin/bash

#### Description: Run normalized graph cuts for fast images
#### To be set:
####    -path to parent directory,
####    -subject names
####    -2D histogram properties:
####    -path to ncut.npy file
#### Input:
####    -fast biased corrected T1divPD image
#### Output:
####    -segmentator brain mask for fast GM
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

# set 2D histogram properties
percmin="2.5"
percmax="97.5"
scale="400"
gramag="3D_scharr"
cbar_init="2.0"
cbar_max="5.0"

# set path to ncut.npy file
ncut_base="_T1wDivPD_unbiased_mas_volHist_pMax97pt5_pMin2pt5_sc400_ncut_sp2500_c2pt0.npy"

echo "====================="
echo "Batch Segmentator GUI"
echo "====================="
tLen=${#arr_t1[@]}
for (( i=0; i<${tLen}; i++ )); do
  subj=${arr_t1[i]}
  input_name="${analysis_path}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased_mas.nii.gz"
  input_ncut="${analysis_path}/derivatives/${subj}/unbiased/${subj}${ncut_base}"
  command="segmentator $input_name --ncut $input_ncut "
  command+="--percmin ${percmin} --percmax ${percmax} --scale ${scale} "
  command+="--gramag ${gramag} --cbar_init ${cbar_init} --cbar_max ${cbar_max} "
  echo "${command}"
  ${command}

done

echo -e "\nDone.\n"
