#!/usr/bin/env python
# -*- coding: utf-8 -*-

def Div(m, n):
    seq = []
    k = divmod(m, n)
    if (k[1] == 0):
        yield(str(k[0]))
    else:
        yield(str(k[0]) + '.')
    while (k[1] != 0):
        k = divmod(k[1] * 10, n)
        yield(str(k[0]))

def principal_period(s):
    i = (s+s).find(s, 1, -1)
    return None if i == -1 else s[:i]

limit = 20000
maxrepeats = 0
number = 0
for n in range(1, 1000):
    c = 0
    s = ''
    for k in Div(1, n):
        s += k
        c += 1
        if (c > limit):
            break
    #print(n, s[:100] + '...')
    c = 2
    sub = s[c:]
    found = False
    while (c < len(sub)):
        st = principal_period(sub)
        if st:
            #print('# repeating: ', len(st))
            if (len(st) > maxrepeats):
                maxrepeats = len(st)
                number = n
            found = True
            break
        else:
            c += 1
            sub = s[c:]
    if not found:
        #print('# repeating: ', 0)
        pass

print('ANSWER: ', number, ' REPEATS: ', maxrepeats, ' VALUE: ', 1 / number)
c = 0
for k in Div(1, number):
    print(k, end='')
    c += 1
    if (c > maxrepeats + 20):
        break
print()
