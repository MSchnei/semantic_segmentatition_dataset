#!/bin/bash

#### Description: Prepare normalized graph cuts for fast composition images
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

# set 2D histogram properties
percmin="0.25"
percmax="99.75"
scale="400"
cbar_init="2.5"
cbar_max="5.0"

# set ncut_prepare properties
mR="8"
sp="2500"
c="2"

echo "======================="
echo "Preparing ncut files..."
echo "======================="
tLen=${#arr_t1[@]}
for (( i=0; i<${tLen}; i++ )); do
  subj=${arr_t1[i]}
  input_name1="${analysis_path}/derivatives/${subj}/composition/ilr_coord_1.nii.gz"
  input_name2="${analysis_path}/derivatives/${subj}/composition/ilr_coord_2.nii.gz"

  # save 2D histogram
  command="segmentator ${input_name1} "
  command+="--percmin ${percmin} --percmax ${percmax} --scale ${scale} "
  command+="--gramag ${input_name2} "
  command+="--cbar_init ${cbar_init} --cbar_max ${cbar_max} --nogui"
  echo "${command}"
  ${command}
  # prepare ncut tree
  hist_name=${input_name1%.nii*}"_volHist*_sc${scale}.npy"
  command="segmentator --ncut_prepare ${hist_name} "
  command+="--ncut_maxRec ${mR} --ncut_nrSupPix ${sp} --ncut_compactness ${c} "
  command+="--percmin ${percmin} --percmax ${percmax} --scale ${scale} "
  command+="--cbar_init ${cbar_init} --cbar_max ${cbar_max}"
  echo "${command}"
  ${command}

  echo -e "\n----\n"
done
