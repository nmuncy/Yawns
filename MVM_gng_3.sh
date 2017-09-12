#!/bin/bash

# written by Nathan Muncy on 8/11/17
# This script will make a brain mask, run MC simulations, and run an MVM


workDir=/Volumes/Yorick/YAWNS3
grpDir=${workDir}/grpAnalysis
actDir=/Volumes/Yorick/Templates/vold2_mni/priors_ACT


if [ ! -d $grpDir ]; then
    mkdir $grpDir
fi


cd $grpDir


## make brain mask
if [ ! -f vold2_mni_brain_mask+tlrc.HEAD ]; then

    refScan=${workDir}/Jensenpedisleep041/5_Hour/deconv_gonogo2_blur5_ANTS_resampled+tlrc

    cp ${actDir}/Template_BrainCerebellumBinaryMask.nii.gz ${grpDir}/tmp_brain_mask.nii.gz
    3dcopy tmp_brain_mask.nii.gz tmp_brain_mask+tlrc
    3dfractionize -template $refScan -prefix tmp_brain_mask_resampled -input tmp_brain_mask+tlrc
    3dcalc -a tmp_brain_mask_resampled+tlrc -prefix vold2_mni_brain_mask -expr "step(a)"

    rm tmp*

fi


## run Monte Carlo simulations
if [ ! -f MCstats.txt ]; then

    stats=`3dClustSim -mask vold2_mni_brain_mask+tlrc -fwhm 5 -athr 0.05 -iter 10000 -NN 1 -nodec`
    echo "$stats" > MCstats.txt

fi



## run MVM
scan=deconv_GNGvF_blur5_ANTS_resampled+tlrc
out=MVM_DurGoNoGoBMI
mask=vold2_mni_brain_mask+tlrc

if [ ! -f ${out}+tlrc.HEAD ]; then

    3dMVM  -prefix $out -jobs 6 -mask $mask \
    -bsVars "BMI" \
    -wsVars "duration*stimtype" \
    -num_glt 3 \
    -gltLabel 1 dur.stim -gltCode 1 'duration: 1*5_Hour -1*9_Hour stimtype: 1*go -1*nogo' \
    -gltLabel 2 dur.bmi -gltCode 2 'duration: 1*5_Hour -1*9_Hour BMI: 1*Hi -1*Lo' \
    -gltLabel 3 stim.bmi -gltCode 3 'stimtype: 1*go -1*nogo BMI: 1*Hi -1*Lo' \
    -dataTable  \
    Subj                    duration	stimtype	BMI     InputFile \
    Jensenpedisleep004      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep004/5_Hour/"${scan}[1]" \
    Jensenpedisleep004      5_Hour      go          Lo      ${workDir}/JensenPedisleep004/5_Hour/"${scan}[3]" \
    Jensenpedisleep004      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep004/9_Hour/"${scan}[1]" \
    Jensenpedisleep004      9_Hour      go          Lo      ${workDir}/JensenPedisleep004/9_Hour/"${scan}[3]" \
    Jensenpedisleep006      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep006/5_Hour/"${scan}[1]" \
    Jensenpedisleep006      5_Hour      go          Lo      ${workDir}/JensenPedisleep006/5_Hour/"${scan}[3]" \
    Jensenpedisleep006      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep006/9_Hour/"${scan}[1]" \
    Jensenpedisleep006      9_Hour      go          Lo      ${workDir}/JensenPedisleep006/9_Hour/"${scan}[3]" \
    Jensenpedisleep007      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep007/5_Hour/"${scan}[1]" \
    Jensenpedisleep007      5_Hour      go          Lo      ${workDir}/JensenPedisleep007/5_Hour/"${scan}[3]" \
    Jensenpedisleep007      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep007/9_Hour/"${scan}[1]" \
    Jensenpedisleep007      9_Hour      go          Lo      ${workDir}/JensenPedisleep007/9_Hour/"${scan}[3]" \
    Jensenpedisleep008      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep008/5_Hour/"${scan}[1]" \
    Jensenpedisleep008      5_Hour      go          Lo      ${workDir}/JensenPedisleep008/5_Hour/"${scan}[3]" \
    Jensenpedisleep008      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep008/9_Hour/"${scan}[1]" \
    Jensenpedisleep008      9_Hour      go          Lo      ${workDir}/JensenPedisleep008/9_Hour/"${scan}[3]" \
    Jensenpedisleep009      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep009/5_Hour/"${scan}[1]" \
    Jensenpedisleep009      5_Hour      go          Lo      ${workDir}/JensenPedisleep009/5_Hour/"${scan}[3]" \
    Jensenpedisleep009      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep009/9_Hour/"${scan}[1]" \
    Jensenpedisleep009      9_Hour      go          Lo      ${workDir}/JensenPedisleep009/9_Hour/"${scan}[3]" \
    Jensenpedisleep010      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep010/5_Hour/"${scan}[1]" \
    Jensenpedisleep010      5_Hour      go          Lo      ${workDir}/JensenPedisleep010/5_Hour/"${scan}[3]" \
    Jensenpedisleep010      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep010/9_Hour/"${scan}[1]" \
    Jensenpedisleep010      9_Hour      go          Lo      ${workDir}/JensenPedisleep010/9_Hour/"${scan}[3]" \
    Jensenpedisleep012      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep012/5_Hour/"${scan}[1]" \
    Jensenpedisleep012      5_Hour      go          Lo      ${workDir}/JensenPedisleep012/5_Hour/"${scan}[3]" \
    Jensenpedisleep012      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep012/9_Hour/"${scan}[1]" \
    Jensenpedisleep012      9_Hour      go          Lo      ${workDir}/JensenPedisleep012/9_Hour/"${scan}[3]" \
    Jensenpedisleep013      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep013/5_Hour/"${scan}[1]" \
    Jensenpedisleep013      5_Hour      go          Lo      ${workDir}/JensenPedisleep013/5_Hour/"${scan}[3]" \
    Jensenpedisleep013      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep013/9_Hour/"${scan}[1]" \
    Jensenpedisleep013      9_Hour      go          Lo      ${workDir}/JensenPedisleep013/9_Hour/"${scan}[3]" \
    Jensenpedisleep014      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep014/5_Hour/"${scan}[1]" \
    Jensenpedisleep014      5_Hour      go          Lo      ${workDir}/JensenPedisleep014/5_Hour/"${scan}[3]" \
    Jensenpedisleep014      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep014/9_Hour/"${scan}[1]" \
    Jensenpedisleep014      9_Hour      go          Lo      ${workDir}/JensenPedisleep014/9_Hour/"${scan}[3]" \
    Jensenpedisleep015      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep015/5_Hour/"${scan}[1]" \
    Jensenpedisleep015      5_Hour      go          Lo      ${workDir}/JensenPedisleep015/5_Hour/"${scan}[3]" \
    Jensenpedisleep015      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep015/9_Hour/"${scan}[1]" \
    Jensenpedisleep015      9_Hour      go          Lo      ${workDir}/JensenPedisleep015/9_Hour/"${scan}[3]" \
    Jensenpedisleep017      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep017/5_Hour/"${scan}[1]" \
    Jensenpedisleep017      5_Hour      go          Lo      ${workDir}/JensenPedisleep017/5_Hour/"${scan}[3]" \
    Jensenpedisleep017      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep017/9_Hour/"${scan}[1]" \
    Jensenpedisleep017      9_Hour      go          Lo      ${workDir}/JensenPedisleep017/9_Hour/"${scan}[3]" \
    Jensenpedisleep019      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep019/5_Hour/"${scan}[1]" \
    Jensenpedisleep019      5_Hour      go          Lo      ${workDir}/JensenPedisleep019/5_Hour/"${scan}[3]" \
    Jensenpedisleep019      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep019/9_Hour/"${scan}[1]" \
    Jensenpedisleep019      9_Hour      go          Lo      ${workDir}/JensenPedisleep019/9_Hour/"${scan}[3]" \
    Jensenpedisleep020      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep020/5_Hour/"${scan}[1]" \
    Jensenpedisleep020      5_Hour      go          Lo      ${workDir}/JensenPedisleep020/5_Hour/"${scan}[3]" \
    Jensenpedisleep020      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep020/9_Hour/"${scan}[1]" \
    Jensenpedisleep020      9_Hour      go          Lo      ${workDir}/JensenPedisleep020/9_Hour/"${scan}[3]" \
    Jensenpedisleep021      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep021/5_Hour/"${scan}[1]" \
    Jensenpedisleep021      5_Hour      go          Lo      ${workDir}/JensenPedisleep021/5_Hour/"${scan}[3]" \
    Jensenpedisleep021      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep021/9_Hour/"${scan}[1]" \
    Jensenpedisleep021      9_Hour      go          Lo      ${workDir}/JensenPedisleep021/9_Hour/"${scan}[3]" \
    Jensenpedisleep022      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep022/5_Hour/"${scan}[1]" \
    Jensenpedisleep022      5_Hour      go          Lo      ${workDir}/JensenPedisleep022/5_Hour/"${scan}[3]" \
    Jensenpedisleep022      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep022/9_Hour/"${scan}[1]" \
    Jensenpedisleep022      9_Hour      go          Lo      ${workDir}/JensenPedisleep022/9_Hour/"${scan}[3]" \
    Jensenpedisleep023      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep023/5_Hour/"${scan}[1]" \
    Jensenpedisleep023      5_Hour      go          Lo      ${workDir}/JensenPedisleep023/5_Hour/"${scan}[3]" \
    Jensenpedisleep023      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep023/9_Hour/"${scan}[1]" \
    Jensenpedisleep023      9_Hour      go          Lo      ${workDir}/JensenPedisleep023/9_Hour/"${scan}[3]" \
    Jensenpedisleep024      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep024/5_Hour/"${scan}[1]" \
    Jensenpedisleep024      5_Hour      go          Lo      ${workDir}/JensenPedisleep024/5_Hour/"${scan}[3]" \
    Jensenpedisleep024      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep024/9_Hour/"${scan}[1]" \
    Jensenpedisleep024      9_Hour      go          Lo      ${workDir}/JensenPedisleep024/9_Hour/"${scan}[3]" \
    Jensenpedisleep025      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep025/5_Hour/"${scan}[1]" \
    Jensenpedisleep025      5_Hour      go          Lo      ${workDir}/JensenPedisleep025/5_Hour/"${scan}[3]" \
    Jensenpedisleep025      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep025/9_Hour/"${scan}[1]" \
    Jensenpedisleep025      9_Hour      go          Lo      ${workDir}/JensenPedisleep025/9_Hour/"${scan}[3]" \
    Jensenpedisleep027      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep027/5_Hour/"${scan}[1]" \
    Jensenpedisleep027      5_Hour      go          Lo      ${workDir}/JensenPedisleep027/5_Hour/"${scan}[3]" \
    Jensenpedisleep027      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep027/9_Hour/"${scan}[1]" \
    Jensenpedisleep027      9_Hour      go          Lo      ${workDir}/JensenPedisleep027/9_Hour/"${scan}[3]" \
    Jensenpedisleep028      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep028/5_Hour/"${scan}[1]" \
    Jensenpedisleep028      5_Hour      go          Lo      ${workDir}/JensenPedisleep028/5_Hour/"${scan}[3]" \
    Jensenpedisleep028      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep028/9_Hour/"${scan}[1]" \
    Jensenpedisleep028      9_Hour      go          Lo      ${workDir}/JensenPedisleep028/9_Hour/"${scan}[3]" \
    Jensenpedisleep029      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep029/5_Hour/"${scan}[1]" \
    Jensenpedisleep029      5_Hour      go          Lo      ${workDir}/JensenPedisleep029/5_Hour/"${scan}[3]" \
    Jensenpedisleep029      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep029/9_Hour/"${scan}[1]" \
    Jensenpedisleep029      9_Hour      go          Lo      ${workDir}/JensenPedisleep029/9_Hour/"${scan}[3]" \
    Jensenpedisleep030      5_Hour      nogo        Lo      ${workDir}/JensenPedisleep030/5_Hour/"${scan}[1]" \
    Jensenpedisleep030      5_Hour      go          Lo      ${workDir}/JensenPedisleep030/5_Hour/"${scan}[3]" \
    Jensenpedisleep030      9_Hour      nogo        Lo      ${workDir}/JensenPedisleep030/9_Hour/"${scan}[1]" \
    Jensenpedisleep030      9_Hour      go          Lo      ${workDir}/JensenPedisleep030/9_Hour/"${scan}[3]" \
    Jensenpedisleep032      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep032/5_Hour/"${scan}[1]" \
    Jensenpedisleep032      5_Hour      go          Hi      ${workDir}/Jensenpedisleep032/5_Hour/"${scan}[3]" \
    Jensenpedisleep032      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep032/9_Hour/"${scan}[1]" \
    Jensenpedisleep032      9_Hour      go          Hi      ${workDir}/Jensenpedisleep032/9_Hour/"${scan}[3]" \
    Jensenpedisleep033      5_Hour      nogo        Lo      ${workDir}/Jensenpedisleep033/5_Hour/"${scan}[1]" \
    Jensenpedisleep033      5_Hour      go          Lo      ${workDir}/Jensenpedisleep033/5_Hour/"${scan}[3]" \
    Jensenpedisleep033      9_Hour      nogo        Lo      ${workDir}/Jensenpedisleep033/9_Hour/"${scan}[1]" \
    Jensenpedisleep033      9_Hour      go          Lo      ${workDir}/Jensenpedisleep033/9_Hour/"${scan}[3]" \
    Jensenpedisleep034      5_Hour      nogo        Lo      ${workDir}/Jensenpedisleep034/5_Hour/"${scan}[1]" \
    Jensenpedisleep034      5_Hour      go          Lo      ${workDir}/Jensenpedisleep034/5_Hour/"${scan}[3]" \
    Jensenpedisleep034      9_Hour      nogo        Lo      ${workDir}/Jensenpedisleep034/9_Hour/"${scan}[1]" \
    Jensenpedisleep034      9_Hour      go          Lo      ${workDir}/Jensenpedisleep034/9_Hour/"${scan}[3]" \
    Jensenpedisleep035      5_Hour      nogo        Lo      ${workDir}/Jensenpedisleep035/5_Hour/"${scan}[1]" \
    Jensenpedisleep035      5_Hour      go          Lo      ${workDir}/Jensenpedisleep035/5_Hour/"${scan}[3]" \
    Jensenpedisleep035      9_Hour      nogo        Lo      ${workDir}/Jensenpedisleep035/9_Hour/"${scan}[1]" \
    Jensenpedisleep035      9_Hour      go          Lo      ${workDir}/Jensenpedisleep035/9_Hour/"${scan}[3]" \
    Jensenpedisleep036      5_Hour      nogo        Lo      ${workDir}/Jensenpedisleep036/5_Hour/"${scan}[1]" \
    Jensenpedisleep036      5_Hour      go          Lo      ${workDir}/Jensenpedisleep036/5_Hour/"${scan}[3]" \
    Jensenpedisleep036      9_Hour      nogo        Lo      ${workDir}/Jensenpedisleep036/9_Hour/"${scan}[1]" \
    Jensenpedisleep036      9_Hour      go          Lo      ${workDir}/Jensenpedisleep036/9_Hour/"${scan}[3]" \
    Jensenpedisleep037      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep037/5_Hour/"${scan}[1]" \
    Jensenpedisleep037      5_Hour      go          Hi      ${workDir}/Jensenpedisleep037/5_Hour/"${scan}[3]" \
    Jensenpedisleep037      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep037/9_Hour/"${scan}[1]" \
    Jensenpedisleep037      9_Hour      go          Hi      ${workDir}/Jensenpedisleep037/9_Hour/"${scan}[3]" \
    Jensenpedisleep038      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep038/5_Hour/"${scan}[1]" \
    Jensenpedisleep038      5_Hour      go          Hi      ${workDir}/Jensenpedisleep038/5_Hour/"${scan}[3]" \
    Jensenpedisleep038      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep038/9_Hour/"${scan}[1]" \
    Jensenpedisleep038      9_Hour      go          Hi      ${workDir}/Jensenpedisleep038/9_Hour/"${scan}[3]" \
    Jensenpedisleep041      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep041/5_Hour/"${scan}[1]" \
    Jensenpedisleep041      5_Hour      go          Hi      ${workDir}/Jensenpedisleep041/5_Hour/"${scan}[3]" \
    Jensenpedisleep041      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep041/9_Hour/"${scan}[1]" \
    Jensenpedisleep041      9_Hour      go          Hi      ${workDir}/Jensenpedisleep041/9_Hour/"${scan}[3]" \
    Jensenpedisleep042      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep042/5_Hour/"${scan}[1]" \
    Jensenpedisleep042      5_Hour      go          Hi      ${workDir}/Jensenpedisleep042/5_Hour/"${scan}[3]" \
    Jensenpedisleep042      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep042/9_Hour/"${scan}[1]" \
    Jensenpedisleep042      9_Hour      go          Hi      ${workDir}/Jensenpedisleep042/9_Hour/"${scan}[3]" \
    Jensenpedisleep043      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep043/5_Hour/"${scan}[1]" \
    Jensenpedisleep043      5_Hour      go          Hi      ${workDir}/Jensenpedisleep043/5_Hour/"${scan}[3]" \
    Jensenpedisleep043      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep043/9_Hour/"${scan}[1]" \
    Jensenpedisleep043      9_Hour      go          Hi      ${workDir}/Jensenpedisleep043/9_Hour/"${scan}[3]" \
    Jensenpedisleep044      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep044/5_Hour/"${scan}[1]" \
    Jensenpedisleep044      5_Hour      go          Hi      ${workDir}/Jensenpedisleep044/5_Hour/"${scan}[3]" \
    Jensenpedisleep044      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep044/9_Hour/"${scan}[1]" \
    Jensenpedisleep044      9_Hour      go          Hi      ${workDir}/Jensenpedisleep044/9_Hour/"${scan}[3]" \
    Jensenpedisleep045      5_Hour      nogo        Lo      ${workDir}/Jensenpedisleep045/5_Hour/"${scan}[1]" \
    Jensenpedisleep045      5_Hour      go          Lo      ${workDir}/Jensenpedisleep045/5_Hour/"${scan}[3]" \
    Jensenpedisleep045      9_Hour      nogo        Lo      ${workDir}/Jensenpedisleep045/9_Hour/"${scan}[1]" \
    Jensenpedisleep045      9_Hour      go          Lo      ${workDir}/Jensenpedisleep045/9_Hour/"${scan}[3]" \
    Jensenpedisleep046      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep046/5_Hour/"${scan}[1]" \
    Jensenpedisleep046      5_Hour      go          Hi      ${workDir}/Jensenpedisleep046/5_Hour/"${scan}[3]" \
    Jensenpedisleep046      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep046/9_Hour/"${scan}[1]" \
    Jensenpedisleep046      9_Hour      go          Hi      ${workDir}/Jensenpedisleep046/9_Hour/"${scan}[3]" \
    Jensenpedisleep047      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep047/5_Hour/"${scan}[1]" \
    Jensenpedisleep047      5_Hour      go          Hi      ${workDir}/Jensenpedisleep047/5_Hour/"${scan}[3]" \
    Jensenpedisleep047      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep047/9_Hour/"${scan}[1]" \
    Jensenpedisleep047      9_Hour      go          Hi      ${workDir}/Jensenpedisleep047/9_Hour/"${scan}[3]" \
    Jensenpedisleep048      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep048/5_Hour/"${scan}[1]" \
    Jensenpedisleep048      5_Hour      go          Hi      ${workDir}/Jensenpedisleep048/5_Hour/"${scan}[3]" \
    Jensenpedisleep048      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep048/9_Hour/"${scan}[1]" \
    Jensenpedisleep048      9_Hour      go          Hi      ${workDir}/Jensenpedisleep048/9_Hour/"${scan}[3]" \
    Jensenpedisleep049      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep049/5_Hour/"${scan}[1]" \
    Jensenpedisleep049      5_Hour      go          Hi      ${workDir}/Jensenpedisleep049/5_Hour/"${scan}[3]" \
    Jensenpedisleep049      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep049/9_Hour/"${scan}[1]" \
    Jensenpedisleep049      9_Hour      go          Hi      ${workDir}/Jensenpedisleep049/9_Hour/"${scan}[3]" \
    Jensenpedisleep050      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep050/5_Hour/"${scan}[1]" \
    Jensenpedisleep050      5_Hour      go          Hi      ${workDir}/Jensenpedisleep050/5_Hour/"${scan}[3]" \
    Jensenpedisleep050      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep050/9_Hour/"${scan}[1]" \
    Jensenpedisleep050      9_Hour      go          Hi      ${workDir}/Jensenpedisleep050/9_Hour/"${scan}[3]" \
    Jensenpedisleep051      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep051/5_Hour/"${scan}[1]" \
    Jensenpedisleep051      5_Hour      go          Hi      ${workDir}/Jensenpedisleep051/5_Hour/"${scan}[3]" \
    Jensenpedisleep051      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep051/9_Hour/"${scan}[1]" \
    Jensenpedisleep051      9_Hour      go          Hi      ${workDir}/Jensenpedisleep051/9_Hour/"${scan}[3]" \
    Jensenpedisleep052      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep052/5_Hour/"${scan}[1]" \
    Jensenpedisleep052      5_Hour      go          Hi      ${workDir}/Jensenpedisleep052/5_Hour/"${scan}[3]" \
    Jensenpedisleep052      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep052/9_Hour/"${scan}[1]" \
    Jensenpedisleep052      9_Hour      go          Hi      ${workDir}/Jensenpedisleep052/9_Hour/"${scan}[3]" \
    Jensenpedisleep053      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep053/5_Hour/"${scan}[1]" \
    Jensenpedisleep053      5_Hour      go          Hi      ${workDir}/Jensenpedisleep053/5_Hour/"${scan}[3]" \
    Jensenpedisleep053      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep053/9_Hour/"${scan}[1]" \
    Jensenpedisleep053      9_Hour      go          Hi      ${workDir}/Jensenpedisleep053/9_Hour/"${scan}[3]" \
    Jensenpedisleep055      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep055/5_Hour/"${scan}[1]" \
    Jensenpedisleep055      5_Hour      go          Hi      ${workDir}/Jensenpedisleep055/5_Hour/"${scan}[3]" \
    Jensenpedisleep055      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep055/9_Hour/"${scan}[1]" \
    Jensenpedisleep055      9_Hour      go          Hi      ${workDir}/Jensenpedisleep055/9_Hour/"${scan}[3]" \
    Jensenpedisleep056      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep056/5_Hour/"${scan}[1]" \
    Jensenpedisleep056      5_Hour      go          Hi      ${workDir}/Jensenpedisleep056/5_Hour/"${scan}[3]" \
    Jensenpedisleep056      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep056/9_Hour/"${scan}[1]" \
    Jensenpedisleep056      9_Hour      go          Hi      ${workDir}/Jensenpedisleep056/9_Hour/"${scan}[3]" \
    Jensenpedisleep058      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep058/5_Hour/"${scan}[1]" \
    Jensenpedisleep058      5_Hour      go          Hi      ${workDir}/Jensenpedisleep058/5_Hour/"${scan}[3]" \
    Jensenpedisleep058      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep058/9_Hour/"${scan}[1]" \
    Jensenpedisleep058      9_Hour      go          Hi      ${workDir}/Jensenpedisleep058/9_Hour/"${scan}[3]" \
    Jensenpedisleep059      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep059/5_Hour/"${scan}[1]" \
    Jensenpedisleep059      5_Hour      go          Hi      ${workDir}/Jensenpedisleep059/5_Hour/"${scan}[3]" \
    Jensenpedisleep059      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep059/9_Hour/"${scan}[1]" \
    Jensenpedisleep059      9_Hour      go          Hi      ${workDir}/Jensenpedisleep059/9_Hour/"${scan}[3]" \
    Jensenpedisleep060      5_Hour      nogo        Lo      ${workDir}/Jensenpedisleep060/5_Hour/"${scan}[1]" \
    Jensenpedisleep060      5_Hour      go          Lo      ${workDir}/Jensenpedisleep060/5_Hour/"${scan}[3]" \
    Jensenpedisleep060      9_Hour      nogo        Lo      ${workDir}/Jensenpedisleep060/9_Hour/"${scan}[1]" \
    Jensenpedisleep060      9_Hour      go          Lo      ${workDir}/Jensenpedisleep060/9_Hour/"${scan}[3]" \
    Jensenpedisleep061      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep061/5_Hour/"${scan}[1]" \
    Jensenpedisleep061      5_Hour      go          Hi      ${workDir}/Jensenpedisleep061/5_Hour/"${scan}[3]" \
    Jensenpedisleep061      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep061/9_Hour/"${scan}[1]" \
    Jensenpedisleep061      9_Hour      go          Hi      ${workDir}/Jensenpedisleep061/9_Hour/"${scan}[3]" \
    Jensenpedisleep063      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep063/5_Hour/"${scan}[1]" \
    Jensenpedisleep063      5_Hour      go          Hi      ${workDir}/Jensenpedisleep063/5_Hour/"${scan}[3]" \
    Jensenpedisleep063      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep063/9_Hour/"${scan}[1]" \
    Jensenpedisleep063      9_Hour      go          Hi      ${workDir}/Jensenpedisleep063/9_Hour/"${scan}[3]" \
    Jensenpedisleep064      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep064/5_Hour/"${scan}[1]" \
    Jensenpedisleep064      5_Hour      go          Hi      ${workDir}/Jensenpedisleep064/5_Hour/"${scan}[3]" \
    Jensenpedisleep064      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep064/9_Hour/"${scan}[1]" \
    Jensenpedisleep064      9_Hour      go          Hi      ${workDir}/Jensenpedisleep064/9_Hour/"${scan}[3]" \
    Jensenpedisleep066      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep066/5_Hour/"${scan}[1]" \
    Jensenpedisleep066      5_Hour      go          Hi      ${workDir}/Jensenpedisleep066/5_Hour/"${scan}[3]" \
    Jensenpedisleep066      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep066/9_Hour/"${scan}[1]" \
    Jensenpedisleep066      9_Hour      go          Hi      ${workDir}/Jensenpedisleep066/9_Hour/"${scan}[3]" \
    Jensenpedisleep067      5_Hour      nogo        Hi      ${workDir}/Jensenpedisleep067/5_Hour/"${scan}[1]" \
    Jensenpedisleep067      5_Hour      go          Hi      ${workDir}/Jensenpedisleep067/5_Hour/"${scan}[3]" \
    Jensenpedisleep067      9_Hour      nogo        Hi      ${workDir}/Jensenpedisleep067/9_Hour/"${scan}[1]" \
    Jensenpedisleep067      9_Hour      go          Hi      ${workDir}/Jensenpedisleep067/9_Hour/"${scan}[3]" \
    Jensenpedisleep068      5_Hour      nogo        Lo      ${workDir}/Jensenpedisleep068/5_Hour/"${scan}[1]" \
    Jensenpedisleep068      5_Hour      go          Lo      ${workDir}/Jensenpedisleep068/5_Hour/"${scan}[3]" \
    Jensenpedisleep068      9_Hour      nogo        Lo      ${workDir}/Jensenpedisleep068/9_Hour/"${scan}[1]" \
    Jensenpedisleep068      9_Hour      go          Lo      ${workDir}/Jensenpedisleep068/9_Hour/"${scan}[3]"

fi









