import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
import seaborn as sns
from matplotlib.colors import ListedColormap
import sys


WORKDIR='/home/liunyw/project/howler_monkey'
matplotlib.rcParams['pdf.fonttype'] = 42
matplotlib.rcParams['ps.fonttype'] = 42
new_rc_params = {'text.usetex': False, "svg.fonttype": 'none'}
matplotlib.rcParams.update(new_rc_params)
#matplotlib.rcParams['figure.figsize'] = (10.0, 20.0)
matplotlib.rcParams['figure.figsize'] = (6.0, 8.0)
matplotlib.rcParams.update({'font.size': 8})
#matplotlib.rcParams['font.family'] = 'Times New Roman'
matplotlib.rcParams['font.family'] = 'Arial'


def plot_Multiple_Bar_Charts(df_lineage2tissue_pvalue, file_plot_bar):

    group_order = df_lineage2tissue_pvalue['Source'].unique()
    df_nonzero = df_lineage2tissue_pvalue[df_lineage2tissue_pvalue["Log10PValue"] > 0]

    tissue_scores = (
        df_nonzero
        .groupby("Tissue")["Log10PValue"]
        .apply(np.prod)  
        .sort_values(ascending=False)
    )


    tissue_order = tissue_scores.index.tolist()


    fig, axes = plt.subplots(5, 1, sharex=True, sharey=True)

    # plot
    for ax, group in zip(axes, group_order):
        subset = df_lineage2tissue_pvalue[df_lineage2tissue_pvalue['Source'] == group]

        sns.barplot(
            data=subset,
            x='Tissue',
            y='Log10PValue',
            order=tissue_order,
            palette='pastel',
            ax=ax
        )
        ax.axhline(y=1.3, linestyle='--', color='gray', linewidth=0.8)
        ax.set_title(f"{group}", fontsize=14)
        ax.tick_params(axis='x', rotation=90)  


    axes[-1].set_xlabel('Tissue')
    # fig.text(0.04, 0.5, 'Fold Change', va='center', rotation='vertical', fontsize=14)
    plt.tight_layout()
    plt.show()
    plt.savefig(file_plot_bar, transparent=True)


def main():


    dict_sourcename2enrichmentfiles = {'Positive selected gene': '/home/liunyw/project/howler_monkey/enrichment/positivegenes/Tissueenrichment_PSG.txt',
    'Rapidly evolving gene': '/home/liunyw/project/howler_monkey/enrichment/reg/Tissueenrichment_REG.txt',
    'Lost gene': '/home/liunyw/project/howler_monkey/enrichment/lossgenes/Tissueenrichment.geneloss.noOR.geneID.txt',
    'Expanding gene': '/home/liunyw/project/howler_monkey/enrichment/expansiongenes/Tissueenrichment_exp_allgene.txt', 
    'Genes associtated accelerated regions': '/home/liunyw/project/howler_monkey/enrichment/LinARs/Tissueenrichment_LinARs.txt'}


    df_plot = pd.DataFrame(columns=['Log10PValue', 'Tissue.Specific.Genes', 'fold.change', 'samples', 'Tissue', 'Source'])
    for sourcename, enrichment_file in dict_sourcename2enrichmentfiles.items():
        df_tmp = pd.read_csv(enrichment_file, sep='\t', index_col=0)
        df_tmp['Source'] = sourcename
        df_plot = pd.concat([df_plot, df_tmp], ignore_index=True)

    df_plot = df_plot[df_plot['Tissue'] != 'Testis']

    plot_Multiple_Bar_Charts(df_plot, f'{WORKDIR}/enrichment/summarizeresults/sourcegene2Log10PValue_v2.pdf')


if __name__ == '__main__':
    main()
