#!/bin/bash

#### Description: Perform fsl fast segmentation
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -prep_WM_extract.nii.gz for all subjects
#### Output:
####    -segmentation labels for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
analysis_path="${parent_path}/data/shared_data/data_mprage"

# list all subject names
declare -a app=(
    "sub-02"
    "sub-03"
    "sub-05"
    "sub-06"
    "sub-07"
                )

# create division images for all subjects
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}

  # get the CSF image
  command="fslmaths "
  # specify path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_prep_WM_extract_seg "
  # mask
  command+="-thr 1 -uthr 1 "
  # specify output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF"
  # run mask command
  echo "${command}"
  ${command}

  # apply cluster thresholding to the CSF image
  command="python /home/marian/Documents/Git/unet/data_prep/connected_clusters.py "
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF.nii.gz"
  # run threshold command
  echo "${command}"
  ${command}

  # fill holes
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_thrNone_c26_bin "
  # mask
  command+="-fillh "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_thrNone_c26_bin_fillh"
	# run mask command
  echo "${command}"
  ${command}

  # fill holes (2nd time)
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_thrNone_c26_bin_fillh "
  # mask
  command+="-fillh "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_thrNone_c26_bin_fillh"
	# run mask command
  echo "${command}"
  ${command}

  # Get vessel image subtract _CSF_thrNone_c26_bin from _CSF_thrNone_c26_bin_fillh
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_thrNone_c26_bin_fillh "
  # mask
  command+="-sub "
	# set path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_thrNone_c26_bin "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_vessels"
	# run mask command
  echo "${command}"
  ${command}

  # add vessel image to CSF image with number 2
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_vessels "
  # multiply 2
  command+="-mul 2 "
	# add _CSF_thrNone_c26_bin image
  command+="-add ${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_thrNone_c26_bin "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/segmentations/WM_prep_segm/${subj}_CSF_vessels"
	# run mask command
  echo "${command}"
  ${command}

done
