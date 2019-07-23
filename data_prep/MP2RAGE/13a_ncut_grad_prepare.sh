#!/bin/bash

#### Description: Prepare normalized graph cuts for fast images
#### To be set:
####    -path to parent directory,
####    -subject names
####    -2D histogram properties:
####    -ncut_prepare properties
#### Input:
####    -fast biased corrected T1divPD image
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

# set 2D histogram properties
percmin="0.1"
percmax="99.9"
scale="400"
cbar_init="2.0"
cbar_max="5.0"
gramag="3D_scharr"

#set ncut_prepare properties
mR="8"
sp="2500"
c="2"

echo "======================="
echo "Preparing ncut files..."
echo "======================="
tLen=${#arr_t1[@]}
for (( i=0; i<${tLen}; i++ )); do
  subj=${arr_t1[i]}
  # mask uni image
  command="fslmaths "
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased "
  command+="-mas ${analysis_path}/derivatives/${subj}/segmentations/${subj}_brain_nosub_mask "  
  command+="${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased_mas"
  echo "${command}"
  ${command}

  input_name="${analysis_path}/derivatives/${subj}/unbiased/${subj}_uni_unbiased_mas.nii.gz"
  # save 2D histogram
  command="segmentator $input_name "
  command+="--percmin ${percmin} --percmax ${percmax} --scale ${scale} "
  command+="--gramag ${gramag} --cbar_init ${cbar_init} --cbar_max ${cbar_max} "
  command+="--nogui"
  echo "${command}"
  ${command}
  # prepare ncut tree
  hist_name=${input_name%.nii*}"_volHist*_sc${scale}.npy"
  command="segmentator --ncut_prepare ${hist_name} "
  command+="--ncut_maxRec ${mR} --ncut_nrSupPix ${sp} --ncut_compactness ${c} "
  command+="--percmin ${percmin} --percmax ${percmax} --scale ${scale} "
  command+="--gramag ${gramag} --cbar_init ${cbar_init} --cbar_max ${cbar_max} "
  echo "${command}"
  ${command}

  echo -e "\n----\n"
done
