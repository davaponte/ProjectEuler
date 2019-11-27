#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000036.py
#  

def IsPalindrome(s):
    for k in range(len(s) // 2):
        if (s[k] != s[-k -1]):
            return False
    return True

Suma = 0
for n in range(1, 1000000):
    b = str(bin(n))[2:]
    if IsPalindrome(b) and IsPalindrome(str(n)):
        Suma += n
        print(n, b)
        
print('ANSWER: ', Suma)
