#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/gene_family

python3 get_Orthogroups_GeneCount_table.py futher_analysis_TOGA.txt base_hg38

sed 's/^/(null)\t/' base_hg38_orthology_count.txt > primate.genefamily.txt
sed -i '1s/(null)/Desc/' primate.genefamily.txt
sed -i '1s/ENSG/homSap/' primate.genefamily.txt

cat spesciname2abbname.txt | while read sciname abbname; do echo "sed -i s'/"$sciname"/"$abbname"/g' primate.genefamily.txt" | sh; done

#cafe filter
python ${WORKDIR}/software/CAFE5/tutorial/clade_and_size_filter.py -s -i primate.genefamily.txt -o primate.genefamily.filter.txt



#mcmctree divergence time
#((((((((((homSap: 0.167295, panTro: 0.167295): 0.076238, gorGor: 0.243533): 0.096061, ponAbe: 0.339593): 0.017988, (nomLeu: 0.241559, (symSyn: 0.190547, hylPil: 0.190547): 0.051012): 0.116023): 0.057456, ((((macMul: 0.061054, macFas: 0.061054): 0.044325, (manLeu: 0.023317, ((papAnu: 0.008720, lopAte: 0.008720): 0.013564, theGel: 0.022284): 0.001033): 0.082062): 0.022678, (cerMon: 0.091836, ((chlAet: 0.011027, eryPat: 0.011027): 0.063684, allNig: 0.074711): 0.017125): 0.036220): 0.219012, ((colGue: 0.280364, pilTep: 0.280364): 0.035387, (traGer: 0.229512, (pygNem: 0.188274, rhiRox: 0.188274): 0.041238): 0.086239): 0.031317): 0.067969): 0.021514, ((((((calJac: 0.103229, leoRos: 0.103229): 0.033593, sagOed: 0.136822): 0.075227, aotNan: 0.212048): 0.065445, ((cebAlb: 0.064964, sapApe: 0.064964): 0.111869, saiBol: 0.176833): 0.100661): 0.007795, aloMac: 0.285289): 0.142733, ((pitPit: 0.070570, cacAyr: 0.070570): 0.273598, pleCup: 0.344168): 0.083853): 0.008530): 0.087173, cepBan: 0.523725): 0.166353, ((dauMad: 0.382945, (((lemCat: 0.178348, proSim: 0.178348): 0.107354, eulFla: 0.285702): 0.028393, (mirCoq: 0.083594, micMur: 0.083594): 0.230501): 0.068849): 0.069759, ((lorTar: 0.056142, nycCou: 0.056142): 0.286017, (galMoh: 0.062904, otoCra: 0.062904): 0.279255): 0.110545): 0.237374): 0.048719, galVar: 0.738797): 0.022703, musMus: 0.761500);
echo "((((((((((homSap:6.2124,panTro:6.2124):1.6160,gorGor:7.8283):7.5079,ponAbe:15.3363):2.7021,(nomLeu:6.2919,(symSyn:5.6372,hylPil:5.6372):0.6547):11.7465):10.5122,((((macMul:1.8048,macFas:1.8048):5.3238,(manLeu:5.7209,((papAnu:2.9505,lopAte:2.9505):56.48,theGel:3.5153):2.2057):1.4076):4.7873,(cerMon:8.8587,((chlAet:5.2521,eryPat:5.2521):2.9356,allNig:8.1877):0.6710):3.0572):4.0543,((colGue:8.3818,pilTep:8.3818):2.4268,(traGer:6.9088,(pygNem:5.5570,rhiRox:5.5570):1.3519):3.8997):5.1616):12.5804):13.2683,((((((calJac:8.9266,leoRos:8.9266):1.8030,sagOed:10.7296):5.4442,aotNan:16.1739):0.8563,((cebAlb:4.9014,sapApe:4.9014):9.3985,saiBol:14.3000):2.7302):2.4899,aloMac:19.5201):1.4668,((pitPit:9.8471,cacAyr:9.8471):6.5683,pleCup:16.4153):4.5715):20.8321):27.3709,cepBan:69.1898):8.3290,((dauMad:54.2217,(((lemCat:8.6126,proSim:8.6126):9.2895,eulFla:17.9021):17.3944,(mirCoq:15.0537,micMur:15.0537):20.2428):18.9253):7.9863,((lorTar:15.7232,nycCou:15.7232):14.5469,(galMoh:11.6733,otoCra:11.6733):18.5967):31.9380):15.3108):9.5969,galVar:87.1157):2.1616,musMus:89.2773);" > primate.tree


/home/liunyw/miniforge3/envs/phygenomics/bin/cafe5 -t primate.tree -i primate.genefamily.filter.txt -p -k 3 &> cafe.out &


mv results/ gamma_results && cd gamma_results
#visualization
cafeplotter -i ${WORKDIR}/gene_family/gamma_results/ -o ${WORKDIR}/gene_family/plot_cafeplotter --format pdf --fig_width 12
cafeplotter -i ${WORKDIR}/gene_family/gamma_results/ -o ${WORKDIR}/gene_family/plot_cafeplotter --format pdf --fig_height 0.3 --fig_width 12


#significant expansion
################################################################################################################
#get all the significant expansion gene families
grep "aloMac<30>\*" Gamma_asr.tre | awk '{print $2}' > Howlermonkey_Significant_families.OG.txt
#get all the significant expansion gene families
grep -f Howlermonkey_Significant_families.OG.txt Gamma_change.tab | awk '{if($31>0)print $1}' >  Howlermonkey_Significant_Expansion_families.OG.txt

##get all the significant expansion gene families all genes
grep -f Howlermonkey_Significant_Expansion_families.OG.txt ../base_hg38_orthology.txt | awk -v FS="\t" '{print $2}' | sed 's/, /\n/g' > Howlermonkey_Significant_Expansion_Allgene.txt
################################################################################################################



#all expansion
################################################################################################################
#get all the significant expansion gene families
awk '{if($31>0)print $1}' Gamma_change.tab | grep -v 'FamilyID' >  Howlermonkey_Expansion_families.OG.txt
##get all the significant expansion gene families all genes
grep -f Howlermonkey_Expansion_families.OG.txt ../base_hg38_orthology.txt | awk -v FS="\t" '{print $2}' | sed 's/, /\n/g' > Howlermonkey_Expansion_Allgene.txt
##get the first gene of the significant expansion gene families, and save it as the representative gene
grep -f Howlermonkey_Expansion_families.OG.txt ../base_hg38_orthology.txt | awk '{print $2}' | sed 's/,//g' > Howlermonkey_Expansion_representgene.txt
################################################################################################################
