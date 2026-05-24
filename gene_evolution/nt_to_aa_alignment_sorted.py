from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import sys


def translate_and_sort(nt_alignment_file, output_file):
    
    order = ['Homo_sapiens', 'Pan_troglodytes', 'Gorilla_gorilla', 'Pongo_abelii', 'Nomascus_leucogenys', 'Symphalangus_syndactylus', 'Hylobates_pileatus', 'Macaca_mulatta', 'Macaca_fascicularis', 'Mandrillus_leucophaeus','Papio_anubis', 'Lophocebus_aterrimus', 'Theropithecus_gelada', 'Cercopithecus_mona', 'Chlorocebus_aethiops', 'Erythrocebus_patas', 'Allenopithecus_nigroviridis', 'Colobus_guereza', 'Piliocolobus_tephrosceles', 'Trachypithecus_germaini', 'Pygathrix_nemaeus', 'Rhinopithecus_roxellana', 'Callithrix_jacchus', 'Leontopithecus_rosalia', 'Saguinus_oedipus', 'Aotus_nancymaae', 'Cebus_albifrons', 'Sapajus_apella', 'Saimiri_boliviensis', 'Alouatta_seniculus', 'Pithecia_pithecia', 'Cacajao_ayresi', 'Plecturocebus_cupreus', 'Cephalopachus_bancanus', 'Daubentonia_madagascariensis', 'Lemur_catta', 'Prolemur_simus', 'Eulemur_flavifrons', 'Mirza_coquereli', 'Microcebus_murinus', 'Loris_tardigradus', 'Nycticebus_coucang', 'Galago_moholi', 'Otolemur_crassicaudatus', 'Galeopterus_variegatus', 'Mus_musculus']

    seq_dict = SeqIO.to_dict(SeqIO.parse(nt_alignment_file, "fasta"))

    # use the first sequence of the existing sequences as the length reference
    reference_seq = next(iter(seq_dict.values())).seq.upper()
    aa_aligned_length = len(reference_seq) // 3

    aa_records = []

    for seq_id in order:
        if seq_id in seq_dict:
            record = seq_dict[seq_id]
            seq = record.seq.upper()
            aa_aligned = []

            for i in range(0, len(seq), 3):
                codon = seq[i:i+3]
                if len(codon) < 3 or "-" in codon:
                    aa_aligned.append("-")
                else:
                    aa_aligned.append(str(Seq(codon).translate()))
        else:
            print(f"Note: {seq_id} not found. Filling with '-'")
            aa_aligned = ["-"] * aa_aligned_length

        aa_record = SeqRecord(Seq("".join(aa_aligned)), id=seq_id, description="")
        aa_records.append(aa_record)

    SeqIO.write(aa_records, output_file, "fasta")
    print(f"AA alignment written to {output_file}")

    

if __name__ == "__main__":
    # if len(sys.argv) != 2:
    #     print("Usage: python nt_to_aa_alignment_sorted.py input_nt.fasta output_aa.fasta")
    # else:
    #     translate_and_sort(sys.argv[1], sys.argv[2])
    translate_and_sort(sys.argv[1], sys.argv[2])