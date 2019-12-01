#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

function IsPrime(n: integer): boolean;
var
  c : integer;
begin
  for c := 2 to Round(Sqrt(n)) do begin
    if (n mod c = 0) and (n <> c) then begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;


var
  Limit: integer;
  n:     integer;
  s:     int64;
begin
  Limit := 2000000;
  n := 2;
  s := 0;
  while (n <= Limit) do begin
    if IsPrime(n) then
      s := s + n;
    Inc(n);
  end;
  WriteLn(s);
end.
