# Preparation of brain dataset for semantic segmentation with supervised learning
Collection of scripts with a two-fold purpose:
1. Training: Prepare MRI image dataset for training a supervised learning algorithm
(eg. a CNN/UNet) to perform semantic segmentation of tissue classes in human brain.
2. Testing: Evaluate the trained algorithm on hold-out dataset

# Description initial dataset
The scripts in this repository take as a starting point the following, initial data set:
```
Dataset: A scalable method to improve gray matter segmentation at ultra high field MRI.
```

The dataset is openly available as a zenodo repository and can be downloaded [here](https://zenodo.org/record/1117858).

# Prepare updated training data set
The scripts then perform several preprocessing steps in order to add more labels to the
dataset, since the initial dataset only contained gray matter labels.

The goal was to obtain the following ground truth labels:
[1] white matter
[2] grey matter
[3] cerebrospinal fluid
[4] ventricles
[5] subcortical
[6] vessels
[7] saggital sinus

The updated dataset will also be made openly available as a zenodo repository and will be downloadable [here](https://zenodo.org/record/3401388).

# Evaluation of algorithm performance
The scripts evaluate the performance of the learning algorithm, which includes plotting of training/validation loss and accuracy over training epochs.
