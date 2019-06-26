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
analysis_path="${parent_path}/data/shared_data/data_mp2rage"

# list all subject names
declare -a app=(
	"sub-001"
	"sub-013"
	"sub-014"
	"sub-019"
                )

# list all image names
declare -a imas=(
	"_inv1"
	"_inv2"
	"_uni"
	"_t1"
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
	  input="${analysis_path}/${subj}/anat/${subj}${ima}_defaced*.nii.gz"
		output="${analysis_path}/derivatives/${subj}/unbiased/${subj}${ima}_unbiased.nii.gz"
		# copy gz file into SPM directory
		command="cp ${input} ${output}"
		echo "${command}"
		${command}
		# gunzip
		gunzip ${output}
	done

	# repeat the same for the t2star image
	input="${analysis_path}/derivatives/${subj}/t2star/${subj}_t2s_map_resliced_defaced.nii.gz"
	output="${analysis_path}/derivatives/${subj}/unbiased/${subj}_t2s_unbiased.nii.gz"
	# copy gz file into SPM directory
	command="cp ${input} ${output}"
	echo "${command}"
	${command}
	# gunzip
	gunzip ${output}
done
