#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

var
  Tope : byte = 200;
  Ways : integer = 0;
  p1, p2, p5, p10, p20, p50, p100, p200 : integer;
  Suma : integer;
  
begin
  for p1 := 0 to Tope do 
    for p2 := 0 to Tope div 2 do 
      for p5 := 0 to Tope div 5 do 
        for p10 := 0 to Tope div 10 do 
          for p20 := 0 to Tope div 20 do 
            for p50 := 0 to Tope div 50 do 
              for p100 := 0 to Tope div 100 do 
                for p200 := 0 to Tope div 200 do begin
                  Suma := p1 + p2 * 2 + p5 * 5 + p10 * 10 + p20 * 20 + p50 * 50 + p100 * 100 + p200 * 200;
                  if (Suma = 200) then Inc(Ways);
                end;
  WriteLn('ANSWER: ', Ways);
end.
