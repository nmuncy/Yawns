#!/bin/bash

# written by Nathan Muncy on 8/11/17
# construct some priors


workDir=/Volumes/Yorick/Nate_work/v2_mni/construction
cd $workDir


for i in extra_files_construct_head extra_files_ACT priors_ACT; do

    if [ ! -d $i ]; then
    mkdir $i
    fi

done



prior=${workDir}/priors_ACT
base=Template_BrainCerebellumBinaryMask.nii.gz


mv ss_* extra_files_ACT
cd extra_files_ACT


#### Get priors
cp ss_BrainExtractionMask.nii.gz ${prior}/${base}
cp ss_BrainSegmentation.nii.gz ${prior}/Template_AtroposSegmentation.nii.gz
cp ss_ExtractedBrain0N4.nii.gz ${prior}/Template_SkullStrippedBrain.nii.gz

for j in {1..6}; do
    cp ss_BrainSegmentationPosteriors${j}.nii.gz ${prior}/Prior${j}.nii.gz
done



#### Build priors
cd $prior

SmoothImage 3 $base 1 "${base/Binary/Probability}"
c3d $base -dilate 1 28x28x28vox -o "${base/Binary/Extraction}"
c3d $base -dilate 1 18x18x18vox -o  "${base/Binary/Registration}"

