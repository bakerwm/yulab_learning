
# prepare test data
[[ -f test_3k_rows.bed ]] && rm test_3k_rows.bed
for i in {1..1000} ; do cat in.bed >> test_3k_rows.bed ; done 

time awk '$5<0.01{split($4,a,"-"); print $1"\t"$2"\t"$3"\t"a[2]"\t"$5"\t"$6}' test_3k_rows.bed > out1.bed

time awk '$5<0.01{OFS="\t"; split($4,a,"-"); print $1,$2,$3,a[2],$5,$6}' test_3k_rows.bed > out1.bed

time python3 foo.py in.bed > out2.bed

# clean data
[[ -f out1.bed ]] && rm out1.bed
[[ -f out2.bed ]] && rm out2.bed
[[ -f test_3k_rows.bed ]] && rm test_3k_rows.bed

# END
