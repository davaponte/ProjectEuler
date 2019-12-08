#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  Math;

function  Check(n: integer): integer;
var
  Prev: array of integer;
  Idx: integer;
  Sum: integer;

  procedure ExpandPrev;
  begin
    if (Idx <= Length(Prev)) then
      SetLength(Prev, Length(Prev) +  1000);
  end;

  function CalcSum(N: integer): integer;
  var
    c, d: integer;
  begin
    // WriteLn('N: ', N);
    Result := 0;
    for c := 1 to Trunc(Log10(N) + 1) do begin
      d := (N div 10 ** (c - 1)) mod 10;
      // WriteLn(d : 3, d ** 2 : 4);
      Inc(Result, d ** 2);
    end;
    // WriteLn(Result);
    // WriteLn;
  end;

  function InPrev(n: integer): boolean;
  var
    d: integer;
  begin
    for d in Prev do begin
      if (d = 0) then
        Break;
      if (n = d) then begin
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;

begin
  Idx := 0;
  ExpandPrev;
  Prev[Idx] := n;
  Inc(Idx);
  repeat
    Sum := CalcSum(n);
    if (Sum = 1) then begin
      Result := 1;
      Exit;
    end;
    if (Sum = 89) then begin
      Result := 89;
      Exit;
    end;
    if InPrev(Sum) then begin
      Result := 0;
      Exit;
    end;
    ExpandPrev;
    Prev[Idx] := Sum;
    Inc(Idx);
    n := Sum;
  until False;
end;

var
  n: integer;
  s: integer;
begin
  s := 0;
  for n := 10000000 downto 1 do begin
    if (Check(n) = 89) then
      Inc(s);
  end;
  WriteLn('ANSWER: ', s);
end.

// 8581146
// execution time : 36.877 s
