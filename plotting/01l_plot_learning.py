#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Compare different dropout rates for dense unet (Tiramisu)."""

import os
import numpy as np
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
from load_tfevents import func_load_event

# %% Set input parameters

# Set path to log directtory
str_log_path = '/media/sf_D_DRIVE/Unet/MPRAGEsingle/results/'

# List project names
lst_prj = ['project42_32strides_maxpool_tranposed_dense_dr_0p00',
           'project43_32strides_maxpool_tranposed_dense_dr_0p05',
           'project44_32strides_maxpool_tranposed_dense_dr_0p10',
           'project45_32strides_maxpool_tranposed_dense_dr_0p15',
           'project46_32strides_maxpool_tranposed_dense_dr_0p20']

# list project names for plotting
lst_names = ['_dropout0p00',
             '_dropout0p05',
             '_dropout0p10',
             '_dropout0p15',
             '_dropout0p20']

# Set subfolder to training logs
lst_evnt_trn = ['events.out.tfevents.1575905302.bi-node1.bi.4966.6516.v2',
                'events.out.tfevents.1575936767.bi-node1.bi.5712.7834.v2',
                'events.out.tfevents.1575972021.bi-node1.bi.6451.7834.v2',
                'events.out.tfevents.1576007657.bi-node1.bi.8352.7834.v2',
                'events.out.tfevents.1576043373.bi-node1.bi.13090.7834.v2']

# Set subfolder to validation logs
lst_evnt_val = ['events.out.tfevents.1575906121.bi-node1.bi.4966.58375.v2',
                'events.out.tfevents.1575937706.bi-node1.bi.5712.63877.v2',
                'events.out.tfevents.1575972970.bi-node1.bi.6451.63877.v2',
                'events.out.tfevents.1576008608.bi-node1.bi.8352.63877.v2',
                'events.out.tfevents.1576044317.bi-node1.bi.13090.63877.v2']

# Set color
lst_colors = ['#d7191c', '#d7191c',
              '#fdae61', '#fdae61',
              '#ffffbf', '#ffffbf',
              '#abdda4', '#abdda4',
              '#2b83ba', '#2b83ba']

# Set dashes
lst_dashes = [(''), (2, 2), (''), (2, 2), (''), (2, 2), (''), (2, 2),
              (''), (2, 2)]

# define size guidance for loading data
tf_size_guidance = {
    'compressedHistograms': 10,
    'images': 0,
    'scalars': 100,
    'histograms': 1}

# Initialize lists for collecting the results
lst_trn_lss = [None] * len(lst_evnt_trn)
lst_val_lss = [None] * len(lst_evnt_trn)
lst_trn_acc = [None] * len(lst_evnt_trn)
lst_val_acc = [None] * len(lst_evnt_trn)

# %% Load data

for ind in range(len(lst_evnt_trn)):
    # Derive paths to training and validation data
    str_evnt_trn = os.path.join(str_log_path, lst_prj[ind], 'logs', 'train',
                                lst_evnt_trn[ind])
    str_evnt_val = os.path.join(str_log_path, lst_prj[ind], 'logs',
                                'validation', lst_evnt_val[ind])

    # Load training and validation loss
    lst_trn_lss[ind] = func_load_event(str_evnt_trn,
                                       tf_size_guidance=tf_size_guidance,
                                       name_scalar='epoch_loss')
    lst_val_lss[ind] = func_load_event(str_evnt_val,
                                       tf_size_guidance=tf_size_guidance,
                                       name_scalar='epoch_loss')
    # Load training and validation accuracy
    lst_trn_acc[ind] = func_load_event(str_evnt_trn,
                                       tf_size_guidance=tf_size_guidance,
                                       name_scalar='epoch_sparse_categorical_accuracy')
    lst_val_acc[ind] = func_load_event(str_evnt_val,
                                       tf_size_guidance=tf_size_guidance,
                                       name_scalar='epoch_sparse_categorical_accuracy')

# %% Plot

# increase font size
sns.set(font_scale=2)
# get number of epochs
var_num_steps = len(lst_trn_lss[0])
ary_epochs = np.arange(var_num_steps)
# initialize data frames
df_loss = pd.DataFrame(index=ary_epochs)
df_acc = pd.DataFrame(index=ary_epochs)

for ind in range(len(lst_evnt_trn)):

    # add data to pandas loss data frame
    df_loss['trn_loss'+lst_names[ind]] = lst_trn_lss[ind]
    df_loss['val_loss'+lst_names[ind]] = lst_val_lss[ind]
    # add data to pandas loss data frame
    df_acc['trn_acc'+lst_names[ind]] = lst_trn_acc[ind]
    df_acc['val_acc'+lst_names[ind]] = lst_val_acc[ind]

# plot losses
fig, ax = plt.subplots()
fig.set_size_inches(17.5, 12.5)
sns.lineplot(data=df_loss, palette=lst_colors, dashes=lst_dashes,
             linewidth=2.5)
plt.xlabel("Number of Epochs")
plt.ylabel("Loss")
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/loss_dropout.svg")
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/loss_dropout.png")

# plot accuracies
fig, ax = plt.subplots()
fig.set_size_inches(17.5, 12.5)
sns.lineplot(data=df_acc, palette=lst_colors, dashes=lst_dashes,
             linewidth=2.5)
plt.xlabel("Number of Epochs")
plt.ylabel("Accuracy")
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/accuracy_dropout.svg")
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/accuracy_dropout.png")
