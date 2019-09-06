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
	"sub-02"
	"sub-03"
	"sub-05"
	"sub-06"
	"sub-07"
        )

# deduce path to mprage folder
mprage_folder="${publication_path}/data_mprage"
# create mprage folder
mkdir -p ${mprage_folder}
# create derivatives folder
mkdir -p ${mprage_folder}/derivatives

# deduce number of subjects
subjLen=${#subjects[@]}

# create directory tree for all subjects
for (( j=0; j<${subjLen}; j++ )); do
  # deduce subject name
  subj=${subjects[j]}
  # create subfolders
	mkdir -p ${mprage_folder}/${subj}
	mkdir -p ${mprage_folder}/${subj}/anat
	mkdir -p ${mprage_folder}/derivatives
	mkdir -p ${mprage_folder}/derivatives/${subj}
	mkdir -p ${mprage_folder}/derivatives/${subj}/unbiased
	mkdir -p ${mprage_folder}/derivatives/${subj}/labeled
	mkdir -p ${mprage_folder}/derivatives/${subj}/masks
done
