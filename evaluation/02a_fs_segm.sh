#!/bin/bash

#### Description: Perform freesurfer segmentation
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -masked,  T1w image.nii.gz for all subjects
#### Output:
####    -segmentation labels for all subjects
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

# create division images for all subjects
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}

  # define subject directory
  SUBJECTS_DIR="${parent_path}/${subj}/anat"
  echo "subject directory:"
  echo $SUBJECTS_DIR
  # define expert files
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  EXPERT_FILE="$DIR/expert.opts"
  echo "expert file:"
  echo $EXPERT_FILE

  # run segmentation command
  input="${parent_path}/${subj}/anat/${subj}_T1w_defaced.nii.gz"
  # command="recon-all -i $input -s fs -all"
  command="recon-all -i $input -s fs -all -hires -expert $EXPERT_FILE"
  # run segmentation command
  echo "${command}"
  ${command}

  # move directory
  output="${parent_path}/derivatives/${subj}/segmentations/fs"
  mv "${parent_path}/${subj}/anat/fs" $output
  # convert mgz to nii.gz
  mri_convert $output/mri/aseg.mgz  $output/aseg.nii.gz

done

# cd $SUBJECTS_DIR
# freeview -v \
#   bert/mri/T1.mgz \
#   bert/mri/wm.mgz \
#   bert/mri/brainmask.mgz \
#   bert/mri/aseg.mgz:colormap=lut:opacity=0.2 \
#   -f \
#   bert/surf/lh.white:edgecolor=blue \
#   bert/surf/lh.pial:edgecolor=red \
#   bert/surf/rh.white:edgecolor=blue \
#   bert/surf/rh.pial:edgecolor=red
