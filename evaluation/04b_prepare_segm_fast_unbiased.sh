#!/bin/bash

#### Description: Prepare fast segmentations for evaluation
#### To be set:
####    -path to parent directory,
####    -path to EvaluateSegmentation tool
####    -list with programme names for initial GM segmentation
#### Input:
####    -grey matter segmentations
#### Output:
####    -Binary WM, GM and CSF segmentation files
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
parent_path="${parent_path}/data/segmentation_data/data_mprage"
# set programme switch
switch="fast"

# list all subject names
declare -a app=(
  "sub-02"
  "sub-03"
  "sub-05"
  "sub-06"
  "sub-07"
  )

# set segmentation labels
declare -a tissue=(
	"WM"
  "GM"
  "CSF"
  )

# set curent integer corresponding to segmentation label
label=(3 2 1)

# derive length of different lists
subjLen=${#app[@]}
tissueLen=${#tissue[@]}

for (( j=0; j<${subjLen}; j++ )); do
	# get subject name
	subj=${app[j]}
	# deduce name for segmentation result file
	segm="${parent_path}/derivatives/${subj}/segmentations/${switch}/${subj}_T1w_unbiased_seg.nii.gz"

	# loop throuh different tissue types
  for (( i=0; i<${tissueLen}; i++ )); do
		# get corresponding label
		lab=${label[i]}
		# get tissue type
		tis=${tissue[i]}
		# determine oupt image
		output="${parent_path}/derivatives/${subj}/segmentations/${switch}/${subj}_T1w_unbiased_${tis}.nii.gz"

    # threshold the image
    command="fslmaths ${segm} "
    command+="-thr ${lab} -uthr ${lab} "
    command+="${output}"
    echo "${command}"
    ${command}

		# binarise the image
    command="fslmaths ${output} -bin "
    command+="${output}"
    echo "${command}"
    ${command}

	done
done
