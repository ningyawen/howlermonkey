import sys
inputfile = sys.argv[1]
outputfile = sys.argv[2]

from Bio import SeqIO
with open(inputfile, "r") as infile:
	with open(outputfile, "w") as outf:
		for seq in SeqIO.parse(infile, 'fasta'):
			seq.name = ""
			seq.description = ""
			outf.write(seq.format('fasta'))

#simplify_header.py ${critter}_raw_genome.fa ${critter}_genome.fa
