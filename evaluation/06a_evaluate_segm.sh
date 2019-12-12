#!/bin/bash

#### Description: Evaluate segmentations
#### To be set:
####    -path to parent directory,
####    -path to EvaluateSegmentation tool
####    -list with programme names for initial GM segmentation
#### Input:
####    -grey matter segmentations
#### Output:
####    -overlap-based metrics for GM segmentations
#### Written by: Marian Schneider, Faruk Gulban

# set parent path
parent_path="${parent_path}/data/segmentation_data/data_mprage"
evalseg="/home/marian/EvaluateSegmentation/EvaluateSegmentation"

# specify which segmentation results should be evaluated
declare -a programme=(
	"spm"
  	"fs"
	"fast"
	"project34_32strides_maxpool_tranposed_dense_pre"
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

for (( j=0; j<${subjLen}; j++ )); do
	# get subject name
	subj=${app[j]}
	# create target directory for evaluation results
	mkdir -p "${parent_path}/derivatives/${subj}/evaluations/"

	for (( k=0; k<${switchLen}; k++ )); do
		# get programme name
		switch=${programme[k]}

		# loop throuh different tissue types
	  for (( i=0; i<${tissueLen}; i++ )); do
			# get tissue type
			tis=${tissue[i]}

		  # deduce path name for ground truth
		  truth="${parent_path}/derivatives/${subj}/segm4eval/gt/${subj}_T1w_${tis}_mas_roi.nii.gz"
	    # deduce name for segmentation result file
	    segm="${parent_path}/derivatives/${subj}/segm4eval/${switch}/${subj}_T1w_${tis}_mas_roi.nii.gz"

			# check whether file exists
			if test -f "$segm"; then
				# evaluate the segmentation
				command="${evalseg} ${truth} ${segm} "
				command+="-use DICE,VOLSMTY,AVGDIST,HDRFDST@0.95@ " # DICE,VOLSMTY,AVGDIST,HDRFDST@0.95@
				command+="-xml ${parent_path}/derivatives/${subj}/evaluations/${subj}_${switch}_${tis}.xml"
				echo "${command}"
				${command}

			else
    		echo "$segm does not exist"
			fi

		done
	done
done
