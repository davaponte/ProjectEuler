{
  The NCalc unit provides several basic functions for calculating
  with Natural big numbers: up to 2147483648 digits long (provided you
  have the memory to store the result in memory).
  This allows for a range larger than the Float type, and without loss
  of precision.

  Ever needed to calculate 9^99 with absolute precision?
  (Answer: 29512665430652752148753480226197736314359272517043832886063884637676943433478020332709411004889)
  or Fac(100)?
  (Answer: 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000)
  In that case: this is the library to use.

  It also provides conversion functions from and to Hexadecimal and Binary.

  Copyright (C) 2013 by Flying Sheep Inc. and Bart Broersma

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

unit NCalc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BoolFactory, Expressions;

type
  TValue = String;
  TPositiveValue = String;
  TPrimitive = Char;

  TCalcFeedbackEvent = procedure(const Msg: String; IsStartOfNewMessage: OPBool) of Object;

  ENumber = class(Exception);
  ENumberNotPositive = class(ENumber);
  ENumberRangeCheckError = class(ENumber);
  EPrimitiveRangeCheckError = class(ENumber);
  EInvalidOPBool = Class(ENumber);


function AddN(N1, N2: TValue): TValue;
function SubN(N1, N2: TValue): TValue;
function MulN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function DivModN(N1, N2: TValue; out AMod: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function DivN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function ModN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function MaxN(N1, N2: TValue): TValue;
function MinN(N1, N2: TValue): TValue;
function LessN(N1, N2: TValue): OPBool;
function MoreN(N1, N2: TValue): OPBool;
function MakeNegativeN(N: TValue): TValue;
function AbsN(N: TValue): TValue;
function EqualsN(N1, N2: TValue): OPBool;
function EqualsP(P1, P2: TPrimitive): OPBool;
function FacN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function ExpN(Base: TValue; Exp: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function GoogolPlex(CallBack: TCalcFeedbackEvent = nil): TValue;
function SqrN(N: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function SqrtN(N: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
function RandomN(N: TPositiveValue): TValue;
function RandomRangeN(N1, N2: TPositiveValue): TValue;
function _FibN(N: TPositiveValue): TPositiveValue;
function FibN(N: TPositiveValue): TPositiveValue;
function LucasN(N: TPositiveValue): TPositiveValue;
function LucasGenN(L1, L2, N: TPositiveValue): TPositiveValue;
function BinomN(N, K: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;

procedure SwapN(var N1, N2: TValue);
procedure IncPrimitive(var P: TPrimitive; V: TPrimitive = '1');
procedure DecPrimitive(var P: TPrimitive; V: TPrimitive = '1');

function IsNumberN(N: TValue): OPBool;
function IsNegativeN(N: TValue): OPBool;
function IsZeroN(N: TValue): OPBool;
function IsPrimitiveN(N: TValue): OPBool;
function OddN(N: TValue): OPBool;
function NormalizeNumberN(N: TValue; DoAssertIsNumber: OPBool = OPBool(True)): TValue;
function NumberToPrimitiveN(N: TValue): TPrimitive;

function NumberToHexN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): String;
function TryHexToNumber(S: String; out N: TValue; CallBack: TCalcFeedbackEvent = nil): OPBool;
function HexToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TValue;

function NumberToBinN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): String;
function TryBinToNumber(S: String; out N: TValue; CallBack: TCalcFeedbackEvent = nil): OPBool;
function BinToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TValue;

function NumberToRomanN(N: TPositiveValue): String;
function TryRomanToNumber(S: String; out N: TPositiveValue; CallBack: TCalcFeedBackEvent = nil): OPBool;
function RomanToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TPositiveValue;

function NumberToOctN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): String;
function TryOctToNumber(S: String; out N: TPositiveValue; CallBack: TCalcFeedBackEvent = nil): OPBool;
function OctToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TPositiveValue;

function IsHexString(S: String; out TrimmedS: String): OPBool;
function IsBinString(S: String; out TrimmedS: String): OPBool;
function IsRomString(S: String; out TrimmedS: String): OPBool;
function IsOctString(S: String; out TrimmedS: String): OPBool;

function OPBoolToValue(ABool: OPBool): TValue;
function ValueToOPBool(AValue: TValue): OPBool;


procedure AssertIsNumberN(N: TValue);

const
  SIsNotANumber = '%s is not a valid number.';
  SIsNotAPositiveNumber = '%s is not a positive number';
  SPrimitiveRangeError = 'Range Check Error: %s is not a valid primitive.';
  SNumberRangeCheckError = 'Range Check Error: %s is out of bounds here.';
  SEDivByZero = 'Divide by zero.';
  SIsNotSquare = '%s is not a square af any natural number.';
  SEZeroExpZero = 'You cannot raise the power of 0 to 0.';
  SIsNotAHexNumber = '%s is not a hexadecimal number.';
  SIsNotABinNumber = '%s is not a binary number.';
  SIsNotARomNumber = '%s is not a valid Roman number.';
  SIsNotAOctNumber = '%s is not an octal number.';

const
  //Googol = 10^100
  Googol = '10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';


var
  DebugNCalc: OPBool;

implementation


type
  TCalcRes = record
    Value: TPrimitive;
    Carry: TPrimitive;
  end;

const
  Prime_Zero: TPrimitive = '0';
  Prime_Last: TPrimitive = '9';
  Prime_Negative: TPrimitive = '-';
  Prime_Positive: TPrimitive = '+';
  PrimitiveNumbers = ['0'..'9'];


procedure RaiseENumber(N: TValue);
begin
  Raise ENumber.CreateFmt(SIsNotANumber,[N]);
end;

procedure AssertIsNumberN(N: TValue);
begin
  if IsFalse(IsNumberN(N)) then RaiseENumber(N);
end;

procedure RaiseENumberNotPositive(N: TPositiveValue);
begin
  Raise ENumberNotPositive.CreateFmt(SIsNotAPositiveNumber,[N]);
end;

procedure AssertIsPositiveN(N: TPositiveValue);
begin
  if IsTrue(IsNegativeN(N)) then RaiseENumberNotPositive(N);
end;

procedure RaiseEPrimitiveRangeCheckError(P: TPrimitive);
begin
  Raise EPrimitiveRangeCheckError.CreateFmt(SPrimitiveRangeError,[P]);
end;

procedure RaiseEPrimitiveRangeCheckError(N: TValue);
begin
  Raise EPrimitiveRangeCheckError.CreateFmt(SPrimitiveRangeError,[N]);
end;

procedure AssertIsPrimitive(P: TPrimitive);
begin
  if IsFalse(P in PrimitiveNumbers) then RaiseEPrimitiveRangeCheckError(P);
end;

procedure RaiseENumberRangeCheckError(N: TValue);
begin
  Raise ENumberRangeCheckError.CreateFmt(SNumberRangeCheckError,[N]);
end;

procedure RaiseEDivByZero;
begin
  Raise EDivByZero.Create(SEDivByZero);
end;

{$i ncalc.inc}
{$i ncalcadd.inc}
{$i ncalcsub.inc}
{$i ncalcmul.inc}
{$i ncalcdiv.inc}



procedure InitLookupTables;
begin
  InitAddLookupTable;
  InitSubLookupTable;
  InitMulLookupTable;

end;

initialization
  Randomize;
  InitLookupTables;
  DebugNCalc := ToBool(False);

end.

