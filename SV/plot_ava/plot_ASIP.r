#!/home/liunyw/miniforge3/envs/R-base/bin/Rscript

library(SVbyEye)
library(GenomicRanges)


## Get PAF to plot
paf.file <- '/home/liunyw/project/howler_monkey/SV/plot_ava/ASIP.target.ava.paf'

## Read in PAF  
paf.table <- readPaf(
    paf.file = paf.file, include.paf.tags = TRUE,
    restrict.paf.tags = "cg"
)

##Read bed file
df_anno <- read.table("/home/liunyw/project/howler_monkey/SV/plot_ava/ASIP.anno.bed", header = FALSE, sep = "\t", stringsAsFactors = FALSE)
colnames(df_anno)[1:4] <- c("chr", "start", "end", "ID")
gr_anno <- GRanges(
  seqnames = df_anno$chr,
  ranges = IRanges(start = df_anno$start, end = df_anno$end),
  ID = df_anno$ID
)

##read bed file
df_repeat <- read.table("/home/liunyw/project/howler_monkey/SV/plot_ava/ASIP.repeat.bed", header = FALSE, sep = "\t", stringsAsFactors = FALSE)
colnames(df_repeat)[1:4] <- c("chr", "start", "end", "ID")
gr_repeat <- GRanges(
  seqnames = df_repeat$chr,
  ranges = IRanges(start = df_repeat$start, end = df_repeat$end),
  ID = df_repeat$ID
)


seqnames.order <- c("hylPil_ASIP", "hg38_ASIP", "rhiRox_ASIP", "calJac_ASIP", "aloMac_ASIP")

## Make a plot colored by alignment directionality
pdf("/home/liunyw/project/howler_monkey/SV/plot_ava/ASIP_anno.pdf")
plt <- plotAVA(paf.table = paf.table, color.by = "direction",seqnames.order = seqnames.order, color.palette = c("+" = "azure3", "-" = "yellow3"))
addAnnotation(
    ggplot.obj = plt, annot.gr = gr_anno, shape = "rectangle", fill.by = "ID", color.palette = c("hg38_ASIP" = "#42517e", "rhiRox_ASIP" = "#42517e", "calJac_ASIP" = "#42517e") , 
    coordinate.space = "self", y.label.id = "ID", annotation.level = 0
)
dev.off()


pdf("/home/liunyw/project/howler_monkey/SV/plot_ava/ASIP_repeat.pdf")
plt <- plotAVA(paf.table = paf.table, color.by = "direction",seqnames.order = seqnames.order, color.palette = c("+" = "azure3", "-" = "yellow3"))
addAnnotation(
    ggplot.obj = plt, annot.gr = gr_repeat, coordinate.space = "self",
    y.label.id = "ID", shape = "rectangle", annotation.level = 0
)
dev.off()

