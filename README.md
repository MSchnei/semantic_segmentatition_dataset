# Preparation of dataset for MRI tissue class segmentation of human brain
Collection of scripts that were used to prepare MRI image dataset for training
a unet to perform tissue class segmentation of the human brain.

# Description
The scripts in this repository take as a starting point the following data set:
```
Dataset: A scalable method to improve gray matter segmentation at ultra high field MRI.
```

The dataset is openly available as a zenodo repository and can be downloaded [here](https://zenodo.org/record/1117858).

The scripts then perform several preprocessing steps in order to add more labels to the
dataset, since the initial dataset only contained gray matter labels.
