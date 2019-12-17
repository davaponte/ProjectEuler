#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000089.py
#

Value = {'I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000}

# f = open('/home/data/Projects/Python/ProjectEuler/p089_roman.txt')
# lines = f.readlines()
# for line in lines:
#     s = line.replace('\n', '')
#
# f.close()


def GetValue(s):
    Prev = s[0]
    Acum = Value[Prev]
    print('0', Acum, Prev)
    for c in s[1:]:
        if Value[c] <= Value[Prev]:
            Prev = c
            print('A', Acum, Prev)
            Acum += Value[Prev]
        else:
            Prev = c
            print('B', Acum, Prev)
            Acum = Value[Prev] - Acum
    return Acum


print('.1', GetValue('XXXXIIIIIIIII'))
print('.2', GetValue('XXXXVIIII'))
print('.3', GetValue('XXXXIX'))
print('.4', GetValue('XLIIIIIIIII'))
print('.5', GetValue('XLVIIII'))
print('.6', GetValue('XLIX'))

# print(GetValue('IIIIIIIIIIIIIIII'))
# print(GetValue('VIIIIIIIIIII'))
# print(GetValue('VVIIIIII'))
# print(GetValue('XIIIIII'))
# print(GetValue('VVVI'))
# print(GetValue('XVI'))
