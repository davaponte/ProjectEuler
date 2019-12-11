#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  integer = Int64;
const
  Limit = 20000;
var
  c, x: integer;
  Primes: array of integer;

function IsPrime(n: integer): boolean;
var
  x: integer;
  l: integer;
begin
  x := 2;
  l := Round(Sqrt(n)); // Límite
  Result := (n > 1); // Preset
  if (n = 2) then Exit; // Si es 2 sal. El preset está en True
  repeat // Itera y chequea...
    if (n mod x = 0) then begin // Si es divisible sal con False
      Result := False;
      Exit;
    end;
    if (x = 2) then
      Inc(x)     // La primera vez incrementa en 1...
    else
      Inc(x, 2); // ...luego ve de 2 en 2
  until (x > l); // Sal al explorar todos. El preset está en True
end;

function Len(N: integer): integer;
// Una función para obtener la longitud de un número (cuántos dígitos tiene)
// sin convertir a string y sin logarimos. Es MUY rápida.
begin
  Result := 0;
  repeat
    Inc(Result);
    N := N div 10;
  until (N = 0);
end;

function AddPrimes(a, b: integer): integer;
// 'Agrega' dos números sin usar strings
var
  c: integer;
begin
  for c := 1 to Len(b) do
    a := a * 10;
  Result := a + b;
end;

function CheckPrime(n: integer): boolean;
begin
  // if (n < Limit) then
  // else
  //   Result := n in Primes
    Result := IsPrime(n);
end;

function AreValid(a, b: integer): boolean;
begin
  Result := CheckPrime(AddPrimes(a, b)) and CheckPrime(AddPrimes(b, a));
end;

procedure Loop;
var
  p1, p2, p3, p4, p5: integer;
  q1, q2, q3, q4, q5: integer;
  r1, r2, r3, r4, r5: integer;
  Sum, Lowest: integer;
begin
  Lowest := MaxInt;
  for p1 := 0 to Length(Primes) - 5 do begin
    q1 := Primes[p1];
    if (q1 > Lowest) then Break;
    for p2 := p1 + 1 to Length(Primes) - 4 do begin
      q2 := Primes[p2];
      if (q1 + q2 > Lowest) then Break;
      if not AreValid(q1, q2) then Continue;
      for p3 := p2 + 1 to Length(Primes) - 3 do begin
        q3 := Primes[p3];
        if (q1 + q2 + q3 > Lowest) then Break;
        if not AreValid(q1, q3) or not AreValid(q2, q3) then Continue;
        for p4 := p3 + 1 to Length(Primes) - 2 do begin
          q4 := Primes[p4];
          if (q1 + q2 + q3 + q4 > Lowest) then Break;
          if not AreValid(q1, q4) or not AreValid(q2, q4) or not AreValid(q3, q4) then Continue;
          for p5 := p4 + 1 to Length(Primes) - 1 do begin
            q5 := Primes[p5];
            if (q1 + q2 + q3 + q4 + q5 > Lowest) then Break;
            if not AreValid(q1, q5) or not AreValid(q2, q5) or not AreValid(q3, q5) or not AreValid(q4, q5) then Continue;
            Sum := q1 + q2 + q3 + q4 + q5;
            WriteLn('Partial...');
            WriteLn(q1, ', ', q2, ', ', q3, ', ', q4, ', ', q5);
            WriteLn('SUM: ', Sum);
            if (Sum < Lowest) then begin
              Lowest := Sum;
              r1 := q1;
              r2 := q2;
              r3 := q3;
              r4 := q4;
              r5 := q5;
            end;
          end;
        end;
      end;
    end;
  end;
  WriteLn(r1, ', ', r2, ', ', r3, ', ', r4, ', ', r5);
  WriteLn('ANSWER: ', Sum);
end;

begin
  x := 0;
  c := 3;
  repeat
    if IsPrime(c) then begin
      Inc(x);
      if (x > Length(Primes)) then begin
        SetLength(Primes, Length(Primes) + 256);
      end;
      Primes[x - 1] := c;
    end;
    Inc(c);
  until (c > Limit);
  SetLength(Primes, x);

  Loop;
end.
