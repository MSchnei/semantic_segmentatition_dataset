#!/bin/bash

#### Description: Unzip T1wDivPD image so SPM can handle it
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -T1wDivPD.nii.gz for all subjects
#### Output:
####    -T1wDivPD.nii for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
parent_path="${parent_path}/data/segmentation_data/data_mprage"

# list all subject names
declare -a app=(
	"sub-02"
	"sub-03"
	"sub-05"
	"sub-06"
	"sub-07"
                )

# unzip T1wDivPD image for all subjects
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
	# set input and output names for copying operation
  input="${parent_path}/${subj}/anat/${subj}_T1w_defaced.nii.gz"
	output_dir="${parent_path}/derivatives/${subj}/segmentations/spm"
	output="${output_dir}/${subj}_T1w_defaced.nii.gz"
	# create target directory for unzipped file
	mkdir -p $output_dir
	# copy gz file into SPM directory
	command="cp ${input} ${output}"
	echo "${command}"
	${command}
	# gunzip
	command="gunzip ${output}"
	echo "${command}"
	${command}
done
