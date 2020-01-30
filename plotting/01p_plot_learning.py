#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Compare different norm and SE schemes for TiramisuNet, weighted, dr 0.05."""

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
lst_prj = ['project53b_32strides_maxpool_tranposed_dense_IN_nose_weighted',
           'project54b_32strides_maxpool_tranposed_dense_IN_cse_weighted',
           'project55b_32strides_maxpool_tranposed_dense_IN_pe_weighted',
           'project56b_32strides_maxpool_tranposed_dense_INLN_nose_weighted',
           'project57b_32strides_maxpool_tranposed_dense_INLN_cse_weighted',
           'project58b_32strides_maxpool_tranposed_dense_INLN_pe_weighted',
           'project59b_32strides_maxpool_tranposed_dense_LN_nose_weighted',
           'project60b_32strides_maxpool_tranposed_dense_LN_cse_weighted',
           'project61b_32strides_maxpool_tranposed_dense_LN_pe_weighted',
           ]

# list project names for plotting
lst_names = ['_dense_IN_nose_w',
             '_dense_IN_cse_w',
             '_dense_IN_pe_w',
             '_dense_INLN_nose_w',
             '_dense_INLN_cse_w',
             '_dense_INLN_pe_w',
             '_dense_LN_nose_w',
             '_dense_LN_cse_w',
             '_dense_LN_pe_w'
             ]

# Set subfolder to training logs
lst_evnt_trn = ['events.out.tfevents.1579297598.bi-node1.bi.27178.7922.v2',
                'events.out.tfevents.1579333136.bi-node1.bi.28396.7948.v2',
                'events.out.tfevents.1579366512.bi-node1.bi.30148.7997.v2',
                'events.out.tfevents.1579401688.bi-node1.bi.31020.9726.v2',
                'events.out.tfevents.1579447158.bi-node1.bi.534.9752.v2',
                'events.out.tfevents.1579491018.bi-node1.bi.1474.9801.v2',
                'events.out.tfevents.1579576142.bi-node1.bi.4363.5810.v2',
                'events.out.tfevents.1579654602.bi-node1.bi.7119.5836.v2',
                'events.out.tfevents.1579733101.bi-node1.bi.9795.5885.v2']

# Set subfolder to validation logs
lst_evnt_val = ['events.out.tfevents.1579298546.bi-node1.bi.27178.64050.v2',
                'events.out.tfevents.1579334025.bi-node1.bi.28396.63858.v2',
                'events.out.tfevents.1579367448.bi-node1.bi.30148.64285.v2',
                'events.out.tfevents.1579402893.bi-node1.bi.31020.83058.v2',
                'events.out.tfevents.1579448320.bi-node1.bi.534.82866.v2',
                'events.out.tfevents.1579492220.bi-node1.bi.1474.83293.v2',
                'events.out.tfevents.1579577174.bi-node1.bi.4363.57010.v2',
                'events.out.tfevents.1579655596.bi-node1.bi.7119.56818.v2',
                'events.out.tfevents.1579734129.bi-node1.bi.9795.57245.v2']

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
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/loss_norm_vs_se_weighted_dr0p05.svg", bbox_inches="tight")
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/loss_norm_vs_se_weighted_dr0p05.png", bbox_inches="tight")

# plot accuracies
fig, ax = plt.subplots()
fig.set_size_inches(17.5, 12.5)
sns.lineplot(data=df_acc, palette=lst_colors, dashes=lst_dashes,
             linewidth=2.5)
plt.xlabel("Number of Epochs")
plt.ylabel("Accuracy")
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/accuracy_norm_vs_se_weighted_dr0p05.svg", bbox_inches="tight")
fig.savefig("/Users/Marian/Documents/Unet/presentation/results/plots/accuracy_norm_vs_se_weighted_dr0p05.png", bbox_inches="tight")

