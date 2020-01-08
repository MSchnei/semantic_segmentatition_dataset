#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Compare different normnalization schemes for TiramisuNet."""

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
lst_prj = ['project53_32strides_maxpool_tranposed_dense_IN_nose',
           'project56_32strides_maxpool_tranposed_dense_INLN_nose']

# list project names for plotting
lst_names = ['_denseIN',
             '_denseINLN']

# Set subfolder to training logs
lst_evnt_trn = ['events.out.tfevents.1578332955.bi-node1.bi.22385.7834.v2',
                'events.out.tfevents.1578368563.bi-node1.bi.23311.9638.v2']

# Set subfolder to validation logs
lst_evnt_val = ['events.out.tfevents.1578333901.bi-node1.bi.22385.63877.v2',
                'events.out.tfevents.1578369772.bi-node1.bi.23311.82885.v2']

# Set color
lst_colors = ['#d7191c', '#d7191c',
              '#fdae61', '#fdae61']

# Set dashes
lst_dashes = [(''), (2, 2), (''), (2, 2)]

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
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/loss_INvsINLN.svg")
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/loss_INvsINLN.png")

# plot accuracies
fig, ax = plt.subplots()
fig.set_size_inches(17.5, 12.5)
sns.lineplot(data=df_acc, palette=lst_colors, dashes=lst_dashes,
             linewidth=2.5)
plt.xlabel("Number of Epochs")
plt.ylabel("Accuracy")
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/accuracy_INvsINLN.svg")
fig.savefig("/media/sf_D_DRIVE/Unet/presentation/results/plots/accuracy_INvsINLN.png")
