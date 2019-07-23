"""Opening closing operations on MRI data (nifti)."""

import os
import numpy as np
from nibabel import load, save, Nifti1Image

# set analysis path
analysispath = str(os.environ['parent_path']) + "/data/shared_data/data_mp2rage"

# set list with subj names
subjnames = [
    'sub-001',
    'sub-013',
    'sub-014',
    'sub-019',
    ]

# set list with tissue labels
labellist = ['_csf', '_vessels', '_subcortical', '_sinus', '_wm',
             '_ventricles', '_gm']

# set array with numerical values in order corresponding to labels list
aryvalues = np.array([3, 6, 5, 7, 1, 4, 2], dtype=np.int32)

for subj in subjnames:
    print('Working on ' + subj)

    # create path to different labels and store paths in pathlist
    pathlist = []
    for labelname in labellist:
        pathlist.append(os.path.join(analysispath, 'derivatives', subj,
                                     'labels', subj + labelname + '.nii.gz'))

    # create nii object for every different label and store in niilist
    niilist = []
    for path in pathlist:
        niilist.append(load(path))

    # Loop over list with nii objects to get data
    for indNii, nii in enumerate(niilist):

        # load data as boolean
        tempbool = nii.get_data().astype(np.bool)

        if indNii == 0:
            dataOut = np.zeros((tempbool.shape), dtype=np.int32)

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
    out.set_data_dtype(np.int32)
    save(out, os.path.join(dirname, subj + '_all_labels_v01.nii.gz'))

    print '... image composed.'
