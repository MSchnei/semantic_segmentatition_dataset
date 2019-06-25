#### Description: Reorient ground truth image to match anat images
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -ground truth image in original orientation
#### Output:
####    -ground truth image in reoriented orientation
#### Written by: Marian Schneider, Faruk Gulban

# set analysis path
analysis_path="${parent_path}/data/shared_data/data_mp2rage"

# list all subject names
declare -a app=(
				"sub-001"
        "sub-013"
        "sub-014"
        "sub-019"
                )

# mask all images with brain mask
subjLen=${#app[@]}
for (( i=0; i<${subjLen}; i++ )); do
	# derive particular subject name
  subj=${app[i]}
  # give path to file with proper nii header
  file_header_proper="${analysis_path}/${subj}/anat/${subj}_t1_defaced2"
  # give path to file with broken nii header after correction
  file_header_broken="${analysis_path}/derivatives/${subj}/ground_truth/${subj}_gm"
  # create a copy of the broken file header
  file_header_broken_cp="${file_header_broken}_reoriented"
  cp ${file_header_broken}_v*.nii.gz ${file_header_broken_cp}.nii.gz
  # reorient image
  fslswapdim ${file_header_broken_cp} AP SI LR ${file_header_broken_cp}
done
