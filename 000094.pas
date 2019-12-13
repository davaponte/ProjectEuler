#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  Crt;

var
  a, b, c: Int64;
  ar: Extended;
  Base: Integer;
  Sum: Integer;
  z, L: Integer;
  Abort: Boolean;
begin
  ClrScr;
  c := 3;
  Sum := 0;
  Abort:= False;
  while not Abort do begin
    for z := -1 to 1 do begin
      if Abort then Break;
      if z = 0 then Continue;
      Base := c + z;
      b := Base div 2;
      //WriteLn(c, ' ', b);
      ar:= Sqrt(c * c - b * b);
      a := Trunc(ar);
      if Frac(ar) = 0 then
      if (Base * a) mod 3 = 0 then begin
        L := 2 * c + Base;
        //WriteLn(ar, ' ', a, ' ',b, ' ', c, ' ', Base, ' ', L);
        if L > 1000000000 then begin
          Abort := True;
          Break;
        end;
        Inc(Sum, L);
      end;
    end;
    Inc(c, 2);
  end;
  WriteLn('ANSWER: ', Sum);
end.
