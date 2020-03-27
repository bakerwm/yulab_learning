#!/usr/env/bin python3

import sys

with open(sys.argv[1]) as r:
    for line in r:
        fields = line.split('\t')
        if float(fields[4]) >= 0.01:
            continue
        fields[3] = fields[3].split('-')[1]
        print('\t'.join(fields[:6]))
