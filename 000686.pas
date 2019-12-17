#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}
uses
  SysUtils;

type
  Extended = Int64;

const  // 9223372036854775807
  Limit = 4000000000000000000;
var
  j, n: integer;
  S: string;
  p: Extended;

function Fix(n: Extended): Extended;
begin
  // if n > 1e400 then
  //   n := n / 1e380;
  if n > Limit then begin
    // WriteLn(n, ' ', n div (Limit div 10000));
    n := n div 100000;
  end;
  Result := n;
end;

function Power(a: Extended; b: integer): Extended;
var
  k: integer;
begin
  Result := b;
  for k := 2 to b do
    Result := Fix(Result * a);
end;

function Mult(a, b: Extended): Extended;
begin
  Result := Fix(a * b);
end;

function Get123(n: Extended): Extended;
begin
  while (n >= 1000) do begin
    n := n div 10;
  end;
  Result := n;
end;

begin
  j := 45; // 821;// 2416; //45;    // El valor conocido
  Dec(j);     // Uno menos para que encuentre justo ése
  n := 12710; // 233100;// 686500; //12710; // Este normal porque es el que va a encontrar en la primera iterarción, pero...
  p := Power(2, n - 1);
  // WriteLn(p);
  repeat
    p := Mult(p, 2);
    // S := FloatToStr(p);
    // Delete(S, Pos('.', S), 1);
    // S := IntToStr(p);
    // if (Copy(S, 1, 3) = '123') then begin
    if Get123(p) = 123 then begin
      Inc(j);
      // if (n mod 25000 = 0) then
      //    WriteLn('j: ', j, ' | n: ', n);
      if (j = 678910) then begin
        WriteLn('ANSWER: ', n);
        Break;
      end;
    end;
    Inc(n);
  until False;
end.
