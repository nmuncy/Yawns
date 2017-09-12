#!/bin/bash

# written by Nathan Muncy on 8/11/17
# qsub submission of ACT, for rendering priors


workDir=~/compute/Nate_work/v2_mni/construct_2
tempDir=~/bin/Templates/old_templates/oasis_30


dim=3
mov=vold2_mni_template.nii.gz
fixed=${tempDir}/T_template0.nii.gz
bfixed=${tempDir}/T_template0_BrainCerebellum.nii.gz
pmask=${tempDir}/T_template0_BrainCerebellumProbabilityMask.nii.gz
emask=${tempDir}/T_template0_BrainCerebellumExtractionMask.nii.gz
prior=${tempDir}/Priors2/priors%d.nii.gz
out=ss_


cd $workDir

echo antsCorticalThickness.sh \
-d $dim \
-a $mov \
-e $fixed \
-t $bfixed \
-m $pmask \
-f $emask \
-p $prior \
-o $out \
| qsub -l nodes=1:ppn=4,pmem=16gb,walltime=20:00:00 -N v2mniSS

