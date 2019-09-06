# Preparation of dataset for MRI tissue class segmentation of human brain
Collection of scripts that were used to prepare MRI image dataset for training
a unet to perform tissue class segmentation of the human brain.

# Description initial dataset
The scripts in this repository take as a starting point the following, initial data set:
```
Dataset: A scalable method to improve gray matter segmentation at ultra high field MRI.
```

The dataset is openly available as a zenodo repository and can be downloaded [here](https://zenodo.org/record/1117858).


# Description updated dataset
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
