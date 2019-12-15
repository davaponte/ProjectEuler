{%MainUnit ncalc.pp}

{
  Copyright (C) 2013 by Flying Sheep Inc. and Bart Broersma

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}


function DivNBruteForce(N1, N2: TPositiveValue; out Rest: TPositiveValue): TPositiveValue;
begin
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivNBruteForce: N1=',N1,' N2=',N2);
  AssertIsPositiveN(N1);
  AssertIsPositiveN(N2);
  if IsTrue(IsZeroN(N2)) then RaiseEDivByZero;
  Result := Prime_Zero;
  Rest := Prime_Zero;
  if IsTrue(EqualsN(N1,N2)) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivNBruteForce: N1 = N2');
    IncPrimitive(Result[1]);
    Exit;
  end;
  if IsTrue(MaxN(N1, N2) = N2) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivNBruteForce: N1 < N2');
    Rest := N1;
    Exit;
  end;
  N1 := NormalizeNumberN(N1);
  //ShortCut
  if IsTrue(EqualsN(N2, '1')) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivNBruteForce: Shortcut (N2=1): Result = ',N1,' RRest = ',Rest);
    Result := N1;
    Exit;
  end;
  //At this point N1 > N2
  While IsFalse(IsNegativeN(N1)) do
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('DivNBruteForce: Result = ',Result,' N1 = ',N1,' -> ');
    N1 := SubN(N1, N2);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N1);
    if IsFalse(IsNegativeN(N1)) then
    begin
      Rest := N1;
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('Rest > 0 [',Rest,'] Result = ',Result,' -> ');
      Result := AddN(Result, '1');
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(Result);
    end;
  end;
end;


function DivModN(N1, N2: TValue; out AMod: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
var
  Temp: TPositiveValue;
  Len: Integer;
  {%H-}_N1: TPositiveValue;
begin
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: N1=',N1,' N2=',N2);
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  if IsTrue(IsZeroN(N2)) then RaiseEDivByZero;
  if IsTrueComplex(IsTrue(IsNegativeN(N1)), IsTrue(IsNegativeN(N2))) then
  begin
    // -x div -y = (x div y)
    Result := DivModN(MakeNegativeN(N1), MakeNegativeN(N2), AMod);
    AMod := MakeNegativeN(AMod);
    Exit;
  end;
  if IsTrue(IsNegativeN(N1)) and IsFalse(IsNegativeN(N2)) then
  begin
    // -x * y = -(x div y)
    Result := MakeNegativeN(DivModN(MakeNegativeN(N1), N2, AMod));
    AMod := MakeNegativeN(AMod);
    Exit;
  end;
  if IsFalse(IsNegativeN(N1)) and IsTrue(IsNegativeN(N2)) then
  begin
    // x * -y = -(x div y)
    Result := MakeNegativeN(DivModN(N1, MakeNegativeN(N2), AMod));
    Exit;
  end;
  Result := Prime_Zero;
  AMod := Prime_Zero;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: check Equals(',N1,',',N2,')');
  N1 := NormalizeNumberN(N1);
  N2 := NormalizeNumberN(N2);
  if IsTrue(EqualsN(N2,'1')) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: Shortcut (N2=1): Result = ',N1,' AMod = ',Amod);
    Result := N1;
    Exit;
  end;
  if IsTrue(EqualsN(N1,N2)) then
  begin
    IncPrimitive(Result[1]);
    Exit;
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: Check ',N1,' < ',N2);
  if IsTrue(MaxN(N1, N2) = N2) then
  begin
    // N1 < N2
    AMod := N1;
    Exit;
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Result = ',N1,' div ',N2,' = ',StrToInt64(N1) div StrToInt64(N2));
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: After all initial checks: N1="',N1,'" N2="',N2,'"');
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: After all Normalize: N1="',N1,'" N2="',N2,'"');
  Len := Length(N2);
  _N1 := N1;
  if IsTrue(Len > 1) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: Len > 1 [',Len,']');
    Temp := System.Copy(N1, 1, Len - 1);
    System.Delete(N1, 1, Len - 1);
  end
  else
    Temp := Prime_Zero;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: Before repeat: N1 = ',N1,' Temp = ',Temp);
  repeat
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('DivModN: Temp = ',Temp,' -> ');
    if IsTrue(IsZeroN(Temp)) then
      Temp := N1[1]
    else
      Temp := Temp + N1[1];
    System.Delete(N1, 1, 1);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(Temp,' N1 = ',N1);
    if IsTrue(IsZeroN(Result)) then
      Result := DivNBruteForce(Temp, N2, AMod)
    else
      Result := Result + DivNBruteForce(Temp, N2, AMod);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('DivModN: Result = ',Result,' Rest = ',AMod);
    Temp := AMod;
    if Assigned(CallBack) then CallBack(Format('DivModN: Intermediate Result = %s with AMod = %s',[Result, AMod]), True);
  until IsTrue(Length(N1) = 0);

  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Result = ',Result,' [',strtoint64(_N1) div strtoint64(N2),']');

end;

function DivN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
{$PUSH}
{$HINTS OFF}
var
  AMod: TValue;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  if IsTrue(IsZeroN(N2)) then RaiseEDivByZero;
  Result := DivModN(N1, N2, AMod, CallBack);
{$POP}
end;

function ModN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
{$PUSH}
{$HINTS OFF}
var
  {%H-}ADiv: TValue;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  if IsTrue(IsZeroN(N2)) then RaiseEDivByZero;
  ADiv := DivModN(N1, N2, Result, CallBack);
{$POP}
end;

function TrySmallSqrtLookup(N: TValue; out Res: TValue): OPBool;
begin
  AssertIsPositiveN(N);
  N := NormalizeNumberN(N);
  case N of
    '1': Res := '1';
    '4': Res := '2';
    '9': Res := '3';
    '16': Res := '4';
    '25': Res := '5';
    '36': Res := '6';
    '49': Res := '7';
    '64': Res := '8';
    '81': Res := '9';
    '100': Res := '10';
    '121': Res := '11';
    '144': Res := '12';
    '169': Res := '13';
    '196': Res := '14';
    '225': Res := '15';
    '256': Res := '16';
    '289': Res := '17';
    '324': Res := '18';
    '361': Res := '19';
    '400': Res := '20';
    '441': Res := '21';
    '484': Res := '22';
    '529': Res := '23';
    '576': Res := '24';
    '625': Res := '25';
    '676': Res := '26';
    '729': Res := '27';
    '784': Res := '28';
    '841': Res := '29';
    '900': Res := '30';
    '961': Res := '31';
    '1024': Res := '32';
    else Res := Prime_Zero;
  end;
  Result := IsFalse(IsZeroN(Res));
end;

//This function returns the square root of N, but only if the result
//is indeed a natural number:
// e.g. SqrtN('4') -> '2'
//      SqrtN('625') -> '25'
//      SqrtN('10') -> exception
function SqrtN(N: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
var
  Divisor, Res, AMod: TValue;
  i: Integer;
  Stop: OPBool;
begin
  AssertIsPositiveN(N);
  if IsTrue(IsZeroN(N)) then
  begin
    Result := Prime_Zero;
    Exit;
  end;
  N := NormalizeNumberN(N);
  if IsFalse(MoreN(N, '1024')) then
  begin
    if IsFalse(TrySmallSqrtLookup(N, Res)) then
      Raise ENumber.CreateFmt(SIsNotSquare, [N]);
    Result := Res;
    Exit;
  end;
  Divisor := '';
  for i := 1 to (Length(N) div 2) do Divisor := Divisor + '5';
  repeat
    Res := DivModN(N, Divisor, AMod);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SqrtN: Divisor = ',Divisor,' Res = ',Res,' AMod = ',AMod);
    if Assigned(CallBack) then CallBack('SqrtN: Intermediate result = ' + Divisor, ToBool(True));
    Stop := IsTrue(IsZeroN(AMod)) or IsTrue(EqualsN(Res, Divisor)) or IsTrue(EqualsN(AbsN(SubN(Res, Divisor)),'1'));
    if IsFalse(Stop) then
      Divisor := DivN( AddN(Res, Divisor)  , '2');
  until Stop;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SqrtN: after repeat loop: Divisor = ',Divisor);
  if IsFalse(IsZeroN(AMod)) then
    Raise ENumber.CreateFmt(SIsNotSquare, [N]);
  Result := Divisor;
end;

//keep at end of include file to fool codetools
procedure divfoolct;
begin
end;
