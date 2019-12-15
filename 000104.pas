#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  a, b, h: extended;
  p, i: integer;
  ai, bi, hi: int64;
  s: string;
  r: boolean;

function is_pandigital(s: string): boolean;
var
  i,k: integer;
begin
  is_pandigital := True;
  if length(s) <> 9 then
    is_pandigital := False
  else
    if Pos('0', s) > 0 then
      is_pandigital := False
    else begin
      for i := 1 to 9 do  begin
         k := pos(inttostr(i), s);
         if k = 0 then
           is_pandigital := False;
         delete(s, k, 1);
      end;
      if s <> '' then
        is_pandigital := False;
    end;
end;

begin
  i := 2;
  ai := 1;
  bi := 1;
  a := 1;
  b := 1;
  repeat
    Inc(i);
    h := b;
    b := a + b;
    if b > 1e500 then begin
      b := b / 1e480;
      h := h / 1e480;
    end;
    a := h;
    hi := bi;
    bi := ai + bi;
    bi := bi mod 1000000000;
    ai := hi;
    s := floattostr(b);
    p := pos('.', s);
    Delete(s, p, 1);
    s := Copy(s, 0, 9);
    r := is_pandigital(s) and is_pandigital(inttostr(bi));
    if r then
      WriteLn(inttostr(i) + ' * ' + floattostr(b));
  until r;
end.
