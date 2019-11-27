#!/usr/bin/env instantfpc


{$mode objfpc}
{$APPTYPE CONSOLE}
//1 2  3  4   5   6    7     8     9     10     11      12       13       14        15        16         17         18          19           20
//2 6 20 70 252 924 3432 12870 48620 184756 705432 2704156 10400600 40116600 155117520 601080390 2333606220 9075135300 35345263800 137846528820

uses 
  Crt, SysUtils, DateUtils;

const
  MaxRC = 20;

type
  Range = 0..MaxRC;
  
var
  Matrix: array[Range, Range] of byte;
  NumRoutes: int64 = 0;
  StartTime: TDateTime;
  NewTime:   TDateTime;
  LastRoutesFound: int64 = 0;
  Deltams: int64 = 15000;
  
procedure PrintMatrix;
var
  Row, Col: integer;
begin
  for Row := 0 to MaxRC do begin 
    for Col := 0 to MaxRC do
      Write(Matrix[Row][Col] : 3);
    WriteLn;
  end;
  WriteLn('# routes: ', NumRoutes);
  WriteLn;
end; 

procedure FillMatrix(Value: integer);
var
  Row, Col: integer;
begin
  if (Value <> -1) then 
    FillChar(Matrix, SizeOf(Matrix), Value)
  else
    for Row := 0 to MaxRC do 
      for Col := 0 to MaxRC do
        Matrix[Row][Col] := Col + Row * (High(Matrix[Row]) + 1)
end; 
    
procedure Walk(r, c: integer);
var
  Diff, DiffRoutes: int64;
begin 
  if (r < 0) or (r > MaxRC) then Exit;
  if (c < 0) or (c > MaxRC) then Exit;
  if (Matrix[r, c] = 1) then Exit;
  Matrix[r, c] := 1;
 
  if (r = MaxRC) and (c = MaxRC) then begin
(*
    NewTime := Now;
    Diff := MilliSecondsBetween(NewTime, StartTime);
    if (Diff > Deltams) then begin
      PrintMatrix;
      StartTime := NewTime;
      DiffRoutes := NumRoutes - LastRoutesFound;
      WriteLn(DiffRoutes, ' routes found in ', Diff, 'ms');
      WriteLn(DiffRoutes / Diff / 1000 : 2 : 2, ' millions of routes per second');
      LastRoutesFound := NumRoutes;
      if (KeyPressed and (ReadKey = #27)) then begin
        WriteLn('ABORTED!');
        WriteLn('Routes found: ', NumRoutes);
        Halt;
      end;
    end;
*)
    Inc(NumRoutes);
    Matrix[r, c] := 0;
    Exit;
  end;
  Walk(r, c + 1);
  Walk(r + 1, c);
  Matrix[r, c] := 0;
end; 
  
begin
  FillMatrix(0);
  WriteLn('We will report every ', Deltams div 1000, ' seconds');
  WriteLn('Keep pressed ESCAPE to abort');
  StartTime := Now;
  Walk(0, 0);
  WriteLn('Maxtrx: ', MaxRC, 'x', MaxRC, ' - Total routes: ', NumRoutes);
end.
