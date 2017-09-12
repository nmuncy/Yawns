#!/bin/bash

# written by Nathan Muncy on 8/11/17
# This script will split Neurosynth masks, rename them, and pull subject mean betas for each mask

### Variables

workDir=/Volumes/Yorick/YAWNS3
roiDir=${workDir}/roiAnalysis
refDir=${workDir}/Jensenpedisleep032/5_Hour
print1=${roiDir}/roi_NGF_betas.txt
print2=${roiDir}/roi_GNG_betas.txt

> $print1
> $print2



### Arrays

#Attention
Attn_0=(1:rParietal)
Attn_1=(2:rFrontal)
Attn_2=(3:lParietal)
Attn_3=(4:lFrontal)
Attn_4=(5:rInfParietal)

Attn_list=(
Attn_0[@]
Attn_1[@]
Attn_2[@]
Attn_3[@]
Attn_4[@]
)

#Reward
Reward_0=(1:blBG)
Reward_1=(2:midbrain)
Reward_2=(3:ACC)
Reward_3=(4:lOFC)
Reward_4=(5:PCC)
Reward_5=(6:rOFC)

Reward_list=(
Reward_0[@]
Reward_1[@]
Reward_2[@]
Reward_3[@]
Reward_4[@]
Reward_5[@]
)

#Inhibition
Inhibit_0=(1:rAntInsula)
Inhibit_1=(2:rInfParietal)
Inhibit_2=(3:rMidFrontal)
Inhibit_3=(4:rACC)

Inhibit_list=(
Inhibit_0[@]
Inhibit_1[@]
Inhibit_2[@]
Inhibit_3[@]
)

subjList=(004 006 007 008 009 010 012 013 014 015 017 019 020 021 022 023 024 025 027 028 029 030 032 033 034 035 036 037 038 041 042 043 044 045 046 047 048 049 050 051 052 053 055 056 058 059 060 061 063 064 066 067 068)
MaskType=(Attn Reward Inhibit)





### Functions

# take neurosynth mask, split, resample, and binarize it.
MakeMask() {
    file=$1
    name=${file%%_*}
    num=`3dinfo $file | grep "At sub-brick #0 '#0' datum type is short" | sed 's/[^0-9]*//g' | sed 's/^...//'`
    3dcopy $file tmp_${name}.nii.gz
    for (( c=1; c<=$num; c++ )); do
        c3d tmp_${name}.nii.gz -thresh $c $c 1 0 -o tmp_${name}_mask${c}.nii.gz
        3dcopy tmp_${name}_mask${c}.nii.gz tmp_${name}_mask${c}+tlrc
        3dFractionize -template ${refDir}/deconv_GNGvF_blur5_ANTS_resampled+tlrc -input tmp_${name}_mask${c}+tlrc -prefix tmp_${name}_mask${c}_resampled
        3dcalc -a tmp_${name}_mask${c}_resampled+tlrc -prefix ${name}_mask${c} -expr "step(a)"
    done
    rm tmp*
}


# rename numeric mask according to arrays defined above
# it would be nice to do this in one function, but having triple-nested arrays was stupid hard
RenameAttn() {
    len=${#Attn_list[@]}
    for (( a=0; a<$len; a++ )); do
        let c=$[$a+1]
        fileB=Attn_mask${c}+tlrc.BRIK
        fileH=Attn_mask${c}+tlrc.HEAD
        maskN=${!Attn_list[a]%:*}
        name=${!Attn_list[a]#*:}
        mv $fileB ${fileB/$maskN/_$name}
        mv $fileH ${fileH/$maskN/_$name}
    done
}

RenameReward() {
    len=${#Reward_list[@]}
    for (( a=0; a<$len; a++ )); do
        let c=$[$a+1]
        fileB=Reward_mask${c}+tlrc.BRIK
        fileH=Reward_mask${c}+tlrc.HEAD
        maskN=${!Reward_list[a]%:*}
        name=${!Reward_list[a]#*:}
        mv $fileB ${fileB/$maskN/_$name}
        mv $fileH ${fileH/$maskN/_$name}
    done
}

RenameInhibit() {
    len=${#Inhibit_list[@]}
    for (( a=0; a<$len; a++ )); do
        let c=$[$a+1]
        fileB=Inhibit_mask${c}+tlrc.BRIK
        fileH=Inhibit_mask${c}+tlrc.HEAD
        maskN=${!Inhibit_list[a]%:*}
        name=${!Inhibit_list[a]#*:}
        mv $fileB ${fileB/$maskN/_$name}
        mv $fileH ${fileH/$maskN/_$name}
    done
}



### work

# make masks
cd $roiDir
for i in *_k*mask+tlrc.HEAD; do

    name=${i%.*}
    string=${i%%_*}

    if [ ! -f ${string}_mask1+tlrc.HEAD ]; then
        MakeMask $name
    fi

done


# rename Attn, Reward, Inhibit masks
for i in ${MaskType[@]}; do
    if [ -f ${i}_mask1+tlrc.HEAD ]; then
        Rename$i
    fi
done


# split BG masks for hemi
if [ ! -f Reward_mask_lBG+tlrc.HEAD ]; then

    3dcopy Reward_mask_blBG+tlrc tmp_file.nii.gz

    c3d tmp_file.nii.gz -as SEG -cmp -pop -pop -thresh 50% inf 1 0 -as MASK \
    -push SEG -times -o tmp_Rmask.nii.gz \
    -push MASK -replace 1 0 0 1 \
    -push SEG -times -o tmp_Lmask.nii.gz

    3dcopy tmp_Lmask.nii.gz Reward_mask_lBG+tlrc
    3dcopy tmp_Rmask.nii.gz Reward_mask_rBG+tlrc

    rm tmp*
fi


# make list of masks
c=0; for i in *mask*HEAD; do
    if [[ $i != *z* ]] && [ $i != Reward_mask_blBG+tlrc.HEAD ]; then

        maskList[$c]=${i/.HEAD}
        let c=$[$c+1]

    fi
done


# pull, print betas
for i in ${subjList[@]}; do

    echo $i >> $print1
    echo $i >> $print2

    for j in 5_Hour 9_Hour; do
        echo $j >> $print1
        echo $j >> $print2

        for k in ${maskList[@]}; do

            mask=${roiDir}/$k
            data1=${workDir}/Jensenpedisleep${i}/${j}/deconv_gonogo2_blur5_ANTS_resampled+tlrc
            data2=${workDir}/Jensenpedisleep${i}/${j}/deconv_GNGvF_blur5_ANTS_resampled+tlrc
            betas1=1,3,5
            betas2=1,3

            type=${k%%_*}
            hold=${k##*_}
            string=${hold%+*}

            stats1=`3dROIstats -mask $mask "${data1}[${betas1}]}"`
            stats2=`3dROIstats -mask $mask "${data2}[${betas2}]}"`

            echo "$type $string $stats1" >> $print1
            echo "$type $string $stats2" >> $print2

        done
    done

echo >> $print1
echo >> $print2
done








