"""Opening closing operations on MRI data (nifti)."""

import os
import glob
import numpy as np
from nibabel import load, save, Nifti1Image

# set analysis path
analysispath = str(os.environ['parent_path']) + "/data/shared_data/data_mp2rage"

# set list with subj names
subjnames = ['sub-001', 'sub-013', 'sub-014', 'sub-019']

# set array with values that brain mask, sub mask, ventricle mask and gm have
aryvalues = np.array([0, 0, 0, 0], dtype=np.int32)

for subj in subjnames:
    print('Working on ' + subj)

    # Load uni image
    uni_path = os.path.join(analysispath, 'derivatives', subj,
                            'unbiased', subj + '_uni_unbiased.nii.gz')
    uni_nii = load(uni_path)
    uni_data = uni_nii.get_data()

    # Load different masks
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
        # when we load the brain mask, we invert the boolean to set data
        # outside brain_mask to zero
        if indNii == 0:
            tempbool = np.invert(tempbool)

        # retrieve value that should be assigned
        tempval = aryvalues[indNii]
        # assign this value to data points in uni image indexed by boolean
        uni_data[tempbool] = tempval

    # Set directory name
    dirname = os.path.join(analysispath, 'derivatives', subj, 'segmentations')

    # save as nifti
    out = Nifti1Image(uni_data, header=uni_nii.header, affine=uni_nii.affine)
    save(out, os.path.join(dirname, subj + '_prep_WM_extract.nii.gz'))

    print '... WM extraction image prepared.'
