#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

var
  F: array[0..9] of integer;

procedure FillFactorial;
var
  c: integer;
begin
  F[0] := 1;
  for c := Low(F) + 1 to High(F) do
    F[c] := F[c - 1] * c;
end;

function Sum(N: integer): integer;
begin
  Result := 0;
  while (N > 0) do begin
    Result := Result + N mod 10;
    N := N div 10;
  end;
end;

function SumFact(N: integer): integer;
begin
  Result := 0;
  while (N > 0) do begin
    Result := Result + F[N mod 10];
    N := N div 10;
  end;
end;

function Iterate(N: integer): boolean;
var
  List: array[1..60] of integer;
  Chains: integer;
  c: integer;
begin
  Result := False;
  Chains := 0;
  FillChar(List, SizeOf(List), 0);
  repeat
    for c := 1 to Chains do
      if (List[c] = N) then begin
        Result := Chains = 60;
        Exit;
      end;
    Inc(Chains);
    List[Chains] := N;
    N := SumFact(N);
  until (False);
end;

var
  n: integer;
  s: integer;
begin
  FillFactorial;

  // WriteLn(Iterate(169));
  // WriteLn(Iterate(69));
  // WriteLn(Iterate(78));
  // WriteLn(Iterate(540));

  for n := 70 to 999999 do
    if Iterate(n) then Inc(s);

  WriteLn('ANSWER: ', s);
end.
