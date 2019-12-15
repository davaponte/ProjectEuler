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


Type
  TMulLookupTable = array[0..9,0..9] of TCalcRes;
var
  MulTable: TMulLookupTable;

const
  { 0 x 0 } Mul_0_0: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 1 } Mul_0_1: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 2 } Mul_0_2: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 3 } Mul_0_3: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 4 } Mul_0_4: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 5 } Mul_0_5: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 6 } Mul_0_6: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 7 } Mul_0_7: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 8 } Mul_0_8: TCalcRes = (Value: '0'; Carry: '0');
  { 0 x 9 } Mul_0_9: TCalcRes = (Value: '0'; Carry: '0');
  { 1 x 0 } Mul_1_0: TCalcRes = (Value: '0'; Carry: '0');
  { 1 x 1 } Mul_1_1: TCalcRes = (Value: '1'; Carry: '0');
  { 1 x 2 } Mul_1_2: TCalcRes = (Value: '2'; Carry: '0');
  { 1 x 3 } Mul_1_3: TCalcRes = (Value: '3'; Carry: '0');
  { 1 x 4 } Mul_1_4: TCalcRes = (Value: '4'; Carry: '0');
  { 1 x 5 } Mul_1_5: TCalcRes = (Value: '5'; Carry: '0');
  { 1 x 6 } Mul_1_6: TCalcRes = (Value: '6'; Carry: '0');
  { 1 x 7 } Mul_1_7: TCalcRes = (Value: '7'; Carry: '0');
  { 1 x 8 } Mul_1_8: TCalcRes = (Value: '8'; Carry: '0');
  { 1 x 9 } Mul_1_9: TCalcRes = (Value: '9'; Carry: '0');
  { 2 x 0 } Mul_2_0: TCalcRes = (Value: '0'; Carry: '0');
  { 2 x 1 } Mul_2_1: TCalcRes = (Value: '2'; Carry: '0');
  { 2 x 2 } Mul_2_2: TCalcRes = (Value: '4'; Carry: '0');
  { 2 x 3 } Mul_2_3: TCalcRes = (Value: '6'; Carry: '0');
  { 2 x 4 } Mul_2_4: TCalcRes = (Value: '8'; Carry: '0');
  { 2 x 5 } Mul_2_5: TCalcRes = (Value: '0'; Carry: '1');
  { 2 x 6 } Mul_2_6: TCalcRes = (Value: '2'; Carry: '1');
  { 2 x 7 } Mul_2_7: TCalcRes = (Value: '4'; Carry: '1');
  { 2 x 8 } Mul_2_8: TCalcRes = (Value: '6'; Carry: '1');
  { 2 x 9 } Mul_2_9: TCalcRes = (Value: '8'; Carry: '1');
  { 3 x 0 } Mul_3_0: TCalcRes = (Value: '0'; Carry: '0');
  { 3 x 1 } Mul_3_1: TCalcRes = (Value: '3'; Carry: '0');
  { 3 x 2 } Mul_3_2: TCalcRes = (Value: '6'; Carry: '0');
  { 3 x 3 } Mul_3_3: TCalcRes = (Value: '9'; Carry: '0');
  { 3 x 4 } Mul_3_4: TCalcRes = (Value: '2'; Carry: '1');
  { 3 x 5 } Mul_3_5: TCalcRes = (Value: '5'; Carry: '1');
  { 3 x 6 } Mul_3_6: TCalcRes = (Value: '8'; Carry: '1');
  { 3 x 7 } Mul_3_7: TCalcRes = (Value: '1'; Carry: '2');
  { 3 x 8 } Mul_3_8: TCalcRes = (Value: '4'; Carry: '2');
  { 3 x 9 } Mul_3_9: TCalcRes = (Value: '7'; Carry: '2');
  { 4 x 0 } Mul_4_0: TCalcRes = (Value: '0'; Carry: '0');
  { 4 x 1 } Mul_4_1: TCalcRes = (Value: '4'; Carry: '0');
  { 4 x 2 } Mul_4_2: TCalcRes = (Value: '8'; Carry: '0');
  { 4 x 3 } Mul_4_3: TCalcRes = (Value: '2'; Carry: '1');
  { 4 x 4 } Mul_4_4: TCalcRes = (Value: '6'; Carry: '1');
  { 4 x 5 } Mul_4_5: TCalcRes = (Value: '0'; Carry: '2');
  { 4 x 6 } Mul_4_6: TCalcRes = (Value: '4'; Carry: '2');
  { 4 x 7 } Mul_4_7: TCalcRes = (Value: '8'; Carry: '2');
  { 4 x 8 } Mul_4_8: TCalcRes = (Value: '2'; Carry: '3');
  { 4 x 9 } Mul_4_9: TCalcRes = (Value: '6'; Carry: '3');
  { 5 x 0 } Mul_5_0: TCalcRes = (Value: '0'; Carry: '0');
  { 5 x 1 } Mul_5_1: TCalcRes = (Value: '5'; Carry: '0');
  { 5 x 2 } Mul_5_2: TCalcRes = (Value: '0'; Carry: '1');
  { 5 x 3 } Mul_5_3: TCalcRes = (Value: '5'; Carry: '1');
  { 5 x 4 } Mul_5_4: TCalcRes = (Value: '0'; Carry: '2');
  { 5 x 5 } Mul_5_5: TCalcRes = (Value: '5'; Carry: '2');
  { 5 x 6 } Mul_5_6: TCalcRes = (Value: '0'; Carry: '3');
  { 5 x 7 } Mul_5_7: TCalcRes = (Value: '5'; Carry: '3');
  { 5 x 8 } Mul_5_8: TCalcRes = (Value: '0'; Carry: '4');
  { 5 x 9 } Mul_5_9: TCalcRes = (Value: '5'; Carry: '4');
  { 6 x 0 } Mul_6_0: TCalcRes = (Value: '0'; Carry: '0');
  { 6 x 1 } Mul_6_1: TCalcRes = (Value: '6'; Carry: '0');
  { 6 x 2 } Mul_6_2: TCalcRes = (Value: '2'; Carry: '1');
  { 6 x 3 } Mul_6_3: TCalcRes = (Value: '8'; Carry: '1');
  { 6 x 4 } Mul_6_4: TCalcRes = (Value: '4'; Carry: '2');
  { 6 x 5 } Mul_6_5: TCalcRes = (Value: '0'; Carry: '3');
  { 6 x 6 } Mul_6_6: TCalcRes = (Value: '6'; Carry: '3');
  { 6 x 7 } Mul_6_7: TCalcRes = (Value: '2'; Carry: '4');
  { 6 x 8 } Mul_6_8: TCalcRes = (Value: '8'; Carry: '4');
  { 6 x 9 } Mul_6_9: TCalcRes = (Value: '4'; Carry: '5');
  { 7 x 0 } Mul_7_0: TCalcRes = (Value: '0'; Carry: '0');
  { 7 x 1 } Mul_7_1: TCalcRes = (Value: '7'; Carry: '0');
  { 7 x 2 } Mul_7_2: TCalcRes = (Value: '4'; Carry: '1');
  { 7 x 3 } Mul_7_3: TCalcRes = (Value: '1'; Carry: '2');
  { 7 x 4 } Mul_7_4: TCalcRes = (Value: '8'; Carry: '2');
  { 7 x 5 } Mul_7_5: TCalcRes = (Value: '5'; Carry: '3');
  { 7 x 6 } Mul_7_6: TCalcRes = (Value: '2'; Carry: '4');
  { 7 x 7 } Mul_7_7: TCalcRes = (Value: '9'; Carry: '4');
  { 7 x 8 } Mul_7_8: TCalcRes = (Value: '6'; Carry: '5');
  { 7 x 9 } Mul_7_9: TCalcRes = (Value: '3'; Carry: '6');
  { 8 x 0 } Mul_8_0: TCalcRes = (Value: '0'; Carry: '0');
  { 8 x 1 } Mul_8_1: TCalcRes = (Value: '8'; Carry: '0');
  { 8 x 2 } Mul_8_2: TCalcRes = (Value: '6'; Carry: '1');
  { 8 x 3 } Mul_8_3: TCalcRes = (Value: '4'; Carry: '2');
  { 8 x 4 } Mul_8_4: TCalcRes = (Value: '2'; Carry: '3');
  { 8 x 5 } Mul_8_5: TCalcRes = (Value: '0'; Carry: '4');
  { 8 x 6 } Mul_8_6: TCalcRes = (Value: '8'; Carry: '4');
  { 8 x 7 } Mul_8_7: TCalcRes = (Value: '6'; Carry: '5');
  { 8 x 8 } Mul_8_8: TCalcRes = (Value: '4'; Carry: '6');
  { 8 x 9 } Mul_8_9: TCalcRes = (Value: '2'; Carry: '7');
  { 9 x 0 } Mul_9_0: TCalcRes = (Value: '0'; Carry: '0');
  { 9 x 1 } Mul_9_1: TCalcRes = (Value: '9'; Carry: '0');
  { 9 x 2 } Mul_9_2: TCalcRes = (Value: '8'; Carry: '1');
  { 9 x 3 } Mul_9_3: TCalcRes = (Value: '7'; Carry: '2');
  { 9 x 4 } Mul_9_4: TCalcRes = (Value: '6'; Carry: '3');
  { 9 x 5 } Mul_9_5: TCalcRes = (Value: '5'; Carry: '4');
  { 9 x 6 } Mul_9_6: TCalcRes = (Value: '4'; Carry: '5');
  { 9 x 7 } Mul_9_7: TCalcRes = (Value: '3'; Carry: '6');
  { 9 x 8 } Mul_9_8: TCalcRes = (Value: '2'; Carry: '7');
  { 9 x 9 } Mul_9_9: TCalcRes = (Value: '1'; Carry: '8');


procedure InitMulLookupTable;
begin
  MulTable[0,0] := Mul_0_0;
  MulTable[0,1] := Mul_0_1;
  MulTable[0,2] := Mul_0_2;
  MulTable[0,3] := Mul_0_3;
  MulTable[0,4] := Mul_0_4;
  MulTable[0,5] := Mul_0_5;
  MulTable[0,6] := Mul_0_6;
  MulTable[0,7] := Mul_0_7;
  MulTable[0,8] := Mul_0_8;
  MulTable[0,9] := Mul_0_9;
  MulTable[1,0] := Mul_1_0;
  MulTable[1,1] := Mul_1_1;
  MulTable[1,2] := Mul_1_2;
  MulTable[1,3] := Mul_1_3;
  MulTable[1,4] := Mul_1_4;
  MulTable[1,5] := Mul_1_5;
  MulTable[1,6] := Mul_1_6;
  MulTable[1,7] := Mul_1_7;
  MulTable[1,8] := Mul_1_8;
  MulTable[1,9] := Mul_1_9;
  MulTable[2,0] := Mul_2_0;
  MulTable[2,1] := Mul_2_1;
  MulTable[2,2] := Mul_2_2;
  MulTable[2,3] := Mul_2_3;
  MulTable[2,4] := Mul_2_4;
  MulTable[2,5] := Mul_2_5;
  MulTable[2,6] := Mul_2_6;
  MulTable[2,7] := Mul_2_7;
  MulTable[2,8] := Mul_2_8;
  MulTable[2,9] := Mul_2_9;
  MulTable[3,0] := Mul_3_0;
  MulTable[3,1] := Mul_3_1;
  MulTable[3,2] := Mul_3_2;
  MulTable[3,3] := Mul_3_3;
  MulTable[3,4] := Mul_3_4;
  MulTable[3,5] := Mul_3_5;
  MulTable[3,6] := Mul_3_6;
  MulTable[3,7] := Mul_3_7;
  MulTable[3,8] := Mul_3_8;
  MulTable[3,9] := Mul_3_9;
  MulTable[4,0] := Mul_4_0;
  MulTable[4,1] := Mul_4_1;
  MulTable[4,2] := Mul_4_2;
  MulTable[4,3] := Mul_4_3;
  MulTable[4,4] := Mul_4_4;
  MulTable[4,5] := Mul_4_5;
  MulTable[4,6] := Mul_4_6;
  MulTable[4,7] := Mul_4_7;
  MulTable[4,8] := Mul_4_8;
  MulTable[4,9] := Mul_4_9;
  MulTable[5,0] := Mul_5_0;
  MulTable[5,1] := Mul_5_1;
  MulTable[5,2] := Mul_5_2;
  MulTable[5,3] := Mul_5_3;
  MulTable[5,4] := Mul_5_4;
  MulTable[5,5] := Mul_5_5;
  MulTable[5,6] := Mul_5_6;
  MulTable[5,7] := Mul_5_7;
  MulTable[5,8] := Mul_5_8;
  MulTable[5,9] := Mul_5_9;
  MulTable[6,0] := Mul_6_0;
  MulTable[6,1] := Mul_6_1;
  MulTable[6,2] := Mul_6_2;
  MulTable[6,3] := Mul_6_3;
  MulTable[6,4] := Mul_6_4;
  MulTable[6,5] := Mul_6_5;
  MulTable[6,6] := Mul_6_6;
  MulTable[6,7] := Mul_6_7;
  MulTable[6,8] := Mul_6_8;
  MulTable[6,9] := Mul_6_9;
  MulTable[7,0] := Mul_7_0;
  MulTable[7,1] := Mul_7_1;
  MulTable[7,2] := Mul_7_2;
  MulTable[7,3] := Mul_7_3;
  MulTable[7,4] := Mul_7_4;
  MulTable[7,5] := Mul_7_5;
  MulTable[7,6] := Mul_7_6;
  MulTable[7,7] := Mul_7_7;
  MulTable[7,8] := Mul_7_8;
  MulTable[7,9] := Mul_7_9;
  MulTable[8,0] := Mul_8_0;
  MulTable[8,1] := Mul_8_1;
  MulTable[8,2] := Mul_8_2;
  MulTable[8,3] := Mul_8_3;
  MulTable[8,4] := Mul_8_4;
  MulTable[8,5] := Mul_8_5;
  MulTable[8,6] := Mul_8_6;
  MulTable[8,7] := Mul_8_7;
  MulTable[8,8] := Mul_8_8;
  MulTable[8,9] := Mul_8_9;
  MulTable[9,0] := Mul_9_0;
  MulTable[9,1] := Mul_9_1;
  MulTable[9,2] := Mul_9_2;
  MulTable[9,3] := Mul_9_3;
  MulTable[9,4] := Mul_9_4;
  MulTable[9,5] := Mul_9_5;
  MulTable[9,6] := Mul_9_6;
  MulTable[9,7] := Mul_9_7;
  MulTable[9,8] := Mul_9_8;
  MulTable[9,9] := Mul_9_9;
end;

function MulPrimitive(P1,P2: TPrimitive): TCalcRes;
begin
  Result := MulTable[Ord(P1) - Ord(Prime_Zero), Ord(P2) - Ord(Prime_Zero)];
end;

function MulNPrimitive(N: TValue; P: TPrimitive): TValue;
var
  i: Integer;
  CalcRes: TCalcRes;
  Temp: TPrimitive;
  MustCarry: OPBool;
  IsNeg: OPBool;
  SecCalcRes: TCalcRes;
  OldCarry: TPrimitive;
begin
  AssertIsNumberN(N);
  AssertIsPrimitive(P);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('MulNPrimitive: N = ',N,' P = ',P);
  N := NormalizeNumberN(N);
  if IsTrue(IsZeroN(P)) or IsTrue(IsZeroN(N)) then
  begin
    Result := Prime_Zero;
    Exit;
  end;
  if IsTrue(EqualsP(P, '1')) then
  begin
    Result := N;
    Exit;
  end;
  IsNeg := IsTrue(IsNegativeN(N));
  if IsTrue(IsNeg) then N := MakeNegativeN(N);
  Result := '';
  CalcRes.Carry := Prime_Zero;
  CalcRes.Value := Prime_Zero;
  MustCarry := ToBool(False);
  for i := Length(N) downto 1 do
  begin
    MustCarry := HasCarry(CalcRes);
    OldCarry := CalcRes.Carry;
    CalcRes := MulPrimitive(N[i], P);
    Temp := CalcRes.Value;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write(N[i],' * ',P,' -> Value: ',temp,' Carry: ',CalcRes.Carry,' OldCarry: ',OldCarry, ' NewCarry: ',CalcRes.Carry);
    if IsTrue(MustCarry) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write(' Temp');
      SecCalcRes := AddPrimitive(Temp, OldCarry);
      Temp := SecCalcRes.Value;
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write(' -> ',Temp);
      //can only happen if current carry = 0
      if IsFalse(IsZeroN(SecCalcRes.Carry)) then
      begin
        IncPrimitive(CalcRes.Carry, SecCalcRes.Carry);
        MustCarry := ToBool(True);
        //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write(' NewCarry -> ',CalcRes.Carry);
      end;
    end;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln;
    Result := Temp + Result;
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Result = ',Result);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Carry left = ',HasCarry(CalcRes),' [',CalcRes.Carry,']');
  if IsTrue(HasCarry(CalcRes)) then
  begin
    Result := CalcRes.Carry + Result;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Result = ',Result);
  end;
  if IsTrue(IsNeg) then Result := MakeNegativeN(Result);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('End result = ',Result,' [',StrToInt(N)*StrToInt(P),']');
end;


function MulN(N1, N2: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
var
  i: Integer;
  P: TPrimitive;
  InterMed: TValue;
  Pad: Integer;
  j: Integer;
begin
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('MulN: N1=',N1,' N2=',N2);
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  if IsTrueComplex(IsTrue(IsNegativeN(N1)), IsTrue(IsNegativeN(N2))) then
  begin
    // -x * -y = (x * y)
    Result := MulN(MakeNegativeN(N1), MakeNegativeN(N2));
    Exit;
  end;
  if IsTrue(IsNegativeN(N1)) and IsFalse(IsNegativeN(N2)) then
  begin
    // -x * y = -(x * y)
    Result := MakeNegativeN(MulN(MakeNegativeN(N1), N2));
    Exit;
  end;
  if IsFalse(IsNegativeN(N1)) and IsTrue(IsNegativeN(N2)) then
  begin
    // x * -y = -(x * y)
    Result := MakeNegativeN(MulN(N1, MakeNegativeN(N2)));
    Exit;
  end;
  N1 := NormalizeNumberN(N1);
  N2 := NormalizeNumberN(N2);
  //ShortCuts
  if IsTrue(IsZeroN(N1)) or IsTrue(IsZeroN(N2)) then
  begin
    Result := Prime_Zero;
    Exit;
  end;
  if IsTrue(EqualsN(N1, '1')) then
  begin
    Result := N2;
    Exit;
  end;
  if IsTrue(EqualsN(N2, '1')) then
  begin
    Result := N1;
    Exit;
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Result = ',N1,' * ',N2,' = ',StrToInt64(N1) * StrToInt64(N2));
  Result := '';
  for i := Length(N2) downto 1 do
  begin
    P := N2[i];
    Pad := Length(N2) - i;
    InterMed := MulNPrimitive(N1, P);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('i = ',i,' Pad = ',Pad);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('InterMed: ',N1,' * ',P,' = ',InterMed,' [',StrToInt64(N1)*StrToInt64(P),']');
    for j := 1 to Pad do InterMed := InterMed + Prime_Zero;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('InterMed after padding: ',InterMed);
    if IsTrue(Pad = 0) then
      Result := InterMed
    else
      Result := AddN(Result, InterMed);
    if Assigned(CallBack) then CallBack(Format('MulN: Intermediate Result = %s',[Result]), True);
  end;
end;

{
  FacN(100) = 93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000
  A 158 digit number ....
}
function FacN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): TValue;
begin
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('FacN: N=',N);
  AssertIsNumberN(N);
  AssertIsPositiveN(N);
  if IsTrue(IsZeroN(N)) then RaiseENumberRangeCheckError(N);
  NormalizeNumberN(N);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('FacN: After normalize: N="',N,'"');
  Result := '1';
  while IsFalse(IsZeroN(N)) do
  begin
    Result := MulN(N, Result);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('FacN: Result = ',Result,' (N = ',N,' -> ');
    N := SubN(N, '1');
    if Assigned(CallBack) then CallBack(Format('FacN: InterMediate Result = %s (%s steps to go).',[Result, N]), True);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N);
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('FacN: Result = ',Result);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('FacN: End.');
end;

function BinomN(N, K: TValue; CallBack: TCalcFeedbackEvent = nil): TPositiveValue;
begin
  AssertIsNumberN(N);
  AssertIsPositiveN(N);
  NormalizeNumberN(N);
  AssertIsNumberN(K);
  NormalizeNumberN(K);
  if IsTrue(MoreN(K, N)) or (IsTrue(IsNegativeN(K))) then
  //source: https://nl.wikipedia.org/wiki/Binomiaalco%C3%ABffici%C3%ABnt
  begin
    Result := Prime_Zero;
    Exit;
  end;
  //source: https://en.wikipedia.org/wiki/Binomial_coefficient
  if IsTrue(IsZeroN(K)) or IsTrue(EqualsN(N, K)) then
  begin
    Result := '1';
    Exit;
  end;
  // BinomN(N,K) = BinomN(N, N-K)
  //so if K > N/2 then calculating Binom(N,N-K) is more efficient
  if IsTrue(MoreN(K, DivN(N, '2', CallBack))) then
    K := SubN(N, K);
  Result := DivN(FacN(N, CallBack), (MulN(FacN(K, CallBack), FacN(SubN(N, K), Callback), CallBack)));
end;

function ExpN(Base: TValue; Exp: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): TValue;
begin
  AssertIsNumberN(Base);
  AssertIsPositiveN(Exp);
  if IsTrueComplex(IsTrue(IsZeroN(Base)), IsTrue(IsZeroN(Exp))) then Raise ENumber.Create(SEZeroExpZero);
  if IsTrue(IsZeroN(Base)) then
  begin
    Result := Prime_Zero;
    Exit;
  end;
  if IsTrue(IsZeroN(Exp)) then
  begin
    Result := Prime_Zero;
    Exit;
  end;
  if IsTrue(EqualsN(Base, '1')) then
  begin
    Result := '1';
    Exit;
  end;
  if IsTrue(IsNegativeN(Base)) then
  begin
    if IsTrue(OddN(Exp)) then
    begin
      Result := MakeNegativeN(ExpN(MakeNegativeN(Base), Exp, Callback));
      Exit;
    end
    else
    begin
      Base := MakeNegativeN(Base);
      if IsTrue(EqualsN(Base, '1')) then
      begin
        Result := '1';
        Exit;
      end;
    end;
  end;
  Result := Base;
  while IsFalse(EqualsN(Exp, '1')) do
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('ExpN: N = ',Base,' Exp = ',Exp,' -> ');
    Exp := SubN(Exp, '1');
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(Exp);
    Result := MulN(Result, Base);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('ExpN: Result = ',Result);
    if Assigned(CallBack) Then CallBack('ExpN: intermediate Result = ' + Result, True);
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('ExpN end.');
end;

function GoogolPlex(CallBack: TCalcFeedbackEvent): TValue;
begin
  Result := ExpN('10' , Googol, CallBack);
end;

function SqrN(N: TValue; CallBack: TCalcFeedbackEvent = nil): TValue;
begin
  AssertIsNumberN(N);
  Result := MulN(N, N, CallBack);
end;

//keep at end of include file to fool codetools
procedure mulfoolct;
begin
end;
