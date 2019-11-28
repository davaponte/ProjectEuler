# -*- coding: utf-8 -*-

# Esta solución no es mía. Tuve que usarla pues mi algoritmo no encontraba la solución.
# Al final resultó que cuando dicen que el archivo no encriptado contiene solo palabras
# en inglés, olvidaron añadir los números, caracteres especiales y operadores matemáticos.
# Una perlita, pues. Una vez notado esta bagatela mi algoritmo funcionó perfectamente.

import itertools
from collections import Counter

def solve(filename='p059_cipher.txt', keylen=3):
    cipher = map(int, open(filename).read().split(','))
    key = map(lambda n: max(Counter(cipher[n::keylen]).iteritems(),
                            key=lambda x: x[1])[0] ^ ord(' '),
              xrange(keylen))
    print [chr(k) for k in key]
    return sum(c^k for c, k in itertools.izip(cipher, itertools.cycle(key)))

if __name__ == '__main__':
    print solve()
