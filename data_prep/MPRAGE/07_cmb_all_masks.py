"""Opening closing operations on MRI data (nifti)."""

import os
import glob
import numpy as np
from nibabel import load, save, Nifti1Image

# set analysis path
analysispath = str(os.environ['parent_path']) + "/data/shared_data/data_mprage"

# set list with subj names
subjnames = ['sub-02', 'sub-03', 'sub-05', 'sub-06', 'sub-07']

# set array with values that brain mask, sub mask, ventricle mask and gm have
aryvalues = np.array([1, 2, 6, 5], dtype=np.float32)

for subj in subjnames:
    print('Working on ' + subj)

    # establish paths to different masks
    brainmask_path = os.path.join(analysispath, 'derivatives', subj,
                                  'segmentations', subj +
                                  '_brain_mask_v*.nii.gz')
    submask_path = os.path.join(analysispath, 'derivatives', subj,
                                'segmentations', subj + '_sub_mask_v*.nii.gz')
    venctricle_path = os.path.join(analysispath, 'derivatives', subj,
                                   'segmentations', subj +
                                   '_ventricle_mask_v*.nii.gz')
    gm_path = os.path.join(analysispath, 'derivatives', subj,
                           'ground_truth', subj + '_gm_v*.nii.gz')

    # put all paths in list
    pathlist = [brainmask_path, submask_path, venctricle_path, gm_path]
    # create list to store results
    niilist = []

    # Loop over list with file paths to get nii objects
    for path in pathlist:

        # get filename with spaceholder
        templstpath = glob.glob(path)

        # check that only one file was retrieved
        if len(templstpath) > 1:
            print('!!!More than one file found!!!')
        else:
            # load data and append to nii list
            niilist.append(load(templstpath[0]))

    # Loop over list with nii objects to get data
    for indNii, nii in enumerate(niilist):

        # load data as boolean
        tempbool = nii.get_data().astype(np.bool)

        if indNii == 0:
            dataOut = np.zeros((tempbool.shape), dtype=np.float32)

        # retrieve value that should be assigned
        tempval = aryvalues[indNii]
        # assign this value to data points indexed by boolean
        dataOut[tempbool] = tempval

    # Extract directory name
    dirname = os.path.dirname(niilist[0].get_filename())
    niiheader = niilist[0].header
    niiaffine = niilist[0].affine

    # save as nifti
    out = Nifti1Image(dataOut, header=niiheader, affine=niiaffine)
    save(out, os.path.join(dirname, subj + '_labels_v01.nii.gz'))

    print '... image composed.'
