#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000028-B.py
#

n = 5

Suma = -1 # Porque el central se sumará dos veces
for r in range(n):
    x = min(r, n - 1 - r)
    Suma += (n - 2 * x)**2  - 2 * (r - x)

    c = n - r - 1
    Suma += (n - 2 * r - 2)**2 + (c - r)

print('ANSWER: ', Suma)
