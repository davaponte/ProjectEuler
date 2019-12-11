#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  Num = '1_2_3_4_5_6_7_8_9_0';
// # 1929394959697989990
// # 1020304050607080900
  Max = 1389026624; //# 1389026623.1062636
  Min = 1010101010; //# 1010101010.1010101

var
  n, x: Int64;
  Sqr: Int64;
  s: string;

begin
  for n := Min to Max do begin
      Sqr := n * n;
      s := IntToStr(Sqr);
      for x := 1 to 9 do
        s[2 * x] := '_';
      // WriteLn(s);
      if (s = Num) then begin
        WriteLn('ANSWER: ', n);
        Halt;
      end;
  end;
end.
