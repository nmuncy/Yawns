#!/bin/bash

# written by Nathan Muncy on 8/11/17
# this script will pull subject mean betas for each MVM cluster

workDir=/Volumes/Yorick/YAWNS3
grpDir=${workDir}/grpAnalysis
subjList=(004 006 007 008 009 010 012 013 014 015 017 019 020 021 022 023 024 025 027 028 029 030 032 033 034 035 036 037 038 041 042 043 044 045 046 047 048 049 050 051 052 053 055 056 058 059 060 061 063 064 066 067 068)



# build list of clusters
cd $grpDir
c=0; for a in Clust*HEAD; do

    clust[$c]="${a/+tlrc.HEAD}"
    let c=$[$c+1]

done


# pull number of labels per mask, split masks by label
if [ ! -f ${clust[0]}_1+tlrc.HEAD ]; then
    for b in ${clust[@]}; do

        if [ ! -f ${b}.nii.gz ]; then
            3dcopy ${b}+tlrc ${b}.nii.gz
        fi

        num=`3dinfo ${b}+tlrc | grep "At sub-brick #0 '#0' datum type is short" | sed 's/[^0-9]*//g' | sed 's/^...//'`
        for (( c=1; c<=$num; c++ )); do

            c3d ${b}.nii.gz -thresh $c $c 1 0 -o ${b}_${c}.nii.gz
            3dcopy ${b}_${c}.nii.gz ${b}_${c}+tlrc

        done

    rm *.nii.gz
    done
fi


# build list of masks
c=0; for d in Clust*HEAD; do
    if [[ $d != *mask+tlrc* ]]; then

        mask[$c]="${d/+tlrc.HEAD}"
        let c=$[$c+1]

    fi
done

maskLen="${#mask[@]}"

# make output txt files
for e in ${mask[@]}; do
    > ${e/Clust_}_betas.txt
done


# get, print betas
cd $workDir
for i in ${subjList[@]}; do

subjDir=${workDir}/Jensenpedisleep${i}
cd $subjDir

        for a in 5_Hour 9_Hour; do
        durDir=${subjDir}/$a
        cd $a

                for j in ${mask[@]}; do

                    print=${grpDir}/"${j/Clust_}"_betas.txt

                    if [[ $j == *DurNoGoFixBMI* ]]; then
                        betas=1,5
                        deconFile=deconv_gonogo2_blur5_ANTS_resampled+tlrc

                    elif [[ $j == *DurGoNoGoBMI* ]]; then
                        betas=1,3
                        deconFile=deconv_GNGvF_blur5_ANTS_resampled+tlrc
                    fi

                    stats=`3dROIstats -mask ${grpDir}/${j}+tlrc "${deconFile}[${betas}]"`
                    echo "$i $a $stats" >> $print
                    echo >> $print

                done

        cd $subjDir
        done

cd $workDir
done


## organize print
#this part needs to be updated to be more robust in various environments

cd $grpDir

if [ ! -d clust_dir ]; then
    mkdir clust_dir
fi

for i in Clust*; do
    if [[ $i != *mask+tlrc* ]]; then
        mv $i clust_dir
    fi
done



for a in ${clust[@]}; do
    > Master_"${a/Clust_}"_betas.txt
done

c=0; for b in Master*; do
    printM[$c]=$b
    let c=$[$c+1]
done


for a in ${printM[@]}; do
    for i in MVM*txt; do

        holdA=${a#*_}
        stringA=${holdA%_mask*}
        stringI=${i%_mask*}

        if [[ $stringA == $stringI ]]; then

            maskN=`ls $i | sed -e s/[^0-9]//g`
            echo "Mask $maskN" >> $a
            cat $i >> $a

        fi
    done
done


if [ ! -d txt_dir ]; then
    mkdir txt_dir
fi

mv MVM*txt txt_dir
