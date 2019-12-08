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
    Seq.sort()

    # Bajo ciertas reglas es que se permite. En este problema pareciera que no
    # if Seq[4] == 14 and Seq[0] == 2: # Caso especial para el AS
    #     Seq = [1] + Seq[:4] # Esto mueve el AS al comienzo pero solo si había un dos

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
        return 100000, Suit, 'Royal Flush', Hand, Cards[Seq[4]]

    # Check for Straight Flush: All cards are consecutive values of same suit.
    Suit = Hand[0][1]
    Valid = (card[0] in ['T', 'J', 'Q', 'K', 'A']) and (card[1] == Suit)
    if Valid: # Solo entra si todas tienen el mismo suit
        if all([Seq[d] + 1 == Seq[d + 1] for d in range(len(Seq) - 1)]):
            return 90000 + Seq[4] * 100 + Seq[4], Suit, 'Straight Flush', Hand, Cards[Seq[4]]

    # Check for Four of a Kind: Four cards of the same value.
    if GroupV.get(4):
        return 80000 + Seq[4] * 100 + Seq[4], GroupV[4], 'Four of a Kind', Hand, Cards[Seq[4]]

    # Check for Full House: Three of a kind and a pair.
    if GroupV.get(3) and GroupV.get(2):
        return 70000 + InvCards[GroupV[3]] * 100 + Seq[4], GroupV[3], 'Full House', Hand, Cards[Seq[4]]

    # Check for Flush: All cards of the same suit.
    if GroupS.get(5):
        return 60000 + Seq[4] * 100 + Seq[4], GroupS[5], 'Flush', Hand, Cards[Seq[4]]

    # Check for Straight: All cards are consecutive values.
    if all([Seq[d] + 1 == Seq[d + 1] for d in range(len(Seq) - 1)]):
        return 50000 + Seq[4] * 100 + Seq[4], Cards[Seq[4]], 'Straight', Hand, Cards[Seq[4]]

    # Check for Three of a Kind: Three cards of the same value.
    if GroupV.get(3):
        return 40000 + InvCards[GroupV[3]] * 100 + Seq[4], GroupV[3], 'Three of a Kind', Hand, Cards[Seq[4]]

    # Check for Two Pairs: Two different pairs.
    if len(VGroup) == 3: # El diccionario inverso no sirve en este caso
        Max = max([InvCards[k] for k, v in VGroup.items() if v == 2])
        return 30000 + Max * 100 + Seq[4], '??', 'Two Pairs', Hand, Cards[Seq[4]]

    # Check for One Pair: Two cards of the same value.
    if GroupV.get(2):
        # TODO: En lugar de Seq[4] se debe agregar la carta más alta que no esté en el par
        Max = max([n for n in Seq if n != InvCards[GroupV[2]]])
        return 20000 + InvCards[GroupV[2]] * 100 + Max, GroupV[2], 'One Pair', Hand, Cards[Seq[4]]

    # Check for High Card: Highest value card.
    return 10000 + Seq[4] * 100 + Seq[4], Cards[Seq[4]], 'High Card', Hand, Cards[Seq[4]] # En este caso se devuelve el mayor valor posible

def CompareHands(HandA, HandB):
    A = GetHandValue(HandA)
    B = GetHandValue(HandB)
    # Va = Cards[int(str(A[0])[1:3])] if A[0] < 100000 else Cards[int(str(A[0])[2:4])]
    # Vb = Cards[int(str(B[0])[1:3])] if B[0] < 100000 else Cards[int(str(B[0])[2:4])]
    # print(Va, 'vs', Vb)

    if (A[0] > B[0]):
        print('Player 1 wins', HandA, 'is better than', HandB)
        return 1
    elif (A[0] < B[0]):
        return 0
        print('Player 1 looses', HandA, 'is not better than', HandB)
    else:
        print('Both players have:', A[2])
        return -INFINITE

# CompareHands(['QH', 'AH', 'JH', 'QH', 'TH'], ['2H', '3H', '4H', 'AH', '5D'])
# CompareHands(['5H', '5C', '6S', '7S', 'KD'], ['2C', '3S', '8S', '8D', 'TD'])
# CompareHands(['5D', '8C', '9S', 'JS', 'AC'], ['2C', '5C', '7D', '8S', 'QH'])
# CompareHands(['2D', '9C', 'AS', 'AH', 'AC'], ['3D', '6D', '7D', 'TD', 'QD'])
# CompareHands(['4D', '6S', '9H', 'QH', 'QC'], ['3D', '6D', '7H', 'QD', 'QS'])
# CompareHands(['2H', '2D', '4C', '4D', '4S'], ['3C', '3D', '3S', '9S', '9D'])

f = open('p054_poker.txt')
lines = f.readlines()
# p1 = []
# p2 = []
Wins = 0
for line in lines:
    # p1.append(list(card for card in line[:14].split()))
    # p2.append(list(card for card in line[15:29].split()))
    HandA = list(card for card in line[:14].split())
    HandB = list(card for card in line[15:29].split())
    Wins += CompareHands(HandA, HandB)
f.close()

print('ANSWER: ', Wins)

# El código admite muchas mejoras. Tuve que estudiar
# mucho sobre Poker (que no me agrada demasiado) para
# medio entender cómo sopesar las manos.
# Al final implementé un sistema propio de pesos que funciona. 
# Sospecho que ante algunos casos borde va a fallar.
