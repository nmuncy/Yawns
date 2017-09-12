#!/bin/sh

# written by Nathan Muncy on 8/11/17
# run the template through joint label fusion


#SBATCH --time=50:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=32768M   # memory per CPU core
#SBATCH -J "v2jlf"   # job name

# Compatibility variables for PBS. Delete if not needed.
export PBS_NODEFILE=`/fslapps/fslutils/generate_pbs_nodefile`
export PBS_JOBID=$SLURM_JOB_ID
export PBS_O_WORKDIR="$SLURM_SUBMIT_DIR"
export PBS_QUEUE=batch

# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE


### settings for antsJointLabelFusion


workDir=/fslhome/kirwan/compute/Nate_work/v2_mni/construct_2
tempDir=~/bin/Templates/old_templates/oasis_20

dim=3
out=${workDir}/JLF_
subj=${workDir}/vold2_mni_template.nii.gz
atlas=${tempDir}/Atlases
labels=${tempDir}/Labels
parallel=5
cores=1
post=${workDir}/priors_JLF/label_%04d.nii.gz


antsJointLabelFusion_fixed.sh \
-d ${dim} \
-t ${subj} \
-o ${out} \
-p ${post} \
-c ${parallel} \
-j ${cores} \
-g ${atlas}/atlas_1/t1weighted.nii.gz -l ${labels}/1_labels.nii.gz \
-g ${atlas}/atlas_2/t1weighted.nii.gz -l ${labels}/2_labels.nii.gz \
-g ${atlas}/atlas_3/t1weighted.nii.gz -l ${labels}/3_labels.nii.gz \
-g ${atlas}/atlas_4/t1weighted.nii.gz -l ${labels}/4_labels.nii.gz \
-g ${atlas}/atlas_5/t1weighted.nii.gz -l ${labels}/5_labels.nii.gz \
-g ${atlas}/atlas_6/t1weighted.nii.gz -l ${labels}/6_labels.nii.gz \
-g ${atlas}/atlas_7/t1weighted.nii.gz -l ${labels}/7_labels.nii.gz \
-g ${atlas}/atlas_8/t1weighted.nii.gz -l ${labels}/8_labels.nii.gz \
-g ${atlas}/atlas_9/t1weighted.nii.gz -l ${labels}/9_labels.nii.gz \
-g ${atlas}/atlas_10/t1weighted.nii.gz -l ${labels}/10_labels.nii.gz \
-g ${atlas}/atlas_11/t1weighted.nii.gz -l ${labels}/11_labels.nii.gz \
-g ${atlas}/atlas_12/t1weighted.nii.gz -l ${labels}/12_labels.nii.gz \
-g ${atlas}/atlas_13/t1weighted.nii.gz -l ${labels}/13_labels.nii.gz \
-g ${atlas}/atlas_14/t1weighted.nii.gz -l ${labels}/14_labels.nii.gz \
-g ${atlas}/atlas_15/t1weighted.nii.gz -l ${labels}/15_labels.nii.gz \
-g ${atlas}/atlas_16/t1weighted.nii.gz -l ${labels}/16_labels.nii.gz \
-g ${atlas}/atlas_17/t1weighted.nii.gz -l ${labels}/17_labels.nii.gz \
-g ${atlas}/atlas_18/t1weighted.nii.gz -l ${labels}/18_labels.nii.gz \
-g ${atlas}/atlas_19/t1weighted.nii.gz -l ${labels}/19_labels.nii.gz \
-g ${atlas}/atlas_20/t1weighted.nii.gz -l ${labels}/20_labels.nii.gz 
