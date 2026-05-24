#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/cactus/genome
for i in *; do echo ${i%.*} >> ../tmp1.txt; done
find $PWD -maxdepth 1 | xargs ls -ld | awk '{print $9}' > ../tmp2.txt
sed -i '1d' ../tmp2.txt
cd ..
paste tmp1.txt tmp2.txt  > tmp3.txt

echo "((((((((((homSap:0.167295,panTro:0.167295):0.076238,gorGor:0.243533):0.096061,ponAbe:0.339593):0.017988,(nomLeu:0.241559,(symSyn:0.190547,hylPil:0.190547):0.051012):0.116023):0.057456,((((macMul:0.061054,macFas:0.061054):0.044325,(manLeu:0.023317,((papAnu:0.008720,lopAte:0.008720):0.013564,theGel:0.022284):0.001033):0.082062):0.022678,(cerMon:0.091836,((chlAet:0.011027,eryPat:0.011027):0.063684,allNig:0.074711):0.017125):0.036220):0.219012,((colGue:0.280364,pilTep:0.280364):0.035387,(traGer:0.229512,(pygNem:0.188274,rhiRox:0.188274):0.041238):0.086239):0.031317):0.067969):0.021514,((((((calJac:0.103229,leoRos:0.103229):0.033593,sagOed:0.136822):0.075227,aotNan:0.212048):0.065445,((cebAlb:0.064964,sapApe:0.064964):0.111869,saiBol:0.176833):0.100661):0.007795,aloSen:0.285289):0.142733,((pitPit:0.070570,cacAyr:0.070570):0.273598,pleCup:0.344168):0.083853):0.008530):0.087173,cepBan:0.523725):0.166353,((dauMad:0.382945,(((lemCat:0.178348,proSim:0.178348):0.107354,eulFla:0.285702):0.028393,(mirCoq:0.083594,micMur:0.083594):0.230501):0.068849):0.069759,((lorTar:0.056142,nycCou:0.056142):0.286017,(galMoh:0.062904,otoCra:0.062904):0.279255):0.110545):0.237374):0.048719,galVar:0.738797):0.022703,musMus:0.761500);" > howlermonkey.seqFile
echo -e '\n' >> howlermonkey.seqFile
cat tmp3.txt >> howlermonkey.seqFile

rm tmp*
