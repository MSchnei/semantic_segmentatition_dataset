#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Compare different norm and SE schemes for TiramisuNet, unweighted."""

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
lst_prj = ['project53_32strides_maxpool_tranposed_dense_IN_nose',
           'project54_32strides_maxpool_tranposed_dense_IN_cse',
           'project55_32strides_maxpool_tranposed_dense_IN_pe',
           'project56_32strides_maxpool_tranposed_dense_INLN_nose',
           'project57_32strides_maxpool_tranposed_dense_INLN_cse',
           'project58_32strides_maxpool_tranposed_dense_INLN_pe',
           'project59_32strides_maxpool_tranposed_dense_LN_nose',
           'project60_32strides_maxpool_tranposed_dense_LN_cse',
           'project61_32strides_maxpool_tranposed_dense_LN_pe',
           ]

# list project names for plotting
lst_names = ['_dense_IN_nose',
             '_dense_IN_cse',
             '_dense_IN_pe',
             '_dense_INLN_nose',
             '_dense_INLN_cse',
             '_dense_INLN_pe',
             '_dense_LN_nose',
             '_dense_LN_cse',
             '_dense_LN_pe'
             ]

# Set subfolder to training logs
lst_evnt_trn = ['events.out.tfevents.1578332955.bi-node1.bi.22385.7834.v2',
                'events.out.tfevents.1578418409.bi-node1.bi.26804.7860.v2',
                'events.out.tfevents.1578451731.bi-node1.bi.28655.7909.v2',
                'events.out.tfevents.1578368563.bi-node1.bi.23311.9638.v2',
                'events.out.tfevents.1578492429.bi-node1.bi.27725.9664.v2',
                'events.out.tfevents.1578536257.bi-node1.bi.28887.9713.v2',
                'events.out.tfevents.1579536362.bi-node1.bi.3471.5722.v2',
                'events.out.tfevents.1579616208.bi-node1.bi.6271.5748.v2',
                'events.out.tfevents.1579693207.bi-node1.bi.7939.5797.v2']

# Set subfolder to validation logs
lst_evnt_val = ['events.out.tfevents.1578333901.bi-node1.bi.22385.63877.v2',
                'events.out.tfevents.1578419349.bi-node1.bi.26804.63685.v2',
                'events.out.tfevents.1578452664.bi-node1.bi.28655.64112.v2',
                'events.out.tfevents.1578369772.bi-node1.bi.23311.82885.v2',
                'events.out.tfevents.1578493592.bi-node1.bi.27725.82693.v2',
                'events.out.tfevents.1578537455.bi-node1.bi.28887.83120.v2',
                'events.out.tfevents.1579537387.bi-node1.bi.3471.56837.v2',
                'events.out.tfevents.1579617198.bi-node1.bi.6271.56645.v2',
                'events.out.tfevents.1579694232.bi-node1.bi.7939.57072.v2']

# Set color
lst_colors = ['#6baed6', '#6baed6',
              '#3182bd', '#3182bd',
              '#08519c', '#08519c',
              '#74c476', '#74c476',
              '#31a354', '#31a354',
              '#006d2c', '#006d2c',
              '#fd8d3c', '#fd8d3c',
              '#e6550d', '#e6550d',
              '#a63603', '#a63603',
              ]

# Set dashes
lst_dashes = [(''), (2, 2), (''), (2, 2), (''), (2, 2),
              (''), (2, 2), (''), (2, 2), (''), (2, 2),
              (''), (2, 2), (''), (2, 2), (''), (2, 2)]

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
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/loss_norm_vs_se.svg", bbox_inches="tight")
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/loss_norm_vs_se.png", bbox_inches="tight")

# plot accuracies
fig, ax = plt.subplots()
fig.set_size_inches(17.5, 12.5)
sns.lineplot(data=df_acc, palette=lst_colors, dashes=lst_dashes,
             linewidth=2.5)
plt.xlabel("Number of Epochs")
plt.ylabel("Accuracy")
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/accuracy_norm_vs_se.svg", bbox_inches="tight")
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/accuracy_norm_vs_se.png", bbox_inches="tight")
