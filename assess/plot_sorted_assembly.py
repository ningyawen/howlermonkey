#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jul  6 00:25:17 2021

@author: aahmed
"""

import sys
import os
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib
import argparse
import numpy as np

WORKDIR='/home/liunyw/project/howler_monkey'

# set these parameters to 42 to make the text editable
matplotlib.rcParams['pdf.fonttype'] = 42
matplotlib.rcParams['ps.fonttype'] = 42
new_rc_params = {'text.usetex': False, "svg.fonttype": 'none'}
matplotlib.rcParams.update(new_rc_params)
#set the size of the figure
matplotlib.rcParams['figure.figsize'] = (8.0, 20.0)
#set the size of the text
matplotlib.rcParams.update({'font.size': 6})
#set the font of the text
matplotlib.rcParams['font.family'] = 'Arial'



def plot(base_species):
    stats = pd.read_csv(f'{WORKDIR}/assemblyStats/primate_all_TOGA_{base_species}_stats.tsv', sep='\t', index_col=0)
    stats.sort_values("intact genes",inplace=True)

    rename_dict = {}
    with open(f'{WORKDIR}/assemblyStats/HillerID2Speciesname_{base_species}.txt', 'r') as f_out:
        for line in f_out:
            tmp = line.strip().split('\t')
            rename_dict[tmp[0]] = tmp[1]

    df_renamed = stats.rename(index=rename_dict)
    stats = df_renamed


    # extract the stacked data
    categories = stats.index
    stack_values = stats[["intact genes", "genes with inactivating mutations", "genes with missing sequence"]]


    fig, ax = plt.subplots() 

    # left subplot: show the low value region
    ax.barh(categories, stack_values['intact genes'], color='#4c588c', label='intact genes')
    ax.barh(categories, stack_values['genes with inactivating mutations'], left=stack_values['intact genes'], color='#db8145', label='genes with inactivating mutations')
    ax.barh(categories, stack_values['genes with missing sequence'], left=stack_values['intact genes'] + stack_values['genes with inactivating mutations'], color='#BFBFBF', label='genes with missing sequence')

    # adjust the position of the ticks: the x-axis ticks are at the bottom
    ax.xaxis.set_ticks_position('both')
    ax.tick_params(axis='x', which='both', labelbottom=True, labeltop=True)

    #set the legend
    ax.legend()

    plt.show()
    # show the figure
    fig.savefig(f'{WORKDIR}/assemblyStats/sorted_statsplot_{base_species}.pdf', bbox_inches="tight")

def main():

    plot('basehg38')

if __name__ == '__main__':
    main()