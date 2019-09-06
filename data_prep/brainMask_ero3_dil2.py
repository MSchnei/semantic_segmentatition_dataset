"""Opening closing operations on MRI data (nifti)."""

import os
import numpy as np
from scipy.ndimage import morphology
from nibabel import load, save, Nifti1Image

# set parameters
nii = load('/media/sf_D_DRIVE/Unet/data/shared_data/data_mp2rage/derivatives/sub-019/segmentations/sub-019_WM_v01.nii.gz')

# load data
basename = nii.get_filename().split(os.extsep, 1)[0]
dirname = os.path.dirname(nii.get_filename())
data = nii.get_data()

print('Data contains these unique values:')
print(str(np.unique(data)))

# perform closing

data = morphology.binary_dilation(data, iterations=1)
data = morphology.binary_dilation(data, iterations=1)


# save as nifti

out = Nifti1Image(data, header=nii.header, affine=nii.affine)
save(out, basename + "_ero3_dil3.nii.gz")


print 'Morphology operations are done.'
