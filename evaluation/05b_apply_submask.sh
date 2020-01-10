#!/bin/bash

#### Description: Apply subcortical mask to all subjects
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
parent_path="${parent_path}/data/segmentation_data/data_mprage"

# specify which segmentation results should be evaluated
declare -a programme=(
  # "gt"
	# "spm"
  # "fs"
	# "fast"
	"project50_32strides_maxpool_tranposed_classic_dr_0p05_weighted"
  "project51_32strides_maxpool_tranposed_dense_dr_0p05_weighted"
  "project52_32strides_maxpool_tranposed_denseExt_dr_0p05_weighted"
	)

# list all subject names
declare -a app=(
  "sub-02"
  # "sub-03"
  # "sub-05"
  # "sub-06"
  # "sub-07"
                )

# set segmentation labels
declare -a tissue=(
	"WM"
	"GM"
	"CSF"
	"ventricle"
	"subcortex"
	"vessel"
	"sinus"
  )

# derive length of different lists
switchLen=${#programme[@]}
subjLen=${#app[@]}
tissueLen=${#tissue[@]}

# Loop over subjects
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
  for (( k=0; k<${switchLen}; k++ )); do
		# get programme name
		switch=${programme[k]}
    # create target directory
    mkdir -p "${parent_path}/derivatives/${subj}/segm4eval/${switch}"

    # loop throuh different tissue types
    for (( j=0; j<${tissueLen}; j++ )); do
      # get tissue type
      tis=${tissue[j]}

      # get input, subcortical mask, output name
      input="${parent_path}/derivatives/${subj}/segmentations/${switch}/${subj}_T1w_${tis}.nii.gz"
      mask="${parent_path}/derivatives/${subj}/segm4eval/${subj}_submask"
      output="${parent_path}/derivatives/${subj}/segm4eval/${switch}/${subj}_T1w_${tis}_mas.nii.gz"

      # check whether input file exists
			if test -f "$input"; then

        if [ "$tis" == "subcortex" ]; then
          # if subcortex do not apply sub-cortex mask, just copy image
          command="fslmaths ${input} ${output}"
          echo "${command}"
          ${command}
        else
          # otherwise mask the image
          command="fslmaths ${input} "
          command+="-mas ${mask} "
          command+="${output}"
          echo "${command}"
          ${command}
        fi

			else
    		echo "$input does not exist"
			fi

    done
  done
done
