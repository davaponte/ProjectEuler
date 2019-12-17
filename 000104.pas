#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  a, b, h: extended;
  i: integer;
  ai, bi, hi: int64;
  s: string;

function IsPanDigital(s: string): boolean;
var
  i, k: integer;
begin
  Result := True;
  if Pos('0', s) > 0 then
    Result := False
  else
    for i := 1 to 9 do  begin
      k := Pos(Char(i + 48), s);
      if k = 0 then begin
        Result := False;
        Exit;
      end;
      s[k] := '0';
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
    if b > 1e4000 then begin
      b := b / 1e3980;
      h := h / 1e3980;
    end;
    a := h;
    hi := bi;
    bi := ai + bi;
    bi := bi mod 1000000000;
    ai := hi;
    s := FloatToStr(b);
    Delete(s, Pos('.', s), 1);
    if IsPanDigital(Copy(s, 1, 9)) and IsPanDigital(Copy(IntToStr(bi), 1, 9)) then begin
      WriteLn(IntToStr(i)); //  + ' * ' + FloatToStr(b));
      Exit;
    end;
  until False;
end.
