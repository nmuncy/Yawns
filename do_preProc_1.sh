#!/bin/bash
#
# do_preProc_passive.sh
#
# Example script to perform pre-processing. This will perform the following steps:
#   -rename the raw folder if it hasn't already been done
#   -convert anatomical and functional DICOM files to AFNI format
#   -slice-time correct (if needed, skip this for multi-band)
#   -motion correct within a run
#   -motion correct between runs
#   -co-register structural with functionals
#   -ANTs transform
#   -FreeSurfer segmentation
#   -skull strip and create brain-only mask
#   -make jpegs of the structural to send to subjects
#
# Instructions:
#   -Copy this file into your study directory and rename it something like do_preProc.sh
#   -Update all the study-specific things, like the raw data directory name, the number of functional runs, etc.
#   -Call the script from the study directory with this command: ./do_preProc_sleep.sh "subjectID" where subjectID (without quotes) is the directory name for the subject you want to process.
# Brock Kirwan
# 6/9/15


## Step 0: some variables and cd to the right directory
sub=$1
cd $sub

#Loop for time 1 and time 2. This assumes that you already have folders named "time1" and "time2"
for t in 5_Hour 9_Hour; do
#cd into the timepoint directory
cd $t


## Step 1: rename the raw folder
if [ ! -f raw ]; then
    mv Research_Jensen\ -\ 1 raw
fi


## Step 2: convert anatomical scan from DICOM to AFNI
if [ ! -f struct+orig.HEAD ]; then

    # Import standard structural from dicom to afni
    to3d -prefix struct raw/t1_mpr_sag_iso_*/*.dcm
fi

echo "--Importing functionals to AFNI--"


## Step 3: functional runs to afni
if [ ! -f gonogo1+orig.HEAD ]; then
    run1TRs=`ls -1 raw/gonogo1 | wc -l`
    to3d -prefix gonogo1 -time:zt 40 $run1TRs 3.0sec alt+z raw/gonogo1/*.dcm
fi
if [ ! -f gonogo2+orig.HEAD ]; then
    run2TRs=`ls -1 raw/gonogo2 | wc -l`
    to3d -prefix gonogo2 -time:zt 40 $run2TRs 3.0sec alt+z raw/gonogo2/*.dcm
fi
if [ ! -f passive+orig.HEAD ]; then
    run3TRs=`ls -1 raw/passive_viewing | wc -l`
    to3d -prefix passive -time:zt 40 $run3TRs 3.0sec alt+z raw/passive_viewing/*.dcm
fi


## Step 4: make motion files for passive viewing task
if [ -f motion_passive.txt ]; then
    rm motion_passive.txt
fi
cp motion_passive motion_1
../../move_censor.pl 
mv motion_censor_vector.txt motion_censor_vector_passive.txt


## Step 5: Align runs 1-2
3dvolreg -base gonogo1_volreg+orig'[0]' -prefix gonogo2_aligned gonogo2_volreg+orig


## Step 6: Align struct with run1
echo "--Aligning structural to functional run 1 volreg--"
# The 3dWarp method assumes no movement between the structural acquisition and functional acquisitions. You can try 3dAllineate instead. This doesn't always work, however, particularly when you go to run the aligned brains through ANTs.
# 3dAllineate -base run1_volreg+orig -prefix struct1_rotated -verb -mast_dxyz 1 -input struct1+orig
3dWarp -oblique_parent gonogo1+orig -prefix struct_rotated struct+orig
3dcopy struct_rotated+orig struct_rotated.nii


# move back to the subject's directory
cd ..

done #for $t 

