#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000068-B.py
#

def GetDigitString(A):
# Esta función genera el digit string pedido, pero hay que comenzar desde el
# menor nodo exterior a construir el string, por eso la búsqueda inicial
    Order = [0, 1, 2, 3, 2, 4, 5, 4, 6, 7, 6, 8, 9, 8, 1]
    ExternalNodes = [A[0], A[3], A[5], A[7], A[9]]
    idxk = [0, 3, 6, 9, 12]
    idx = ExternalNodes.index(min(ExternalNodes))
    k = idxk[idx]
    Order = Order[k:] + Order[:k]
    return ''.join(str(A[d]) for d in Order)

# Solución con lazos anidados y con IF intercalados
# para explorar solo opciones válidas
# Los lazos para nodos externos son los únicos que pueden llegar a 10 porque
# de otro modo el 10 quedaría en los nodos internos y la longitud del string
# sería 17 y no 16 como se pide.
# Al ingresar a cada lazo interno se verifica que el valor no sea igual a
# alguno de los valores anteriores pues ya están usados
# Si las sumas de los segmentos no coinciden entonces se salta esa combinación
# Con esos condicionales el algoritmo es sumamente rápido!!
# Esto se me ocurrió en la madrugada del 1/Dic/2019 después de que mi hija me
# despertó a las 4AM y yo tenía una gripe terrible. Entonces lo codifiqué en
# el celular de inmediato y en la tade de ese día lo pasé a la laptop
Sol = []
for a0 in range(1, 11):
    for a1 in range(1, 10):
        if (a0 == a1):
            continue
        for a2 in range(1, 10):
            if a2 in [a0, a1]:
                continue
            s1 = a0 + a1 + a2
            for a3 in range(1, 11):
                if a3 in [a0, a1, a2]:
                    continue
                for a4 in range(1, 10):
                    if a4 in [a0, a1, a2, a3]:
                        continue
                    s2 = a3 + a2 + a4
                    if (s1 != s2):
                        continue
                    for a5 in range(1, 11):
                        if a5 in [a0, a1, a2, a3, a4]:
                            continue
                        for a6 in range(1, 10):
                            if a6 in [a0, a1, a2, a3, a4, a5]:
                                continue
                            s3 = a5 + a4 + a6
                            if (s3 != s2):
                                continue
                            for a7 in range(1, 11):
                                if a7 in [a0, a1, a2, a3, a4, a5, a6]:
                                    continue
                                for a8 in range(1, 10):
                                    if a8 in [a0, a1, a2, a3, a4, a5, a6, a7]:
                                        continue
                                    s4 = a7 + a6 + a8
                                    if (s4 != s3):
                                        continue
                                    for a9 in range(1, 11):
                                        if a9 in [a0, a1, a2, a3, a4, a5, a6, a7, a8]:
                                            continue
                                        s5 = a9 + a8 + a1
                                        if (s5 != s4):
                                            continue
                                        Sol.append([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9])

Max = [GetDigitString(sol) for sol in Sol]
print('ANSWER: ', max(Max))
