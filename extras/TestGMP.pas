#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}

uses
  gmp;

var
  A, B, C: mpz_t; // multi precision (big) integers
  Pie: mpz_t;
  St: array[0..5192] of char;
begin
  mpz_init(A); //mpz_add(A, 2);
  mpz_init(B);
  mpz_init(C);
  mpz_init_set_str(Pie, '3141592653589793238462643383279502884', 10);

  // mpz_init_set_ui(A, 2);
  // mpz_init_set_ui(B, 80);
  // mpz_init_set_ui(C, 0);
  try
    // mpz_powm(A, A, B, C);
    mp_printf('%d'#10, Pie);
    mp_printf('%d %d %d'#10, C, A, B);
    mpz_pow_ui(C, A, 80);

    //A := A * B;
    mp_printf('%d %d %d'#10, C, A, B);
  finally
    mpz_clear(A);          // Release the mem owned by A and B
    mpz_clear(B);
  end;
end.
