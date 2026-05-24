#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/cactus && mkdir genome

python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Aotus_nancymaae/ncbi_dataset/data/GCF_000952055.2/GCF_000952055.2_Anan_2.0_genomic.fna ${WORKDIR}/cactus/genome/aotNan.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Cacajao_ayresi/ncbi_dataset/data/GCA_963573425.1/GCA_963573425.1_PGDP_CacAyr_genomic.fna ${WORKDIR}/cactus/genome/cacAyr.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Callithrix_jacchus/ncbi_dataset/data/GCA_011100555.1/GCA_011100555.1_mCalJac1.pat.X_genomic.fna ${WORKDIR}/cactus/genome/calJac.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Cebus_albifrons/ncbi_dataset/data/GCA_023783575.1/GCA_023783575.1_ASM2378357v1_genomic.fna ${WORKDIR}/cactus/genome/cebAlb.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Cephalopachus_bancanus/ncbi_dataset/data/GCA_027257055.1/GCA_027257055.1_ASM2725705v1_genomic.fna ${WORKDIR}/cactus/genome/cepBan.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Cercopithecus_mona/ncbi_dataset/data/GCA_014849445.1/GCA_014849445.1_KIZ_CMon_1.0_genomic.fna ${WORKDIR}/cactus/genome/cerMon.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Chlorocebus_aethiops/ncbi_dataset/data/GCA_023783515.1/GCA_023783515.1_ASM2378351v1_genomic.fna ${WORKDIR}/cactus/genome/chlAet.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Colobus_guereza/ncbi_dataset/data/GCA_021498455.1/GCA_021498455.1_ASM2149845v1_genomic.fna ${WORKDIR}/cactus/genome/colGue.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Daubentonia_madagascariensis/ncbi_dataset/data/GCA_004027145.1/GCA_004027145.1_DauMad_v1_BIUU_genomic.fna ${WORKDIR}/cactus/genome/dauMad.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Erythrocebus_patas/ncbi_dataset/data/GCA_023783455.1/GCA_023783455.1_ASM2378345v1_genomic.fna ${WORKDIR}/cactus/genome/eryPat.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Eulemur_flavifrons/ncbi_dataset/data/GCA_001262665.1/GCA_001262665.1_Eflavifronsk33QCA_genomic.fna ${WORKDIR}/cactus/genome//eulFla.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Galago_moholi/ncbi_dataset/data/GCA_023783435.1/GCA_023783435.1_ASM2378343v1_genomic.fna ${WORKDIR}/cactus/genome/galMoh.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Galeopterus_variegatus/ncbi_dataset/data/GCA_004027255.2/GCA_004027255.2_GalVar_v2_BIUU_UCD_genomic.fna ${WORKDIR}/cactus/genome/galVar.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Hylobates_pileatus/ncbi_dataset/data/GCA_021498465.1/GCA_021498465.1_ASM2149846v1_genomic.fna ${WORKDIR}/cactus/genome/hylPil.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Lemur_catta/ncbi_dataset/data/GCF_020740605.2/GCF_020740605.2_mLemCat1.pri_genomic.fna ${WORKDIR}/cactus/genome/lemCat.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Lophocebus_aterrimus/ncbi_dataset/data/GCA_023783235.1/GCA_023783235.1_ASM2378323v1_genomic.fna ${WORKDIR}/cactus/genome/lopAte.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Loris_tardigradus/ncbi_dataset/data/GCA_023783135.1/GCA_023783135.1_ASM2378313v1_genomic.fna ${WORKDIR}/cactus/genome/lorTar.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Macaca_fascicularis/ncbi_dataset/data/GCF_037993035.1/GCF_037993035.1_T2T-MFA8v1.0_genomic.fna ${WORKDIR}/cactus/genome/macFas.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Macaca_mulatta/ncbi_dataset/data/GCF_003339765.1/GCF_003339765.1_Mmul_10_genomic.fna ${WORKDIR}/cactus/genome/macMul.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Mandrillus_leucophaeus/ncbi_dataset/data/GCA_023783495.1/GCA_023783495.1_ASM2378349v1_genomic.fna ${WORKDIR}/cactus/genome/manLeu.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Microcebus_murinus/ncbi_dataset/data/GCF_000165445.2/GCF_000165445.2_Mmur_3.0_genomic.fna ${WORKDIR}/cactus/genome/micMur.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Mirza_coquereli/ncbi_dataset/data/GCA_004024645.1/GCA_004024645.1_MizCoq_v1_BIUU_genomic.fna ${WORKDIR}/cactus/genome/mirCoq.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Nomascus_leucogenys/ncbi_dataset/data/GCA_006542625.1/GCA_006542625.1_Asia_NLE_v1_genomic.fna ${WORKDIR}/cactus/genome/nomLeu.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Nycticebus_coucang/ncbi_dataset/data/GCF_027406575.1/GCF_027406575.1_mNycCou1.pri_genomic.fna ${WORKDIR}/cactus/genome/nycCou.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Papio_anubis/ncbi_dataset/data/GCA_008728515.1/GCA_008728515.1_Panubis1.0_genomic.fna ${WORKDIR}/cactus/genome//papAnu.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Piliocolobus_tephrosceles/ncbi_dataset/data/GCA_002776525.3/GCA_002776525.3_ASM277652v3_genomic.fna ${WORKDIR}/cactus/genome/pilTep.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Pithecia_pithecia/ncbi_dataset/data/GCA_004026645.1/GCA_004026645.1_PitPit_v1_BIUU_genomic.fna ${WORKDIR}/cactus/genome/pitPit.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Plecturocebus_cupreus/ncbi_dataset/data/GCA_040437455.1/GCA_040437455.1_PleCup_hybrid_genomic.fna ${WORKDIR}/cactus/genome/pleCup.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Prolemur_simus/ncbi_dataset/data/GCA_003258685.1/GCA_003258685.1_Prosim_1.0_genomic.fna ${WORKDIR}/cactus/genome/proSim.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Pygathrix_nemaeus/ncbi_dataset/data/GCA_004024825.1/GCA_004024825.1_PygNem_v1_BIUU_genomic.fna ${WORKDIR}/cactus/genome/pygNem.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Rhinopithecus_roxellana/ncbi_dataset/data/GCA_007565055.1/GCA_007565055.1_ASM756505v1_genomic.fna ${WORKDIR}/cactus/genome/rhiRox.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Saguinus_oedipus/ncbi_dataset/data/GCA_031835075.1/GCA_031835075.1_ASM3183507v1_genomic.fna ${WORKDIR}/cactus/genome/sagOed.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Saimiri_boliviensis_boliviensis/ncbi_dataset/data/GCF_016699345.1/GCF_016699345.1_BCM_Sbol_2.0_genomic.fna ${WORKDIR}/cactus/genome/saiBol.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Sapajus_apella/ncbi_dataset/data/GCA_009761245.1/GCA_009761245.1_GSC_monkey_1.0_genomic.fna ${WORKDIR}/cactus/genome/sapApe.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Theropithecus_gelada/ncbi_dataset/data/GCA_003255815.1/GCA_003255815.1_Tgel_1.0_genomic.fna ${WORKDIR}/cactus/genome/theGel.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Trachypithecus_germaini/ncbi_dataset/data/GCA_047047975.1/GCA_047047975.1_ASM4704797v1_genomic.fna ${WORKDIR}/cactus/genome/traGer.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/mGorGor1.pri.cur.20231122.fasta ${WORKDIR}/cactus/genome/gorGor.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/mPanTro3.pri.cur.20231122.fasta ${WORKDIR}/cactus/genome/panTro.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/mPonAbe1.pri.cur.20231205.fasta ${WORKDIR}/cactus/genome/ponAbe.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/mSymSyn1.pri.cur.20240514.fasta ${WORKDIR}/cactus/genome/symSyn.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Allenopithecus_nigroviridis_HiC.fasta ${WORKDIR}/cactus/genome/allNig.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Leontopithecus_rosalia_HiC.fasta ${WORKDIR}/cactus/genome/leoRos.fa
python3 ${WORKDIR}/cactus/simplify_header.py ${WORKDIR}/raw_genome/Otolemur_crassicaudatus_HiC.fasta ${WORKDIR}/cactus/genome/otoCra.fa
ln -s ${WORKDIR}/raw_genome/mm10.fa ${WORKDIR}/cactus/genome/musMus.fa
ln -s ${WORKDIR}/raw_genome/hg38.fa ${WORKDIR}/cactus/genome/homSap.fa
ln -s ${WORKDIR}/aloMac.sm.fa ${WORKDIR}/cactus/genome/aloMac.fa
