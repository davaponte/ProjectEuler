#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000051.py
#
# Para este problema, después de consultar documentación, la solución no parece
# ser de fuerza bruta. Es decir, la que había pensado es generar los primtos
# de menos de 1MM y entonces iterar sobre los de X dígitos con RegExpr a fin de
# obtener grupos. Y si conseguía un grupo de 8 entonces ése era
#
# En lugar de eso el mejor approach es analizar matemáticamente el problema.
# Para eso me basé en el análisis que está en
#     https://www.mathblog.dk/project-euler-51-eight-prime-family/
# Entonces sólo hay que buscar primos de 5 ó 6 dígitos solamente y remplazar
# las partes remplazables (placeholders) con dígitos de 0, 1 y 2 (ver an{alisis)
#

def IsPrime(n):
    for k in range(2, int((n**.5)) + 1):
        if n % k == 0:
            return False
    return (n > 1)

# * es un placeholder y (a y b) son dígitos fijos que pertenecen al número
Pattern5Dig = [
'a***b',
'*a**b',
'**a*b',
'***ab'
]

# * es un placeholder y (a, b y c) son dígitos fijos que perteneces al número
Pattern6Dig = [
'ab***c',
'a*b**c',
'a**b*c',
'a***bc',
'*ab**c',
'*a*b*c',
'*a**bc',
'**ab*c',
'**a*bc',
'***abc'
]

# Bueno, al final dejé atrás el análisis y seguí según mi pensamiento
# Nada más que con el esquema de patrones (sin RegExpr) es más que suficiente

# Búsqueda para 5 dígitos
Number = []
for Template in Pattern5Dig:
    for a in range(1, 10): # Solo hay que llenar dos spots
        for b in range(1, 10, 2): # Solo hay que llenar dos spots. Salta los pares
            Number.append(Template.replace('a', str(a)).replace('b', str(b)))

# Iterar sobre Numbers remplazando el placeholder de dígito variable y chequeando
# si es primo. Si lo es se cuenta cuántos hay para ese valor
Sol = {}
for N in Number:
    Sol[N] = {'Values': [], 'Counter': 0}
    for d in range(1, 10):
        Option = N.replace('*', str(d))
        if IsPrime(int(Option)):
            Sol[N]['Values'].append(Option)
            Sol[N]['Counter'] += 1

# Búsqueda para 6 dígitos
Number = []
for Template in Pattern6Dig:
    for a in range(1, 10): # Solo hay que llenar tres spots
        for b in range(1, 10): # Solo hay que llenar tres spots
            for c in range(1, 10, 2): # Solo hay que llenar tres spots. Salta los pares
                Number.append(Template.replace('a', str(a)).replace('b', str(b)).replace('c', str(c)))

# Volver a iterar
for N in Number:
    Sol[N] = {'Values': [], 'Counter': 0}
    for d in range(1, 10):
        Option = N.replace('*', str(d))
        if IsPrime(int(Option)):
            Sol[N]['Values'].append(Option)
            Sol[N]['Counter'] += 1

for k in Sol:
    if Sol[k]['Counter'] == 8:
        # print(Sol[k])
        print('ANWER: ', min(Sol[k]['Values']))

# Solución hallada en 400ms
# ANWER:  121313
