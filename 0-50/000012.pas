#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

//ANSWER:      12375  76576500       576

function CountDividers(n: int64): int64;
var
  c: int64;
begin
  Result := 2;
  for c := 2 to Round(Sqrt(n)) do //n div 2 do
    if (n mod c = 0) then
      Result := Result + 1;
end;

var
  Limit:   int64;
  n, k, d: int64;
begin
  Limit := 10;
  k := 1;
  n := 0;
  while True {(k <= Limit)} do begin
    n := n + k;
    d := CountDividers(n) * 2;
    if (d > 500) then begin
      WriteLn('ANSWER: ', k : 10, n : 10, d : 10);
      Break;
    end;
    if (k mod 500 = 0) then
      WriteLn(k : 10, n : 10, d : 10);
    k := k + 1;
  end;
end.
