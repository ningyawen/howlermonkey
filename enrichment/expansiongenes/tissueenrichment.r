library(TissueEnrich)

# 生成输入文件名
inputfile_name <- "/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/expansiongenes/Howlermonkey_Expansion_Allgene.txt"
# 生成输出文件名
outputfile_name <- "/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/expansiongenes/Tissueenrichment_exp_allgene.txt"
outputfile_log10Pvalue <- "/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/expansiongenes/Tissueenrichment_exp_allgene.log10Pvalue.pdf"
outputfile_Foldchangebar <- "/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/expansiongenes/Tissueenrichment_exp_allgene.Foldchangebar.pdf"
# print(outputfile_name)


############################################################################################################################################
inputGenes_df<-read.table(inputfile_name, na.strings = c("NA"))
inputGenes <- as.character(inputGenes_df$V1)  # 将V1列转换为字符
# print(inputGenes)

# 创建基因集对象
gs<-GeneSet(geneIds=inputGenes,organism="Homo Sapiens",geneIdType=ENSEMBLIdentifier())



# 执行TE富集分析
output<-teEnrichment(inputGenes = gs)

#提取组织特异性基因分析结果
seEnrichmentOutput<-output[[1]]
enrichmentOutput<-setNames(data.frame(assay(seEnrichmentOutput),row.names = rowData(seEnrichmentOutput)[,1]), colData(seEnrichmentOutput)[,1])
enrichmentOutput$Tissue <- row.names(enrichmentOutput)
print(enrichmentOutput)
write.table(enrichmentOutput, file = outputfile_name, sep = "\t",quote = FALSE)

# 绘制−Log10(P−Value)的条形图
pdf(outputfile_log10Pvalue, width = 9, height = 4.5)
ggplot(enrichmentOutput, aes(x = reorder(Tissue, -Log10PValue), y = Log10PValue, label = Tissue.Specific.Genes, fill = Tissue)) +
geom_bar(stat = 'identity') +
scale_fill_manual(values= c('#D2B787', '#F4E5D3', '#EAD4B8', '#D2B787', '#B89A65', '#9E7D43', '#B8E0EA', '#9FD4E5', '#52A1B8', '#3D869D', '#286B82', '#C5C9A5', '#B8C3A3', '#AABDA1', '#9CB79F', '#8EB19D', '#F9F1E5', '#EDE0CC', '#E1CFB3', '#D5BE9A', '#C9AD81', '#BE9B6E', '#AA885D', '#96754C', '#82623B', '#6E4F2A', '#E3C8A1', '#D4B78F', '#C5A67D', '#B6956B', '#A78459', '#7AB3C4', '#68A0B0', '#568D9C', '#52A1B8')) +
labs(x = '', y = '-Log10(p-adjusted)') +
theme_bw() +
theme(text=element_text("serif")) +
theme(legend.position = "none") +
theme(plot.title = element_text(hjust = 0.5, size = 20), axis.title = element_text(size = 15)) +
theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()

#使用富集的fold-change值绘制条形图，来进一步展示不同组织间的变化情况
pdf(outputfile_Foldchangebar, width = 9, height = 3)
ggplot(enrichmentOutput,aes(x=reorder(Tissue,-fold.change),y=fold.change,label = Tissue.Specific.Genes,fill = Tissue))+
    geom_bar(stat = 'identity')+
    scale_fill_manual(values= c('#D2B787', '#F4E5D3', '#EAD4B8', '#D2B787', '#B89A65', '#9E7D43', '#B8E0EA', '#9FD4E5', '#52A1B8', '#3D869D', '#286B82', '#C5C9A5', '#B8C3A3', '#AABDA1', '#9CB79F', '#8EB19D', '#F9F1E5', '#EDE0CC', '#E1CFB3', '#D5BE9A', '#C9AD81', '#BE9B6E', '#AA885D', '#96754C', '#82623B', '#6E4F2A', '#E3C8A1', '#D4B78F', '#C5A67D', '#B6956B', '#A78459', '#7AB3C4', '#68A0B0', '#568D9C', '#52A1B8')) +
    labs(x='', y = 'Fold change')+
    theme_bw()+
    theme(legend.position="none")+
    theme(plot.title = element_text(hjust = 0.5,size = 20),axis.title = element_text(size=15))+
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),panel.grid.major= element_blank(),panel.grid.minor = element_blank())
dev.off()





# library(tidyr)

# vector_tissue <- c('Duodenum', 'Small Intestine', 'Colon', 'Rectum', 'Esophagus', 'Pancreas', 'Stomach')

# for (tissue in vector_tissue) {

#     tissue_name <- ifelse(tissue == "Small Intestine", "Small_Intestine", tissue)

#     seExp<-output[[2]][[tissue]]
#     outputfile_name <- paste0("/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/expansiongenes/Tissueenrichment_TS_genes_expression_", tissue_name, ".txt")
#     exp<-setNames(data.frame(assay(seExp), row.names = rowData(seExp)[,1]), colData(seExp)[,1])
#     exp$Gene<-row.names(exp)
#     exp<-exp %>% gather(key = "Tissue", value = "expression",1:(ncol(exp)-1))
#     write.table(exp, outputfile_name, sep = "\t", quote = FALSE) 


#     #Retrieval of input tissue-specific genes
#     outputfile_enrichgenelist  <-  paste0("/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/expansiongenes/Tissueenrichment_TS_enrichgeneID_", tissue_name, ".txt")
#     seGroupInf <- output[[3]][[tissue]]
#     groupInf <- data.frame(assay(seGroupInf))
#     write.table(groupInf, file = outputfile_enrichgenelist, sep = "\t",quote = FALSE)
# }


############################################################################################################################################


