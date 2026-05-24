#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import sys
import os
import pandas as pd
import tqdm
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
# matplotlib.rcParams['figure.figsize'] = (6.0, 12.0)
matplotlib.rcParams['figure.figsize'] = (8.0, 16.0)
#set the size of the text
matplotlib.rcParams.update({'font.size': 9})
#set the font of the text
matplotlib.rcParams['font.family'] = 'Arial'
#set the colors
INTACT_COLOR = '#4c588c'
LOSS_COLOR = '#db8145'
MISSING_COLOR = '#BFBFBF'
#change the colors
# INTACT_COLOR = '#F9A8A0'
# # LOSS_COLOR = '#F6C6B1'
# LOSS_COLOR = '#F5E2C2'
# # MISSING_COLOR = '#F5E2C2'
# MISSING_COLOR = '#D3D3D3'

stats = pd.read_csv(f'{WORKDIR}/assemblyStats/manual_checked_primate_all_TOGA_basehg38_stats.tsv', sep='\t', index_col=0)

HillerID2spe = {}
with open(f'{WORKDIR}/assemblyStats/manual_checked_primate_species_HillerID2onlySpeciesname_basehg38.txt', 'r') as f_HillerID2onlySpe:
    for line in f_HillerID2onlySpe:
        tmp = line.strip().split('\t')
        HillerID2spe[tmp[0]] = tmp[1]
stats.rename(index=HillerID2spe, inplace=True)


# # set the y-axis labels in a specific order
desired_order = ['Pan troglodytes', 'Gorilla gorilla', 'Pongo abelii', 'Nomascus leucogenys', 'Symphalangus syndactylus', 'Hylobates pileatus', 'Macaca mulatta', 'Macaca fascicularis', 'Mandrillus leucophaeus',  'Papio anubis', 'Lophocebus aterrimus', 'Theropithecus gelada', 'Cercopithecus mona', 'Chlorocebus aethiops', 'Erythrocebus patas', 'Allenopithecus nigroviridis', 'Colobus guereza', 'Piliocolobus tephrosceles', 'Trachypithecus germaini', 'Pygathrix nemaeus', 'Rhinopithecus roxellana', 'Callithrix jacchus',  'Leontopithecus rosalia', 'Saguinus oedipus',  'Aotus nancymaae', 'Cebus albifrons', 'Sapajus apella', 'Saimiri boliviensis', 'Alouatta macconnelli', 'Pithecia pithecia', 'Cacajao ayresi', 'Plecturocebus cupreus', 'Cephalopachus bancanus', 'Daubentonia madagascariensis', 'Lemur catta', 'Prolemur simus',  'Eulemur flavifrons',  'Mirza coquereli', 'Microcebus murinus', 'Loris tardigradus', 'Nycticebus coucang', 'Galago moholi', 'Otolemur crassicaudatus', 'Galeopterus variegatus', 'Mus musculus']

# # reorder the data in a specific order
df_plot_stats = stats.loc[desired_order]
df_reversed = df_plot_stats[::-1]
df_plot_stats = df_reversed
# print(df_plot_stats)

# extract the stacked data
categories = df_plot_stats.index
stack_values = df_plot_stats[["intact genes", "genes with inactivating mutations", "genes with missing sequence"]]

# create two subplots, share the y-axis, and adjust the spacing
fig, (ax1, ax2) = plt.subplots(1, 2, sharey=True, gridspec_kw={'wspace': 0.05, 'width_ratios':[1,50]})

# left subplot: show the low value region
ax1.barh(categories, stack_values['intact genes'], color=INTACT_COLOR, label='intact genes')
ax1.barh(categories, stack_values['genes with inactivating mutations'], left=stack_values['intact genes'], color=LOSS_COLOR, label='genes with inactivating mutations')
ax1.barh(categories, stack_values['genes with missing sequence'], left=stack_values['intact genes'] + stack_values['genes with inactivating mutations'], color=MISSING_COLOR, label='genes with missing sequence')
ax1.set_xlim(0, 100)  # set the left x-axis range

# right subplot: show the high value region
ax2.barh(categories, stack_values['intact genes'], color=INTACT_COLOR)
ax2.barh(categories, stack_values['genes with inactivating mutations'], left=stack_values['intact genes'], color=LOSS_COLOR)
ax2.barh(categories, stack_values['genes with missing sequence'], left=stack_values['intact genes'] + stack_values['genes with inactivating mutations'], color=MISSING_COLOR)
ax2.set_xlim(15000, 18600)  # set the right x-axis range

# hide the middle border
ax1.spines['right'].set_visible(False)
ax2.spines['left'].set_visible(False)

# adjust the position of the ticks: the x-axis ticks are at the bottom
# ax1.xaxis.tick_bottom()
# ax2.xaxis.tick_bottom()
ax1.xaxis.set_ticks_position('both')
ax2.xaxis.set_ticks_position('both')
ax1.tick_params(axis='x', which='both', labelbottom=True, labeltop=True)
ax2.tick_params(axis='x', which='both', labelbottom=True, labeltop=True)
ax2.tick_params(axis='y', length=0)  # hide the y-axis ticks of the right subplot

# custom the x-axis ticks
ax1.set_xticks([0])  # set the x-axis ticks of the left subplot
ax1.set_xticklabels(['0'])  # set the x-axis ticks of the left subplot
ax2.set_xticks([15000, 16000, 17000, 18000])  # set the x-axis ticks of the right subplot
ax2.set_xticklabels(['15000', '16000', '17000', '18000'])  # set the x-axis ticks of the right subplot

# get the current y-axis ticks and labels
y_ticks = ax1.get_yticks()  # 获取刻度位置
y_tick_labels = [label.get_text() for label in ax1.get_yticklabels()]  # 获取刻度标签
# fix the y-axis ticks
ax1.set_yticks(y_ticks)  # explicitly set the y-axis ticks
# define the y-axis labels as italic
ax1.set_yticklabels(ax1.get_yticklabels(), fontstyle='italic')


# add the break symbol
d = 0.2  # the size of the symbol
kwargs = dict(
    marker=[(-1, -d), (1, d)],
    markersize=10,
    linestyle="none",
    color='k',
    mec='k',
    mew=1,
    clip_on=False
)
ax1.plot([1, 1], [0, 1], transform=ax1.transAxes, **kwargs)
ax2.plot([0, 0], [0, 1], transform=ax2.transAxes, **kwargs)

# add the legend
ax1.legend(loc='upper right')

plt.show()
# show the figure
fig.savefig(f'{WORKDIR}/assemblyStats/mainfig_statsplot_basehg38.pdf', bbox_inches="tight")
