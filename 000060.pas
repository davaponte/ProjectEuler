#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  SysUtils, Math;

type
  integer = Int64;
const
  BigLimit = 1000000;
  Limit = 10000;
var
  c, x: integer;
  BigPrimes: bitpacked array[2..BigLimit] of boolean;
  Primes: array of integer;

  // HowMany := 17218919;
  // HowMuch := 1999317839;

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
  if (n < BigLimit) then
    Result := BigPrimes[n]
  else
    Result := IsPrime(n);
end;

function AreValid(a, b: integer): boolean;
begin
  Result := CheckPrime(AddPrimes(a, b)) and CheckPrime(AddPrimes(b, a));
end;

function Loop: string;
var
  p1, p2, p3, p4, p5: integer;
  q1, q2, q3, q4, q5: integer;
  r1, r2, r3, r4, r5: integer;
  Sum, Lowest: integer;

  function Response: string;
  begin
    Response := IntToStr(r1) + ', ' +
      IntToStr(r2) + ', ' + IntToStr(r3) + ', ' +
      IntToStr(r4) + ', ' + IntToStr(r5) + #13#10 +
      'ANSWER: ' + IntToStr(Sum);
  end;

  function Max(A: array of integer): integer;
  var
    c, M: integer;
  begin
    M := 0;
    for c := 0 to High(A) do
      if (A[c] > M) then
        M := A[c];
    Result := M;
  end;

  function Min(A: array of integer): integer;
  var
    c, M: integer;
  begin
    M := MaxInt;
    for c := 0 to High(A) do begin
      Write(A[c]: 6);
      if (A[c] < M) then
        M := A[c];
    end;
    WriteLn(' MIN: ', M);
    Result := M;
  end;

begin
  Result := '';
  Lowest := MaxInt;
  for p1 := 0 to Length(Primes) - 5 do begin
    q1 := Primes[p1];
    if (Lowest < MaxInt) and (5 * q1 > Lowest) then begin
      // WriteLn('skip 1');
      Break;
    end;
    for p2 := p1 + 1 to Length(Primes) - 4 do begin
      q2 := Primes[p2];
      if (Lowest < MaxInt) and (q1 + 4 * q2 > Lowest) then begin
        // WriteLn('skip 2');
        Break;
      end;
      if not AreValid(q1, q2) then Continue;
      for p3 := p2 + 1 to Length(Primes) - 3 do begin
        q3 := Primes[p3];
        if not AreValid(q1, q3) or not AreValid(q2, q3) then Continue;
        if (Lowest < MaxInt) and (q1 + q2 + 3 * q3 > Lowest) then begin
          // WriteLn('skip 3');
          Break;
        end;
        for p4 := p3 + 1 to Length(Primes) - 2 do begin
          q4 := Primes[p4];
          if not AreValid(q1, q4) or not AreValid(q2, q4) or not AreValid(q3, q4) then Continue;
          if (Lowest < MaxInt) and (q1 + q2 + q3 + 2 * q4 > Lowest) then begin
            // WriteLn('skip 4');
            Break;
          end;
          for p5 := p4 + 1 to Length(Primes) - 1 do begin
            q5 := Primes[p5];
            if (Lowest < MaxInt) and (q1 + q2 + q3 + q4 + q5 > Lowest) then begin
              // WriteLn('skip 5');
              Break;
            end;
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
              Result := Response;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure CreateBigPrimes;
var
  x: integer;
begin
  Write('Creating Big List of Primes...');
  for x := Low(BigPrimes) to High(BigPrimes) do
    BigPrimes[x] := IsPrime(x);
  WriteLn('[DONE] ', Length(BIgPrimes), ' slots created.');
end;

procedure FindValidPrimes;
var
  c, x: integer;
begin
  Write('Finding Valid Primes...');
  x := 0;
  c := 3; // Evita el 2
  repeat
    if (c <> 5) and CheckPrime(c) then begin // y el 5
      Inc(x);
      if (x > Length(Primes)) then
        SetLength(Primes, Length(Primes) + 256);
      Primes[x - 1] := c;
    end;
    Inc(c);
  until (c > Limit);
  SetLength(Primes, x);
  WriteLn('[DONE] ', Length(Primes), ' primes found.');
end;

type
  TPair = record
    a, b: integer;
  end;
var
  Pairs: array of TPair;

procedure FindPairs;
var
  c, d, x: integer;
begin
  Write('Finding Pairs...');
  x := 0;
  for c := 0 to Length(Primes) - 2 do
    for d := c + 1 to Length(Primes) - 1 do
      if AreValid(Primes[c], Primes[d]) then begin
        Inc(x);
        if (x > Length(Pairs)) then
          SetLength(Pairs, Length(Pairs) + 128);
        Pairs[x - 1].a := Primes[c];
        Pairs[x - 1].b := Primes[d];
      end;
  SetLength(Pairs, x);
  WriteLn('[DONE] ', Length(Pairs), ' pairs found.');
end;

begin
  CreateBigPrimes;
  FindValidPrimes;
  WriteLn(Loop);
end.
