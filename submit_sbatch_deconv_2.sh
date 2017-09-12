#!/bin/bash

# written by Nathan Muncy on 8/11/17
# Wrapper script for sbatch_deconv_2


workDir=~/compute/YAWNS3
tempDir=~/bin/Templates/vold2_mni
scriptDir=${workDir}/Scripts
slurmDir=${workDir}/Slurm_out
time=`date '+%Y_%m_%d-%H_%M_%S'`
outDir=${slurmDir}/deconv_${time}

if [ ! -d $outDir ]; then
    mkdir -p $outDir
fi


cd $workDir

for i in J*; do
    for j in 5_Hour 9_Hour; do

        subjDir=${workDir}/${i}/${j}

        sbatch \
        -o ${outDir}/output_deconv_${i}_${j}.txt \
        -e ${outDir}/error_deconv_${i}_${j}.txt \
        ${scriptDir}/sbatch_deconv_2.sh $tempDir $subjDir $scriptDir


    sleep 1
    done
done

