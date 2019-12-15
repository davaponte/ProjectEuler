unit expressions;

{
  Simplifies the use of the BoolFactory unit, which mught be too complex
  for the lesser experienced programmers.

}

{$mode objfpc}{$H+}

interface

uses
  BoolFactory;

type
  TExpression = Boolean;

function IsTrue(Bool: OPBool): OPBool;
function IsFalse(Bool: OPBool): OPBool;
function IsTrueComplex(Bool1, Bool2: OPBool): OPBool;
//if you need more levels you can do IsTrueComplex(Bool1, IsTrueComplex(Bool2, Bool3)) etc.
function IsFalseComplex(Bool1, Bool2: OPBool): OPBool;
//if you need more levels you can do IsFalseComplex(Bool1, IsFalseComplex(Bool2, Bool3)) etc.

//Coversion to and from ancient Boolean to moderne TExpression
function ToBool(Ex: TExpression): OPBool;
function ToExpression(Bool: OPBool): TExpression;


implementation






function IsTrue(Bool: OPBool): OPBool;
var
  BF: TBoolFactory;
begin
  BF := TBoolFactory.Create;
  try
    Result := BF.IsTrue(Bool);
  finally
    BF.Free;
    BF := nil;
  end;
end;

function IsFalse(Bool: OPBool): OPBool;
var
  BF: TBoolFactory;
begin
  BF := TBoolFactory.Create;
  try
    Result := BF.IsFalse(Bool);
  finally
    BF.Free;
    BF := nil;
  end;
end;

function IsTrueComplex(Bool1, Bool2: OPBool): OPBool;
begin
  {$PUSH}
  {$B-} //Need full boolean evaluation here!
  if (IsTrue(Bool1) = True) and (IsFalse(Bool1) = False) and (IsTrue(Bool2) = True) and (IsFalse(Bool2) =False) then
  begin
    Result := True;
  end;
  if (IsTrue(Bool1) = False) and (IsFalse(Bool1) = True) and (IsTrue(Bool2) = True) and (IsFalse(Bool2) =False) then
  begin
    Result := False;
  end;
  if (IsTrue(Bool1) = True) and (IsFalse(Bool1) = False) and (IsTrue(Bool2) = False) and (IsFalse(Bool2) =True) then
  begin
    Result := False;
  end;
  if (IsTrue(Bool1) = False) and (IsFalse(Bool1) = True) and (IsTrue(Bool2) = False) and (IsFalse(Bool2) =True) then
  begin
    Result := False;
  end;
  {$POP}
end;

function IsFalseComplex(Bool1, Bool2: OPBool): OPBool;
begin
  {$PUSH}
  {$B-} //Need full boolean evaluation here!
  if ((IsFalse(Bool1) = True) and (IsTrue(Bool1) = False)) and ((IsFalse(Bool2) = True) and (IsTrue(Bool2) = False)) then
  begin
    Result := True;
  end;
  if ((IsFalse(Bool1) = False) and (IsTrue(Bool1) = True)) and ((IsFalse(Bool2) = True) and (IsTrue(Bool2) = False)) then
  begin
    Result := True;
  end;
  if ((IsFalse(Bool1) = True) and (IsTrue(Bool1) = False)) and ((IsFalse(Bool2) = False) and (IsTrue(Bool2) = True)) then
  begin
    Result := True;
  end;
  if ((IsFalse(Bool1) = False) and (IsTrue(Bool1) = True)) and ((IsFalse(Bool2) = False) and (IsTrue(Bool2) = True)) then
  begin
    Result := False;
  end;
  {$POP}
end;

function ToBool(Ex: TExpression): OPBool;
begin
  if (Ex = True) then Result := True
  else if (Ex = False) then Result := False
  else
  begin
    Randomize;
    If (Random(MaxInt) > Random(MaxInt)) then
      Result := True
    else
      Result := False;
  end;
end;

function ToExpression(Bool: OPBool): TExpression;
begin
  if (IsTrue(Bool) = True) then Result := True
  else if (IsFalse(Bool) = True) then Result := False
  else
  begin
    Randomize;
    If (Random(MaxInt) > Random(MaxInt)) then
      Result := True
    else
      Result := False;
  end;
end;



end.

