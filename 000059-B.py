# -*- coding: utf-8 -*-

# Esta solución no es mía. Tuve que usarla pues mi algoritmo no encontraba la solución.
# Al final resultó que cuando dicen que el archivo no encriptado contiene solo palabras
# en inglés, olvidaron añadir los números, caracteres especiales y operadores matemáticos.
# Una perlita, pues. Una vez notado esta bagatela mi algoritmo funcionó perfectamente.


# This is one of those problems that python seems particularly well suited to.
# If we assume our most frequent character is space, then we slice the cipher text
# into 3 buckets of every 3rd character and xor the most frequent character in each
# bucket with space to generate the key. Then it’s a simple matter to produce the
# decrypted text.
#
# Solution runs in roughly 1.4 ms. Much faster and more concise than other
# approaches I’ve seen.

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
