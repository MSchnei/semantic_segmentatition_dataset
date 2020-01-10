#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Calculate accuracy for nifti files of predicted and ground truth images."""

import os
import numpy as np
import tensorflow as tf
import tensorflow_addons as tfa
from tabulate import tabulate
from io_nii_data import func_nii_to_tf_tensor

# %% Set paramaters

# set parent path
str_parent_path = str(os.environ['parent_path'])

# set subject
str_subj = 'sub-02'

# path to ground truth images
str_gt_path = os.path.join(str_parent_path, 'data', 'segmentation_data',
                           'data_mprage')
# path to predicted segmentations
str_sg_path = os.path.join(str_parent_path, 'MPRAGEsingle', 'predicted_nii')

# list the segmentation models that should be considered
lst_sg_models = ['project50_32strides_maxpool_tranposed_classic_dr_0p05_weighted',
                 'project51_32strides_maxpool_tranposed_dense_dr_0p05_weighted',
                 'project52_32strides_maxpool_tranposed_denseExt_dr_0p05_weighted']
# list header descriptions for every model
lst_model_headers = ['UNet', 'Tiramisu51',  'Tiramisu68']
# list header description for every tissue class
lst_tss_headers = ['backgr', 'WM', 'GM', 'CSF',  'ventricle', 'subcortex',
                   'vessels', 'sinus']

# list the strides (test-time augmentation rates that should be considered)
lst_aug_strides = ['stride_32']

# set path to ground truth
str_gt = os.path.join(str_gt_path, 'derivatives', str_subj, 'labeled',
                      str_subj + '_labels_v01.nii.gz')

# %%

# Prepare lists for different metrics
resultsF1 = []

# Load ground truth image
tns_gt = func_nii_to_tf_tensor(str_gt, dtype=np.int32)

# loop over augmentations
for aug_stride in lst_aug_strides:
    print('---Working on augmentation: ' + aug_stride)

    # loop over models
    for indModel, sg_model in enumerate(lst_sg_models):
        model_name = lst_model_headers[indModel]
        print('------Working on model: ' + model_name)
    
        # Append model name to lists for row header
        resultsF1.append([model_name])

        # derive path to predicted segmentations
        str_ps = os.path.join(str_sg_path, sg_model, aug_stride,
                              'pred.nii.gz')

        # Load nifti files and convert to tensors
        # Load predicted segmentation
        tns_ps = func_nii_to_tf_tensor(str_ps, dtype=np.int32)

        # Convert to one-hot tensors
        tns_gt_hot = tf.one_hot(tns_gt, 8, dtype=tns_gt.dtype)
        tns_ps_hot = tf.one_hot(tns_ps, 8, dtype=tns_ps.dtype)
        # Calculate f1 score, set average None or 'weighted'
        obj_f1 = tfa.metrics.F1Score(num_classes=8, average=None)
        obj_f1.update_state(tf.reshape(tns_gt_hot, [-1, 8]),
                            tf.reshape(tns_ps_hot, [-1, 8]))
        ary_f1 = obj_f1.result().numpy()
        str_f1 = ["%.4f" % var_f1 for var_f1 in ary_f1]

        # Append calculated metrics to metrics list
        resultsF1[indModel].extend(str_f1)

    # %% print tables

    print('Weighted F1 Score: ' + aug_stride)
    table = tabulate(resultsF1,  tablefmt='orgtbl',
                     headers=[''] + lst_tss_headers)
    print(table)
    table = tabulate(resultsF1,  tablefmt='latex',
                     headers=[''] + lst_tss_headers)
    print(table)