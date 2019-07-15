* Create ventricle mask using itk snap
	* Use the snake segmentation algorithm
	* Use both T1wDivPD and PDw images in algorithm (seems to give more robust result)
	* Save continuously updated versions as sub-??_ventricle_mask_v??.nii.gz in segmentations folder
