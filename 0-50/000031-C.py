#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000031-C.py
#  

# ~ Top = 200
# ~ Coins = [1, 2, 5, 10, 20, 50, 100, 200, 201] # El último es para crear la raíz
# ~ M = [[c * x for x in range(Top // c + 1)] for c in Coins]

# ~ for line in M:
    # ~ print(line)
    
Top = 200
Coins = [1, 2, 5, 10, 20, 50, 100, 200]
Ways = [0 for n in range(Top + 1)]
Ways[0] = 1
 
for i in range(len(Coins)):
    for j in range(Coins[i], Top + 1):
        Ways[j] += Ways[j - Coins[i]]
print(Ways[len(Ways) - 1])
