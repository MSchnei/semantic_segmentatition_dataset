#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Compare dropout rate in dense U-Net, trained with weighted loss."""

import os
import numpy as np
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
from load_tfevents import func_load_event

# %% Set input parameters

# Set path to log directtory
str_log_path = '/Users/Marian/Documents/Unet/MPRAGEsingle/results/'

# List project names
lst_prj = ['project51_32strides_maxpool_tranposed_dense_dr_0p05_weighted',
           'project51a_32strides_maxpool_tranposed_dense_dr_0p10_weighted',
           'project51b_32strides_maxpool_tranposed_dense_dr_0p15_weighted',
           'project51c_32strides_maxpool_tranposed_dense_dr_0p20_weighted',
           'project51d_32strides_maxpool_tranposed_dense_dr_0p25_weighted']

# list project names for plotting
lst_names = ['_dense_weighted_dr0p05',
             '_dense_weighted_dr0p10',
             '_dense_weighted_dr0p15',
             '_dense_weighted_dr0p20',
             '_dense_weighted_dr0p25']

# Set subfolder to training logs
lst_evnt_trn = ['events.out.tfevents.1578004967.bi-node1.bi.9960.7922.v2',
                'events.out.tfevents.1578603041.bi-node1.bi.3081.7922.v2',
                'events.out.tfevents.1578806310.bi-node1.bi.11127.7922.v2',
                'events.out.tfevents.1578842239.bi-node1.bi.11859.7922.v2',
                'events.out.tfevents.1578878182.bi-node1.bi.13742.7922.v2']

# Set subfolder to validation logs
lst_evnt_val = ['events.out.tfevents.1578005918.bi-node1.bi.9960.64050.v2',
                'events.out.tfevents.1578604004.bi-node1.bi.3081.64050.v2',
                'events.out.tfevents.1578807268.bi-node1.bi.11127.64050.v2',
                'events.out.tfevents.1578843193.bi-node1.bi.11859.64050.v2',
                'events.out.tfevents.1578879130.bi-node1.bi.13742.64050.v2']

# Set color
lst_colors = ['#e41a1c', '#e41a1c',
              '#377eb8', '#377eb8',
              '#4daf4a', '#4daf4a',
              '#984ea3', '#984ea3',
              '#ff7f00', '#ff7f00']

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
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/loss_dr_dense_weighted.svg")
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/loss_dr_dense_weighted.png")

# plot accuracies
fig, ax = plt.subplots()
fig.set_size_inches(17.5, 12.5)
sns.lineplot(data=df_acc, palette=lst_colors, dashes=lst_dashes,
             linewidth=2.5)
plt.xlabel("Number of Epochs")
plt.ylabel("Accuracy")

fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/accuracy_dr_dense_weighted.svg")
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/accuracy_dr_dense_weighted.png")
