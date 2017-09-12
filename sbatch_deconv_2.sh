#!/bin/bash

# written by Nathan Muncy on 8/11/17
# This script will deconvolve, register, and antify data


#SBATCH --time=05:00:00   # walltime
#SBATCH --ntasks=2   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=16gb   # memory per CPU core
#SBATCH -J "YAWNSdecon"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE



tempDir=$1
workDir=$2
scriptDir=$3


cd $workDir


### deconvolve data
name=GNGvF
if [ ! -f deconv_${name}_blur5+orig.HEAD ]; then

    3dDeconvolve -input gonogo1_volreg+orig gonogo2_aligned+orig \
    -polort A -num_stimts 9 \
    -mask struct_mask+orig \
    -stim_file  1 "motion_gonogo.txt[0]" -stim_label 1 "Roll"  -stim_base 1 \
    -stim_file  2 "motion_gonogo.txt[1]" -stim_label 2 "Pitch" -stim_base 2 \
    -stim_file  3 "motion_gonogo.txt[2]" -stim_label 3 "Yaw"   -stim_base 3 \
    -stim_file  4 "motion_gonogo.txt[3]" -stim_label 4 "dS"    -stim_base 4 \
    -stim_file  5 "motion_gonogo.txt[4]" -stim_label 5 "dL"    -stim_base 5 \
    -stim_file  6 "motion_gonogo.txt[5]" -stim_label 6 "dP"    -stim_base 6 \
    -stim_times 7  timingErrors.txt  'BLOCK(1,1)' -stim_label 7 errors \
    -stim_times 8  timingHiCorr.txt  'BLOCK(1,1)' -stim_label 8 corrNoGo \
    -stim_times 9  timingLoCorr.txt  'BLOCK(1,1)' -stim_label 9 corrGo \
    -num_glt 2 \
    -gltsym 'SYM: corrNoGo' -glt_label 1 corrNoGo \
    -gltsym 'SYM: corrGo'   -glt_label 2 corrGo \
    -censor 'motion_censor_vector_gonogo.txt[0]' \
    -tout -nobout -nocout \
    -bucket deconv_${name} \
    -x1D deconv_${name}.x1D \
    -jobs 2 \
    -GOFORIT 12

    # blur the functional dataset by 5mm
    3dmerge -prefix deconv_${name}_blur5 -1blur_fwhm 5 -doall deconv_${name}+orig

fi



### register, antify
template=${tempDir}/vold2_mni_head.nii.gz
struct=struct_rotated.nii
out=${struct%.*}

for i in deconv*blur5+orig.HEAD; do

    string=${i%+*}
    file=${i%.*}

    if [ ! -f ${string}_ANTS_resampled+tlrc.HEAD ]; then

        if [ ! -f struct_rotatedAffine.txt ]; then
            3dcopy struct_rotated+orig $struct
            ants.sh 3 $template $struct
        fi

        ${scriptDir}/antifyFunctional.sh $out $template $file

    fi
done









