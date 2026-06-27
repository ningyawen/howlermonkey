#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/FBP_genefamily

mkdir plot_chain

/home/liunyw/miniforge3/envs/phygenomics/bin/chainFilter -t=chr9 -tOverlapStart=94503132 -tOverlapEnd=94650249  -minScore=500000 /home/liunyw/project/howler_monkey/make_chain/chain/aloMac/chr9.chain > FBP.howlermonkey.chain

./chainToBigChain FBP.howlermonkey.chain FBP.howlermonkey.bigChain.pre FBP.howlermonkey.bigChain.link.pre
./bedToBigBed -type=bed6+6 -as=bigChain.as -tab FBP.howlermonkey.bigChain.pre hg38.chrom.sizes FBP.howlermonkey.bigChain.bb
./bedToBigBed -type=bed4+1 -as=bigLink.as -tab FBP.howlermonkey.bigChain.link.pre hg38.chrom.sizes FBP.howlermonkey.bigChain.link.bb

