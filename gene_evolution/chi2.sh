#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey

for i in $(ls ${WORKDIR}/gene_evolution/check_maf); do echo ${i}; cd ${WORKDIR}/gene_evolution/check_maf/${i}; null=$(grep 'lnL  =' null/logfile_codeml-branchsite_null.txt | awk '{print $3}'); alte=$(grep 'lnL  =' modelA/logfile_codeml-branchsite.txt | awk '{print $3}'); deviation=`echo "$null - $alte"|bc`; multiplication=`echo "$deviation*2"|bc`; abs=`python3 ${WORKDIR}/gene_evolution/script/abs.py $multiplication`; ${WORKDIR}/software/paml-4.10.7/bin/chi2 1 $abs &> ${i}.chi2.log;  done

