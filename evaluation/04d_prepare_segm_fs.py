#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Create seperate, binarised nii files for each tissue type in fs segm."""


import os
import numpy as np
from nibabel import load, save, Nifti1Image

# set parent path
parent_path = os.path.join(str(os.environ['parent_path']), 'data',
                           'segmentation_data', 'data_mprage')

# set programme switch
switch = 'fs'

# list all subject names
app = [
   'sub-02',
   'sub-03',
   'sub-05',
   'sub-06',
   'sub-07'
  ]

# set segmentation labels
tissue = [
    'WM',
    'GM',
#    'CSF',
#    'vessel',
    'ventricle',
    'subcortex',
#    'sinus'
    ]

# set curent integer corresponding to segmentation label
label = [
    [2, 41, 250, 251, 252, 253, 254, 255],
    [3, 42],
#    [24, 122, 257, 701],
#    [30, 62],
    [4, 43, 72],
    [6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18, 19, 20, 24, 26, 27, 28,
     45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 58, 59, 60,
     15, 192],
#    [262]
    ]

# derive length of different lists
subjLen = len(app)
tissueLen = len(tissue)

for subj in app:
    # deduce name for segmentation result file
    segm = os.path.join(parent_path, 'derivatives', subj, 'segmentations',
                        switch, subj + '_T1w_seg.nii.gz')

    # loop throuh different tissue types
    for lab, tis in zip(label, tissue):
        # determine oupt image
        output = os.path.join(parent_path, 'derivatives', subj,
                              'segmentations', switch, subj + '_T1w_' + tis +
                              '.nii.gz')

        # Load segmentation image
        nii = load(segm)
        # Get voxels where tissue type is True (label conditions are met)
        aryLab = np.any(
            np.stack([nii.get_data() == ind_lab for ind_lab in lab]),
            axis=0)
        # Convert data type to input data type
        aryOut = aryLab.astype(nii.get_data_dtype())
        # save as nifti
        out = Nifti1Image(aryOut, header=nii.header, affine=nii.affine)
        save(out, output)
        print('Saved:')
        print(output)
