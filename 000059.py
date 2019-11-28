#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000059.py
#

from itertools import permutations as p
from functools import reduce

Valid = [chr(x) for x in range(ord('A'), ord('Z')+1)] + [chr(x) for x in range(ord('a'), ord('z')+1)] +\
        [chr(x) for x in range(ord('0'), ord('9')+1)] +\
        [chr(10), chr(13), chr(32), ',', '*', '"', ';', '.', ':', "'", '?', '!', '-', '(', ')', '/', '+', '*', '[', ']']
print(Valid)
# Resulta que, según Project Euler, el los caracteres especiales también son parte de las palabras en inglés. HDSPM!

f = open('p059_cipher.txt')
text = f.read()
f.close
M = [int(c) for c in text.split(',')]

# Esto es para mejorar la velocidad. Sólo analizo un pedazo del archivo
# Pero, para evitar problemas, el pedazo debe ser un múltiplo del tamaño de la clave
Slice = (len(M) // 10) // 3 * 3 # Hasta un divisor de 17 da resultado este truco
# print(Slice)
N = M[:Slice]

Keys = [chr(n) for n in range(ord('a'), ord('z') + 1)]
C = list(p(Keys, 3))

for key in C:
    K = [ord(c) for c in key]
    D = [[N[x]^K[0], N[x+1]^K[1] if x+1<len(N) else None, (N[x+2]^K[2]) if x+2<len(N) else None] for x in range(0,len(N),3)]
    # Convertir a vector
    MM = [chr(D[r][c]) for r in range(len(D)) for c in range(3)]
    if all([c in Valid for c in MM]):
        print('Clave: ', key)
        D = [[M[x]^K[0], M[x+1]^K[1] if x+1<len(M) else None, (M[x+2]^K[2]) if x+2<len(M) else None] for x in range(0,len(M),3)]
        MM = [chr(D[r][c]) for r in range(len(D)) for c in range(3)]
        break

Texto = reduce(lambda a, b: a+b, MM)
print(Texto)
print('ANSWER: ', sum(ord(c) for c in MM))
