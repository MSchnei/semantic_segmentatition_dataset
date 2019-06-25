#!/bin/bash

#### Description: Divides T1w file by PD file and multiplies by 500
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -T1w.nii.gz fro all subjects
####    -PD.nii.gz for all subjects
#### Output:
####    -T1wDivPD.nii.gz for all subjects
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
	# call to fslmaths
  command="fslmaths "
	# specify path to T1w image
  command+="${analysis_path}/${subj}/anat/${subj}_T1w_defaced "
	# divide
  command+="-div "
	# set path to Pd images
  command+="${analysis_path}/${subj}/anat/${subj}_PD_defaced "
	# multiply by 500
  command+="-mul 500 "
	# specify output name
  command+="${analysis_path}/derivatives/${subj}/ratios/${subj}_T1wDivPD_defaced"
	# create output folders
	mkdir -p ${analysis_path}/derivatives/${subj}/ratios
	# run dividison command
  echo "${command}"
  ${command}
done
