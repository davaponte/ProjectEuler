#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  gmp;

var
  A, B, C: mpz_t; // multi precision (big) integers
  p, _2: mpz_t;
  n, j: integer;
  S: array[0..500000] of char;
begin
  // j: 45 | n: 12710 | len: 3827
  // p(123, 45) = 12710

  // j: 821 | n: 233100 | len: 70171
  // j: 902 | n: 256400 | len: 77185
  // j: 1090 | n: 309800 | len: 93260
  // j: 1173 | n: 333100 | len: 100274
  // j: 1254 | n: 356400 | len: 107288
  // j: 1359 | n: 386500 | len: 116349
  // j: 1441 | n: 409800 | len: 123363
  // j: 1523 | n: 433100 | len: 130377
  // j: 1605 | n: 456400 | len: 137391
  // j: 1711 | n: 486500 | len: 146452
  // j: 1793 | n: 509800 | len: 153466
  // j: 1875 | n: 533100 | len: 160480
  // j: 2064 | n: 586500 | len: 176555
  // j: 2144 | n: 609800 | len: 183569
  // j: 2227 | n: 633100 | len: 190583
  // j: 2332 | n: 663200 | len: 199644
  // j: 2416 | n: 686500 | len: 206658
  // j: 2495 | n: 709800 | len: 213672
  // j: 2683 | n: 763200 | len: 229747
  // j: 2766 | n: 786500 | len: 236761



  j := 2416; //45;    // El valor conocido
  Dec(j);     // Uno menos para que encuentre justo ése
  n := 686500; //12710; // Este normal porque es el que va a encontrar en la primera iterarción, pero...
  mpz_init(p);
  mpz_init_set_ui(_2, 2);
  mpz_pow_ui(p, _2, n - 1); // ...le quitamos 1 para que coincida con la j
  repeat
    mpz_mul(p, p, _2);
    mpz_get_str(S, 10, p);
    // WriteLn(S);
    if (S[0] = '1') and (S[1] = '2') and (S[2] = '3') then begin
      Inc(j);
      if (n mod 100 = 0) then
         WriteLn('j: ', j, ' | n: ', n, ' | len: ', strlen(S));

      // WriteLn(i);
      if (j = 678910) then begin
        WriteLn('ANSWER: ', n);
        Break;
      end;
    end;
    Inc(n);
  until False;
end.
