#!/bin/bash

#### Description: Unzip images so SPM can handle them
#### To be set:
####    -path to parent directory,
####    -subject names
####    -image names
#### Input:
####    -images.nii.gz for all subjects
#### Output:
####    -images.nii for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set analysis path
analysis_path="${parent_path}/data/shared_data/data_mprage"

# list all subject names
declare -a app=(
		"sub-02"
		"sub-03"
		"sub-05"
		"sub-06"
		"sub-07"
                )

# list all image names
declare -a imas=(
		"_T1w"
		"_PD"
		"_T2star"
                )

# unzip T1wDivPD image for all subjects
subjLen=${#app[@]}
imaLen=${#imas[@]}

# Loop over subjects
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
	# create target directory
	mkdir -p "${analysis_path}/derivatives/${subj}/unbiased"

	# Loop over provided images
	for (( j=0; j<${imaLen}; j++ )); do
		# derive particular image name
		ima=${imas[j]}
		# set input and output names for copying operation
	  input="${analysis_path}/${subj}/anat/${subj}${ima}_defaced.nii.gz"
		output="${analysis_path}/derivatives/${subj}/unbiased/${subj}${ima}_unbiased.nii.gz"
		# copy gz file into SPM directory
		command="cp ${input} ${output}"
		echo "${command}"
		${command}
		# gunzip
		gunzip ${output}
	done

	# repeat the same for the division image
	input="${analysis_path}/derivatives/${subj}/ratios/${subj}_T1wDivPD_defaced.nii.gz"
	output="${analysis_path}/derivatives/${subj}/unbiased/${subj}_T1wDivPD_unbiased.nii.gz"
	# copy gz file into SPM directory
	command="cp ${input} ${output}"
	echo "${command}"
	${command}
	# gunzip
	gunzip ${output}
done
