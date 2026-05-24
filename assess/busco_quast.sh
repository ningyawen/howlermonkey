#!/bin/bash

export PATH="/home/liunyw/software/ncbi-blast-2.12.0+/bin:$PATH"
export PATH="/home/liunyw/software/augustus-3.3.2/bin:$PATH"
export PATH="/home/liunyw/software/augustus-3.3.2/scripts:$PATH"
export PATH="/home/liunyw/software/hmmer-3.3/bin:$PATH"
export PATH="/home/liunyw/software/metaeuk/bin:$PATH"
export PATH="/home/liunyw/software/bbmap:$PATH"
export PATH="/home/liunyw/software/Prodigal:$PATH"

/home/liunyw/software/busco-5.4.2/bin/busco \
	-i aloMac.fa \
	-o busco_aloMac \
	-l /home/liunyw/software/busco-5.4.2/primates_odb10 \
	-m genome \
	-c 10 \
	--offline

python /home/liunyw/software/quast-5.0.2/quast.py -o quast_aloMac aloMac.fa