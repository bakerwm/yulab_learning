# Question: Extract data from a large bed file

url: [https://www.biostars.org/p/428286/](https://www.biostars.org/p/428286/)

## Question

Filter a large text file by specific column, eg: score value in `BED` file;

For example, extract lines from a large BED file, `score` < 0.01

```
chr1    10006   10018   M6176_1.02-NR2F1    0.00117 +   sequence=taaccctaaccc
chr1    10006   10020   M6432_1.02-PPARD    0.00034 +   sequence=taaccctaacccta
chr1    10008   10030   M6456_1.02-RREB1    0.00014 -   sequence=GGGTTAGGGTTAGGGTTAGGGT
```


## Solution

### test data

```
$ wc -l test_3m_rows.bed test_30m_rows.bed
   3000000 test_3m_rows.bed
  30000000 test_30m_rows.bed

```

### `Awk` version

use `OFS="\t"` in `awk` command is much slower.

```
$ time awk '$5<0.01{split($4,a,"-"); print $1"\t"$2"\t"$3"\t"a[2]"\t"$5"\t"$6}' test_3m_rows.bed > out1.bed

real    0m5.135s
user    0m5.012s
sys     0m0.120s

$ time awk '$5<0.01{split($4,a,"-"); print $1"\t"$2"\t"$3"\t"a[2]"\t"$5"\t"$6}' test_30m_rows.bed > out2.bed

real    0m53.181s
user    0m49.875s
sys     0m1.244s
```

### `python` version


```
$ time python foo.py test_3m_rows.bed > out3.bed

real    0m4.416s
user    0m4.195s
sys     0m0.220s

$ time python foo.py test_30m_rows.bed > out4.bed

real    0m46.769s
user    0m43.935s
sys     0m2.396s

```

### The `python` script

```
$ cat foo.py
#!/usr/env/bin python3

import sys

with open(sys.argv[1]) as r:
    for line in r:
        fields = line.split('\t')
        if float(fields[4]) >= 0.01:
            continue
        fields[3] = fields[3].split('-')[1]
        print('\t'.join(fields[:6]))
```


**EOF**
