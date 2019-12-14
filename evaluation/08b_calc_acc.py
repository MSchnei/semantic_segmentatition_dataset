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
lst_sg_models = ['project32_32strides_maxpool_tranposed_classic_pre',
                 'project43_32strides_maxpool_tranposed_dense_dr_0p05']
# list header descriptions for every model
lst_model_headers = ['UNet', 'Tiramisu']

# list the strides (test-time augmentation rates that should be considered)
lst_aug_strides = ['stride_64', 'stride_32', 'stride_16']

# set path to ground truth
str_gt = os.path.join(str_gt_path, 'derivatives', str_subj, 'labeled',
                      str_subj + '_labels_v01.nii.gz')

# %%

# Prepare lists for different metrics
resultsAcc = []
resultsF1 = []

# Load ground truth image
tns_gt = func_nii_to_tf_tensor(str_gt, dtype=np.int32)

# loop over models
for model_name, sg_model in zip(lst_model_headers, lst_sg_models):
    
    # Append model name to lists for row header
    resultsAcc.append([model_name])
    resultsF1.append([model_name])
    
    # loop over augmentations
    for ind_aug, aug_stride in enumerate(lst_aug_strides):

        # derive path to predicted segmentations
        str_ps = os.path.join(str_sg_path, sg_model, aug_stride,
                              'pred.nii.gz')
        
        # derive path to predicted probabilities
        str_pp = os.path.join(str_sg_path, sg_model, aug_stride,
                              'pred_per_class.nii.gz')

        # Load nifti files and convert to tensors
        # Load predicted segmentation
        tns_ps = func_nii_to_tf_tensor(str_ps, dtype=np.int32)
        # Load predicted probabilities
        tns_pp = func_nii_to_tf_tensor(str_pp, dtype=np.float32)

        # Calculate accuracy
        obj_acc = tf.keras.metrics.SparseCategoricalAccuracy()
        obj_acc.update_state(tns_gt, tns_pp)
        var_acc = obj_acc.result().numpy()
        
        # Convert to one-hot tensors
        tns_gt_hot = tf.one_hot(tns_gt, 8, dtype=tns_gt.dtype)
        tns_ps_hot = tf.one_hot(tns_ps, 8, dtype=tns_ps.dtype)
        # Calculate f1 score, set average None or 'weighted'
        obj_f1 = tfa.metrics.F1Score(num_classes=8, average='weighted')
        obj_f1.update_state(tf.reshape(tns_gt_hot, [-1, 8]),
                            tf.reshape(tns_ps_hot, [-1, 8]))
        var_f1 = obj_f1.result().numpy()
        
        # Append calculated metrics to metrics list
        resultsAcc[ind_aug].extend(["%.4f" % var_acc])
        resultsF1[ind_aug].extend(["%.4f" % var_f1])


# %% print tables

print('Accuracy')
table = tabulate(resultsAcc,  tablefmt='orgtbl',
                 headers=[''] + lst_aug_strides)
print(table)
table = tabulate(resultsAcc,  tablefmt='latex',
                 headers=[''] + lst_aug_strides)
print(table)

print('Weighted F1 Score')
table = tabulate(resultsF1,  tablefmt='orgtbl',
                 headers=[''] + lst_aug_strides)
print(table)
table = tabulate(resultsF1,  tablefmt='latex',
                 headers=[''] + lst_aug_strides)
print(table)