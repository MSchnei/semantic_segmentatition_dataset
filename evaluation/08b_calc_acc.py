#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Calculate accuracy for nifti files of predicted and ground truth images."""

import os
import numpy as np
import tensorflow as tf
from io_nii_data import func_nii_to_tf_tensor

# %% Set paramaters

# set parent path
str_parent_path = str(os.environ['parent_path'])

# set subject
str_subj = 'sub-02'

# set path to ground truth
str_gt = os.path.join(str_parent_path, 'data', 'segmentation_data',
                      'data_mprage', 'derivatives', str_subj, 'labeled',
                      str_subj + '_labels_v01.nii.gz')

# set path to predicted segmentation
str_ps = os.path.join(str_parent_path, 'MPRAGEsingle', 'predicted_nii',
                      'project34_32strides_maxpool_tranposed_dense_pre',
                      'pred_per_class.nii.gz')

# %% Step 1: Load nii and convert to tensors

# Load ground truth image
tns_gt = func_nii_to_tf_tensor(str_gt, dtype=np.int32)
# Load predicted segmentation
# expects one channel in last dimension for every label in gt
tns_ps = func_nii_to_tf_tensor(str_ps, dtype=np.float32)

# %% Step 2: Calculate accuracy

m = tf.keras.metrics.SparseCategoricalAccuracy()
m.update_state(tns_gt, tns_ps)
var_acc = m.result().numpy()
