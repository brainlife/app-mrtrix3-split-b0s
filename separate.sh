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
dwiextract ${bzero_line} \
	-singleshell ${shell} \
	${dwi} \
	-fslgrad ${bvecs} ${bvals} \
	./${folders}/dwi.nii.gz \
	-export_grad_fsl ./${folders}/dwi.bvecs ./${folders}/dwi.bvals \
	-nthreads $NCORE \
	-force

