# -*- coding: utf-8 -*-

"""
Description: Create one file with hard segmentation labels.
To be set:
   -path to parent directory,
   -subject names
   -number of segmentation inputs
Input:
   -hard spm segmentation labels in seperate files for all subjects
Output:
   -hard spm segmentation labels in a single file for every subjects
Written by: Marian Schneider, Faruk Gulban
"""

import os
import numpy as np
from nibabel import load, save, Nifti1Image

parent_path = str(os.environ['parent_path']) + "/data/segmentation_data/data_mprage"

lsSubj = ["sub-02", "sub-03", "sub-05", "sub-06", "sub-07"]
varNrInputs = 3

# loop through subjects
for subj in lsSubj:
    # %% load first three segmentation labels and put them in list
    data = []
    for ind in range(0, varNrInputs):
        filename = (parent_path + "/derivatives/" + subj +
                    "/segmentations/spm/c" + str(ind+1) + subj +
                    "_T1w_defaced_max.nii.gz")
        nii = load(filename)
        data.append(nii.get_data().reshape((nii.shape + (1,))))

    # %% find maximum prob across all files
    data = np.concatenate((data), axis=3)
    # for which tissue probability class do we get the highest probability?
    aryArgMax = np.argmax(data, axis=3)
    # increment to dinstinguish all-zero voxels from voxel with 0th label
    aryArgMax += 1
    # reset all voxels that are zero in all 3 labels to zero
    aryArgMax[np.all(np.isclose(data, 0.0), axis=-1)] = 0

    # save as nifti
    out = Nifti1Image(aryArgMax, header=nii.header, affine=nii.affine)
    outname = os.path.join(parent_path, "derivatives", subj, "segmentations",
                           "spm", subj + "_T1w_seg.nii.gz")
    save(out, outname)
    print("... created")
