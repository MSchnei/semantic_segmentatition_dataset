#!/bin/bash

#### Description: Run *.m files for spm segmentation
#### To be set:
####    -path to parent directory,
####    -subject names
####    -image names
#### Input:
####    -spm_segment *.m files for all subjects
#### Output:
####    -unbiased images for all subjects
#### Written by: Marian Schneider, Faruk Gulban

# set analysis_path path
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
	"_T1wDivPD"
              )

# get number of subjects and image files
subjLen=${#app[@]}
imaLen=${#imas[@]}

# run *.m files for spm segmentation
for (( i=0; i<${subjLen}; i++ )); do
  subj=${app[i]}
	echo "Working on ${subj}"

	# Loop over provided images
	for (( j=0; j<${imaLen}; j++ )); do
		# derive particular image name
		ima=${imas[j]}
		# derive path to m file
		pathTextFile="${analysis_path}/derivatives/${subj}/unbiased/spm_segment${ima}.m"
		# compose Matlab command
		m_cmd="run('${pathTextFile}');"
		m_cmd+="exit()"
		# Compose bash command and run bash
		b_cmd="MATLAB -nodisplay -nodesktop -nosplash -r \"${m_cmd}\""
		echo "${b_cmd}"
		eval $b_cmd
		# remove a few files that were created in vein
		echo "Deleting files"
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/c1${subj}${ima}_unbiased.nii"
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/c2${subj}${ima}_unbiased.nii"
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/c3${subj}${ima}_unbiased.nii"
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/c4${subj}${ima}_unbiased.nii"
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/c5${subj}${ima}_unbiased.nii"
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/c6${subj}${ima}_unbiased.nii"
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/${subj}${ima}_unbiased_seg8.mat"
		# remove *.m files for spm segmentation
		rm -rf ${pathTextFile}
		# remove and zip files
		rm -rf "${analysis_path}/derivatives/${subj}/unbiased/${subj}${ima}_unbiased.nii"
		mv "${analysis_path}/derivatives/${subj}/unbiased/m${subj}${ima}_unbiased.nii" "${analysis_path}/derivatives/${subj}/unbiased/${subj}${ima}_unbiased.nii"
		gzip "${analysis_path}/derivatives/${subj}/unbiased/${subj}${ima}_unbiased.nii"
	done

done
