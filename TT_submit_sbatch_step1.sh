#!/bin/bash

# written by Nathan Muncy on 8/11/17
# wrapper script for sbatch_step1


workDir=~/compute/Nate_work/v2_mni
scanDir=${workDir}/Scans
scriptDir=${workDir}/Scripts
slurmDir=${workDir}/Slurm_out
tempDir=${workDir}/mni_icbm152_nlin_sym_09c_nifti/mni_icbm152_nlin_sym_09c

time=`date '+%Y_%m_%d-%H_%M_%S'`

cd $slurmDir
if [ ! -d $time ]; then
    mkdir $time
fi

outDir=${slurmDir}/${time}


cd $scanDir

for i in s* ; do

    subjDir=${scanDir}/${i}

    sbatch \
    -o ${outDir}/output_step1_${i}.txt \
    -e ${outDir}/error_step1_${i}.txt \
    ${scriptDir}/sbatch_step1.sh $i $workDir $scanDir $tempDir $subjDir

    sleep 1

done
