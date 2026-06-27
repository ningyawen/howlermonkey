#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey

cd ${WORKDIR}/enrichment && mkdir summarizeresults && cd summarizeresults


#summarize the results of the enrichment analysis
python3 summarized_tissueenrichpvalue.py




