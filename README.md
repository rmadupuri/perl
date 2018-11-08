Takes in a tab separated text file of the form UNIPROTID\tRESIDUENUMBER and extracts the sequence within the window of -10/+10 residues of the given residue number


### Usage
Split Genome Nexus annotated ```data_mutations.txt``` to ```annotated_mutations.txt``` and ```unannotated_muatations.txt``` tables based on the empty HGVSp_Short.

### Command Line
```
python split_maf.py path/to/data_mutations.txt path/to/annotated_mutations.txt path/to/unannotated_mutations.txt
```
