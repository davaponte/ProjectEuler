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
  TAddLookupTable = array[0..9,0..9] of TCalcRes;
var
  AddTable: TAddLookupTable;

const

  { 0 + 0 } Add_0_0: TCalcRes = (Value: '0'; Carry: '0');
  { 0 + 1 } Add_0_1: TCalcRes = (Value: '1'; Carry: '0');
  { 0 + 2 } Add_0_2: TCalcRes = (Value: '2'; Carry: '0');
  { 0 + 3 } Add_0_3: TCalcRes = (Value: '3'; Carry: '0');
  { 0 + 4 } Add_0_4: TCalcRes = (Value: '4'; Carry: '0');
  { 0 + 5 } Add_0_5: TCalcRes = (Value: '5'; Carry: '0');
  { 0 + 6 } Add_0_6: TCalcRes = (Value: '6'; Carry: '0');
  { 0 + 7 } Add_0_7: TCalcRes = (Value: '7'; Carry: '0');
  { 0 + 8 } Add_0_8: TCalcRes = (Value: '8'; Carry: '0');
  { 0 + 9 } Add_0_9: TCalcRes = (Value: '9'; Carry: '0');
  { 1 + 0 } Add_1_0: TCalcRes = (Value: '1'; Carry: '0');
  { 1 + 1 } Add_1_1: TCalcRes = (Value: '2'; Carry: '0');
  { 1 + 2 } Add_1_2: TCalcRes = (Value: '3'; Carry: '0');
  { 1 + 3 } Add_1_3: TCalcRes = (Value: '4'; Carry: '0');
  { 1 + 4 } Add_1_4: TCalcRes = (Value: '5'; Carry: '0');
  { 1 + 5 } Add_1_5: TCalcRes = (Value: '6'; Carry: '0');
  { 1 + 6 } Add_1_6: TCalcRes = (Value: '7'; Carry: '0');
  { 1 + 7 } Add_1_7: TCalcRes = (Value: '8'; Carry: '0');
  { 1 + 8 } Add_1_8: TCalcRes = (Value: '9'; Carry: '0');
  { 1 + 9 } Add_1_9: TCalcRes = (Value: '0'; Carry: '1');
  { 2 + 0 } Add_2_0: TCalcRes = (Value: '2'; Carry: '0');
  { 2 + 1 } Add_2_1: TCalcRes = (Value: '3'; Carry: '0');
  { 2 + 2 } Add_2_2: TCalcRes = (Value: '4'; Carry: '0');
  { 2 + 3 } Add_2_3: TCalcRes = (Value: '5'; Carry: '0');
  { 2 + 4 } Add_2_4: TCalcRes = (Value: '6'; Carry: '0');
  { 2 + 5 } Add_2_5: TCalcRes = (Value: '7'; Carry: '0');
  { 2 + 6 } Add_2_6: TCalcRes = (Value: '8'; Carry: '0');
  { 2 + 7 } Add_2_7: TCalcRes = (Value: '9'; Carry: '0');
  { 2 + 8 } Add_2_8: TCalcRes = (Value: '0'; Carry: '1');
  { 2 + 9 } Add_2_9: TCalcRes = (Value: '1'; Carry: '1');
  { 3 + 0 } Add_3_0: TCalcRes = (Value: '3'; Carry: '0');
  { 3 + 1 } Add_3_1: TCalcRes = (Value: '4'; Carry: '0');
  { 3 + 2 } Add_3_2: TCalcRes = (Value: '5'; Carry: '0');
  { 3 + 3 } Add_3_3: TCalcRes = (Value: '6'; Carry: '0');
  { 3 + 4 } Add_3_4: TCalcRes = (Value: '7'; Carry: '0');
  { 3 + 5 } Add_3_5: TCalcRes = (Value: '8'; Carry: '0');
  { 3 + 6 } Add_3_6: TCalcRes = (Value: '9'; Carry: '0');
  { 3 + 7 } Add_3_7: TCalcRes = (Value: '0'; Carry: '1');
  { 3 + 8 } Add_3_8: TCalcRes = (Value: '1'; Carry: '1');
  { 3 + 9 } Add_3_9: TCalcRes = (Value: '2'; Carry: '1');
  { 4 + 0 } Add_4_0: TCalcRes = (Value: '4'; Carry: '0');
  { 4 + 1 } Add_4_1: TCalcRes = (Value: '5'; Carry: '0');
  { 4 + 2 } Add_4_2: TCalcRes = (Value: '6'; Carry: '0');
  { 4 + 3 } Add_4_3: TCalcRes = (Value: '7'; Carry: '0');
  { 4 + 4 } Add_4_4: TCalcRes = (Value: '8'; Carry: '0');
  { 4 + 5 } Add_4_5: TCalcRes = (Value: '9'; Carry: '0');
  { 4 + 6 } Add_4_6: TCalcRes = (Value: '0'; Carry: '1');
  { 4 + 7 } Add_4_7: TCalcRes = (Value: '1'; Carry: '1');
  { 4 + 8 } Add_4_8: TCalcRes = (Value: '2'; Carry: '1');
  { 4 + 9 } Add_4_9: TCalcRes = (Value: '3'; Carry: '1');
  { 5 + 0 } Add_5_0: TCalcRes = (Value: '5'; Carry: '0');
  { 5 + 1 } Add_5_1: TCalcRes = (Value: '6'; Carry: '0');
  { 5 + 2 } Add_5_2: TCalcRes = (Value: '7'; Carry: '0');
  { 5 + 3 } Add_5_3: TCalcRes = (Value: '8'; Carry: '0');
  { 5 + 4 } Add_5_4: TCalcRes = (Value: '9'; Carry: '0');
  { 5 + 5 } Add_5_5: TCalcRes = (Value: '0'; Carry: '1');
  { 5 + 6 } Add_5_6: TCalcRes = (Value: '1'; Carry: '1');
  { 5 + 7 } Add_5_7: TCalcRes = (Value: '2'; Carry: '1');
  { 5 + 8 } Add_5_8: TCalcRes = (Value: '3'; Carry: '1');
  { 5 + 9 } Add_5_9: TCalcRes = (Value: '4'; Carry: '1');
  { 6 + 0 } Add_6_0: TCalcRes = (Value: '6'; Carry: '0');
  { 6 + 1 } Add_6_1: TCalcRes = (Value: '7'; Carry: '0');
  { 6 + 2 } Add_6_2: TCalcRes = (Value: '8'; Carry: '0');
  { 6 + 3 } Add_6_3: TCalcRes = (Value: '9'; Carry: '0');
  { 6 + 4 } Add_6_4: TCalcRes = (Value: '0'; Carry: '1');
  { 6 + 5 } Add_6_5: TCalcRes = (Value: '1'; Carry: '1');
  { 6 + 6 } Add_6_6: TCalcRes = (Value: '2'; Carry: '1');
  { 6 + 7 } Add_6_7: TCalcRes = (Value: '3'; Carry: '1');
  { 6 + 8 } Add_6_8: TCalcRes = (Value: '4'; Carry: '1');
  { 6 + 9 } Add_6_9: TCalcRes = (Value: '5'; Carry: '1');
  { 7 + 0 } Add_7_0: TCalcRes = (Value: '7'; Carry: '0');
  { 7 + 1 } Add_7_1: TCalcRes = (Value: '8'; Carry: '0');
  { 7 + 2 } Add_7_2: TCalcRes = (Value: '9'; Carry: '0');
  { 7 + 3 } Add_7_3: TCalcRes = (Value: '0'; Carry: '1');
  { 7 + 4 } Add_7_4: TCalcRes = (Value: '1'; Carry: '1');
  { 7 + 5 } Add_7_5: TCalcRes = (Value: '2'; Carry: '1');
  { 7 + 6 } Add_7_6: TCalcRes = (Value: '3'; Carry: '1');
  { 7 + 7 } Add_7_7: TCalcRes = (Value: '4'; Carry: '1');
  { 7 + 8 } Add_7_8: TCalcRes = (Value: '5'; Carry: '1');
  { 7 + 9 } Add_7_9: TCalcRes = (Value: '6'; Carry: '1');
  { 8 + 0 } Add_8_0: TCalcRes = (Value: '8'; Carry: '0');
  { 8 + 1 } Add_8_1: TCalcRes = (Value: '9'; Carry: '0');
  { 8 + 2 } Add_8_2: TCalcRes = (Value: '0'; Carry: '1');
  { 8 + 3 } Add_8_3: TCalcRes = (Value: '1'; Carry: '1');
  { 8 + 4 } Add_8_4: TCalcRes = (Value: '2'; Carry: '1');
  { 8 + 5 } Add_8_5: TCalcRes = (Value: '3'; Carry: '1');
  { 8 + 6 } Add_8_6: TCalcRes = (Value: '4'; Carry: '1');
  { 8 + 7 } Add_8_7: TCalcRes = (Value: '5'; Carry: '1');
  { 8 + 8 } Add_8_8: TCalcRes = (Value: '6'; Carry: '1');
  { 8 + 9 } Add_8_9: TCalcRes = (Value: '7'; Carry: '1');
  { 9 + 0 } Add_9_0: TCalcRes = (Value: '9'; Carry: '0');
  { 9 + 1 } Add_9_1: TCalcRes = (Value: '0'; Carry: '1');
  { 9 + 2 } Add_9_2: TCalcRes = (Value: '1'; Carry: '1');
  { 9 + 3 } Add_9_3: TCalcRes = (Value: '2'; Carry: '1');
  { 9 + 4 } Add_9_4: TCalcRes = (Value: '3'; Carry: '1');
  { 9 + 5 } Add_9_5: TCalcRes = (Value: '4'; Carry: '1');
  { 9 + 6 } Add_9_6: TCalcRes = (Value: '5'; Carry: '1');
  { 9 + 7 } Add_9_7: TCalcRes = (Value: '6'; Carry: '1');
  { 9 + 8 } Add_9_8: TCalcRes = (Value: '7'; Carry: '1');
  { 9 + 9 } Add_9_9: TCalcRes = (Value: '8'; Carry: '1');



procedure InitAddLookupTable;
begin
  AddTable[0,0] := Add_0_0;
  AddTable[0,1] := Add_0_1;
  AddTable[0,2] := Add_0_2;
  AddTable[0,3] := Add_0_3;
  AddTable[0,4] := Add_0_4;
  AddTable[0,5] := Add_0_5;
  AddTable[0,6] := Add_0_6;
  AddTable[0,7] := Add_0_7;
  AddTable[0,8] := Add_0_8;
  AddTable[0,9] := Add_0_9;
  AddTable[1,0] := Add_1_0;
  AddTable[1,1] := Add_1_1;
  AddTable[1,2] := Add_1_2;
  AddTable[1,3] := Add_1_3;
  AddTable[1,4] := Add_1_4;
  AddTable[1,5] := Add_1_5;
  AddTable[1,6] := Add_1_6;
  AddTable[1,7] := Add_1_7;
  AddTable[1,8] := Add_1_8;
  AddTable[1,9] := Add_1_9;
  AddTable[2,0] := Add_2_0;
  AddTable[2,1] := Add_2_1;
  AddTable[2,2] := Add_2_2;
  AddTable[2,3] := Add_2_3;
  AddTable[2,4] := Add_2_4;
  AddTable[2,5] := Add_2_5;
  AddTable[2,6] := Add_2_6;
  AddTable[2,7] := Add_2_7;
  AddTable[2,8] := Add_2_8;
  AddTable[2,9] := Add_2_9;
  AddTable[3,0] := Add_3_0;
  AddTable[3,1] := Add_3_1;
  AddTable[3,2] := Add_3_2;
  AddTable[3,3] := Add_3_3;
  AddTable[3,4] := Add_3_4;
  AddTable[3,5] := Add_3_5;
  AddTable[3,6] := Add_3_6;
  AddTable[3,7] := Add_3_7;
  AddTable[3,8] := Add_3_8;
  AddTable[3,9] := Add_3_9;
  AddTable[4,0] := Add_4_0;
  AddTable[4,1] := Add_4_1;
  AddTable[4,2] := Add_4_2;
  AddTable[4,3] := Add_4_3;
  AddTable[4,4] := Add_4_4;
  AddTable[4,5] := Add_4_5;
  AddTable[4,6] := Add_4_6;
  AddTable[4,7] := Add_4_7;
  AddTable[4,8] := Add_4_8;
  AddTable[4,9] := Add_4_9;
  AddTable[5,0] := Add_5_0;
  AddTable[5,1] := Add_5_1;
  AddTable[5,2] := Add_5_2;
  AddTable[5,3] := Add_5_3;
  AddTable[5,4] := Add_5_4;
  AddTable[5,5] := Add_5_5;
  AddTable[5,6] := Add_5_6;
  AddTable[5,7] := Add_5_7;
  AddTable[5,8] := Add_5_8;
  AddTable[5,9] := Add_5_9;
  AddTable[6,0] := Add_6_0;
  AddTable[6,1] := Add_6_1;
  AddTable[6,2] := Add_6_2;
  AddTable[6,3] := Add_6_3;
  AddTable[6,4] := Add_6_4;
  AddTable[6,5] := Add_6_5;
  AddTable[6,6] := Add_6_6;
  AddTable[6,7] := Add_6_7;
  AddTable[6,8] := Add_6_8;
  AddTable[6,9] := Add_6_9;
  AddTable[7,0] := Add_7_0;
  AddTable[7,1] := Add_7_1;
  AddTable[7,2] := Add_7_2;
  AddTable[7,3] := Add_7_3;
  AddTable[7,4] := Add_7_4;
  AddTable[7,5] := Add_7_5;
  AddTable[7,6] := Add_7_6;
  AddTable[7,7] := Add_7_7;
  AddTable[7,8] := Add_7_8;
  AddTable[7,9] := Add_7_9;
  AddTable[8,0] := Add_8_0;
  AddTable[8,1] := Add_8_1;
  AddTable[8,2] := Add_8_2;
  AddTable[8,3] := Add_8_3;
  AddTable[8,4] := Add_8_4;
  AddTable[8,5] := Add_8_5;
  AddTable[8,6] := Add_8_6;
  AddTable[8,7] := Add_8_7;
  AddTable[8,8] := Add_8_8;
  AddTable[8,9] := Add_8_9;
  AddTable[9,0] := Add_9_0;
  AddTable[9,1] := Add_9_1;
  AddTable[9,2] := Add_9_2;
  AddTable[9,3] := Add_9_3;
  AddTable[9,4] := Add_9_4;
  AddTable[9,5] := Add_9_5;
  AddTable[9,6] := Add_9_6;
  AddTable[9,7] := Add_9_7;
  AddTable[9,8] := Add_9_8;
  AddTable[9,9] := Add_9_9;
end;

function AddPrimitive(P1,P2: TPrimitive): TCalcRes;
begin
  Result := AddTable[Ord(P1) - Ord(Prime_Zero), Ord(P2) - Ord(Prime_Zero)];
end;

function AddN(N1, N2: TValue): TValue;
var
  i: Integer;
  CalcRes: TCalcRes;
  Temp: TPrimitive;
  MustCarry: OPBool;

begin
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('AddN: N1=',N1,' N2=',N2);
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  if IsTrueComplex(IsTrue(IsNegativeN(N1)),IsTrue(IsNegativeN(N2))) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('-x + -y = -(x+y)');
    Result := MakeNegativeN(AddN(MakeNegativeN(N1), MakeNegativeN(N2)));
    Exit;
  end;
  if IsTrue(IsNegativeN(N2)) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('x + -y = x - y');
    Result := SubN(N1,MakenegativeN(N2));
    Exit;
  end;
  if IsTrue(IsNegativeN(N1)) then
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('-x + y = y - x');
    Result := SuBN(N2,MakeNegativeN(N1));
    Exit;
  end;
  //both positive numbers
  N1 := NormalizeNumberN(N1);
  N2 := NormalizeNumberN(N2);
  //pad with zero's
  while IsTrue(Length(N1) < Length(N2)) do N1 := Prime_Zero + N1;
  while IsTrue(Length(N1) > Length(N2)) do N2 := Prime_Zero + N2;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('After padding:');
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('N1: ',N1);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('N2: ',N2);
  Result := '';
  CalcRes.Carry := Prime_Zero;
  CalcRes.Value := Prime_Zero;
  for i := Length(N1) downto 1 do
  begin
    MustCarry := HasCarry(CalcRes);
    CalcRes := AddPrimitive(N1[i], N2[i]);
    Temp := CalcRes.Value;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N1[i],' + ',N2[i],' -> Value: ',temp,' Carry: ',CalcRes.Carry,' MustCarry: ',MustCarry);
    if IsTrue(MustCarry) then
    begin
      IncPrimitive(Temp);
      //can only happen if current carry = 0
      if IsTrue(Temp = Prime_Zero) then
      begin
        CalcRes.Carry := '1';
        MustCarry := ToBool(True);
      end;
    end;
    Result := Temp + Result;
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Result = ',Result);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Carry left = ',HasCarry(CalcRes));
  if IsTrue(HasCarry(CalcRes)) then
  begin
    Result := '1' + Result;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Result = ',Result);
  end;
end;

procedure IncPrimitive(var P: TPrimitive; V: TPrimitive);
var
  CalcRes: TCalcRes;
begin
  AssertIsPrimitive(P);
  AssertIsPrimitive(V);
  CalcRes := AddPrimitive(P, V);
  P := CalcRes.Value;
end;



//keep at end of include file to fool codetools
procedure addsubfoolct;
begin
end;
