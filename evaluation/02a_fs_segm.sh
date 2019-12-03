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
  # convert from fs space back to native anatomical space
  mri_label2vol --seg $output/mri/aseg.mgz --temp $output/mri/rawavg.mgz --o $output/mri/aseg-in-rawavg.mgz --regheader $output/mri/aseg.mgz
  # convert mgz to nii.gz
  mri_convert $output/mri/aseg-in-rawavg.mgz  $output/${subj}_T1w_seg.nii.gz

done

# cd $SUBJECTS_DIR
# freeview -v \
#   fs/mri/T1.mgz \
#   fs/mri/wm.mgz \
#   fs/mri/brainmask.mgz \
#   fs/mri/aseg.mgz:colormap=lut:opacity=0.2 \
#   -f \
#   fs/surf/lh.white:edgecolor=blue \
#   fs/surf/lh.pial:edgecolor=red \
#   fs/surf/rh.white:edgecolor=blue \
#   fs/surf/rh.pial:edgecolor=red
