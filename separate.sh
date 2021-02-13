#!/bin/bash

NCORE=8
dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`
bvecs=`jq -r '.bvecs' config.json`
shell=`jq -r '.shell' config.json`
with_bzeros=`jq -r '.with_bzeros' config.json`
folders="dwi"

# make output dir
[ ! -d ${folders} ] && mkdir -p ${folders}

# set bzero line. if true (default), will include bzeros. if false, will exclude
if [[ ${with_bzeros} == 'true' ]]; then
	bzero_line="-bzero"
else
	bzero_line="-no_bzero"
fi

# extract shell with bzeros
dwiextract  ${dwi} -fslgrad ${bvecs} ${bvals} ./${folders}/dwi.nii.gz \
	-singleshell ${shell} \
	${bzero_line} \
	-export_grad_fsl ./${folders}/dwi.bvecs ./${folders}/dwi.bvals \
	-nthreads $NCORE \
	-force

