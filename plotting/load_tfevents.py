#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 18 12:20:23 2019

@author: marian
"""

from tensorboard.backend.event_processing.event_accumulator import EventAccumulator


def func_load_event(str_path, tf_size_guidance=None, name_scalar='epoch_loss'):
    """Load data from tfevents file."""

    if tf_size_guidance is None:
        # Loading too much data is slow...
        tf_size_guidance = {
            'compressedHistograms': 10,
            'images': 0,
            'scalars': 100,
            'histograms': 1}

    event_acc = EventAccumulator(str_path, tf_size_guidance)
    event_acc.Reload()

    # print(event_trn.Tags())

    lst_trn_lss = event_acc.Scalars(name_scalar)
    lst_trn_lss = [lst_trn_lss[i][2] for i in range(len(lst_trn_lss))]

    return lst_trn_lss