"""
Description: Convert EvaluateSegmentation XML outputs to latex tables.
To be set:
   -path to parent directory,
   -list with programme names used for initial segmentation
   -subject names
Input:
   -evaluation xml files
Output:
   -overview tables with results
Written by: Marian Schneider, Faruk Gulban

Dependency:
https://github.com/Visceral-Project/EvaluateSegmentation

Note1: assumes that evaluate segmentation file was run
"""

import os
import xmltodict
from tabulate import tabulate

# %%
# specify path to the directory
dirStr = os.path.join(str(os.environ['parent_path']),
                      'data', 'segmentation_data', 'data_mprage')

# specify which programmes were used for evaluating the segmentation
switchLst = ['spm', 'fast', 'fs',
             'project50_32strides_maxpool_tranposed_classic_dr_0p05_weighted',
             'project51_32strides_maxpool_tranposed_dense_dr_0p05_weighted',
             'project52_32strides_maxpool_tranposed_denseExt_dr_0p05_weighted']
# write how programme names should appear in output table
nameLst = ['SPM', 'FAST', 'FS', '3DUnet', 'TiramisuNet51', 'TiramisuNet68']

# specify which subjects were evaluated
subjLst = ['sub-02']  # , 'sub-03', 'sub-05', 'sub-06', 'sub-07']

# specify which tissues were evalutaed
tissueLst = ['WM', 'GM', 'CSF', 'ventricle', 'vessel', 'sinus']  # 'subcortex'

# %% Create a list with path names of xml files that exist
summary = []
for subj in subjLst:

    # get file path
    tempPath = os.path.join(dirStr, 'derivatives', subj, 'evaluations')

    # define lists to collect file names for this subject
    filesSubj = []

    for switch in switchLst:

        progLst = []

        for tissue in tissueLst:

            evalFile = os.path.join(tempPath, subj + '_' + switch + '_' +
                                    tissue + '.xml')
            if os.path.exists(evalFile):
                progLst.append(evalFile)
            else:
                progLst.append('')

        filesSubj.append(progLst)

    summary.append(filesSubj)

    # %%

for filesSubj in summary:

    # prepare lists for different metrics
    resultsDice = []
    resultsVlsm = []
    resultsAvhd = []
    resultsHddt = []

    for indProg, progLst in enumerate(filesSubj):

        # Append programe name to lists for row header
        resultsDice.append([nameLst[indProg]])
        resultsVlsm.append([nameLst[indProg]])
        resultsAvhd.append([nameLst[indProg]])
        resultsHddt.append([nameLst[indProg]])

        for indFile, file in enumerate(progLst):

            if not file:
                # if file for this tisseu does not exist, add empty string
                resultsDice[indProg].extend([''])
                resultsVlsm[indProg].extend([''])
                resultsAvhd[indProg].extend([''])
                resultsHddt[indProg].extend([''])

            else:
                # if file exists, open file
                with open(file) as fd:
                    doc = xmltodict.parse(fd.read())

                # extract values
                dce = float(doc['measurement']['metrics']['DICE']['@value'])
                vls = float(doc['measurement']['metrics']['VOLSMTY']['@value'])
                ahd = float(doc['measurement']['metrics']['AVGDIST']['@value'])
                hdd = float(doc['measurement']['metrics']['HDRFDST']['@value'])

                # append values to respective list
                resultsDice[indProg].extend(["%.4f" % dce])
                resultsVlsm[indProg].extend(["%.4f" % vls])
                resultsAvhd[indProg].extend(["%.4f" % ahd])
                resultsHddt[indProg].extend(["%.4f" % hdd])

    # %% print tables

    print('DICE')
    table = tabulate(resultsDice,  tablefmt='orgtbl',
                     headers=[''] + tissueLst)
    print(table)
    table = tabulate(resultsDice,  tablefmt='latex',
                     headers=[''] + tissueLst)
    print(table)

    print('Volume Similarity')
    table = tabulate(resultsVlsm,  tablefmt='orgtbl',
                     headers=[''] + tissueLst)
    print(table)
    table = tabulate(resultsVlsm,  tablefmt='latex',
                     headers=[''] + tissueLst)
    print(table)

    print('Average Hausdorff Distance')
    table = tabulate(resultsAvhd,  tablefmt='orgtbl',
                     headers=[''] + tissueLst)
    print(table)
    table = tabulate(resultsAvhd,  tablefmt='latex',
                     headers=[''] + tissueLst)
    print(table)

    print('Hausdorff Distance')
    table = tabulate(resultsHddt,  tablefmt='orgtbl',
                     headers=[''] + tissueLst)
    print(table)
    table = tabulate(resultsHddt,  tablefmt='latex',
                     headers=[''] + tissueLst)
    print(table)
