library(gprofiler2)


# 生成输入文件名
inputfile_name <- "/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/positivegenes/PSG_all_geneID.txt"
# 生成输出文件名
outputfile_name <- "/lustre/home/luyizheng/liunyw/project/howler_monkey/enrichment/positivegenes/gprofiler_PSG_all_geneID.txt"
# print(outputfile_name)

gene_data <- read.csv(inputfile_name, header = FALSE, stringsAsFactors = FALSE)
gene_list <- gene_data$V1


gostres <- gost(gene_list,
                organism = "hsapiens", ordered_query = FALSE,
                multi_query = FALSE, significant = TRUE, exclude_iea = FALSE,
                measure_underrepresentation = FALSE, evcodes = TRUE,
                user_threshold = 0.05, correction_method = "g_SCS",
                domain_scope = "annotated", custom_bg = NULL,
                numeric_ns = "", sources = NULL, highlight = TRUE)

#存储数据
gostres <- gostres$result[,c('p_value', 'term_size', 'query_size', 'intersection_size', 'term_id', 'term_name', 'effective_domain_size', 'source_order', 'parents', 'intersection')]
gostres$parents <- sapply(gostres$parents, function(x) paste(x, collapse = ", "))
write.table(gostres,outputfile_name, row.names = FALSE, quote = FALSE, sep = "\t")


