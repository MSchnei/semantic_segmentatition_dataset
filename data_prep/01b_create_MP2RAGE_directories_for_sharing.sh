#!/bin/bash

#### Description: Set up the necessary directories
#### To be set:
####    -path to designated analysis folder,
####    -list with subject names
#### Output:
####    -directories for analysis
#### Written by: Marian Schneider, Faruk Gulban

# set path to folder that will be published
publication_path="${parent_path}/data/segmentation_data"

# list all subject names
declare -a subjects=(
	"sub-001"
	"sub-013"
	"sub-014"
	"sub-019"
        )

# deduce path to mp2rage folder
mp2rage_folder="${publication_path}/data_mp2rage"
# create mp2rage folder
mkdir -p ${mp2rage_folder}
# create derivatives folder
mkdir -p ${mp2rage_folder}/derivatives

# deduce number of subjects
subjLen=${#subjects[@]}

# create directory tree for all subjects
for (( j=0; j<${subjLen}; j++ )); do
  # deduce subject name
  subj=${subjects[j]}
  # create subfolders
	mkdir -p ${mp2rage_folder}/${subj}
	mkdir -p ${mp2rage_folder}/${subj}/anat
	mkdir -p ${mp2rage_folder}/derivatives
	mkdir -p ${mp2rage_folder}/derivatives/${subj}
	mkdir -p ${mp2rage_folder}/derivatives/${subj}/unbiased
	mkdir -p ${mp2rage_folder}/derivatives/${subj}/labeled
	mkdir -p ${mp2rage_folder}/derivatives/${subj}/masks
done
