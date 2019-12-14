#!/bin/bash

NCORE=8
dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`
bvecs=`jq -r '.bvecs' config.json`
folders="nodif dwi"

for FOLDER in $folders
do
	mkdir -p ${FOLDER}

	# separate b0s from sos and sense data
	if [ ${FOLDER} == "nodif" ]; then
		dwiextract -bzero ${dwi} -fslgrad ${bvecs} ${bvals} ./${FOLDER}/dwi.nii.gz -nthreads $NCORE -force
	else
		dwiextract -no_bzero ${dwi} -fslgrad ${bvecs} ${bvals} ./${FOLDER}/dwi.nii.gz -nthreads $NCORE -force
	fi

	cp ${bvals} ./${FOLDER}/
	cp ${bvecs} ./${FOLDER}/
done
