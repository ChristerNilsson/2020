# Cluster ADT sequences based on hamming distance from expected list

import os
import sys
from operator import itemgetter
import time

seq_run = "Hash"
#curdir = sys.argv[1]
curdir = '.'
os.chdir(curdir)

def hamming(str1, str2):
		"""Calculate the Hamming distance between two character strings"""
		return sum(c1 != c2 for c1, c2 in zip(str1, str2))
assert hamming("AAAA","AAAA") == 0
assert hamming("ABAA","AAAA") == 1
assert hamming("ABAA","AABA") == 2

def process(line,names):
	line = line.split()
	if line[1] == 'ADT':
		tag_name = line[2]
		adt = line[3].split(",")
		for a in adt:
			names[a] = tag_name
names = {}
process("Hash	ADT	6077_P_C1_ECB_R1_T7	TTGTCTCAGGCT,ATCGAAGGTCGA	2	TCCGGAGA	v3BC1,v3BC11",names)
process("Hash	ADT	6077_P_C1_ECB_R2_T7	ACTAGGCACCTA,TTCCGATGTAGC	2	TCCGGAGA	v3BC2,v3BC17",names)
process("Hash	ADT	6077_P_C1_ECB_R1_T12	ACATTGGAAGCC,CAAGTTAGATGG	2	TCCGGAGA	v3BC3,v3BC13",names)
process("Hash	ADT	6077_P_C1_ECB_R2_T12	ATACAAGCGGCT,CCTGTGTAACGC	2	TCCGGAGA	v3BC4,v3BC14",names)
process("Hash	ADT	6077_P_C1_ECB_R1_T2	GCTTTTGGTCCT,CTGTATAGGACA	2	TCCGGAGA	v3BC5,v3BC15",names)
process("Hash	ADT	6077_P_C1_ECB_R2_T2	GCCTCGTTAGAA,GAGATTCGCAGG	2	TCCGGAGA	v3BC6,v3BC16",names)
process("Hash	ADT	6077_P_C1_ECB_R2_T3	GATCTGATAAGT,TGGTATGTATCG	2	TCCGGAGA	v3BC19,v3BC20",names)
assert len(names) == 14
assert names == {'TTGTCTCAGGCT': '6077_P_C1_ECB_R1_T7', 'ATCGAAGGTCGA': '6077_P_C1_ECB_R1_T7', 'ACTAGGCACCTA': '6077_P_C1_ECB_R2_T7', 'TTCCGATGTAGC': '6077_P_C1_ECB_R2_T7', 'ACATTGGAAGCC': '6077_P_C1_ECB_R1_T12', 'CAAGTTAGATGG': '6077_P_C1_ECB_R1_T12', 'ATACAAGCGGCT': '6077_P_C1_ECB_R2_T12', 'CCTGTGTAACGC': '6077_P_C1_ECB_R2_T12', 'GCTTTTGGTCCT': '6077_P_C1_ECB_R1_T2', 'CTGTATAGGACA': '6077_P_C1_ECB_R1_T2', 'GCCTCGTTAGAA': '6077_P_C1_ECB_R2_T2', 'GAGATTCGCAGG': '6077_P_C1_ECB_R2_T2', 'GATCTGATAAGT': '6077_P_C1_ECB_R2_T3', 'TGGTATGTATCG': '6077_P_C1_ECB_R2_T3'}

start = time.time()

#with open(seq_run + '_lookup_separated.txt', "r") as lines:
# OUTPUT: names {}
with open("Hash/"+seq_run + '_lookup.txt', "r") as lines:
		names = {}
		for line in lines:
				process(line,names)

with open("Hash/"+seq_run + "_in.txt", "r") as lines:
		adt_all = {}
		adt_counts = {}
		min_edit_distance = 2
		total_count = 0
		ambiguous_count = 0
		no_match_count = 0

		for line in lines:
				total_count += 1
				line = line.split()
				curr_adt = line[3]

				if curr_adt in adt_counts:
						adt_counts[curr_adt] += 1
						if adt_all[curr_adt] == "two_matches":
								ambiguous_count += 1
						if adt_all[curr_adt] == "no_match":
								no_match_count += 1

				else:
						adt_counts[curr_adt] = 1
						scores = []
						for each in names.keys():
								edit_dist = hamming(each,curr_adt)
								scores.append([each,edit_dist])
						scores = sorted(scores, key=itemgetter(1))
						best_adt, next_adt = scores[0], scores[1]

						if best_adt[1] == next_adt[1]:
								adt_all[curr_adt] = "two_matches"
								ambiguous_count += 1 # do not add to final dict, cannot determine which adt is better
						elif best_adt[1] > min_edit_distance:
								adt_all[curr_adt] = "no_match"
								no_match_count += 1  # current read adt does not match any in expected list
						else:
								sample_adt = best_adt[0]
								adt_all[curr_adt] = sample_adt

#with open(seq_run + "_ADT_clusters_expected_sep.txt", "w") as output:
with open("Hash/"+seq_run + "_out.txt", "w") as output:
		for adt in adt_all.keys():
				output.write(adt+'\t')
				output.write(str(adt_counts[adt])+'\t')
				output.write(adt_all[adt]+'\t')  # sample adt sequence
				if adt_all[adt] in names:
						output.write(names[adt_all[adt]]+'\n')  # sample name
				else:
						output.write(adt_all[adt]+'\n')

print("totReads", total_count)
print("totUniqueADTs",len(adt_all))  #number of ADTs from sequencing Hash
print("totClusters",len(names)) #number of clusters output
print("AmbiguousSampleAssignment", ambiguous_count)
print("NoSampleAssignment", no_match_count)

print(time.time()-start)
