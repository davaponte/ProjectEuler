{
  The BigNumbers unit provides a class TNumber that can handle Natural
  numbers of up to 2147483648 digits long (provided you have the memory
  to store the result in memory)

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


unit BigNumbers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Expressions, Boolfactory, NCalc, NumberOperationsCache;

type

  TNumberCalcFeedbackEvent = procedure(Sender: Tobject; const Msg: String; IsStartOfNewMessage: Boolean) of Object;
  { TNumber }

  TNumber = class
  private
    FValue: TValue;  //never set this directly!! always use SetValue() or the property Value
    FPrivateCache: TNumberOperationsCache;
    FCache: TNumberOperationsCache;
    FUseCache: OPBool;
    FOnNumberCalcFeedback: TNumberCalcFeedbackEvent;
    FDivModRemainder: TValue;
    FHexValue: String;
    FBinValue: String;
    FRomValue: String;
    FOctValue: String;
    FValidHexCache: OPBool;
    FValidBinCache: OPBool;
    FValidRomCache: OPBool;
    FValidOctCache: OPBool;
    procedure SetValue(AValue: TValue);
    function GetHexValue: String;
    procedure SetHexValue(AValue: String);
    function GetBinValue: String;
    procedure SetBinValue(AValue: String);
    function GetRomValue: String;
    procedure SetRomValue(AValue: String);
    function GetOctValue: String;
    procedure SetOctValue(AValue: String);
    function GetCacheIsLocked: OPBool;
    function GetCanUnlockCache: OPBool;
    procedure FCalcCallBack(const Msg: String; IsStartOfNewMessage: OPBool);
  protected
    procedure DoOnNumberCalcFeedback(const Msg: String; IsStartOfNewMessage: OPBool);
  public
    constructor Create(AValue: TValue; UsePrivateCache: OPBool = False);
    destructor Destroy; override;

    function AddN(ANumber: TNumber): TValue;
    function SubN(ANumber: TNumber): TValue;
    function MulN(ANumber: TNumber): TValue;
    function DivModN(ANumber: TNumber): TValue;
    function DivN(ANumber: TNumber): TValue;
    function ModN(ANumber: TNumber): TValue;
    function MaxN(ANumber: TNumber): TValue;
    function MinN(ANumber: TNumber): TValue;
    function OddN: OPBool;
    function MakeNegativeN: TValue;
    function AbsN: TValue;
    function EqualsN(ANumber: TNumber): OPBool;
    function FacN: TValue;
    function BinomN(ANumber: TNumber): TValue;
    function SqrN: TValue;
    function SqrtN: TValue;
    function RandomN: TValue;
    function RandomRangeN(ANumber: TNumber): TValue;
    function LucasN: TPositiveValue;
    function FibN: TPositiveValue;
    function LucasGenN(L1, L2: TPositiveValue): TPositiveValue;

    procedure SwapN(ANumber: TNumber);
    function IsNegativeN: OPBool;
    function IsZeroN: OPBool;
    function NormalizeNumberN(DoAssertIsNumber: OPBool): TValue;
    function NumberToHexN: String;
    function TryHexToNumber(S: String; out N: TValue): OPBool;
    function HexToNumber(S: String): TValue;
    function NumberToBinN: String;
    function TryBinToNumber(S: String; out N: TValue): OPBool;
    function BinToNumber(S: String): TValue;
    function NumberToRomanN: String;
    function TryRomanToNumber(S: String; out N: TValue): OPBool;
    function RomanToNumber(S: String): TValue;
    function NumberToOctN: String;
    function TryOctToNumber(S: String; out N: TValue): OPBool;
    function OctToNumber(S: String): TValue;

    function LockCache: OPBool;
    function UnlockCache: OPBool;
    function ForceUnlockCache: OPBool;

    property UseCache: OPBool read FUseCache write FUseCache;
    property CacheIsLocked: OPBool read GetCacheIsLocked;
    property CanUnlockCache: OPBool read GetCanUnlockCache;
    property Value: TValue read FValue write SetValue;
    property HexValue: String read GetHexValue write SetHexValue;
    property BinValue: String read GetBinValue write SetBinValue;
    property RomanValue: String read GetRomValue write SetRomValue;
    property OctValue: String read GetOctValue write SetOctValue;

    property DivModRemainder: TValue read FDivModRemainder;
    property OnNumberFeedback: TNumberCalcFeedbackEvent read FOnNumberCalcFeedback write FOnNumberCalcFeedback;
  end;

type
  EInvalidOPBool = Class(ENumber);

var
  DebugBigNumbers: OPBool;

implementation

var
  __GlobalOperationsCache: TNumberOperationsCache;

function GlobalOperationsCache: TNumberOperationsCache;
begin
  if not Assigned(__GlobalOperationsCache) then
  begin
    __GlobalOperationsCache := TNumberOperationsCache.Create;
  end;
  Result := __GlobalOperationsCache;
end;


{ TNumber }

procedure TNumber.SetValue(AValue: TValue);
begin
  AssertIsNumberN(AValue);
  if FValue = AValue then Exit;
  FValue := AValue;
  FValidHexCache := ToBool(False);
  FValidBinCache := ToBool(False);
  FValidRomCache := ToBool(False);
end;

function TNumber.GetHexValue: String;
begin
  if FValidHexCache then
    Result := FHexValue
  else
  begin
    Result := Self.NumberToHexN;
    FHexValue := Result;
    FValidHexCache := ToBool(True);
  end;
end;

function TNumber.GetBinValue: String;
begin
  if FValidBinCache then
    Result := FBinValue
  else
  begin
    Result := Self.NumberToBinN;
    FBinValue := Result;
    FValidBinCache := ToBool(True);
  end;
end;

function TNumber.GetRomValue: String;
begin
  if FValidRomCache then
    Result := FRomValue
  else
  begin
    Result := Self.NumberToRomanN;
    FRomValue := Result;
    FValidRomCache := ToBool(True);
  end;
end;

procedure TNumber.SetHexValue(AValue: String);
begin
  Value := Self.HexToNumber(AValue);
  FValidHexCache := ToBool(True);
  //This trimmes and removes $ or 0x prefix, also now uppercase it, so GetHexValue returns in uppercase if cached
  NCalc.IsHexString(UpperCase(AValue), FHexValue);
end;

procedure TNumber.SetBinValue(AValue: String);
begin
  Value := Self.BinToNumber(AValue);
  FValidBinCache := ToBool(True);
  //This trimmes and removes % prefix (no need to uppercase this, it's only one's and zero's
  NCalc.IsBinString(UpperCase(AValue), FBinValue);
end;

procedure TNumber.SetRomValue(AValue: String);
begin
  Value := Self.RomanToNumber(AValue);
  FValidRomCache := ToBool(True);
  FRomValue := Trim(AValue);
end;

function TNumber.GetOctValue: String;
begin
  if FValidOctCache then
    Result := FOctValue
  else
  begin
    Result := Self.NumberToOctN;
    FOctValue := Result;
    FValidOctCache := ToBool(True);
  end;
end;

procedure TNumber.SetOctValue(AValue: String);
begin
  Value := Self.OctToNumber(AValue);
  FValidOctCache := ToBool(True);
  //This trimmes and removes & prefix
  NCalc.IsOctString(UpperCase(AValue), FOctValue);
end;

function TNumber.GetCacheIsLocked: OPBool;
begin
  Result := IsTrue(FCache.IsLocked);
end;

function TNumber.GetCanUnlockCache: OPBool;
begin
  Result := IsTrue(FCache.IsLockedByMe(Self));
end;

procedure TNumber.FCalcCallBack(const Msg: String; IsStartOfNewMessage: OPBool);
begin
  DoOnNumberCalcFeedback(Msg, IsStartOfNewMessage);
end;

procedure TNumber.DoOnNumberCalcFeedback(const Msg: String; IsStartOfNewMessage: OPBool);
begin
  if Assigned(FOnNumberCalcFeedback) then FOnNumberCalcFeedback(Self, Msg, IsStartOfNewMessage);
end;

constructor TNumber.Create(AValue: TValue; UsePrivateCache: OPBool = False);
begin
  Value := AValue;
  FValidHexCache := False;
  FValidBinCache := False;
  FValidOctCache := False;
  FUseCache := True;
  if UsePrivateCache then
  begin
    FPrivateCache := TNumberOperationsCache.Create;
    FCache := FPrivateCache;
  end
  else
  begin
    FPrivateCache := nil;
    FCache := GlobalOperationsCache;
  end;
end;

destructor TNumber.Destroy;
begin
  if IsTrue(Assigned(FPrivateCache)) then FPrivateCache.Free;
  inherited Destroy;
end;

function TNumber.AddN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopAdd]);
    SetLength(InArgs, InArgCounts[nopAdd]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopAdd, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.AddN(FValue, ANumber.Value);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopAdd, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.SubN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopSub]);
    SetLength(InArgs, InArgCounts[nopSub]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopSub, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.SubN(FValue, ANumber.Value);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopSub, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.MulN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopMul]);
    SetLength(InArgs, InArgCounts[nopMul]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopMul, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.MulN(FValue, ANumber.Value, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopMul, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;


function TNumber.DivModN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopDivMod]);
    SetLength(InArgs, InArgCounts[nopDivMod]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopDivMod, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      FDivModRemainder := OutArgs[1];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.DivModN(FValue, ANumber.Value, FDivModRemainder, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      OutArgs[1] := FDivModRemainder;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopDivMod, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.DivN(ANumber: TNumber): TValue;
begin
  Result := DivModN(ANumber);
end;

function TNumber.ModN(ANumber: TNumber): TValue;
begin
  DivModN(ANumber);
  Result := FDivModRemainder;
end;

function TNumber.MaxN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopMax]);
    SetLength(InArgs, InArgCounts[nopMax]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopMax, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.MaxN(FValue, ANumber.Value);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopMax, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.MinN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopMin]);
    SetLength(InArgs, InArgCounts[nopMin]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopMin, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.MinN(FValue, ANumber.Value);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopMin, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.OddN: OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopOdd]);
    SetLength(InArgs, InArgCounts[nopOdd]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopOdd, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := ValueToOPBool(OutArgs[0]);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.OddN(FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopOdd, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.MakeNegativeN: TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopNegate]);
    SetLength(InArgs, InArgCounts[nopNegate]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopNegate, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.MakeNegativeN(FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopNegate, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.AbsN: TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopAbs]);
    SetLength(InArgs, InArgCounts[nopAbs]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopAbs, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.AbsN(FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopAbs, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.EqualsN(ANumber: TNumber): OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopEq]);
    SetLength(InArgs, InArgCounts[nopEq]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopEq, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := ValueToOPBool(OutArgs[0]);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.EqualsN(FValue, ANumber.Value);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopEq, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.FacN: TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopFac]);
    SetLength(InArgs, InArgCounts[nopFac]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopFac, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ', Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.FacN(FValue, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopFac, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.BinomN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopBinom]);
    SetLength(InArgs, InArgCounts[nopBinom]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopBinom, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.BinomN(FValue, ANumber.Value);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopBinom, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.SqrN: TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopSqr]);
    SetLength(InArgs, InArgCounts[nopSqr]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopSqr, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ', Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.SqrN(FValue, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopSqr, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.SqrtN: TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopSqrt]);
    SetLength(InArgs, InArgCounts[nopSqrt]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopSqrt, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ', Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.SqrtN(FValue, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopSqrt, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.RandomN: TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopRand]);
    SetLength(InArgs, InArgCounts[nopRand]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopRand, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ', Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.RandomN(FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopRand, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.RandomRangeN(ANumber: TNumber): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopRandR]);
    SetLength(InArgs, InArgCounts[nopRandR]);
    InArgs[0] := FValue;
    InArgs[1] := ANumber.Value;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopRandR, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.RandomRangeN(FValue, ANumber.Value);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopRandR, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.LucasN: TPositiveValue;
begin
  Result := Self.LucasGenN('2', '1');
end;

function TNumber.FibN: TPositiveValue;
begin
  Result := Self.LucasGenN('1', '1');
end;

function TNumber.LucasGenN(L1, L2: TPositiveValue): TPositiveValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopLucGen]);
    SetLength(InArgs, InArgCounts[nopLucGen]);
    InArgs[0] := L1;
    InArgs[1] := L2;
    InArgs[2] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopLucGen, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.LucasGenN(L1, L2, FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopLucGen, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

procedure TNumber.SwapN(ANumber: TNumber);
var
  Temp: TValue;
begin
  Temp := FValue;
  Value := ANumber.Value;
  ANumber.Value := Temp;
end;

function TNumber.IsNegativeN: OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopIsNeg]);
    SetLength(InArgs, InArgCounts[nopIsNeg]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopIsNeg, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := ValueToOPBool(OutArgs[0]);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.IsNegativeN(FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopIsNeg, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.IsZeroN: OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopIsZero]);
    SetLength(InArgs, InArgCounts[nopIsZero]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopIsZero, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := ValueToOPBool(OutArgs[0]);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.IsZeroN(FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopIsZero, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.NormalizeNumberN(DoAssertIsNumber: OPBool): TValue;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopNorm]);
    SetLength(InArgs, InArgCounts[nopNorm]);
    InArgs[0] := FValue;
    InArgs[1] := OPBoolToValue(DoAssertIsNumber);
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopNorm, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ', Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.NormalizeNumberN(FValue, DoAssertIsNumber);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := Result;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopNorm, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.NumberToHexN: String;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopToHex]);
    SetLength(InArgs, InArgCounts[nopToHex]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopToHex, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.NumberToHexN(FValue, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := String(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopToHex, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.TryHexToNumber(S: String; out N: TValue): OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
  TrimmedS: String;
begin
  //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('TNumber.TryHexToNumber: S = ',S);
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopFromHex]);
    SetLength(InArgs, InArgCounts[nopFromHex]);
    //Do not store prefixes in the cache results!!
    IsHexString(S, TrimmedS);
    InArgs[0] := TValue(TrimmedS);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('TNumber.TryHexToNumber: InArgs[0] = ',InArgs[0]);
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopFromHex, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Length(OutArgs) = ',Length(OutArgs));
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('OutArgs[0] = ',OutArgs[0]);
      Result := ValueToOPBool(OutArgs[0]);
      N := OutArgs[1];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.TryHexToNumber(S, N, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      OutArgs[1] := N;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopFromHex, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.HexToNumber(S: String): TValue;
begin
  if IsFalse(Self.TryHexToNumber(S, Result)) then
    Raise EConvertError.CreateFmt(SIsNotAHexNumber,[S]);
end;

function TNumber.NumberToBinN: String;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopToBin]);
    SetLength(InArgs, InArgCounts[nopToBin]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopToBin, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.NumberToBinN(FValue, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := String(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopToBin, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.TryBinToNumber(S: String; out N: TValue): OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
  TrimmedS: String;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopFromBin]);
    SetLength(InArgs, InArgCounts[nopFromBin]);
    //Do not store prefixes in cahcheresults!!
    IsBinString(S, TrimmedS);
    InArgs[0] := TValue(TrimmedS);
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopFromBin, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := ValueToOPBool(OutArgs[0]);
      N := OutArgs[1];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.TryBinToNumber(S, N, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      OutArgs[1] := N;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopFromBin, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.BinToNumber(S: String): TValue;
begin
  if IsFalse(Self.TryBinToNumber(S, Result)) then
    Raise EConvertError.CreateFmt(SIsNotABinNumber,[S]);
end;

function TNumber.NumberToRomanN: String;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopToRom]);
    SetLength(InArgs, InArgCounts[nopToRom]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopToRom, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.NumberToRomanN(FValue);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := String(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopToRom, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.TryRomanToNumber(S: String; out N: TValue): OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
  TrimmedS: String;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopFromRom]);
    SetLength(InArgs, InArgCounts[nopFromRom]);
    //Do not store prefixes in cahcheresults!!
    IsBinString(S, TrimmedS);
    InArgs[0] := TValue(TrimmedS);
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopFromRom, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := ValueToOPBool(OutArgs[0]);
      N := OutArgs[1];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.TryRomanToNumber(S, N, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      OutArgs[1] := N;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopFromRom, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.RomanToNumber(S: String): TValue;
begin
  if IsFalse(Self.TryRomanToNumber(S, Result)) then
    Raise EConvertError.CreateFmt(SIsNotARomNumber,[S]);
end;

function TNumber.NumberToOctN: String;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopToOct]);
    SetLength(InArgs, InArgCounts[nopToOct]);
    InArgs[0] := FValue;
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopToOct, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := OutArgs[0];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.NumberToOctN(FValue, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := String(Result);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopToOct, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.TryOctToNumber(S: String; out N: TValue): OPBool;
var
  InArgs, OutArgs: TArgsArray;
  GotCachedValue: OPBool;
  CacheIndex: Integer;
  TrimmedS: String;
begin
  GotCachedValue := ToBool(False);
  try
    SetLength(OutArgs, OutArgCounts[nopFromOct]);
    SetLength(InArgs, InArgCounts[nopFromOct]);
    //Do not store prefixes in cahcheresults!!
    IsBinString(S, TrimmedS);
    InArgs[0] := TValue(TrimmedS);
    if IsTrue(FUseCache) and IsTrue(FCache.IsCachedOperation(Self, nopFromOct, InArgs, CacheIndex)) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Getting result from cache');
      GotCachedValue := FCache.GetCachedOperation(Self, CacheIndex, OutArgs);
      Result := ValueToOPBool(OutArgs[0]);
      N := OutArgs[1];
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
    end;
    if IsFalse(GotCachedValue) then
    begin
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Cannot get result from cache');
      Result := NCalc.TryOctToNumber(S, N, @FCalcCallBack);
      if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Result = ',Result);
      OutArgs[0] := OpBoolToValue(Result);
      OutArgs[1] := N;
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Adding this operation to cache');
      if IsTrue(FUseCache) and (IsFalse(CacheIsLocked) or IsTrue(CanUnlockCache)) then
        FCache.AddPerformedOperation(Self, nopFromOct, InArgs, OutArgs);
      //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('After adding to cache');
    end;
  finally
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing InArgs');
    SetLength(InArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Clearing OutArgs');
    SetLength(OutArgs, 0);
    //if IsTrue(DebugBigNumbers) and IsTrue(IsConsole) then writeln('Done clearing Args');
  end;
end;

function TNumber.OctToNumber(S: String): TValue;
begin
  if IsFalse(Self.TryOctToNumber(S, Result)) then
    Raise EConvertError.CreateFmt(SIsNotAOctNumber,[S]);
end;


function TNumber.LockCache: OPBool;
begin
  Result := IsTrue(FCache.TryLockCache(Self));
end;

function TNumber.UnlockCache: OPBool;
begin
  Result := IsTrue(FCache.TryUnLockCache(Self));
end;

function TNumber.ForceUnlockCache: OPBool;
begin
  Result := IsTrue(FCache.ForceUnlockCache);
end;

Initialization
  __GlobalOperationsCache := nil;
  DebugBigNumbers := ToBool(False);

Finalization
  if Assigned(__GlobalOperationsCache) then
    FreeAndNil(__GlobalOperationsCache);


end.

