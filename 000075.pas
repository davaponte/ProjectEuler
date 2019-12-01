#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

function FindWays(L: integer): integer;
var
  Ways: integer;
  a, b: integer;
  c:    Extended;
begin
  // WriteLn('LEN: ', L);
  Result := 0;
  Ways := 0;
  for a := Round(Sqrt(L)) to L div 2 do
    for b := a to L div 2 do begin
      c := Sqrt(a * a + b * b);
      if (a + b + c = L) then begin
        // WriteLn(a, ' ', b, ' ', c, ' ', L);
        Inc(Ways);
        if (Ways > 1) then
          Exit;

      end;
    end;
  Result := Ways;
end;

var
  Acum, L: integer;
begin
  for L := 12 to 15000 do
    Acum := Acum + FindWays(L);
  WriteLn(Acum);
end.
