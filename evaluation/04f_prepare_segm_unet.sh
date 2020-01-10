#!/bin/bash

#### Description: Prepare deep model segmentations for evaluation
#### To be set:
####    -path to parent directory,
####    -path to EvaluateSegmentation tool
####    -list with programme names for initial GM segmentation
#### Input:
####    -grey matter segmentations
#### Output:
####    -Binary WM, GM and CSF segmentation files
#### Written by: Marian Schneider, Faruk Gulban

# set path to MPRAGE data
data_path="${parent_path}/data/segmentation_data/data_mprage"
# set path to unet segmentation
segm_path="${parent_path}/MPRAGEsingle/predicted_nii"

# list all result folder names of all segmentation models
declare -a results=(
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

# set curent integer corresponding to segmentation label
label=(1 2 3 4 5 6 7)

# derive length of different lists
subjLen=${#app[@]}
tissueLen=${#tissue[@]}
resultsLen=${#results[@]}

for (( j=0; j<${subjLen}; j++ )); do
	# get subject name
	subj=${app[j]}

  for (( k=0; k<${resultsLen}; k++ )); do
    # deduce results_folder
    results_folder=${results[k]}

  	# deduce name for unet segmentation result file
  	segm="${segm_path}/${results_folder}/pred.nii.gz"
    # create target directory for segmentations
    mkdir -p "${data_path}/derivatives/${subj}/segmentations/${results_folder}"

  	# loop throuh different tissue types
    for (( i=0; i<${tissueLen}; i++ )); do
  		# get corresponding label
  		lab=${label[i]}
  		# get tissue type
  		tis=${tissue[i]}
  		# determine output image
  		output="${data_path}/derivatives/${subj}/segmentations/${results_folder}/${subj}_T1w_${tis}.nii.gz"

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
done
