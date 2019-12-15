#!/usr/bin/env instantfpc

{$mode objfpc}{$H+}
{$APPTYPE CONSOLE}


uses
  gnurz_asm;

var
  GnurzObjekt: TGnurz;
  n, p, _1, _2: GNZTyp;
  i: integer;

function Add(a, b: GNZTyp): GNZTyp;
begin
  Result := GnurzObjekt.GNZadd(a, b);
end;

function Sub(a, b: GNZTyp): GNZTyp;
begin
  Result := GnurzObjekt.GNZSub(a, b);
end;

function Mul(a, b: GNZTyp): GNZTyp;
begin
  Result := GnurzObjekt.GNZmul(a, b);
end;

function Pow(a, b: GNZTyp): GNZTyp;
begin
  Result := GnurzObjekt.GNZPotenz(a, b);
end;

begin
  GnurzObjekt := TGnurz.Create;
  n := GnurzObjekt.WordToGNZTyp(12710);
  i := 44;
  _1 := GnurzObjekt.WordToGNZTyp(1);
  _2 := GnurzObjekt.WordToGNZTyp(2);
  p := Pow(_2, Sub(n, _1));
  WriteLn(GnurzObjekt.GNZTypToStr(p));
{
  repeat
    p := Mul(_2, p);
    if (Copy(GnurzObjekt.GNZTypToStr(p), 1, 3) = '123') then begin
      Inc(i);
      WriteLn(i);
      if (i = 678910) then begin
        WriteLn('ANSWER: ', GnurzObjekt.GNZTypToStr(n));
        Break;
      end;

    end;
    n := Add(n, _1);
  until False;
}
  GnurzObjekt.Free;
end.
