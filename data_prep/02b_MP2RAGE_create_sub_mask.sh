#!/bin/bash

#### Description: Produces a subcortical mask for MP2RAGE images
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -brain_mask.nii.gz fro all subjects
####    -brain_mask_nosub.nii.gz for all subjects
#### Output:
####    -nosub_mask.nii.gz for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
analysis_path="${parent_path}/data/shared_data/data_mp2rage"

# list all subject names
declare -a app=(
  "sub-001"
  "sub-013"
  "sub-014"
  "sub-019"
                )

# create division images for all subjects
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
	# call to fslmaths
  command="fslmaths "
	# specify path to mask
  command+="${analysis_path}/derivatives/${subj}/masks/${subj}_brain_mask "
	# subtract
  command+="-sub "
	# set path to sub-mask
  command+="${analysis_path}/derivatives/${subj}/masks/${subj}_brain_mask_nosub "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/masks/${subj}_nosub_mask"
	# run subtraction command
  echo "${command}"
  ${command}
done
