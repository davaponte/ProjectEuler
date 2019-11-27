#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000038.py
#  

def IsPandigital(s):
    d = {}
    for k in s:
        d[k] = k
    return (len(s) == 9) and (len(d) == 9) and not(d.get('0'))

Maxn = 0
for X in range(2, 10):
    l = [x for x in range(1, X)]
    for n in range(20000):
        s = ''.join([str(x * n) for x in l])
        if IsPandigital(s):
            print('{:5}'.format(n), s)
            Maxn = max(int(s), Maxn)

print('ANSWER: ', Maxn)


# ~ Analysis (https://www.mathblog.dk/project-euler-38-pandigital-multiplying-fixed-number/)
# ~ First of all the fixed number must contain less than 5 digits, since n has to be greater than 1.
# ~ Second thing to not in our analysis is that we are given a candidate which starts with 9, so 
# ~ the fixed number we need to find needs to start with 9 as well which gives us some properties to
# ~ use in the analysis.
# ~ If the fixed number is 2 digit we wont be able to generate a 9 digit number since n = 3 yields 
# ~ an 8 digit number and n=4 yields an 11 digit number. Same goes for 3 digit numbers where we end (
# ~ at 7 or 11 digits in the result. That leaves us with a four digit number starting with 9.
# ~ So already now we can limit the search to numbers between 9123 and 9876 a mere 753 numbers.
# ~ We can rather easily limit it a bit more. If the second digit is >4 then we get a carry over 
# ~ which results in the multiplying by 2 part will yield 19xxx instead of 18xxx and thus we have 
# ~ two 9’s which are not possible solutions. Further more non of the digits can be 1 since we 
# ~ will end up with a solution candidate with two 1’s in it.
# ~ So the solution space can be shrunk to numbers between 9234 and 9487 which means we would need to check 253 solutions.
