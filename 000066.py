#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000066.py
#

d = [n for n in range(1001) if (n**.5 % 1 != 0)]

Dlist = []
ylist = []
xlist = []
for D in d:
    for y in range(1, 10000):
        x = (1 + D * y**2)**.5
        if x % 1 == 0:
            # print(int(x), '² - ', D, '*', y, '² = 1')
            xlist.append(int(x))
            ylist.append(y)
            Dlist.append(D)
            break

for n in range(len(Dlist)):
    print(xlist[n], '² - ', Dlist[n], '*', ylist[n], '² = 1')

IdxMax = xlist.index(max(xlist))
print(xlist[IdxMax], '² - ', Dlist[IdxMax], '*', ylist[IdxMax], '² = 1')
print('ANSWER: ', Dlist[IdxMax])

# 10000
# 284088 ² -  983 * 9061 ² = 1
# ANSWER:  983

# 100000
# 3034565 ² -  934 * 99294 ² = 1
# ANSWER:  934

# 1000000
# 24248647 ² -  688 * 924471 ² = 1
# ANSWER:  688
