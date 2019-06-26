print('hello world')

import os
import nipype.interfaces.spm as spm

# define tissue path
path_tissue = '/home/marian/Documents/spm12/tpm/TPM.nii'

# get new segmentation module from spm
print('Importing NewSegment module...')
seg = spm.NewSegment()
print('... done')

# Define subject name
str_path_subj = 'sub-02'

# Define channels
str_path_filename = os.path.join(os.environ['parent_path'], 'data',
                                 'shared_data', 'data_mprage', 'derivatives',
                                 str_path_subj, 'unbiased', str_path_subj +
                                 '_T1wDivPD_unbiased.nii')
print(str_path_filename)
seg.inputs.channel_files = str_path_filename
seg.inputs.channel_info = (0.001, 60, (False, True))

# Define tissues
tissue1 = ((path_tissue, 1), 3, (True, False), (False, False))
tissue2 = ((path_tissue, 2), 2, (True, False), (False, False))
tissue3 = ((path_tissue, 3), 2, (True, False), (False, False))
tissue4 = ((path_tissue, 4), 3, (True, False), (False, False))
tissue5 = ((path_tissue, 5), 4, (True, False), (False, False))
tissue6 = ((path_tissue, 6), 2, (True, False), (False, False))
seg.inputs.tissues = [tissue1, tissue2, tissue3, tissue4, tissue5, tissue6]

# Set warping options
seg.inputs.affine_regularization = 'mni'
seg.inputs.sampling_distance = 3.0
seg.inputs.write_deformation_fields = [False, False]

# Run segmentation
print('Run segmentation...')
seg.run()
print('... done')
