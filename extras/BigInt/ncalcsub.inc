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


//Lookup tables for adding

Type
  TSubLookupTable = array[0..9,0..9] of TCalcRes;
var
  SubTable: TSubLookupTable;

const

  { 0 - 0 } Sub_0_0: TCalcRes = (Value: '0'; Carry: '0');
  { 0 - 1 } Sub_0_1: TCalcRes = (Value: '9'; Carry: '1');
  { 0 - 2 } Sub_0_2: TCalcRes = (Value: '8'; Carry: '1');
  { 0 - 3 } Sub_0_3: TCalcRes = (Value: '7'; Carry: '1');
  { 0 - 4 } Sub_0_4: TCalcRes = (Value: '6'; Carry: '1');
  { 0 - 5 } Sub_0_5: TCalcRes = (Value: '5'; Carry: '1');
  { 0 - 6 } Sub_0_6: TCalcRes = (Value: '4'; Carry: '1');
  { 0 - 7 } Sub_0_7: TCalcRes = (Value: '3'; Carry: '1');
  { 0 - 8 } Sub_0_8: TCalcRes = (Value: '2'; Carry: '1');
  { 0 - 9 } Sub_0_9: TCalcRes = (Value: '1'; Carry: '1');
  { 1 - 0 } Sub_1_0: TCalcRes = (Value: '1'; Carry: '0');
  { 1 - 1 } Sub_1_1: TCalcRes = (Value: '0'; Carry: '0');
  { 1 - 2 } Sub_1_2: TCalcRes = (Value: '9'; Carry: '1');
  { 1 - 3 } Sub_1_3: TCalcRes = (Value: '8'; Carry: '1');
  { 1 - 4 } Sub_1_4: TCalcRes = (Value: '7'; Carry: '1');
  { 1 - 5 } Sub_1_5: TCalcRes = (Value: '6'; Carry: '1');
  { 1 - 6 } Sub_1_6: TCalcRes = (Value: '5'; Carry: '1');
  { 1 - 7 } Sub_1_7: TCalcRes = (Value: '4'; Carry: '1');
  { 1 - 8 } Sub_1_8: TCalcRes = (Value: '3'; Carry: '1');
  { 1 - 9 } Sub_1_9: TCalcRes = (Value: '2'; Carry: '1');
  { 2 - 0 } Sub_2_0: TCalcRes = (Value: '2'; Carry: '0');
  { 2 - 1 } Sub_2_1: TCalcRes = (Value: '1'; Carry: '0');
  { 2 - 2 } Sub_2_2: TCalcRes = (Value: '0'; Carry: '0');
  { 2 - 3 } Sub_2_3: TCalcRes = (Value: '9'; Carry: '1');
  { 2 - 4 } Sub_2_4: TCalcRes = (Value: '8'; Carry: '1');
  { 2 - 5 } Sub_2_5: TCalcRes = (Value: '7'; Carry: '1');
  { 2 - 6 } Sub_2_6: TCalcRes = (Value: '6'; Carry: '1');
  { 2 - 7 } Sub_2_7: TCalcRes = (Value: '5'; Carry: '1');
  { 2 - 8 } Sub_2_8: TCalcRes = (Value: '4'; Carry: '1');
  { 2 - 9 } Sub_2_9: TCalcRes = (Value: '3'; Carry: '1');
  { 3 - 0 } Sub_3_0: TCalcRes = (Value: '3'; Carry: '0');
  { 3 - 1 } Sub_3_1: TCalcRes = (Value: '2'; Carry: '0');
  { 3 - 2 } Sub_3_2: TCalcRes = (Value: '1'; Carry: '0');
  { 3 - 3 } Sub_3_3: TCalcRes = (Value: '0'; Carry: '0');
  { 3 - 4 } Sub_3_4: TCalcRes = (Value: '9'; Carry: '1');
  { 3 - 5 } Sub_3_5: TCalcRes = (Value: '8'; Carry: '1');
  { 3 - 6 } Sub_3_6: TCalcRes = (Value: '7'; Carry: '1');
  { 3 - 7 } Sub_3_7: TCalcRes = (Value: '6'; Carry: '1');
  { 3 - 8 } Sub_3_8: TCalcRes = (Value: '5'; Carry: '1');
  { 3 - 9 } Sub_3_9: TCalcRes = (Value: '4'; Carry: '1');
  { 4 - 0 } Sub_4_0: TCalcRes = (Value: '4'; Carry: '0');
  { 4 - 1 } Sub_4_1: TCalcRes = (Value: '3'; Carry: '0');
  { 4 - 2 } Sub_4_2: TCalcRes = (Value: '2'; Carry: '0');
  { 4 - 3 } Sub_4_3: TCalcRes = (Value: '1'; Carry: '0');
  { 4 - 4 } Sub_4_4: TCalcRes = (Value: '0'; Carry: '0');
  { 4 - 5 } Sub_4_5: TCalcRes = (Value: '9'; Carry: '1');
  { 4 - 6 } Sub_4_6: TCalcRes = (Value: '8'; Carry: '1');
  { 4 - 7 } Sub_4_7: TCalcRes = (Value: '7'; Carry: '1');
  { 4 - 8 } Sub_4_8: TCalcRes = (Value: '6'; Carry: '1');
  { 4 - 9 } Sub_4_9: TCalcRes = (Value: '5'; Carry: '1');
  { 5 - 0 } Sub_5_0: TCalcRes = (Value: '5'; Carry: '0');
  { 5 - 1 } Sub_5_1: TCalcRes = (Value: '4'; Carry: '0');
  { 5 - 2 } Sub_5_2: TCalcRes = (Value: '3'; Carry: '0');
  { 5 - 3 } Sub_5_3: TCalcRes = (Value: '2'; Carry: '0');
  { 5 - 4 } Sub_5_4: TCalcRes = (Value: '1'; Carry: '0');
  { 5 - 5 } Sub_5_5: TCalcRes = (Value: '0'; Carry: '0');
  { 5 - 6 } Sub_5_6: TCalcRes = (Value: '9'; Carry: '1');
  { 5 - 7 } Sub_5_7: TCalcRes = (Value: '8'; Carry: '1');
  { 5 - 8 } Sub_5_8: TCalcRes = (Value: '7'; Carry: '1');
  { 5 - 9 } Sub_5_9: TCalcRes = (Value: '6'; Carry: '1');
  { 6 - 0 } Sub_6_0: TCalcRes = (Value: '6'; Carry: '0');
  { 6 - 1 } Sub_6_1: TCalcRes = (Value: '5'; Carry: '0');
  { 6 - 2 } Sub_6_2: TCalcRes = (Value: '4'; Carry: '0');
  { 6 - 3 } Sub_6_3: TCalcRes = (Value: '3'; Carry: '0');
  { 6 - 4 } Sub_6_4: TCalcRes = (Value: '2'; Carry: '0');
  { 6 - 5 } Sub_6_5: TCalcRes = (Value: '1'; Carry: '0');
  { 6 - 6 } Sub_6_6: TCalcRes = (Value: '0'; Carry: '0');
  { 6 - 7 } Sub_6_7: TCalcRes = (Value: '9'; Carry: '1');
  { 6 - 8 } Sub_6_8: TCalcRes = (Value: '8'; Carry: '1');
  { 6 - 9 } Sub_6_9: TCalcRes = (Value: '7'; Carry: '1');
  { 7 - 0 } Sub_7_0: TCalcRes = (Value: '7'; Carry: '0');
  { 7 - 1 } Sub_7_1: TCalcRes = (Value: '6'; Carry: '0');
  { 7 - 2 } Sub_7_2: TCalcRes = (Value: '5'; Carry: '0');
  { 7 - 3 } Sub_7_3: TCalcRes = (Value: '4'; Carry: '0');
  { 7 - 4 } Sub_7_4: TCalcRes = (Value: '3'; Carry: '0');
  { 7 - 5 } Sub_7_5: TCalcRes = (Value: '2'; Carry: '0');
  { 7 - 6 } Sub_7_6: TCalcRes = (Value: '1'; Carry: '0');
  { 7 - 7 } Sub_7_7: TCalcRes = (Value: '0'; Carry: '0');
  { 7 - 8 } Sub_7_8: TCalcRes = (Value: '9'; Carry: '1');
  { 7 - 9 } Sub_7_9: TCalcRes = (Value: '8'; Carry: '1');
  { 8 - 0 } Sub_8_0: TCalcRes = (Value: '8'; Carry: '0');
  { 8 - 1 } Sub_8_1: TCalcRes = (Value: '7'; Carry: '0');
  { 8 - 2 } Sub_8_2: TCalcRes = (Value: '6'; Carry: '0');
  { 8 - 3 } Sub_8_3: TCalcRes = (Value: '5'; Carry: '0');
  { 8 - 4 } Sub_8_4: TCalcRes = (Value: '4'; Carry: '0');
  { 8 - 5 } Sub_8_5: TCalcRes = (Value: '3'; Carry: '0');
  { 8 - 6 } Sub_8_6: TCalcRes = (Value: '2'; Carry: '0');
  { 8 - 7 } Sub_8_7: TCalcRes = (Value: '1'; Carry: '0');
  { 8 - 8 } Sub_8_8: TCalcRes = (Value: '0'; Carry: '0');
  { 8 - 9 } Sub_8_9: TCalcRes = (Value: '9'; Carry: '1');
  { 9 - 0 } Sub_9_0: TCalcRes = (Value: '9'; Carry: '0');
  { 9 - 1 } Sub_9_1: TCalcRes = (Value: '8'; Carry: '0');
  { 9 - 2 } Sub_9_2: TCalcRes = (Value: '7'; Carry: '0');
  { 9 - 3 } Sub_9_3: TCalcRes = (Value: '6'; Carry: '0');
  { 9 - 4 } Sub_9_4: TCalcRes = (Value: '5'; Carry: '0');
  { 9 - 5 } Sub_9_5: TCalcRes = (Value: '4'; Carry: '0');
  { 9 - 6 } Sub_9_6: TCalcRes = (Value: '3'; Carry: '0');
  { 9 - 7 } Sub_9_7: TCalcRes = (Value: '2'; Carry: '0');
  { 9 - 8 } Sub_9_8: TCalcRes = (Value: '1'; Carry: '0');
  { 9 - 9 } Sub_9_9: TCalcRes = (Value: '0'; Carry: '0');

procedure InitSubLookupTable;
begin
  SubTable[0,0] := Sub_0_0;
  SubTable[0,1] := Sub_0_1;
  SubTable[0,2] := Sub_0_2;
  SubTable[0,3] := Sub_0_3;
  SubTable[0,4] := Sub_0_4;
  SubTable[0,5] := Sub_0_5;
  SubTable[0,6] := Sub_0_6;
  SubTable[0,7] := Sub_0_7;
  SubTable[0,8] := Sub_0_8;
  SubTable[0,9] := Sub_0_9;
  SubTable[1,0] := Sub_1_0;
  SubTable[1,1] := Sub_1_1;
  SubTable[1,2] := Sub_1_2;
  SubTable[1,3] := Sub_1_3;
  SubTable[1,4] := Sub_1_4;
  SubTable[1,5] := Sub_1_5;
  SubTable[1,6] := Sub_1_6;
  SubTable[1,7] := Sub_1_7;
  SubTable[1,8] := Sub_1_8;
  SubTable[1,9] := Sub_1_9;
  SubTable[2,0] := Sub_2_0;
  SubTable[2,1] := Sub_2_1;
  SubTable[2,2] := Sub_2_2;
  SubTable[2,3] := Sub_2_3;
  SubTable[2,4] := Sub_2_4;
  SubTable[2,5] := Sub_2_5;
  SubTable[2,6] := Sub_2_6;
  SubTable[2,7] := Sub_2_7;
  SubTable[2,8] := Sub_2_8;
  SubTable[2,9] := Sub_2_9;
  SubTable[3,0] := Sub_3_0;
  SubTable[3,1] := Sub_3_1;
  SubTable[3,2] := Sub_3_2;
  SubTable[3,3] := Sub_3_3;
  SubTable[3,4] := Sub_3_4;
  SubTable[3,5] := Sub_3_5;
  SubTable[3,6] := Sub_3_6;
  SubTable[3,7] := Sub_3_7;
  SubTable[3,8] := Sub_3_8;
  SubTable[3,9] := Sub_3_9;
  SubTable[4,0] := Sub_4_0;
  SubTable[4,1] := Sub_4_1;
  SubTable[4,2] := Sub_4_2;
  SubTable[4,3] := Sub_4_3;
  SubTable[4,4] := Sub_4_4;
  SubTable[4,5] := Sub_4_5;
  SubTable[4,6] := Sub_4_6;
  SubTable[4,7] := Sub_4_7;
  SubTable[4,8] := Sub_4_8;
  SubTable[4,9] := Sub_4_9;
  SubTable[5,0] := Sub_5_0;
  SubTable[5,1] := Sub_5_1;
  SubTable[5,2] := Sub_5_2;
  SubTable[5,3] := Sub_5_3;
  SubTable[5,4] := Sub_5_4;
  SubTable[5,5] := Sub_5_5;
  SubTable[5,6] := Sub_5_6;
  SubTable[5,7] := Sub_5_7;
  SubTable[5,8] := Sub_5_8;
  SubTable[5,9] := Sub_5_9;
  SubTable[6,0] := Sub_6_0;
  SubTable[6,1] := Sub_6_1;
  SubTable[6,2] := Sub_6_2;
  SubTable[6,3] := Sub_6_3;
  SubTable[6,4] := Sub_6_4;
  SubTable[6,5] := Sub_6_5;
  SubTable[6,6] := Sub_6_6;
  SubTable[6,7] := Sub_6_7;
  SubTable[6,8] := Sub_6_8;
  SubTable[6,9] := Sub_6_9;
  SubTable[7,0] := Sub_7_0;
  SubTable[7,1] := Sub_7_1;
  SubTable[7,2] := Sub_7_2;
  SubTable[7,3] := Sub_7_3;
  SubTable[7,4] := Sub_7_4;
  SubTable[7,5] := Sub_7_5;
  SubTable[7,6] := Sub_7_6;
  SubTable[7,7] := Sub_7_7;
  SubTable[7,8] := Sub_7_8;
  SubTable[7,9] := Sub_7_9;
  SubTable[8,0] := Sub_8_0;
  SubTable[8,1] := Sub_8_1;
  SubTable[8,2] := Sub_8_2;
  SubTable[8,3] := Sub_8_3;
  SubTable[8,4] := Sub_8_4;
  SubTable[8,5] := Sub_8_5;
  SubTable[8,6] := Sub_8_6;
  SubTable[8,7] := Sub_8_7;
  SubTable[8,8] := Sub_8_8;
  SubTable[8,9] := Sub_8_9;
  SubTable[9,0] := Sub_9_0;
  SubTable[9,1] := Sub_9_1;
  SubTable[9,2] := Sub_9_2;
  SubTable[9,3] := Sub_9_3;
  SubTable[9,4] := Sub_9_4;
  SubTable[9,5] := Sub_9_5;
  SubTable[9,6] := Sub_9_6;
  SubTable[9,7] := Sub_9_7;
  SubTable[9,8] := Sub_9_8;
  SubTable[9,9] := Sub_9_9;
end;

function SubPrimitive(P1,P2: TPrimitive): TCalcRes;
begin
  Result := SubTable[Ord(P1) - Ord(Prime_Zero), Ord(P2) - Ord(Prime_Zero)];
end;


function SubN(N1, N2: TValue): TValue;
var
  CalcRes: TCalcRes;
  MustCarry: Boolean;
  Temp: TPrimitive;
  i: Integer;
  TempN: TValue;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: N1=',N1,' N2=',N2);
  if IsTrueComplex(IsTrue(IsNegativeN(N1)), IsTrue(IsNegativeN(N2))) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: // -x - -y = -x + y = (y-x)');
    SwapN(N1,N2);
    Result := SubN(MakeNegativeN(N1), MakeNegativeN(N2));
    Exit;
  end;
  if IsTrue(IsNegativeN(N1)) and IsFalse(IsNegativeN(N2)) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: // -x -y = -(x+y)');
    Result := MakeNegativeN(AddN(MakeNegativeN(N1), N2));
    Exit;
  end;
  if IsFalse(IsNegativeN(N1)) and IsTrue(IsNegativeN(N2)) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: // x - -y = (x+y)');
    Result := AddN(N1, MakeNegativeN(N2));
    Exit;
  end;
  //both positive numbers
  N1 := NormalizeNumberN(N1);
  N2 := NormalizeNumberN(N2);
  //pad with zero's
  while IsTrue(Length(N1) < Length(N2)) do N1 := Prime_Zero + N1;
  while IsTrue(Length(N1) > Length(N2)) do N2 := Prime_Zero + N2;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: After padding:');
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: N1:=',N1);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: N2:=',N2);
  Result := '';
  CalcRes.Carry := Prime_Zero;
  CalcRes.Value := Prime_Zero;
  //Algorithm only works if N1 > N2 !
  for i := Length(N1) downto 1 do
  begin
    MustCarry := HasCarry(CalcRes);
    CalcRes := SubPrimitive(N1[i], N2[i]);
    Temp := CalcRes.Value;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('SubN: ',N1[i],' - ',N2[i],' -> Value: ',temp,' Carry: ',CalcRes.Carry,' OldCarry: ',MustCarry, ' NewCarry: ',HasCarry(CalcRes));
    if IsTrue(MustCarry) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write(' Temp');
      DecPrimitive(Temp);
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write(' -> ',Temp);
      //can only happen if current carry = 0
      if IsTrue(Temp = Prime_Last) then
      begin
        CalcRes.Carry := '1';
        MustCarry := ToBool(True);
        //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write(' NewCarry -> True');
      end;
    end;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln;
    Result := Temp + Result;
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('SubN: Result = ',Result,' -> After Normalize: ');
  Result := NormalizeNumberN(Result);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(Result);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: Carry left = ',HasCarry(CalcRes));
  if IsTrue(HasCarry(CalcRes)) then
  begin
    //This happens if N1 > N1 eg. 10 - 100
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: CarryLeft!');
    TempN := '1';
    for i := 1 to Length(N2) do TempN := TempN + Prime_Zero;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: Calcing ',TempN,' - ',Result);
    Result := MakeNegativeN(SubN(TempN, Result));
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN: Result = ',Result);
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('SubN end.');
end;

procedure DecPrimitive(var P: TPrimitive; V: TPrimitive);
var
  CalcRes: TCalcRes;
begin
  AssertIsPrimitive(P);
  AssertIsPrimitive(V);
  CalcRes := SubPrimitive(P, V);
  P := CalcRes.Value;
end;


//keep at end of include file to fool codetools
procedure subfoolct;
begin
end;
