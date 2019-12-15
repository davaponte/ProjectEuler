#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  Convert.py
#

Path = '/home/data/Projects/Lazarus/DelphiBigNumbers/Source/'

Files = [
'bases.inc',
'CompilerAndRTLVersions.pas',
'GenerateBaseConversionTables.dpr',
'Velthuis.BigDecimals.pas',
'Velthuis.BigIntegers.operators.hpp',
'Velthuis.BigIntegers.pas',
'Velthuis.BigIntegers.Primes.pas',
'Velthuis.BigRationals.pas',
'Velthuis.ExactFloatStrings.pas',
'Velthuis.FloatUtils.pas',
'Velthuis.Loggers.pas',
'Velthuis.Numerics.pas',
'Velthuis.RandomNumbers.pas',
'Velthuis.Sizes.pas',
'Velthuis.StrConsts.pas'
]
for File in Files:
    FName = Path + File
    print(FName)
    f = open(FName)
    lines = f.readlines()
    NewName = FName.replace('Velthuis.', 'Velthuis_').replace('BigIntegers.Primes', 'BigIntegers_Primes')
    g = open(NewName, 'w')
    print('*****', NewName, '*****')
    for line in lines:
        s = line.replace('system.', '').replace('System.', '')
        s = s.replace('Velthuis.', 'Velthuis_').replace('BigIntegers.Primes', 'BigIntegers_Primes')
        g.write(s)
        print(s.replace('\n', ''))
    print()
    g.close()
    f.close()
