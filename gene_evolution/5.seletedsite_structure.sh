#!/bin/bash

WORKDIR=/lustre/home/luyizheng/liunyw/project/howler_monkey
mkdir -p ${WORKDIR}/gene_evolution/structure/ && cd ${WORKDIR}/gene_evolution/structure/


#############development related genes#############
# MMP13 structure 4FVL
wget -P ${WORKDIR}/gene_evolution/structure/MMP13 https://files.rcsb.org/download/4FVL.pdb
cd ${WORKDIR}/gene_evolution/structure/MMP13
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb 4FVL.pdb
echo 'EA133D,EB133D;' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb 4FVL_Repair.pdb --mutant-file=individual_list.txt

# PAX6 structure AF-P26367-F1-v6
wget -P ${WORKDIR}/gene_evolution/structure/PAX6 https://alphafold.ebi.ac.uk/files/AF-A0A1W2PQG7-F1-model_v6.pdb
cd ${WORKDIR}/gene_evolution/structure/PAX6
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-A0A1W2PQG7-F1-model_v6.pdb
echo -e 'TA325S;\nLA362P;\nGA456C;\nMA468R;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-A0A1W2PQG7-F1-model_v6_Repair.pdb --mutant-file=individual_list.txt
#############development related genes#############



#############energy metabolism related genes#############
cd ${WORKDIR}/gene_evolution/structure/ACAT1
wget -P ${WORKDIR}/gene_evolution/structure/ACAT1 https://alphafold.ebi.ac.uk/files/AF-0000000066244574-model_v1.pdb
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-0000000066244574-model_v1.pdb
echo -e 'LA4Q,LB4Q;\nPA17F,PB17F;\nKA365R,KB365R;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-0000000066244574-model_v1_Repair.pdb --mutant-file=individual_list.txt



#ADH7 structure
wget -P ${WORKDIR}/gene_evolution/structure/ADH7 https://alphafold.ebi.ac.uk/files/AF-0000000065771398-model_v1.pdb
cd ${WORKDIR}/gene_evolution/structure/ADH7
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-0000000065771398-model_v1.pdb
echo -e 'KA67E,KB67E;\nSA127T,SB127T;\nVA149I,VB149I;\nTA157A,TB157A;\nDA239N,DB239N;\nVA280A,VB280A;\nTA300V,TB300V;\nSA309A,SB309A;\nNA375R,NB375R;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-0000000065771398-model_v1_Repair.pdb --mutant-file=individual_list.txt

# TPI1 
wget -P ${WORKDIR}/gene_evolution/structure/TPI1 https://alphafold.ebi.ac.uk/files/AF-0000000066646559-model_v1.pdb
cd ${WORKDIR}/gene_evolution/structure/TPI1
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-0000000066646559-model_v1.pdb
#positive selected site 4D -> 4F
echo -e 'DA4F,DB4F;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-0000000066646559-model_v1_Repair.pdb --mutant-file=individual_list.txt
#############energy metabolism related genes#############



#############absorption related genes#############
# SLC51A structure 9UO2
wget -P ${WORKDIR}/gene_evolution/structure/SLC51A https://files.rcsb.org/download/9UO2.pdb
cd ${WORKDIR}/gene_evolution/structure/SLC51A
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb 9UO2.pdb
echo -e 'LA19V,LC19V;\nVA113T,VC113T;\nAA210T,AC210T;\nFA224G,FC224G;\nIA303V,IC303V;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb 9UO2_Repair.pdb --mutant-file=individual_list.txt


# TAS1R3 structure 9NOR 
wget -P ${WORKDIR}/gene_evolution/structure/TAS1R3 https://alphafold.ebi.ac.uk/files/AF-0000000066260637-model_v1.pdb
cd ${WORKDIR}/gene_evolution/structure/TAS1R3
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-0000000066260637-model_v1.pdb
echo -e 'FA65L,FB65L;\nSA67V,SB67V;\nVA108A,VB108A;\nNA411G,NB411G;\nLA483R,LB483R;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-0000000066260637-model_v1_Repair.pdb --mutant-file=individual_list.txt


# SLC23A1 structure AF-0000000066196994-v1
wget -P ${WORKDIR}/gene_evolution/structure/SLC23A1 https://alphafold.ebi.ac.uk/files/AF-0000000066196994-model_v1.pdb
cd ${WORKDIR}/gene_evolution/structure/SLC23A1
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-0000000066196994-model_v1.pdb
echo -e 'HA13C,HB13C;\nPA281S,PB281S;\nYA474H,YB474H;\nLA487P,LB487P;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-0000000066196994-model_v1_Repair.pdb --mutant-file=individual_list.txt


# SLC46A1 structure Q96NT5
wget -P ${WORKDIR}/gene_evolution/structure/SLC46A1 https://alphafold.ebi.ac.uk/files/AF-Q96NT5-F1-model_v6.pdb
cd ${WORKDIR}/gene_evolution/structure/SLC46A1
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-Q96NT5-F1-model_v6.pdb
echo -e 'VA111A;\nSA131N;\nVA398L;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-Q96NT5-F1-model_v6_Repair.pdb --mutant-file=individual_list.txt



# AMN structure 6GJE
wget -P ${WORKDIR}/gene_evolution/structure/AMN https://alphafold.ebi.ac.uk/files/AF-Q9BXJ7-F1-model_v6.pdb
cd ${WORKDIR}/gene_evolution/structure/AMN
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-Q9BXJ7-F1-model_v6.pdb
echo -e 'GA97A;\nAA303F;\nSA439T;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-Q9BXJ7-F1-model_v6_Repair.pdb --mutant-file=individual_list.txt



# LCT structure https://alphafold.ebi.ac.uk/entry/AF-P09848-F1
wget -P ${WORKDIR}/gene_evolution/structure/LCT  https://alphafold.ebi.ac.uk/files/AF-P09848-F1-model_v6.pdb
cd ${WORKDIR}/gene_evolution/structure/LCT
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-P09848-F1-model_v6.pdb
echo -e 'GA19Q;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-P09848-F1-model_v6_Repair.pdb --mutant-file=individual_list.txt
#############absorption related genes#############




#############RNASE related genes#############
# RNASE4 structure 2RNF 
wget -P ${WORKDIR}/gene_evolution/structure/RNASE4 https://alphafold.ebi.ac.uk/files/AF-P34096-F1-model_v6.pdb
cd ${WORKDIR}/gene_evolution/structure/RNASE4
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-P34096-F1-model_v6.pdb
echo "TA6E;" > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-P34096-F1-model_v6_Repair.pdb --mutant-file=individual_list.txt


# RNASE7 
wget -P ${WORKDIR}/gene_evolution/structure/RNASE7 https://alphafold.ebi.ac.uk/files/AF-Q9H1E1-F1-model_v6.pdb
cd ${WORKDIR}/gene_evolution/structure/RNASE7
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-Q9H1E1-F1-model_v6.pdb
echo -e 'PA3L;\nGA18R;\nEA74Q;\nGA102R;\nEA123D;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-Q9H1E1-F1-model_v6_Repair.pdb --mutant-file=individual_list.txt


# RNASEL 
wget -P ${WORKDIR}/gene_evolution/structure/RNASEL https://alphafold.ebi.ac.uk/files/AF-0000000066157723-model_v1.pdb
cd ${WORKDIR}/gene_evolution/structure/RNASEL
${WORKDIR}/software/foldx/foldx_20270131 --command=RepairPDB --pdb AF-0000000066157723-model_v1.pdb
echo -e 'VA23R,VB23R;\nAA197I,AB197I;\nVA532T,VB532T;\nQA619T,QB619T;\nKA646A,KB646A;\n' > individual_list.txt
${WORKDIR}/software/foldx/foldx_20270131 --command=BuildModel --pdb AF-0000000066157723-model_v1_Repair.pdb --mutant-file=individual_list.txt
#############RNASE related genes#############




#parse foldx results
python ${WORKDIR}/gene_evolution/parse_foldx_results.py
