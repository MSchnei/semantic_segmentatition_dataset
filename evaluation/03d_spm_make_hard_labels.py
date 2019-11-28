# -*- coding: utf-8 -*-

"""
Description: Create hard segmentation labels from soft spm segmentation output
To be set:
   -path to parent directory,
   -subject names
   -number of segmentation inputs
Input:
   -soft spm segmentation labels for all subjects
Output:
   -hard spm segmentation labels for all subjects
Written by: Marian Schneider, Faruk Gulban
"""

import os
import numpy as np
from nibabel import load, save, Nifti1Image

parent_path = str(os.environ['parent_path']) + "/data/segmentation_data/data_mprage"

lsSubj = ["sub-02", "sub-03", "sub-05", "sub-06", "sub-07"]
varNrInputs = 6

# loop through subjects
for subj in lsSubj:
    # %% load all files and put them in list
    data = []
    for ind in range(0, varNrInputs):
        filename = (parent_path + "/derivatives/" + subj +
                    "/segmentations/spm/c" + str(ind+1) + subj +
                    "_T1w_defaced.nii")
        nii = load(filename)
        data.append(nii.get_data().reshape((nii.shape + (1,))))

    # %% find maximum prob across all files
    data = np.concatenate((data), axis=3)
    # for which tissue probability class do we get the highest probability?
    maxPos = np.argmax(data, axis=3)

    # %% assign 1 if that tissue class had highest prob in the voxel, save
    for ind in range(0, varNrInputs):
        filename = (parent_path + "/derivatives/" + subj +
                    "/segmentations/spm/c" + str(ind+1) + subj +
                    "_T1w_defaced.nii")
        nii = load(filename)
        aryTemp = np.zeros((nii.shape))
        aryTemp[maxPos == ind] = 1
        basename = nii.get_filename().split(os.extsep, 1)[0]
        # save as nifti
        out = Nifti1Image(aryTemp, header=nii.header, affine=nii.affine)
        save(out, basename + "_max.nii.gz")
        os.remove(filename)
        print(filename)
        print("... changed")
