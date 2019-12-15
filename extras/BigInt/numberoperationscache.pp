{
  The NumberOperationsCache unit provides a class NumberOperationsCache
  that ised used with the BigNumber unit to provide caching of operations.

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


unit NumberOperationsCache;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, NCalc, Expressions, BoolFactory;

type
  TNumberOperation = (
    nopInvalid, nopAdd, nopSub, nopMul, nopDivMod, nopMax,
    nopMin, nopNegate, nopAbs, nopEq, nopFac, nopBinom, nopIsNeg, nopIsZero, nopNorm,
    nopLess, nopMore, nopExp, nopIsNum,
    nopOdd, nopToHex, nopToBin, nopFromHex, nopFromBin,
    nopSqr, nopSqrt, nopRand, nopRandR, nopToRom, nopFromRom,
    nopToOct, nopFromOct, nopLucGen
    );

{

From NCalc:
*  = defined in cache
-- = not worth caching, so not defined in cache

* function AddN(N1, N2: TValue): TValue;
* function SubN(N1, N2: TValue): TValue;
* function MulN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
* function DivModN(N1, N2: TValue; out AMod: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
* function DivN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
* function ModN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
* function MaxN(N1, N2: TValue): TValue;
* function MinN(N1, N2: TValue): TValue;
* function LessN(N1, N2: TValue): OPBool;
* function MoreN(N1, N2: TValue): OPBool;
* function MakeNegativeN(N: TValue): TValue;
* function AbsN(N: TValue): TValue;
* function EqualsN(N1, N2: TValue): OPBool;
* function EqualsP(P1, P2: TPrimitive): OPBool;
* function FacN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): TValue;
* function ExpN(Base: TValue; Exp: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): TValue;
* function SqrN(N: TValue): TValue;
* function SqrtN(N: TValue): TValue;

-- procedure SwapN(var N1, N2: TValue);
-- procedure IncPrimitive(var P: TPrimitive; V: TPrimitive = '1');
-- procedure DecPrimitive(var P: TPrimitive; V: TPrimitive = '1');

* function IsNumberN(N: TValue): OPBool;
* function IsNegativeN(N: TValue): OPBool;
* function IsZeroN(N: TValue): OPBool;
* function OddN(N: TValue): OPBool;
* function NormalizeNumberN(N: TValue; DoAssertIsNumber: OPBool = OPBool(True)): TValue;

* function NumberToHexN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): String;
* function TryHexToNumber(S: String; out N: TValue; CallBack: TCalcFeedbackEvent = nil): OPBool;
-> cached as Try.. function HexToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TValue;
* function NumberToBinN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): String;
* function TryBinToNumber(S: String; out N: TValue; CallBack: TCalcFeedbackEvent = nil): OPBool;
-> cached as Try.. function BinToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TValue;

}


  TArgsArray = Array of TValue;
  //for function results: Result is ArgsArray[0], then parameters left to right
  //for procedures: parametrs left to right

  { TCustomNumberOperationsCache }

const
  MaxCache = 7; // this seems to be the optimal size

type

  { TCache }

  TCache = class
  private
    FOperation: TNumberOperation;
    FInArgs: TArgsArray;
    FOutArgs: TArgsArray;
    FInArgsCount: Integer;
    FOutArgsCount: Integer;
    function GetInArgs: TArgsArray;
    procedure SetInArgs(AValue: TArgsArray);
    function GetOutArgs: TArgsArray;
    procedure SetOutArgs(AValue: TArgsArray);
    function CompareArgs(Arg1, Arg2: TArgsArray): OPBool;
    function EqualsArgValue(Arg1, Arg2: TValue): OPBool;
  protected
  public
    procedure Clear;
    procedure Assign(Source: TCache);
    function HasValidParams(ACache: TCache): OPBool;
    destructor Destroy; override;

    property Operation: TNumberOperation read FOperation write FOperation;
    property InArgs: TArgsArray read GetInArgs write SetInArgs;
    property OutArgs: TArgsArray read GetOutArgs write SetOutArgs;
    property InArgsCount: Integer read FInArgsCount write FInArgsCount;
    property OutArgsCount: Integer read FOutArgsCount write FOutArgsCount;
  end;

  TCustomNumberOperationsCache = class
  private
    FLocked: OPBool;
    FLockOwner: TObject;
    FCachedOperation: array[1..MaxCache] of TCache;
    FCurOperation: TCache;
    procedure ClearPrevOperationsCache(Index: Integer);
    procedure PushCache;
    function CompareCurPrevOperation(out Index: Integer): OPBool;
    function CompareArgs(Arg1, Arg2: TArgsArray): OPBool;
    function GetLocked: OPBool;
    procedure SetLocked(Value: OPBool; AOwner: TObject);
  protected
    procedure PrepareNewOperation(AOp: TNumberOperation; AInArgs: TArgsArray);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearOperationsCache;
    function IsCachedOperation(Sender: Tobject; AOp: TNumberOperation; AInArgs: TArgsArray; out CacheIndex: Integer): OPBool;
    function GetCachedOperation(Sender: TObject; CacheIndex: Integer; var AOutArgs: TArgsArray): OPBool;
    procedure AddPerformedOperation(Sender: TObject; AOp: TNumberOperation; AInArgs, AOutArgs: TargsArray);
    function TryLockCache(Sender: TObject): OPBool;
    function TryUnLockCache(Sender: TObject): OPBool;
    function ForceUnlockCache: OPBool;
    function IsLockedByMe(Sender: TObject): OPBool;
    property IsLocked: OPBool read GetLocked;
  end;

  TNumberOperationsCache = Class(TCustomNumberOperationsCache)
  public
  end;

  ENumerOperationsCache = Class(Exception);
  EInvalidArgumentCount = Class(ENumerOperationsCache);
  ECacheIsLocked = Class(ENumerOperationsCache);

type
  TArgsCountArray = Array[TNumberOperation] of Integer;


const
  InArgCounts: TArgsCountArray = (
  {nopInvalid} 0,
  {nopAdd}     2,
  {nopSub}     2,
  {nopMul}     2,
  {nopDivMod}  2,
  {nopMax}     2,
  {nopMin}     2,
  {nopNegate}  1,
  {nopAbs}     1,
  {nopEq}      2,
  {nopFac}     1,
  {nopBinom}   2,
  {nopIsNeg}   1,
  {nopIsZero}  1,
  {nopNorm}    2,
  {nopLess}    2,
  {nopMore}    2,
  {nopExp}     1,
  {nopIsNum}   1,
  {nopOdd}     1,
  {nopToHex}   1,
  {nopToBin}   1,
  {nopFromHex} 1,  //out value is not an InArg
  {nopFromBin} 1,   //out value is not an InArg
  {nopSqr}     1,
  {nopSqrt}    1,
  {nopRand}    1,
  {nopRandR}   2,
  {nopToRom}   1,
  {nopFromRom} 1,
  {nopToOct}   1,
  {nopFromOct} 1,
  {nopLucGen}  3

  );

  OutArgCounts: TArgsCountArray = (
  {nopInvalid} 0,
  {nopAdd}     1,
  {nopSub}     1,
  {nopMul}     1,
  {nopDivMod}  2,  // Result, AMod
  {nopMax}     1,
  {nopMin}     1,
  {nopNegate}  1,
  {nopAbs}     1,
  {nopEq}      1,
  {nopFac}     1,
  {nopBinom}   1,
  {nopIsNeg}   1,
  {nopIsZero}  1,
  {nopNorm}    1,

  {nopLess}    1,
  {nopMore}    1,
  {nopExp}     1,
  {nopIsNum}   1,
  {nopOdd}     1,
  {nopToHex}   1,
  {nopToBin}   1,
  {nopFromHex} 2,  //Result and value
  {nopFromBin} 2,  //Result and value
  {nopSqr}     1,
  {nopSqrt}    1,
  {nopRand}    1,
  {nopRandR}   1,
  {nopToRom}   1,
  {nopFromRom} 2,  //Result and value
  {nopToOct}   1,
  {nopFromOct} 2,  //Result and value
  {nopLucGen}  1

  );

var
  DebugNumberOperationsCache: OPBool;

implementation

const
  SInvalidArgumentCount = 'Invalid number of arguments for %: Expected %d, got %d';
  SCacheIsLocked = 'Cannot perform "%" on a locked cache (and the cache is not locked by the caller).';

  SNumberOperations: Array[TNumberOperation] of String = (
  {nopInvalid} 'nopInvalid',
  {nopAdd}     'nopAdd',
  {nopSub}     'nopSub',
  {nopMul}     'nopMul',
  {nopDivMod}  'nopDivMod',
  {nopMax}     'nopMax',
  {nopMin}     'nopMin',
  {nopNegate}  'nopNegate',
  {nopAbs}     'nopAbs',
  {nopEq}      'nopEq',
  {nopFac}     'nopFac',
  {nopinom}    'nopBinom',
  {nopIsNeg}   'nopIsNeg',
  {nopIsZero}  'nopIsZero',
  {nopNorm}    'nopNorm',

  {nopLess}    'nopLess',
  {nopMore}    'nopMore',
  {nopExp}     'nopExp',
  {nopIsNum}   'nopIsNum',
  {nopOdd}     'nopOdd',
  {nopToHex}   'nopToHex',
  {nopToBin}   'nopToBin',
  {nopFromHex} 'nopFromHex',
  {nopFromBin} 'nopFromBin',
  {nopSqr}     'nopSqr',
  {nopSqrt}    'nopSrt',
  {nopRand}    'nopRand',
  {nopRandR}   'nopRandR',
  {nopToRom}   'nopToRom',
  {nopFromRom} 'nopFromRom',
  {nopToOct}   'nopToOct',
  {nopFromOct} 'nopFromOct',
  {nopLucGen}  'nopLucGen'
  );


procedure RaiseEInvalidArgumentCount(AOp: TNumberoperation; Count: Integer);
begin
  Raise EInvalidArgumentCount.CreateFmt(SInvalidArgumentCount,[AOp, InArgCounts[AOp], Count]);
end;

procedure RaiseECacheIsLocked(AMethodName: String);
begin
  Raise ECacheIsLocked.CreateFmt(SCacheIsLocked,[AMethodName]);
end;

{ TCache }

function TCache.GetInArgs: TArgsArray;
var
  i, Len: Integer;
begin
  Len := Length(FInArgs);
  SetLength(Result, Len);
  if (Len > 0) then
  begin
    for i := Low(FInArgs) to High(FInArgs) do
    begin
      Result[i] := FInArgs[i];
    end;
  end;
end;

procedure TCache.SetInArgs(AValue: TArgsArray);
var
  i, Len: Integer;
begin
  Len := Length(AValue);
  SetLength(FInArgs, Len);
  if (Len > 0) then
  begin
    for i := Low(AValue) to High(AValue) do
    begin
      FInArgs[i] := AValue[i];
    end;
  end;
end;

function TCache.GetOutArgs: TArgsArray;
var
  i, Len: Integer;
begin
  Len := Length(FOutArgs);
  SetLength(Result, Len);
  if (Len > 0) then
  begin
    for i := Low(FOutArgs) to High(FOutArgs) do
    begin
      Result[i] := FOutArgs[i];
    end;
  end;
end;

procedure TCache.SetOutArgs(AValue: TArgsArray);
var
  i, Len: Integer;
begin
  Len := Length(AValue);
  SetLength(FOutArgs, Len);
  if (Len > 0) then
  begin
    for i := Low(AValue) to High(AValue) do
    begin
      FOutArgs[i] := AValue[i];
    end;
  end;
end;

function TCache.CompareArgs(Arg1, Arg2: TArgsArray): OPBool;
var
  i: Integer;
begin
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('CompareArgs');
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('Length(Arg1) = ',length(arg1),' Length(Arg2) = ',Length(arg2));
  Result := ToBool(False);
  if IsFalse(Length(Arg1) = Length(Arg2)) then Exit;
  if IsFalse(Length(Arg1) = 0) then
  begin
    //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('Low(Arg1) = ',Low(Arg1),', High(Arg1) = ',High(Arg1));
    for i := Low(Arg1) to High(Arg1) do
    begin
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then write('i = ',i);
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then write(' Arg1[i] = "',arg1[i],'"');
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then write(' Arg2[i] = "',arg2[i],'"');
      if IsFalse(EqualsArgValue(Arg1[i], Arg2[i])) then Exit;
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln(' Compare is OK for i = ',i);
    end;
  end;
  Result := ToBool(True);
end;

function TCache.EqualsArgValue(Arg1, Arg2: TValue): OPBool;
var
  Trim1, Trim2: String;
begin
  Result := ToBool(False);
  //if either Arg is not a number then see what they may be
  //don't use and, other wise it will crash on e.g. Arg1=123 Arg2=11F !
  if IsFalse(IsNumberN(Arg1)) or IsFalse(IsNumberN(Arg2)) then
  begin
    if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCache.EqualsArgValue (Arg1 or Ar2 is not a number): Arg1 = ',Arg1,' Arg2 = ',Arg2);
    if IsTrue(IsBinString(Arg1, Trim1)) and IsTrue(IsBinString(Arg2, Trim2)) then
    begin
      if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCache.EqualsArgValue: Args are Bin');
      //allow for leading zero's
      while (Length(Trim1) > 0) and (Trim1[1] = '0') do System.Delete(Trim1, 1, 1);
      while (Length(Trim2) > 0) and (Trim2[1] = '0') do System.Delete(Trim2, 1, 1);
      Result := IsTrue(Trim1 = Trim2);
    end
    else if IsTrue(IsHexString(Arg1, Trim1)) and IsTrue(IsHexString(Arg2, Trim2)) then
    begin
      if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCache.EqualsArgValue: Args are Hex');
      while (Length(Trim1) > 0) and (Trim1[1] = '0') do System.Delete(Trim1, 1, 1);
      while (Length(Trim2) > 0) and (Trim2[1] = '0') do System.Delete(Trim2, 1, 1);
      Result := IsTrue(CompareText(Trim1, Trim2) = 0);
    end
    else if IsTrue(IsRomString(Arg1, Trim1)) and IsTrue(IsRomString(Arg2, Trim2)) then
    begin
      if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCache.EqualsArgValue: Args are Roman');
      Result := IsTrue(CompareText(Trim1, Trim2) = 0);
    end
    else
    begin
      if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCache.EqualsArgValue: Args should be OPBool here');
      Result := IsTrue(ValueToOPBool(Arg1) = ValueToOPBool(Arg2));
    end
  end
  else
    Result := EqualsN(Arg1, Arg2);
end;

procedure TCache.Clear;
begin
  FOperation := nopInvalid;
  Setlength(FInArgs, 0);
  SetLength(FOutArgs, 0);
  FInArgsCount := 0;
  FOutArgsCount := 0;
end;

procedure TCache.Assign(Source: TCache);
begin
  FOperation := Source.Operation;
  FInArgsCount := Source.InArgsCount;
  FOutArgsCount := Source.OutArgsCount;
  SetInArgs(Source.InArgs);
  SetOutArgs(Source.OutArgs);
end;

function TCache.HasValidParams(ACache: TCache): OPBool;
begin
  Result := IsTrue(FOperation = ACache.Operation)
     and IsTrue(FInArgsCount = ACache.InArgsCount)
     and IsTrue(FOutArgsCount = ACache.OutArgsCount)
     and IsTrue(CompareArgs(FInArgs, ACache.InArgs))
     //and IsTrue(CompareArgs(FOutArgs, ACache.OutArgs))
     ;
end;

destructor TCache.Destroy;
begin
  Clear;
  inherited Destroy;
end;

{ TCustomNumberOperationsCache }

procedure TCustomNumberOperationsCache.ClearPrevOperationsCache(Index: Integer);
begin
  FCachedOperation[Index].Clear;
end;


procedure TCustomNumberOperationsCache.PushCache;
var
  i: Integer;
begin
  for i := 1 to MaxCache - 1 do
  begin
    FCachedOperation[i].Assign(FCachedoperation[i+1]);
  end;
  ClearPrevOperationsCache(MaxCache);
end;

function TCustomNumberOperationsCache.CompareCurPrevOperation(out Index: Integer): OPBool;
var
  i: Integer;
begin
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCustomNumberOperationsCache.CompareCurPrevOperation');
  Result := ToBool(False);
  Index := -1;
  for i :=  1 to MaxCache do
  begin
    Result := FCachedOperation[i].HasValidParams(FCurOperation);
    if IsTrue(Result) then
    begin
      Index := i;
      Break;
    end;
  end;
end;

function TCustomNumberOperationsCache.CompareArgs(Arg1, Arg2: TArgsArray): OPBool;
var
  i: Integer;
begin
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('CompareArgs');
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('Length(Arg1) = ',length(arg1),' Length(Arg2) = ',Length(arg2));
  Result := ToBool(False);
  if IsFalse(Length(Arg1) = Length(Arg2)) then Exit;
  if IsFalse(Length(Arg1) = 0) then
  begin
    //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('Low(Arg1) = ',Low(Arg1),', High(Arg1) = ',High(Arg1));
    for i := Low(Arg1) to High(Arg1) do
    begin
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then write('i = ',i);
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then write(' Arg1[i] = "',arg1[i],'"');
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then write(' Arg2[i] = "',arg2[i],'"');
      if IsFalse(IsZeroN(SubN(Arg1[i], Arg2[i]))) then Exit;
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln(' Compare is OK for i = ',i);
    end;
  end;
  Result := ToBool(True);
end;

function TCustomNumberOperationsCache.GetLocked: OPBool;
begin
  Result := IsTrue(FLocked);
end;

procedure TCustomNumberOperationsCache.SetLocked(Value: OPBool; AOwner: TObject);
begin
  if IsFalse(Value = FLocked) then
  begin
    FLocked := Value;
    FLockOwner := AOwner;
  end;
end;

procedure TCustomNumberOperationsCache.ClearOperationsCache;
var
  i: Integer;
begin
  for i := 1 to MaxCache do ClearPrevOperationsCache(i);
  FCurOperation.Clear;
end;

constructor TCustomNumberOperationsCache.Create;
var
  i: Integer;
begin
  FLocked := ToBool(False);
  for i := 1 to MaxCache do FCachedOperation[i] := TCache.Create;
  FCurOperation := TCache.Create;
  ClearOperationsCache;
end;

destructor TCustomNumberOperationsCache.Destroy;
var
  i: Integer;
begin
  ClearOperationsCache;
  for i := 1 to MaxCache do FCachedOperation[i].Free;
  FCurOperation.Free;
  inherited Destroy;
end;

function TCustomNumberOperationsCache.IsCachedOperation(Sender: Tobject;
  AOp: TNumberOperation; AInArgs: TArgsArray; out CacheIndex: Integer): OPBool;
begin
  Result := ToBool(False);
  CacheIndex := -1;
  if IsTrue(GetLocked) then
  begin
    //Only return True if Sender owns the lock.
    if IsFalse(Sender.Equals(FLockOwner)) then Exit;
  end;
  PrepareNewOperation(AOp, AInArgs);
  Result := IsTrue(CompareCurPrevOperation(CacheIndex));
end;

function TCustomNumberOperationsCache.GetCachedOperation(Sender: TObject;  CacheIndex: Integer; var AOutArgs: TArgsArray): OPBool;
//You must check IsLocked / IsLockedByMe before calling this
//You must call IsCachedOperation before calling this, otherwise result may be invalid
//and you must setup AOutArgs wiht correct length for the cached operation
var
  i: Integer;
begin
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCustomNumberOperationsCache.GetCachedOperation: FCachedOperation = ', SNumberOperations[FCachedOperation[CacheIndex].Operation]);
  Result := ToBool(False);
  if IsTrue(GetLocked) then
  begin
    //Only return True if Sender owns the lock.
    if IsFalse(Sender.Equals(FLockOwner)) then Exit;
  end;
  if IsFalse(Length(AOutArgs) = OutArgCounts[FCachedOperation[CacheIndex].Operation]) then RaiseEInvalidArgumentCount(FCachedOperation[CacheIndex].Operation, Length(AOutArgs));
  AOutArgs := FCachedOperation[CacheIndex].OutArgs;
  for i := Low(AOutArgs) to High(AOutArgs) do
  begin
    //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('i = ',i,' AOutArgs[i] = "',AOutArgs[i],'"');
  end;
  Result := ToBool(True);
end;

procedure TCustomNumberOperationsCache.AddPerformedOperation(Sender: TObject; AOp: TNumberOperation; AInArgs, AOutArgs: TargsArray);
var
  i: Integer;
begin
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCustomNumberOperationsCache.AddPerformedOperation: AOp = ',SNumberOperations[AOp]);
  if IsFalse(Length(AInArgs) = InArgCounts[AOp]) then RaiseEInvalidArgumentCount(AOp, Length(AInArgs));
  if IsTrue(GetLocked) then
  begin
    if IsFalse(Sender.Equals(FLockOwner)) then RaiseECacheIsLocked('TCustomNumberOperationsCache.AddPerformedOperation');
  end;
  PushCache;
  FCachedOperation[MaxCache].Operation := AOp;
  FCachedOperation[MaxCache].InArgsCount := InArgCounts[AOp];
  FCachedOperation[MaxCache].InArgs := AInArgs;
  FCachedOperation[MaxCache].OutArgsCount := OutArgCounts[AOp];
  FCachedOperation[MaxCache].OutArgs := AOutArgs;

  if IsFalse(InArgCounts[AOp] = 0) then
  begin
    for i := Low(AInArgs) to High(AInArgs) do
    begin
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('i = ',i,' FCachedOperations[',MaxCache,'].InArgs[i] = "',FCachedOperation[MaxCache].InArgs[i],' AInArgs[i] = "',AInArgs[i],'"');
    end;
  end;
  if IsFalse(OutArgCounts[AOp] = 0) then
  begin
    for i := Low(AOutArgs) to High(AOutArgs) do
    begin
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('i = ',i,' FCachedOperation[',MaxCache,'].OutArgs[i] = "',FCachedOperation[MaxCache].OutArgs[i],' AOutArgs[i] = "',AOutArgs[i],'"');
    end;
  end;
end;

function TCustomNumberOperationsCache.TryLockCache(Sender: TObject): OPBool;
begin
  Result := IsFalse(FLocked);
  if IsTrue(Result) then
  begin
    try
      SetLocked(ToBool(True), Sender);
    finally
      Result := IsTrueComPlex(IsTrue(GetLocked),IsTrue(Sender.Equals(FLockOwner)));
    end;
  end;
end;

function TCustomNumberOperationsCache.TryUnLockCache(Sender: TObject): OPBool;
begin
  Result := IsFalse(GetLocked);
  if IsFalse(Result) then
  begin
    try
      Result := IsTrue(Sender.Equals(FLockOwner));
      ////if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln(Format('Sender = %p, FLockOwner = %p, Sender.Equals(FLockOwner) = %d',[Pointer(Sender),Pointer(FLockOwner),Ord(Sender.Equals(FLockOwner))]));
      if IsTrue(Result) then SetLocked(ToBool(False), nil);
    finally
      Result := IsFalse(GetLocked);
    end;
  end;
end;

function TCustomNumberOperationsCache.ForceUnlockCache: OPBool;
// Use at your own risk!
begin
  try
    ClearOperationsCache;
    SetLocked(ToBool(False), nil);
  finally
    Result := IsFalse(GetLocked);
  end;
end;

function TCustomNumberOperationsCache.IsLockedByMe(Sender: TObject): OPBool;
begin
  Result := IsTrue(GetLocked);
  if IsTrue(Result) then
  begin
    try
      Result := IsTrue(Sender.Equals(FLockOwner));
    finally
      Result := IsTrueComplex(IsTrue(Result), IsTrue(GetLocked));
    end;
  end;
end;

procedure TCustomNumberOperationsCache.PrepareNewOperation(AOp: TNumberOperation;  AInArgs: TArgsArray);
var
  i: Integer;
begin
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCustomNumberOperationsCache.PrepareNewOperation: AOp = ',SNumberOperations[AOp]);
  if IsFalse(Length(AInArgs) = InArgCounts[AOp]) then RaiseEInvalidArgumentCount(AOp, Length(AInArgs));
  FCurOperation.Clear;
  FCurOperation.Operation := AOp;
  FCurOperation.InArgsCount := InArgCounts[AOp];
  FCurOperation.InArgs := AInArgs;
  FCuroperation.OutArgsCount := OutArgCounts[AOp];
  //SetLength(FCurOperation.OutArgs, OutARgCounts[AOp]);

  if IsFalse(InArgCounts[AOp] = 0) then
  begin
    for i := Low(AInArgs) to High(AInArgs) do
    begin
      //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('i = ',i,' FCurOperation.InArgs[i] = "',FCurOperation.InArgs[i],' AInArgs[i] = "',AInArgs[i],'"');
    end;
  end;
  //if IsTrue(DebugNumberOperationsCache) and IsTrue(IsConsole) then writeln('TCustomNumberOperationsCache.PrepareNewOperation: End.');

end;

Initialization
  DebugNumberOperationsCache := ToBool(False);

end.

