#!/bin/bash

#### Description: Run *.m files for spm segmentation
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -spm_div *.m files for all subjects
#### Output:
####    -spm segmentation results for all subjects
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

# run *.m files for spm segmentation
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	subj=${app[i]}
	pathTextFile="${parent_path}/derivatives/${subj}/segmentations/spm/spm_seg.m"
	# run SPM batch script
	m_cmd="run('${pathTextFile}');"
  m_cmd+="exit()"
	command="MATLAB -nodisplay -nodesktop -nosplash -r \"${m_cmd}\""
	echo "${command}"
	eval $command
done
