#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}
uses
  SysUtils;

var
  j, n: integer;
  S: string;
  p: Extended;

function Power(a: Extended; b: integer): Extended;
var
  k: integer;
begin
  Result := 1;
  for k := 1 to b do begin
    Result := Result * a;
    if Result > 1e4000 then
      Result := Result / 1e3980;
  end;
end;

function Mult(a, b: Extended): Extended;
begin
  Result := a * b;
  if Result > 1e4000 then
    Result := Result / 1e3980;
end;

begin
  j := 45; // 821;// 2416; //45;    // El valor conocido
  Dec(j);     // Uno menos para que encuentre justo ése
  n := 12710; // 233100;// 686500; //12710; // Este normal porque es el que va a encontrar en la primera iterarción, pero...
  p := Power(2, n - 1);
  repeat
    p := Mult(p, 2);
    S := FloatToStr(p);
    Delete(S, Pos('.', S), 1);
    if (Copy(S, 1, 3) = '123') then begin
      Inc(j);
      if (n mod 25000 = 0) then
         WriteLn('j: ', j, ' | n: ', n);
      if (j = 678910) then begin
        WriteLn('ANSWER: ', n);
        Break;
      end;
    end;
    Inc(n);
  until False;
end.
