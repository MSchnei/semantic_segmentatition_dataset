"""Opening closing operations on MRI data (nifti)."""

import os
import numpy as np
from scipy.ndimage import morphology
from nibabel import load, save, Nifti1Image

# set analysis path
analysispath = str(os.environ['parent_path']) + "/data/shared_data/data_mprage"

# set list with subj names
subjnames = ['sub-02', 'sub-03', 'sub-05', 'sub-06', 'sub-07']

for subj in subjnames:
    print("Working on " + subj)

    # load data
    nii = load(os.path.join(analysispath, 'derivatives', subj, 'masks',
                            subj + '_nosub_mask.nii.gz'))
    basename = nii.get_filename().split(os.extsep, 1)[0]
    dirname = os.path.dirname(nii.get_filename())
    data = nii.get_data()

    print('... data contains these unique values:')
    print('... ' + str(np.unique(data)))

    # perform closing
    data = morphology.binary_dilation(data, iterations=1)
    data = morphology.binary_erosion(data, iterations=1)

    # save as nifti
    out = Nifti1Image(data, header=nii.header, affine=nii.affine)
    save(out, basename + '_close.nii.gz')

    print '... morphology operations are done.'
