#### Description: Reorient ground truth image and masks to match anat images
#### To be set:
####    -path to parent directory,
####    -subject names
#### Input:
####    -ground truth image in original orientation
####    -brain mask image in original orientation
####    -nosub image in original orientation
#### Output:
####    -ground truth image in reoriented orientation
####    -brain mask image in reoriented orientation
####    -nosub image in reoriented orientation
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
  # give path to ground truth image that should be reoriented
  file_header_broken="${analysis_path}/derivatives/${subj}/ground_truth/${subj}_gm_v*"
  # reorient image
  fslswapdim ${file_header_broken} AP SI LR ${file_header_broken}
	# give path to brain mask image that should be reoriented
  file_header_broken="${analysis_path}/derivatives/${subj}/masks/${subj}_brain_mask"
  # reorient image
  fslswapdim ${file_header_broken} AP SI LR ${file_header_broken}
	# give path to nosub mask image that should be reoriented
  file_header_broken="${analysis_path}/derivatives/${subj}/masks/${subj}_brain_mask_nosub"
  # reorient image
  fslswapdim ${file_header_broken} AP SI LR ${file_header_broken}
	# give path to T2 star artifact mask
  file_header_broken="${analysis_path}/derivatives/${subj}/masks/${subj}_artifact_mask_T2star"
  # reorient image
  fslswapdim ${file_header_broken} AP SI LR ${file_header_broken}
done
