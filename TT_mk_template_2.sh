#!/bin/bash

# written by Nathan Muncy on 8/11/17
# build a template in MNI space

### for vold2_mni_head
parentDir=/Volumes/Yorick/Nate_work/v2_mni
refDir=${parentDir}/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c
workDir=${parentDir}/construct_2


cd $workDir


DIM=3
ITER=30x90x30
TRANS=GR
SIM=CC
CON=2
PROC=6
REF=${refDir}/mni_icbm152_t1_tal_nlin_sym_09c.nii


buildtemplateparallel.sh \
-d $DIM \
-m $ITER \
-t $TRANS \
-s $SIM \
-c $CON \
-j $PROC \
-o vold2_mni_ \
-z $REF \
s*.nii.gz
