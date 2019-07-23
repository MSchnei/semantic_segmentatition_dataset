"""Opening closing operations on MRI data (nifti)."""

import os
import numpy as np
from scipy.ndimage import morphology
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

for subj in subjnames:
    print("Working on " + subj)

    # load data
    nii = load(os.path.join(analysispath, 'derivatives', subj, 'composition',
                            'ilr_coord_1_labels_0.nii.gz'))
    basename = nii.get_filename().split(os.extsep, 1)[0]
    dirname = os.path.dirname(nii.get_filename())
    data = nii.get_data()

    print('... data contains these unique values:')
    print('... ' + str(np.unique(data)))

    # perform opening
    data = morphology.binary_erosion(data, iterations=1)
    data = morphology.binary_dilation(data, iterations=1)
    # perform closing
    data = morphology.binary_dilation(data, iterations=1)
    data = morphology.binary_erosion(data, iterations=1)

    # save as nifti
    out = Nifti1Image(data, header=nii.header, affine=nii.affine)
    save(out, basename + '_open_close.nii.gz')

    print '... morphology operations are done.'
