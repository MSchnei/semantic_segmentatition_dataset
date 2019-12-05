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
  # "fs"
	"fast"
	)

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
	"_WM"
  "_GM"
  "_CSF"
	"_ventricles"
  "_sagsinus"
  "_subcortex"
	"_vessels"
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
		  truth="${parent_path}/derivatives/${subj}/labeled/${subj}_labels_v0?.nii.gz"
	    # deduce name for segmentation result file
	    segm="${parent_path}/derivatives/${subj}/segmentations/${switch}/${subj}_T1w_seg.nii.gz"

	    # evaluate the segmentation
	    command="${evalseg} ${truth} ${segm} "
	    command+="-use DICE,VOLSMTY " # DICE,VOLSMTY,AVGDIST,HDRFDST@0.95@
	    command+="-xml ${parent_path}/derivatives/${subj}/evaluations/${switch}_seg.xml"
	    echo "${command}"
	    ${command}

		done
	done
done
