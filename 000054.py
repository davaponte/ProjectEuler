#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  000054.py
#

#  10: High Card: Highest value card.
#  20: One Pair: Two cards of the same value.
#  30: Two Pairs: Two different pairs.
#  40: Three of a Kind: Three cards of the same value.
#  50: Straight: All cards are consecutive values.
#  60: Flush: All cards of the same suit.
#  70: Full House: Three of a kind and a pair.
#  80: Four of a Kind: Four cards of the same value.
#  90: Straight Flush: All cards are consecutive values of same suit.
# 100: Royal Flush: Ten, Jack, Queen, King, Ace, in same suit.

from collections import Counter

Cards = {n: str(n) for n in range(2, 10)}
Cards[10] = 'T'
Cards[11] = 'J'
Cards[12] = 'Q'
Cards[13] = 'K'
Cards[14] = 'A'
InvCards = {v: k for k, v in Cards.items()}

def GetHandValue(Hand):
    # ['AS', 'KD', '3D', 'JD', '8H']
    # Crear estructuras
    Seq = []
    for card in Hand:
        Seq.append(InvCards[card[0]])
        # if card[0] in ['2', '3', '4', '5', '6', '7', '8', '9']:
        #     Seq.append(int(card[0]))
        # elif card[0] == 'T':
        #     Seq.append(10)
        # elif card[0] == 'J':
        #     Seq.append(11)
        # elif card[0] == 'Q':
        #     Seq.append(12)
        # elif card[0] == 'K':
        #     Seq.append(13)
        # elif card[0] == 'A':
        #     Seq.append(14)
    Seq.sort()
    if Seq[4] == 14 and Seq[0] == 2: # Caso especial para el AS
        Seq = [1] + Seq[:4] # Esto mueve el AS al comienzo pero solo si había un dos
    Values = [Hand[n][0] for n in range(len(Hand))]
    VGroup = Counter(Values)
    GroupV = {v: k for k, v in VGroup.items()} # para búsqueda inversa
    Suits = [Hand[n][1] for n in range(len(Hand))]
    SGroup = Counter(Suits)
    GroupS = {v: k for k, v in SGroup.items()} # para búsqueda inversa

    # Check for Royal Flush: Ten, Jack, Queen, King, Ace, in same suit.
    Valid = True
    Suit = Hand[0][1]
    for card in Hand:
        Valid = Valid and (card[0] in ['T', 'J', 'Q', 'K', 'A']) and (card[1] == Suit)
    if Valid:
        return 100, Suit, 'Royal Flush', Hand

    # Check for Straight Flush: All cards are consecutive values of same suit.
    Suit = Hand[0][1]
    Valid = (card[0] in ['T', 'J', 'Q', 'K', 'A']) and (card[1] == Suit)
    if Valid: # Solo entra si todas tienen el mismo suit
        if all([Seq[d] + 1 == Seq[d + 1] for d in range(len(Seq) - 1)]):
            return 90, Suit, 'Straight Flush', Hand

    # Check for Four of a Kind: Four cards of the same value.
    if GroupV.get(4):
        return 80, GroupV[4], 'Four of a Kind', Hand

    # Check for Full House: Three of a kind and a pair.
    if GroupV.get(3) and GroupV.get(2):
        return 70, GroupV[3], 'Full House', Hand

    # Check for Flush: All cards of the same suit.
    if GroupS.get(5):
        return 60, GroupS[5], 'Flush', Hand

    # Check for Straight: All cards are consecutive values.
    if all([Seq[d] + 1 == Seq[d + 1] for d in range(len(Seq) - 1)]):
        return 50, 'Straight', Hand

    # Check for Three of a Kind: Three cards of the same value.
    if GroupV.get(3):
        return 40, GroupV[3], 'Three of a Kind', Hand

    # Check for Two Pairs: Two different pairs.
    if len(VGroup) == 3: # El diccionario inverso no sirve en este caso
        return 30, 'Two Pairs', Hand

    # Check for One Pair: Two cards of the same value.
    if GroupV.get(2):
        return 20, GroupV[2], 'One Pair', Hand

    # Check for High Card: Highest value card.
    return 10, Cards[Seq[4]], 'High Card', Hand # En este caso se devuelve el mayor valor posible


print(GetHandValue(['QH', 'AH', 'JH', 'QH', 'TH']))
print(GetHandValue(['5H', '5C', '6S', '7S', 'KD']))
print(GetHandValue(['2C', '3S', '8S', '8D', 'TD']))
print(GetHandValue(['5D', '8C', '9S', 'JS', 'AC']))
print(GetHandValue(['2C', '5C', '7D', '8S', 'QH']))
print(GetHandValue(['2D', '9C', 'AS', 'AH', 'AC']))
print(GetHandValue(['3D', '6D', '7D', 'TD', 'QD']))
print(GetHandValue(['4D', '6S', '9H', 'QH', 'QC']))
print(GetHandValue(['3D', '6D', '7H', 'QD', 'QS']))
print(GetHandValue(['2H', '2D', '4C', '4D', '4S']))
print(GetHandValue(['3C', '3D', '3S', '9S', '9D']))


import sys
sys.exit()

f = open('p054_poker.txt')
lines = f.readlines()
p1 = []
p2 = []
for line in lines:
    p1.append(list(card for card in line[:14].split()))
    p2.append(list(card for card in line[15:29].split()))
f.close()

# print(p1, p1)
