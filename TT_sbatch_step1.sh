#!/bin/bash

# written by Nathan Muncy on 8/11/17
# This script will warp participant scans into MNI 152 space

#SBATCH --time=10:00:00   # walltime
#SBATCH --ntasks=2   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32gb   # memory per CPU core
#SBATCH -J "mniV2ants"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE




workDir=$2
tempDir=$4
subjDir=$5


cd $subjDir

FIX=${tempDir}/mni_icbm152_t1_tal_nlin_sym_09c.nii
MOV=${1}_acpc.nii.gz
OUT=ants

ITS=100x100x100x20
DIM=3
LMWT=0.9
INTWT=4
PCT=0.8
PARZ=100
INTENSITY=CC[$FIX,${MOV},${INTWT},4]

if [ ! -f ${OUT}Affine.txt ]; then

    ${ANTSPATH}/ANTS \
    $DIM \
    -o $OUT \
    -i $ITS \
    -t SyN[0.1] \
    -r Gauss[3,0.5] \
    -m $INTENSITY

fi


if [ ! -f ${1}_mni.nii.gz ]; then

    WarpImageMultiTransform $DIM $MOV ${OUT}toTemplate.nii.gz ${OUT}Warp.nii.gz ${OUT}Affine.txt -R $FIX
    WarpImageMultiTransform $DIM $FIX ${OUT}toMov.nii.gz -i ${OUT}Affine.txt ${OUT}InverseWarp.nii.gz -R $MOV

    cp ${OUT}toTemplate.nii.gz ${1}_mni.nii.gz

fi
