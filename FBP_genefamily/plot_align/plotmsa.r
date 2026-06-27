library("ggmsa")
library("ggplot2")



plot_seq <- '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.fa'
p <- ggmsa(plot_seq, 1, 100, char_width = 0.5, seq_name=T)
ggsave(filename = '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.1_100.pdf', plot = p, height = 6, width = 20)

plot_seq <- '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.fa'
p <- ggmsa(plot_seq, 101, 200, char_width = 0.5, seq_name=T)
ggsave(filename = '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.101_200.pdf', plot = p, height = 6, width = 20)

plot_seq <- '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.fa'
p <- ggmsa(plot_seq, 201, 300, char_width = 0.5, seq_name=T)
ggsave(filename = '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.201_300.pdf', plot = p, height = 6, width = 20)

plot_seq <- '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.fa'
p <- ggmsa(plot_seq, 301, 400, char_width = 0.5, seq_name=T)
ggsave(filename = '/home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.301_400.pdf', plot = p, height = 6, width = 20)

