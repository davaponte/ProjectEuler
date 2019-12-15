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


function IsNumberN(N: TValue): OPBool;
var
  i: Integer;
begin
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('IsNumber: N = ',N);
  Result := ToBool(False);
  //First remove all leading (but allowed) "garbage"
  N := NormalizeNumberN(N, False);
  If IsTrue(Length(N) = 0) then Exit;
  for i := 1 to Length(N) do
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('N[',i,'] = ',N[i]);
    if IsFalse(Ord(N[i]) >= Ord(Prime_Zero)) or IsFalse(Ord(N[i]) <= Ord(Prime_Last)) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N[i],' < 0 or > 9');
      if IsFalse(IsTrueComplex(IsTrue(i=1),IsTrue(N[i] = Prime_Negative))) then
      begin
        //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N[i],' <> "-" or ',i,' <> 1 [',IsFalse(i=1),'/',IsFalse(N[i] = Prime_Negative),']');
        Exit;
      end
      else
      begin
        //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N[i],' = "-" and ',i,' = 1 [',IsFalse(i=1),'/',IsFalse(N[i] = Prime_Negative),']');
      end;
    end
    else
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N[i],' > 0 or < 9');
    end;
  end;
  Result := ToBool(True);
end;

function IsZeroN(N: TValue): OPBool;
begin
  AssertIsNumberN(N);
  N := NormalizeNumberN(N);
  Result := IsTrue(Length(N) = 1) and IsTrue(N[1] = Prime_Zero);
end;

function IsPrimitiveN(N: TValue): OPBool;
begin
  AssertIsNumberN(N);
  N := NormalizeNumberN(N);
  Result := IsTrue(MoreN(N, '-1')) and IsTrue(LessN(N, '10'));
end;

function OddN(N: TValue): OPBool;
var
  AMod: TValue;
begin
  AssertIsNumberN(N);
  DivModN(N, '2', AMod);
  Result := IsFalse(IsZeroN(AMod));
end;

function NormalizeNumberN(N: TValue; DoAssertIsNumber: OPBool): TValue;
var
  Len: Integer;
  IsNeg: Boolean;
begin
  if DoAssertIsNumber then AssertIsNumberN(N);
  N := Trim(N);
  IsNeg := False;
  Len := Length(N);
  while IsTrue(Len > 0) do
  begin
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Len = ',Len,' N = ',N,' IsNeg = ',IsNeg);
    if IsTrue(N[1] = Prime_Negative) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Found "-"');
      IsNeg := not IsNeg;
      {if IsFalse(Len = 1) then} System.Delete(N,1,1);
    end
    else if IsTrue(N[1] = Prime_Positive) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Found "+"');
      System.Delete(N,1,1);
    end
    else
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Not "-" or "+"');
      Break;
    end;
    Len := Length(N);
  end;
  Len := Length(N);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('After processing +/-: N = ',N,' Len = ',Len);
  //Remove trailing Zero's
  while IsTrue(Len > 0) do
  begin
    if IsTrue(N[1] = Prime_Zero) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('N[1] = ',N[1],' = 0');
      System.Delete(N,1,1);
      Dec(Len);
    end
    else Break;
  end;
  if IsNeg then
  begin
    if IsFalse(Len = 0) then
      N := Prime_Negative + N;
  end;
  If IsTrue(Length(N) = 0) then N := Prime_Zero;
  Result := N;
end;

function NumberToPrimitiveN(N: TValue): TPrimitive;
begin
  AssertIsNumberN(N);
  if IsFalse(IsPrimitiveN(N)) then RaiseEPrimitiveRangeCheckError(N);
  Result := N[1];
end;

function IsNegativeN(N: TValue): OPBool;
begin
  Result := IsTrue(IsNumberN(N));
  if IsTrue(Result) then
  begin
    N := NormalizeNumberN(N);
    Result := IsTrueComplex(IsTrue(Length(N) > 0), IsTrue(N[1] = Prime_Negative));
  end;
end;

function HasCarry(ACalcRes: TCalcRes): OPBool;
begin
  Result := IsFalse(ACalcRes.Carry = Prime_Zero);
end;

function MaxN(N1, N2: TValue): TValue;
var
  IsNeg: OPBool;
  _N1, _N2, SubRes: TValue;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  //First easy shortcuts
  if IsTrue(IsNegativeN(N1)) and IsFalse(IsNegativeN(N2)) then Exit(N2);
  if IsFalse(IsNegativeN(N1)) and IsTrue(IsNegativeN(N2)) then Exit(N1);
  //Both have same sign so MoreN work is needed
  _N1 := NormalizeNumberN(N1);
  _N2 := NormalizeNumberN(N2);
  IsNeg := IsTrue(IsNegativeN(_N1));
  if IsTrue(IsNeg) then
  begin
    //remove sign
    System.Delete(_N1,1,1);
    System.Delete(_N2,1,1);
  end;
  SubRes := SubN(_N1, _N2);
  if IsFalse(IsNegativeN(SubRes)) then
  begin
    if IsZeroN(SubRes) then
    //special case: N1 = N2: return randomly N1 or N2
    begin
      if Random < 0.5 then
        Result := N1
      else
        Result := N2;
      Exit;
    end;
    if IsFalse(IsNeg) then
      Result := N1
    else
      Result := N2;
  end
  else
  begin
    if IsFalse(IsNeg) then
      Result := N2
    else
      Result := N1;
  end;

end;

function MinN(N1, N2: TValue): TValue;
var
  IsNeg: OPBool;
  _N1, _N2, SubRes: TValue;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  //First easy shortcuts
  if IsTrue(IsNegativeN(N1)) and IsFalse(IsNegativeN(N2)) then Exit(N1);
  if IsFalse(IsNegativeN(N1)) and IsTrue(IsNegativeN(N2)) then Exit(N2);
  //Both have same sign so MoreN work is needed
  _N1 := NormalizeNumberN(N1);
  _N2 := NormalizeNumberN(N2);
  IsNeg := IsTrue(IsNegativeN(_N1));
  if IsTrue(IsNeg) then
  begin
    //remove sign
    System.Delete(_N1,1,1);
    System.Delete(_N2,1,1);
  end;
  SubRes := SubN(_N1, _N2);
  if IsFalse(IsNegativeN(SubRes)) then
  begin
    if IsZeroN(SubRes) then
    //special case: N1 = N2: return randomly N1 or N2
    begin
      if Random < 0.5 then
        Result := N2
      else
        Result := N1;
      Exit;
    end;
    if IsFalse(IsNeg) then
      Result := N2
    else
      Result := N1;
  end
  else
  begin
    if IsFalse(IsNeg) then
      Result := N1
    else
      Result := N2;
  end;
end;


function MakeNegativeN(N: TValue): TValue;
begin
  AssertIsNumberN(N);
  N := NormalizeNumberN(N);
  if IsTrue(IsNegativeN(N)) then
    System.Delete(N,1,1)
  else
    if IsFalse(IsZeroN(N)) then
      N := Prime_Negative + N;
  Result := N;
end;

function AbsN(N: TValue): TValue;
begin
  AssertIsNumberN(N);
  N := NormalizeNumberN(N);
  if IsTrue(IsNegativeN(N)) then
    System.Delete(N,1,1);
  Result := N;
end;

function EqualsN(N1, N2: TValue): OPBool;
var
  SubRes: TValue;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  SubRes := SubN(N1, N2);
  Result := IsTrue(IsZeroN(SubRes));
end;

function EqualsP(P1, P2: TPrimitive): OPBool;
begin
  AssertIsPrimitive(P1);
  AssertIsPrimitive(P2);
  DecPrimitive(P1, P2);
  Result := IsTrue(P1 = Prime_Zero);
end;

function LessN(N1, N2: TValue): OPBool;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  Result := IsTrue(IsNegativeN(SubN(N1, N2)));
end;

function MoreN(N1, N2: TValue): OPBool;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  Result := IsTrue(IsNegativeN(SubN(N2, N1)));
end;


procedure SwapN(var N1, N2: TValue);
var
  TempN: TValue;
begin
  AssertIsNumberN(N1);
  AssertIsNumberN(N2);
  TempN := N1;
  N1 := N2;
  N2 := TempN;
end;

type
  TDecimal = array['0'..'9'] of TPrimitive;

const
  Decimals: TDecimal = ('0','1','2','3','4','5','6','7','8','9');
  //These are the first 258 decimals of Pi.
  //It has been proven that these are truely random
  PiDecimals = '14159265358979323846264338327950' +
               '28841971693993751058209749445923' +
               '07816406286208998628034825342117' +
               '06798214808651328230664709384460' +
               '95505822317253594081284811174502' +
               '84102701938521105559644622948954' +
               '93038196442881097566593344612847' +
               '56482337867831652712019091456485' +
               '66';

               {  923460348610454326648213393607
                26024914127372458700660631558817
                48815209209628292540917153643678
                92590360011330530548820466521384
                14695194151160943305727036575959
                19530921861173819326117931051185
                48074462379962749567351885752724
                89122793818301194912983367336244
                06566430860213949463952247371907
                02179860943702770539217176293176
                75238467481846766940513200056812
                71452635608277857713427577896091
                73637178721468440901224953430146
                54958537105079227968925892354201
                99561121290219608640344181598136
                29774771309960518707211349999998
                37297804995105973173281609631859
                50244594553469083026425223082533
                44685035261931188171010003137838
                75288658753320838142061717766914
                73035982534904287554687311595628
                63882353787593751957781857780532
                17122680661300192787661119590921
                64201989380952572010654858632788}

function RandomDigit: TPrimitive;
var
  RandByte: Byte;
begin
  //Improve on System.Random function to get better randomness:
  RandByte := 1 + (Integer(Integer(Random(256)) * Random(256)) div 255);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('RandomDigit: RandByte = ',RandByte);
  Result := Decimals[PiDecimals[RandByte]];
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('RandomDigit: Result = ',Result);
end;

function RandomN(N: TPositiveValue): TValue;
var
  FirstDigit: TPrimitive;
  i: Integer;
begin
  AssertIsPositiveN(N);
  if IsTrue(IsZeroN(N)) then
  begin
    Result := Prime_Zero;
    Exit;
  end;
  N := NormalizeNumberN(N);
  Result := N;
  FirstDigit := N[1];  //can only be '0' if IsZeroN(N)
  for i := 1 to Length(Result) do Result[i] := RandomDigit;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('RandomN: Intermediate result = ',Result);
  while IsTrue(MoreN(Result, N)) and IsFalse(IsZeroN(FirstDigit)) do
  begin
    DecPrimitive(FirstDigit);
    Result[1] := FirstDigit;
  end;
  Result := NormalizeNumberN(Result);
end;

function RandomRangeN(N1, N2: TPositiveValue): TValue;
var
  Diff, ToAdd: TValue;
begin
  AssertIsPositiveN(N1);
  AssertIsPositiveN(N2);
  if MoreN(N1, N2) then SwapN(N1, N2);
  Diff := SubN(N2, N1);
  ToAdd := RandomN(Diff);
  Result := AddN(N1, ToAdd);
end;

function _FibN(N: TPositiveValue): TPositiveValue;
var
  N1, N2: TPositiveValue;
begin
  AssertIsPositiveN(N);
  if IsZeroN(N) then
    RaiseENumberRangeCheckError(N);
  //writeln('FibN: N = ',N);
  if IsTrue(EqualsN(N, '1')) or IsTrue(EqualsN(N, '2')) then
    Result := '1'
  else
  begin
    N1 := FibN(SubN(N, '1'));
    N2 := FibN(SubN(N, '2'));
    Result :=  AddN(N1, N2);
  end;
  //writeln('FibN(',N,') = ',Result);
end;


{
FibN(1) = 1
FibN(2) = 1
FibN(N, N>2) = FibN(N-2) + FibN(N-1)
FibN('1000') = '43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875'
}
function FibN(N: TPositiveValue): TPositiveValue;
begin
  AssertIsPositiveN(N);
  if IsZeroN(N) then
    RaiseENumberRangeCheckError(N);
  Result := LucasGenN('1','1',N);
end;

{
LucasN(1) = 2
LucasN(2) = 1
LucasN(N, N>2) = LucasN(N-2) + LucasN(N-1)
The first 36 Lucas numbers are:
[2,1,3,4,7,11,18,29,47,76,123,199,322,521,843,
 1364,2207,3571,5778,9349,15127,24476,39603,64079,
 103682,167761,271443,439204,710647,1149851,
 1860498,3010349,4870847,7881196,12752043,20633239,
 33385282]}
function LucasN(N: TPositiveValue): TPositiveValue;
var
  i, LucMin1, LucMin2: TPositiveValue;
begin
  AssertIsPositiveN(N);
  if IsZeroN(N) then
    RaiseENumberRangeCheckError(N);
  Result := LucasGenN('2','1',N);
end;

function LucasGenN(L1, L2, N: TPositiveValue): TPositiveValue;
var
  i, LucMin1, LucMin2: TPositiveValue;
begin
  AssertIsPositiveN(L1);
  AssertIsPositiveN(L2);
  AssertIsPositiveN(N);
  if IsZeroN(N) then
    RaiseENumberRangeCheckError(N);
  //writeln('FibN: N = ',N);
  if IsTrue(EqualsN(N, '1')) then
  begin
    Result := L1;
  end
  else if IsTrue(EqualsN(N, '2')) then
  begin
    Result := L2;
  end
  else
  begin
    LucMin1 := L2;
    LucMin2 := L1;
    i := '2';
    while IsFalse(EqualsN(i, N)) do
    begin
      i := AddN(i, '1');
      Result := AddN(LucMin2, LucMin1);
      //writeln('LucasN: i = ',i,' LucMin2 = ',LucMin2:6,' LucMin1 = ',LucMin1:6,' Result = ',Result:6);
      LucMin2 := LucMin1;
      LucMin1 := Result;
    end;
  end;
  //writeln('FibN(',N,') = ',Result);
end;

// ********************* Conversion routines **************************
const
  BaseFirst = 1;
  BaseLast = 128;
  HexBase_Exp_1 = '16';
  HexBase_Exp_2 = '256';
  HexBase_Exp_3 = '4096';
  HexBase_Exp_4 = '65536';
  HexBase_Exp_5 = '1048576';
  HexBase_Exp_6 = '16777216';
  HexBase_Exp_7 = '268435456';
  HexBase_Exp_8 = '4294967296';
  HexBase_Exp_9 = '68719476736';
  HexBase_Exp_10 = '1099511627776';
  HexBase_Exp_11 = '17592186044416';
  HexBase_Exp_12 = '281474976710656';
  HexBase_Exp_13 = '4503599627370496';
  HexBase_Exp_14 = '72057594037927936';
  HexBase_Exp_15 = '1152921504606846976';
  HexBase_Exp_16 = '18446744073709551616';
  HexBase_Exp_17 = '295147905179352825856';
  HexBase_Exp_18 = '4722366482869645213696';
  HexBase_Exp_19 = '75557863725914323419136';
  HexBase_Exp_20 = '1208925819614629174706176';
  HexBase_Exp_21 = '19342813113834066795298816';
  HexBase_Exp_22 = '309485009821345068724781056';
  HexBase_Exp_23 = '4951760157141521099596496896';
  HexBase_Exp_24 = '79228162514264337593543950336';
  HexBase_Exp_25 = '1267650600228229401496703205376';
  HexBase_Exp_26 = '20282409603651670423947251286016';
  HexBase_Exp_27 = '324518553658426726783156020576256';
  HexBase_Exp_28 = '5192296858534827628530496329220096';
  HexBase_Exp_29 = '83076749736557242056487941267521536';
  HexBase_Exp_30 = '1329227995784915872903807060280344576';
  HexBase_Exp_31 = '21267647932558653966460912964485513216';
  HexBase_Exp_32 = '340282366920938463463374607431768211456';
  HexBase_Exp_33 = '5444517870735015415413993718908291383296';
  HexBase_Exp_34 = '87112285931760246646623899502532662132736';
  HexBase_Exp_35 = '1393796574908163946345982392040522594123776';
  HexBase_Exp_36 = '22300745198530623141535718272648361505980416';
  HexBase_Exp_37 = '356811923176489970264571492362373784095686656';
  HexBase_Exp_38 = '5708990770823839524233143877797980545530986496';
  HexBase_Exp_39 = '91343852333181432387730302044767688728495783936';
  HexBase_Exp_40 = '1461501637330902918203684832716283019655932542976';
  HexBase_Exp_41 = '23384026197294446691258957323460528314494920687616';
  HexBase_Exp_42 = '374144419156711147060143317175368453031918731001856';
  HexBase_Exp_43 = '5986310706507378352962293074805895248510699696029696';
  HexBase_Exp_44 = '95780971304118053647396689196894323976171195136475136';
  HexBase_Exp_45 = '1532495540865888858358347027150309183618739122183602176';
  HexBase_Exp_46 = '24519928653854221733733552434404946937899825954937634816';
  HexBase_Exp_47 = '392318858461667547739736838950479151006397215279002157056';
  HexBase_Exp_48 = '6277101735386680763835789423207666416102355444464034512896';
  HexBase_Exp_49 = '100433627766186892221372630771322662657637687111424552206336';
  HexBase_Exp_50 = '1606938044258990275541962092341162602522202993782792835301376';
  HexBase_Exp_51 = '25711008708143844408671393477458601640355247900524685364822016';
  HexBase_Exp_52 = '411376139330301510538742295639337626245683966408394965837152256';
  HexBase_Exp_53 = '6582018229284824168619876730229402019930943462534319453394436096';
  HexBase_Exp_54 = '105312291668557186697918027683670432318895095400549111254310977536';
  HexBase_Exp_55 = '1684996666696914987166688442938726917102321526408785780068975640576';
  HexBase_Exp_56 = '26959946667150639794667015087019630673637144422540572481103610249216';
  HexBase_Exp_57 = '431359146674410236714672241392314090778194310760649159697657763987456';
  HexBase_Exp_58 = '6901746346790563787434755862277025452451108972170386555162524223799296';
  HexBase_Exp_59 = '110427941548649020598956093796432407239217743554726184882600387580788736';
  HexBase_Exp_60 = '1766847064778384329583297500742918515827483896875618958121606201292619776';
  HexBase_Exp_61 = '28269553036454149273332760011886696253239742350009903329945699220681916416';
  HexBase_Exp_62 = '452312848583266388373324160190187140051835877600158453279131187530910662656';
  HexBase_Exp_63 = '7237005577332262213973186563042994240829374041602535252466099000494570602496';
  HexBase_Exp_64 = '115792089237316195423570985008687907853269984665640564039457584007913129639936';
  HexBase_Exp_65 = '1852673427797059126777135760139006525652319754650249024631321344126610074238976';
  HexBase_Exp_66 = '29642774844752946028434172162224104410437116074403984394101141506025761187823616';
  HexBase_Exp_67 = '474284397516047136454946754595585670566993857190463750305618264096412179005177856';
  HexBase_Exp_68 = '7588550360256754183279148073529370729071901715047420004889892225542594864082845696';
  HexBase_Exp_69 = '121416805764108066932466369176469931665150427440758720078238275608681517825325531136';
  HexBase_Exp_70 = '1942668892225729070919461906823518906642406839052139521251812409738904285205208498176';
  HexBase_Exp_71 = '31082702275611665134711390509176302506278509424834232340028998555822468563283335970816';
  HexBase_Exp_72 = '497323236409786642155382248146820840100456150797347717440463976893159497012533375533056';
  HexBase_Exp_73 = '7957171782556586274486115970349133441607298412757563479047423630290551952200534008528896';
  HexBase_Exp_74 = '127314748520905380391777855525586135065716774604121015664758778084648831235208544136462336';
  HexBase_Exp_75 = '2037035976334486086268445688409378161051468393665936250636140449354381299763336706183397376';
  HexBase_Exp_76 = '32592575621351777380295131014550050576823494298654980010178247189670100796213387298934358016';
  HexBase_Exp_77 = '521481209941628438084722096232800809229175908778479680162851955034721612739414196782949728256';
  HexBase_Exp_78 = '8343699359066055009355553539724812947666814540455674882605631280555545803830627148527195652096';
  HexBase_Exp_79 = '133499189745056880149688856635597007162669032647290798121690100488888732861290034376435130433536';
  HexBase_Exp_80 = '2135987035920910082395021706169552114602704522356652769947041607822219725780640550022962086936576';
  HexBase_Exp_81 = '34175792574734561318320347298712833833643272357706444319152665725155515612490248800367393390985216';
  HexBase_Exp_82 = '546812681195752981093125556779405341338292357723303109106442651602488249799843980805878294255763456';
  HexBase_Exp_83 = '8749002899132047697490008908470485461412677723572849745703082425639811996797503692894052708092215296';
  HexBase_Exp_84 = '139984046386112763159840142535527767382602843577165595931249318810236991948760059086304843329475444736';
  HexBase_Exp_85 = '2239744742177804210557442280568444278121645497234649534899989100963791871180160945380877493271607115776';
  HexBase_Exp_86 = '35835915874844867368919076489095108449946327955754392558399825615420669938882575126094039892345713852416';
  HexBase_Exp_87 = '573374653997517877902705223825521735199141247292070280934397209846730719022121202017504638277531421638656';
  HexBase_Exp_88 = '9173994463960286046443283581208347763186259956673124494950355357547691504353939232280074212440502746218496';
  HexBase_Exp_89 = '146783911423364576743092537299333564210980159306769991919205685720763064069663027716481187399048043939495936';
  HexBase_Exp_90 = '2348542582773833227889480596789337027375682548908319870707290971532209025114608443463698998384768703031934976';
  HexBase_Exp_91 = '37576681324381331646231689548629392438010920782533117931316655544515344401833735095419183974156299248510959616';
  HexBase_Exp_92 = '601226901190101306339707032778070279008174732520529886901066488712245510429339761526706943586500787976175353856';
  HexBase_Exp_93 = '9619630419041620901435312524449124464130795720328478190417063819395928166869436184427311097384012607618805661696';
  HexBase_Exp_94 = '153914086704665934422965000391185991426092731525255651046673021110334850669910978950836977558144201721900890587136';
  HexBase_Exp_95 = '2462625387274654950767440006258975862817483704404090416746768337765357610718575663213391640930307227550414249394176';
  HexBase_Exp_96 = '39402006196394479212279040100143613805079739270465446667948293404245721771497210611414266254884915640806627990306816';
  HexBase_Exp_97 = '630432099142311667396464641602297820881275828327447146687172694467931548343955369782628260078158650252906047844909056';
  HexBase_Exp_98 = '10086913586276986678343434265636765134100413253239154346994763111486904773503285916522052161250538404046496765518544896';
  HexBase_Exp_99 = '161390617380431786853494948250188242145606612051826469551916209783790476376052574664352834580008614464743948248296718336';
  HexBase_Exp_100 = '2582249878086908589655919172003011874329705792829223512830659356540647622016841194629645353280137831435903171972747493376';
  HexBase_Exp_101 = '41315998049390537434494706752048189989275292685267576205290549704650361952269459114074325652482205302974450751563959894016';
  HexBase_Exp_102 = '661055968790248598951915308032771039828404682964281219284648795274405791236311345825189210439715284847591212025023358304256';
  HexBase_Exp_103 = '10576895500643977583230644928524336637254474927428499508554380724390492659780981533203027367035444557561459392400373732868096';
  HexBase_Exp_104 = '169230328010303641331690318856389386196071598838855992136870091590247882556495704531248437872567112920983350278405979725889536';
  HexBase_Exp_105 = '2707685248164858261307045101702230179137145581421695874189921465443966120903931272499975005961073806735733604454495675614232576';
  HexBase_Exp_106 = '43322963970637732180912721627235682866194329302747133987038743447103457934462900359999600095377180907771737671271930809827721216';
  HexBase_Exp_107 = '693167423530203714894603546035770925859109268843954143792619895153655326951406405759993601526034894524347802740350892957243539456';
  HexBase_Exp_108 = '11090678776483259438313656736572334813745748301503266300681918322458485231222502492159897624416558312389564843845614287315896631296';
  HexBase_Exp_109 = '177450860423732151013018507785157357019931972824052260810910693159335763699560039874558361990664932998233037501529828597054346100736';
  HexBase_Exp_110 = '2839213766779714416208296124562517712318911565184836172974571090549372219192960637992933791850638927971728600024477257552869537611776';
  HexBase_Exp_111 = '45427420268475430659332737993000283397102585042957378767593137448789955507087370207886940669610222847547657600391636120845912601788416';
  HexBase_Exp_112 = '726838724295606890549323807888004534353641360687318060281490199180639288113397923326191050713763565560762521606266177933534601628614656';
  HexBase_Exp_113 = '11629419588729710248789180926208072549658261770997088964503843186890228609814366773219056811420217048972200345700258846936553626057834496';
  HexBase_Exp_114 = '186070713419675363980626894819329160794532188335953423432061490990243657757029868371504908982723472783555205531204141550984858016925351936';
  HexBase_Exp_115 = '2977131414714805823690030317109266572712515013375254774912983855843898524112477893944078543723575564536883288499266264815757728270805630976';
  HexBase_Exp_116 = '47634102635436893179040485073748265163400240214004076398607741693502376385799646303105256699577209032590132615988260237052123652332890095616';
  HexBase_Exp_117 = '762145642166990290864647761179972242614403843424065222377723867096038022172794340849684107193235344521442121855812163792833978437326241529856';
  HexBase_Exp_118 = '12194330274671844653834364178879555881830461494785043558043581873536608354764709453594945715091765512343073949692994620685343654997219864477696';
  HexBase_Exp_119 = '195109284394749514461349826862072894109287383916560696928697309976585733676235351257519131441468248197489183195087913930965498479955517831643136';
  HexBase_Exp_120 = '3121748550315992231381597229793166305748598142664971150859156959625371738819765620120306103063491971159826931121406622895447975679288285306290176';
  HexBase_Exp_121 = '49947976805055875702105555676690660891977570282639538413746511354005947821116249921924897649015871538557230897942505966327167610868612564900642816';
  HexBase_Exp_122 = '799167628880894011233688890827050574271641124522232614619944181664095165137859998750798362384253944616915694367080095461234681773897801038410285056';
  HexBase_Exp_123 = '12786682062094304179739022253232809188346257992355721833919106906625522642205759980012773798148063113870651109873281527379754908382364816614564560896';
  HexBase_Exp_124 = '204586912993508866875824356051724947013540127877691549342705710506008362275292159680204380770369009821930417757972504438076078534117837065833032974336';
  HexBase_Exp_125 = '3273390607896141870013189696827599152216642046043064789483291368096133796404674554883270092325904157150886684127560071009217256545885393053328527589376';
  HexBase_Exp_126 = '52374249726338269920211035149241586435466272736689036631732661889538140742474792878132321477214466514414186946040961136147476104734166288853256441430016';
  HexBase_Exp_127 = '837987995621412318723376562387865382967460363787024586107722590232610251879596686050117143635431464230626991136655378178359617675746660621652103062880256';
  HexBase_Exp_128 = '13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084096';


{

}

Type
  THexArray = Array[BaseFirst..BaseLast] of TValue;

const
  HexArray: THexArray =
    (
      HexBase_Exp_1, HexBase_Exp_2, HexBase_Exp_3, HexBase_Exp_4,
      HexBase_Exp_5, HexBase_Exp_6, HexBase_Exp_7, HexBase_Exp_8,
      HexBase_Exp_9, HexBase_Exp_10, HexBase_Exp_11, HexBase_Exp_12,
      HexBase_Exp_13, HexBase_Exp_14, HexBase_Exp_15, HexBase_Exp_16,
      HexBase_Exp_17, HexBase_Exp_18, HexBase_Exp_19, HexBase_Exp_20,
      HexBase_Exp_21, HexBase_Exp_22, HexBase_Exp_23, HexBase_Exp_24,
      HexBase_Exp_25, HexBase_Exp_26, HexBase_Exp_27, HexBase_Exp_28,
      HexBase_Exp_29, HexBase_Exp_30, HexBase_Exp_31, HexBase_Exp_32,
      HexBase_Exp_33, HexBase_Exp_34, HexBase_Exp_35, HexBase_Exp_36,
      HexBase_Exp_37, HexBase_Exp_38, HexBase_Exp_39, HexBase_Exp_40,
      HexBase_Exp_41, HexBase_Exp_42, HexBase_Exp_43, HexBase_Exp_44,
      HexBase_Exp_45, HexBase_Exp_46, HexBase_Exp_47, HexBase_Exp_48,
      HexBase_Exp_49, HexBase_Exp_50, HexBase_Exp_51, HexBase_Exp_52,
      HexBase_Exp_53, HexBase_Exp_54, HexBase_Exp_55, HexBase_Exp_56,
      HexBase_Exp_57, HexBase_Exp_58, HexBase_Exp_59, HexBase_Exp_60,
      HexBase_Exp_61, HexBase_Exp_62, HexBase_Exp_63, HexBase_Exp_64,
      HexBase_Exp_65, HexBase_Exp_66, HexBase_Exp_67, HexBase_Exp_68,
      HexBase_Exp_69, HexBase_Exp_70, HexBase_Exp_71, HexBase_Exp_72,
      HexBase_Exp_73, HexBase_Exp_74, HexBase_Exp_75, HexBase_Exp_76,
      HexBase_Exp_77, HexBase_Exp_78, HexBase_Exp_79, HexBase_Exp_80,
      HexBase_Exp_81, HexBase_Exp_82, HexBase_Exp_83, HexBase_Exp_84,
      HexBase_Exp_85, HexBase_Exp_86, HexBase_Exp_87, HexBase_Exp_88,
      HexBase_Exp_89, HexBase_Exp_90, HexBase_Exp_91, HexBase_Exp_92,
      HexBase_Exp_93, HexBase_Exp_94, HexBase_Exp_95, HexBase_Exp_96,
      HexBase_Exp_97, HexBase_Exp_98, HexBase_Exp_99, HexBase_Exp_100,
      HexBase_Exp_101, HexBase_Exp_102, HexBase_Exp_103, HexBase_Exp_104,
      HexBase_Exp_105, HexBase_Exp_106, HexBase_Exp_107, HexBase_Exp_108,
      HexBase_Exp_109, HexBase_Exp_110, HexBase_Exp_111, HexBase_Exp_112,
      HexBase_Exp_113, HexBase_Exp_114, HexBase_Exp_115, HexBase_Exp_116,
      HexBase_Exp_117, HexBase_Exp_118, HexBase_Exp_119, HexBase_Exp_120,
      HexBase_Exp_121, HexBase_Exp_122, HexBase_Exp_123, HexBase_Exp_124,
      HexBase_Exp_125, HexBase_Exp_126, HexBase_Exp_127, HexBase_Exp_128
    );


function DigitToHex(N: TValue): Char;
begin
  case N of
    '0': Result := '0';
    '1': Result := '1';
    '2': Result := '2';
    '3': Result := '3';
    '4': Result := '4';
    '5': Result := '5';
    '6': Result := '6';
    '7': Result := '7';
    '8': Result := '8';
    '9': Result := '9';
    '10': Result := 'A';
    '11': Result := 'B';
    '12': Result := 'C';
    '13': Result := 'D';
    '14': Result := 'E';
    '15': Result := 'F';
    else RaiseENumberRangeCheckError(N);
  end;
end;


{
50 recursive calls to InternalNumToHexN will allow for Numbers up to 16 ^ 50 * HexBase_Exp_128
and this should still fit into the stack...
}
function InternalNumToHexN(N: TPositiveValue; RecurseCounter: TValue; CallBack: TCalcFeedbackEvent = nil): String;
var
  Base, DivRes, ModRes, _N: TValue;
  StartAt, i: Integer;
begin
  AssertIsPositiveN(N);
  N := NormalizeNumberN(N);
  _N := N;
  Result := '';
  StartAt := BaseLast;
  for i := BaseFirst to BaseLast do
  begin
    if IsTrue(LessN(N, HexArray[i])) then
    begin
      StartAt := i - 1;
      if IsTrue(StartAt = 0) then StartAt := 1;
      Break;
    end;
  end;

  //StartAt := 1;    //uncomment for bugtracking recursive calls

  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN(',N,'): ');
  if IsFalse(IsZeroN(RecurseCounter)) then if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  RecurseCounter = ',RecurseCounter);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  N = ',N);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  StartAt = ',StartAt);
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  HexArray[',StartAt,'] = ',HexArray[StartAt]);
  for i := StartAt downto BaseFirst do
  begin
    Base := HexArray[i];
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN: Base = ',Base,' N = ',N);
    DivRes := DivModN(N, Base, ModRes);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN: DivRes = ',DivRes,' ModRes = ',ModRes);

    if IsTrue(LessN('15', DivRes)) then
    begin
      //????
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN: DivRes >= 16 !!: ',DivRes);
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('Calling NumberToHex(',DivRes,')');
      N := ModRes;

      //ModRes := Prime_Zero;

      Result := InternalNumToHexN(DivRes, AddN(RecurseCounter, '1'), CallBack) + Result;
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN(',_N,') after recursive call, back to RecurseCounter = ',RecurseCounter);

      //Result := '?';
      //Exit;
    end
    else
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('NumberToHexN:  HexDigit(',DivRes,') =  '); if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(DigitToHex(DivRes));
      Result := Result + DigitToHex(DivRes);
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN: Result = ',Result);
      N := ModRes;
    end;


    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('i = ',i,' NumberToHexN: ModRes = ',ModRes);
    if (i=1) then if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('i = 1: Result = ',Result, ' -> ');
    if (i=1) then Result := Result + DigitToHex(ModRes);
    if (i=1) then if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN: Result = ',Result);
    while IsTrue(Length(Result) > 1) and IsTrue(Result[1] = '0') do
    begin
      System.Delete(Result, 1, 1);
    end;
  end;
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToHexN(',_N,') End: RecurseCounter = ',RecurseCounter,' Result = ',Result);
end;

function NumberToHexN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): String;
begin
  Result := InternalNumToHexN(N, Prime_Zero, CallBack);
end;

function HexCharToBin(Ch: Char): String;
begin
  case Ch of
    '0': Result := '0000';
    '1': Result := '0001';
    '2': Result := '0010';
    '3': Result := '0011';
    '4': Result := '0100';
    '5': Result := '0101';
    '6': Result := '0110';
    '7': Result := '0111';
    '8': Result := '1000';
    '9': Result := '1001';
    'A': Result := '1010';
    'B': Result := '1011';
    'C': Result := '1100';
    'D': Result := '1101';
    'E': Result := '1110';
    'F': Result := '1111';
    else RaiseENumberRangeCheckError(Ch);
  end;
end;

function NumberToBinN(N: TPositiveValue; CallBack: TCalcFeedbackEvent): String;
var
  Hex: TValue;
  Ch: Char;
begin
  AssertIsPositiveN(N);
  N := NormalizeNumberN(N);
  Result := '';
  Hex := TValue(NumberToHexN(N));
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToBinN: Hex = ',Hex);
  while IsTrue(Length(Hex) > 0) do
  begin
    Ch := UpCase(Hex[Length(Hex)]);
    Result := HexCharToBin(Ch) + Result;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToBinN: Intermediate result := ',Result);
    if Assigned(CallBack) then CallBack('NumberToBinN: Intermediate result := ' + Result, True);
    System.Delete(Hex, Length(Hex), 1);
  end;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToBinN End.');
end;

function BinToDigit(Ch: Char): TValue;
begin
  Case Ch of
     '0': Result := '0';
     '1': Result := '1';
    else RaiseENumberRangeCheckError(Ch);
  end;
end;

function BinQuartetToNumber(S: String): TValue;
var
  Count, N: TValue;
  Digit: Char;
begin
  Count := Prime_Zero;
  Result := Prime_Zero;
  while IsFalse(Length(S) = 0) do
  begin
    Digit := S[Length(S)];
    System.Delete(S, Length(S), 1);
    N := BinToDigit(Digit);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('BinQuart: Digit = ',Digit,' Count = ',Count,' BinToDigit(',Digit,') = ',N);
    if IsFalse(IsZeroN(Count)) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('BinQuart: MulN(',N,'ExpN(','2',',',Count,')) = ');
      N := MulN(N, ExpN('2', Count));
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N);
    end;
    Result := AddN(Result, N);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('BinQuart: Result = ',Result);
    Count := AddN(Count, '1');
  end;
end;


function TryBinToNumber(S: String; out N: TValue; CallBack: TCalcFeedbackEvent): OPBool;
var
  SubStr, STrim: String;
  Len: Integer;
  Counter, InterMed: TValue;
begin
  Result := ToBool(False);
  //The out parameter has the prefix stripped and leading and trialing zero's removed if the function returns True
  if not IsBinString(S, STrim) then
  begin
    Exit;
  end;
  S := STrim;
  N := Prime_Zero;
  Len := Length(S);
  Counter := Prime_Zero;
  //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryBinToNumber: S = "',S,'" Len = ',Len);
  while IsFalse(Len = 0) do
  begin
    if IsTrue(Len >= 4) then
    begin
      SubStr := System.Copy(S, Len - (4 - 1), 4);
      System.Delete(S, Len - (4 - 1), 4);
      Len := Length(S);
    end
    else
    begin
      SubStr := S;
      S := '';
      Len := 0;
    end;
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryBinToNumber:');
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  SubStr = "',SubStr,'"');
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  S      = "',S,'"');
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  Len    = ',Len);
    InterMed := BinQuartetToNumber(SubStr);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('BinQuartetToNumber(',SubStr,') = ',InterMed);
    if IsFalse(IsZeroN(Counter)) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('TryBinToNumber: MulN(',InterMed,'ExpN(',HexBase_Exp_1,',',Counter,')) = ');
      InterMed := MulN(InterMed, ExpN(HexBase_Exp_1, Counter));
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(InterMed);
    end;
    N := AddN(N, InterMed);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryBinToNumber: intermediate Result for N = ',N);
    if Assigned(CallBack) then CallBack(Format('TryBinToNumber: intermediate Result for out parameter = ',[N]), True);
    Counter := AddN(Counter, '1');
  end;
  Result := ToBool(True);
end;

function BinToNumber(S: String; CallBack: TCalcFeedbackEvent): TValue;
begin
  if IsFalse(TryBinToNumber(S, Result, CallBack)) then
    Raise EConvertError.CreateFmt(SIsNotABinNumber,[S]);
end;

function IsHexString(S: String; out TrimmedS: String): OPBool;
var
  i: Integer;
begin
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('IsHexString: S="',S,'"');
  Result := ToBool(False);
  TrimmedS := Trim(S);
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  TrimmedS = ',TrimmedS);
  if IsTrue(Length(TrimmedS) > 1) then
  begin
    if IsTrueComplex(IsTrue(TrimmedS[1] = '0'), IsTrue(Upcase(TrimmedS[2]) = 'X')) then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  S starts with "0x"');
      System.Delete(TrimmedS, 1, 2);
    end;
    //allow space between prefix and value
    TrimmedS := Trim(TrimmedS);
  end;
  if IsTrue(Length(TrimmedS) > 0) and IsTrue(TrimmedS[1] = '$') then
  begin
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  S starts with "$"');
      System.Delete(TrimmedS, 1, 1);
    end;
    //allow space between prefix and value
    TrimmedS := Trim(TrimmedS);
  end;
  if IsTrue(Length(TrimmedS) = 0) then
  begin
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  TrimmedS is empty');
    TrimmedS := S;
    Exit;
  end;
  for i := 1 to Length(TrimmedS) do
  begin
    if IsFalse(Upcase(TrimmedS[i]) in ['0'..'9','A'..'F']) then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TrimmedS[',i,'] is not Hex: ',TrimmedS[i]);
      TrimmedS := S;
      Exit;
    end;
  end;
  Result := ToBool(True);
end;

function IsBinString(S: String; out TrimmedS: String): OPBool;
var
  i: Integer;
begin
  Result := ToBool(False);
  TrimmedS := Trim(S);
  if IsTrue(Length(TrimmedS) > 0) and IsTrue(TrimmedS[1] = '%') then
  begin
    System.Delete(TrimmedS, 1, 1);
    //allow space between prefix and value
    TrimmedS := Trim(TrimmedS);
  end;
  if IsTrue(Length(TrimmedS) = 0) then
  begin
    TrimmedS := S;
    Exit;
  end;
  for i := 1 to Length(TrimmedS) do
  begin
    if IsFalse(TrimmedS[i] in ['0'..'1']) then
    begin
      TrimmedS := S;
      Exit;
    end;
  end;
  Result := ToBool(True);
end;

function HexToDigit(H: Char): TValue;
begin
  case Upcase(H) of
    '0': Result := '0';
    '1': Result := '1';
    '2': Result := '2';
    '3': Result := '3';
    '4': Result := '4';
    '5': Result := '5';
    '6': Result := '6';
    '7': Result := '7';
    '8': Result := '8';
    '9': Result := '9';
    'A': Result := '10';
    'B': Result := '11';
    'C': Result := '12';
    'D': Result := '13';
    'E': Result := '14';
    'F': Result := '15';
    else RaiseENumberRangeCheckError(H);
  end;
end;


function HexOctetToNumber(S: String): TValue;
var
  Count, N: TValue;
  Digit: Char;
begin
  Count := Prime_Zero;
  Result := Prime_Zero;
  while IsFalse(Length(S) = 0) do
  begin
    Digit := S[Length(S)];
    System.Delete(S, Length(S), 1);
    N := HexToDigit(Digit);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('HexOct: Digit = ',Digit,' Count = ',Count,' HexToDigit(',Digit,') = ',N);
    if IsFalse(IsZeroN(Count)) then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('HexOct: MulN(',N,',ExpN(',HexBase_Exp_1,',',Count,')) = ');
      N := MulN(N, ExpN(HexBase_Exp_1, Count));
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N);
    end;
    Result := AddN(Result, N);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('HexOct: Result = ',Result);
    Count := AddN(Count, '1');
  end;
end;

function TryHexToNumber(S: String; out N: TValue; CallBack: TCalcFeedbackEvent = nil): OPBool;
var
  SubStr, Strim: String;
  Len: Integer;
  Counter, InterMed: TValue;
begin
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryHexToNumber:');
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  S = "',S,'"');
  Result := IsHexString(S, STrim);
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryHexToNumber: IsHexstring(',S,') = ',Result);
  //The out parameter has the prefix stripped and leading and trialing zero's removed if the function returns True
  if IsFalse(Result) then
  begin
    Exit;
  end;
  S := STrim;
  N := Prime_Zero;
  Len := Length(S);
  Counter := Prime_Zero;
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryHexToNumber: S = "',S,'" Len = ',Len);
  while IsFalse(Len = 0) do
  //pars the string by chunks of 8 (less loops here -> more loops in DivN/ExpN, this number (8) is a bit of a guess)
  begin
    if IsTrue(Len >= 8) then
    begin
      SubStr := System.Copy(S, Len - (8 - 1), 8);
      System.Delete(S, Len - (8 - 1), 8);
      Len := Length(S);
    end
    else
    begin
      SubStr := S;
      S := '';
      Len := 0;
    end;
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryHexToNumber:');
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  SubStr = "',SubStr,'"');
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  S      = "',S,'"');
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  Len    = ',Len);
    InterMed := HexOctetToNumber(SubStr);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('HexOctetToNumber(',SubStr,') = ',InterMed);
    if IsFalse(IsZeroN(Counter)) then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('TryHexTuNumber: MulN(',InterMed,'ExpN(',HexBase_Exp_8,',',Counter,')) = ');
      InterMed := MulN(InterMed, ExpN(HexBase_Exp_8, Counter));
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(InterMed);
    end;
    N := AddN(N, InterMed);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryHexToNumber: intermediate Result for N = ',N);
    if Assigned(CallBack) then CallBack(Format('TryHexToNumber: intermediate Result for out parameter = ',[N]), True);
    Counter := AddN(Counter, '1');
  end;
  Result := ToBool(True);
end;

function HexToNumber(S: String; CallBack: TCalcFeedbackEvent): TValue;
begin
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('HexToNumber: S = "',S,'"');
  if IsFalse(TryHexToNumber(S, Result, CallBack)) then
    Raise EConvertError.CreateFmt(SIsNotAHexNumber,[S]);
end;


{


function intToRoman(Value: Longint): string;

const
  Arabics : Array[1..13] of Integer
          = (1,4,5,9,10,40,50,90,100,400,500,900,1000);
  Romans  :  Array[1..13] of String
          = ('I','IV','V','IX','X','XL','L','XC','C','CD','D','CM','M');

var
  i: Integer;

begin
  Result:='';
  for i:=13 downto 1 do
    while (Value >= Arabics[i]) do
      begin
        Value:=Value-Arabics[i];
        Result:=Result+Romans[i];
      end;
end;


}

function Romans(N: TValue): String;
begin
  AssertIsNumberN(N);
  N := NormalizeNumberN(N);
  case N of
    '1': Result := 'I';
    '2': Result := 'IV';
    '3': Result := 'V';
    '4': Result := 'IX';
    '5': Result := 'X';
    '6': Result := 'XL';
    '7': Result := 'L';
    '8': Result := 'XC';
    '9': Result := 'C';
    '10': Result := 'CD';
    '11': Result := 'D';
    '12': Result := 'CM';
    '13': Result := 'M';
    else RaiseENumberRangeCheckError(N);
  end;
end;

function Arabics(N: TValue): String;
begin
  AssertIsNumberN(N);
  N := NormalizeNumberN(N);
  case N of
      '1': Result := '1';
      '2': Result := '4';
      '3': Result := '5';
      '4': Result := '9';
      '5': Result := '10';
      '6': Result := '40';
      '7': Result := '50';
      '8': Result := '90';
      '9': Result := '100';
      '10': Result := '400';
      '11': Result := '500';
      '12': Result := '900';
      '13': Result := '1000';
    else RaiseENumberRangeCheckError(N);
  end;
end;

function NumberToRomanN(N: TPositiveValue): String;
var
  Count, Ar, ADiv, AMod: TValue;
begin
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToRomanN: N = ',N);
  AssertIsPositiveN(N);
  N := NormalizeNumberN(N);
  Result := '';
  if IsTrue(IsZeroN(N)) then
  begin
    Exit;
  end;
  Count := '13';
  if IsFalse(LessN(N, '19000')) then    //using DivMod is faster when the number of 'M'-s in the result is > appr. 20
  begin
    Ar := Arabics(Count);
    ADiv := DivModN(N, Ar, AMod);
    N := AMod;
    while IsFalse(IsZeroN(ADiv)) do
    begin
      Result := Result + Romans(Count);
      ADiv := SubN(ADiv, '1');
    end;
    Count := SubN(Count, '1');
  end;

  while IsFalse(IsZeroN(Count)) do
  begin
    Ar := Arabics(Count);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('ToRomN: Count = ',Count);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  N = ',N,' Ar = ',Ar,' MoreN(Ar,N) = ',MoreN(Ar,N));
    while IsFalse(MoreN(Ar, N))  do
    begin
      N := SubN(N, Ar); //Value:=Value-Arabics[i];
      Result := Result + Romans(Count);
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  N = ',N,' Ar = ',Ar,' MoreN(Ar,N) = ',MoreN(Ar,N));
    end;
    Count := SubN(Count, '1');
  end;
end;
{
function RomanToint(const S: string): Longint;

const
  RomanChars  = ['C','D','I','L','M','V','X'];
  RomanValues : array['C'..'X'] of Word
              = (100,500,0,0,0,0,1,0,0,50,1000,0,0,0,0,0,0,0,0,5,0,10);

var
  index, Next: Char;
  i,l: Integer;
  Negative: Boolean;

begin
  Result:=0;
  i:=0;
  Negative:=(Length(S)>0) and (S[1]='-');
  if Negative then
    inc(i);
  l:=Length(S);
  while (i<l) do
    begin
    inc(i);
    index:=UpCase(S[i]);
    if index in RomanChars then
      begin
      if Succ(i)<=l then
        Next:=UpCase(S[i+1])
      else
        Next:=#0;
      if (Next in RomanChars) and (RomanValues[index]<RomanValues[Next]) then
        begin
        inc(Result, RomanValues[Next]);
        Dec(Result, RomanValues[index]);
        inc(i);
        end
      else
        inc(Result, RomanValues[index]);
      end
    else
      begin
      Result:=0;
      Exit;
      end;
    end;
  if Negative then
    Result:=-Result;
end;

}
{
A smaller number in front of a larger number means subtraction, all else means addition.
For example, IV means 4, VI means 6.
You would not put more than one smaller number in front of a larger number to subtract.
For example, IIV would not mean 3.

You must separate ones, tens, hundreds, and thousands as separate items.
That means that 99 is XCIX, 90 + 9, but never should be written as IC.
Similarly, 999 cannot be IM and 1999 cannot be MIM.
}
const
  RomanChars  = ['C','D','I','L','M','V','X'];
  RomanValues : array['C'..'X'] of Word
              = (100,500,0,0,0,0,1,0,0,50,1000,0,0,0,0,0,0,0,0,5,0,10);

function IsAllowedRomanSub(Sub, V: Char): OPBool;
begin
  Sub := UpCase(Sub);
  V := UpCase(V);
  case V of
      'M', 'D': Result := IsTrue(Sub = 'C');
      'C': Result := IsTrue(Sub = 'X');
      'L': Result := IsTrue(Sub = 'L');
      'X', 'V': Result := IsTrue(Sub = 'I');
    else Result := ToBool(False);
  end;
end;

function IsRomString(S: String; out TrimmedS: String): OPBool;
//determinig if a string is valid Roman is 90% of converting it, so it is done in the converting function
var
  Dummy: TPositiveValue;
begin
  TrimmedS := Trim(S);
  Result := TryRomanToNumber(TrimmedS, Dummy, nil);
end;


function TryRomanToNumber(S: String; out N: TPositiveValue; CallBack: TCalcFeedBackEvent): OPBool;
var
  i, Len: Integer;
  Terminated: OPBool;
  InterMed: TPositiveValue;
  TrimmedS: String;
begin
  Result := ToBool(False);
  TrimmedS := UpperCase(Trim(S));
  Len := Length(S);
  if IsTrue(Len = 0) then Exit;
  i := 1;
  InterMed := '0';
  Terminated := ToBool(False);
  //leading M's
  while IsTrue(i <= Len) and (TrimmedS[i] = 'M') do
  begin
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 1000');
    Inc(i);
    InterMed := AddN(InterMed, '1000');
    if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
  end;
  //then CM or or CD or D or (C, CC, CCC, CCCC)
  if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'D') then
  begin
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 500');
    Inc(i);
    InterMed := AddN(InterMed, '500');
    if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
  end
  else if IsTrue(i + 1 <= Len) and IsTrue(TrimmedS[i] = 'C') then
  begin
    if IsTrue(TrimmedS[i+1] = 'M') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 900');
      Inc(i,2);
      InterMed := AddN(InterMed, '900');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end
    else if IsTrue(TrimmedS[i+1] = 'D') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 400');
      Inc(i,2);
      InterMed := AddN(InterMed, '400');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
  end ;
  //next max 4 C's
  if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'C') then
  begin
    //find max 4 C's
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 100');
    Inc(i);
    InterMed := AddN(InterMed, '100');
    if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'C') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 100');
      Inc(i);
      InterMed := AddN(InterMed, '100');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'C') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 100');
      Inc(i);
      InterMed := AddN(InterMed, '100');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'C') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 100');
      Inc(i);
      InterMed := AddN(InterMed, '100');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
  end;

  //then XC or XL
  if IsTrue(i + 1 <= Len) and IsTrue(TrimmedS[i] = 'X') then
  begin
    if IsTrue(TrimmedS[i+1] = 'C') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 90');
      Inc(i,2);
      InterMed := AddN(InterMed, '90');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end
    else if  IsTrue(TrimmedS[i+1] = 'L') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 40');
      Inc(i,2);
      InterMed := AddN(InterMed, '40');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
  end;

  //then L
  if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'L') then
  begin
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 50');
    Inc(i);
    InterMed := AddN(InterMed, '50');
    if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
  end;

  //then (X, xx, xxx, xxxx)
  if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'X') then
  begin
    //find max 4 X's
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 10');
    Inc(i);
    InterMed := AddN(InterMed, '10');
    if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'X') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 10');
      Inc(i);
      InterMed := AddN(InterMed, '10');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'X') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 10');
      Inc(i);
      InterMed := AddN(InterMed, '10');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'X') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 10');
      Inc(i);
      InterMed := AddN(InterMed, '10');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
  end;

  //then IX or IV
  if IsTrue(i + 1 <= Len) and IsTrue(TrimmedS[i] = 'I') then
  begin
    if IsTrue(TrimmedS[i+1] = 'X') then
    begin
      Terminated := ToBool(True);
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 9');
      Inc(i,2);
      InterMed := AddN(InterMed, '9');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end
    else if IsTrue(TrimmedS[i+1] = 'V') then
    begin
      Terminated := ToBool(True);
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 4');
      Inc(i,2);
      InterMed := AddN(InterMed, '4');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
  end;

  //then V
  if IsFalse(Terminated) and IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'V') then
  begin
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 5');
    Inc(i);
    InterMed := AddN(InterMed, '5');
    if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
  end;


  //then I
  if IsFalse(Terminated) and IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'I') then
  begin
    Terminated := ToBool(True);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 1');
    Inc(i);
    InterMed := AddN(InterMed, '1');
    if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    //Find max 3 closing I's
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'I') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 1');
      Inc(i);
      InterMed := AddN(InterMed, '1');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'I') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 1');
      Inc(i);
      InterMed := AddN(InterMed, '1');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
    if IsTrue(i <= Len) and IsTrue(TrimmedS[i] = 'I') then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Found 1');
      Inc(i);
      InterMed := AddN(InterMed, '1');
      if Assigned(CallBack) then CallBack('Intermediate result = ' + InterMed, True);
    end;
  end;

  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryRomanToNumber: Len = ',Len,' i = ',i);
  Result := IsTrue(i > Len);
  if Result then N := InterMed;
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then if Result then writeln('TryRomanToNumber: InterMed = ',InterMed);

end;

function RomanToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TPositiveValue;
begin
  if IsFalse(TryRomanToNumber(S, Result, CallBack)) then
    Raise EConvertError.CreateFmt(SIsNotARomNumber,[S]);
end;


function BinTripletToOct(Triplet: String): TPositiveValue;
begin
  case Triplet of
    '000': Result := '0';
    '001': Result := '1';
    '010': Result := '2';
    '011': Result := '3';
    '100': Result := '4';
    '101': Result := '5';
    '110': Result := '6';
    '111': Result := '7';
    else RaiseENumberRangeCheckError(Triplet);
  end;
end;


function NumberToOctN(N: TPositiveValue; CallBack: TCalcFeedbackEvent = nil): String;
var
  Bin: TValue;
  Triplet: String;
begin
  AssertIsPositiveN(N);
  N := NormalizeNumberN(N);
  Result := '';
  Bin := TValue(NumberToBinN(N));
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToOctN: Bin = ',Bin);
  while IsTrue(Length(Bin) >= 3) do
  begin
    Triplet := Copy(Bin, Length(Bin) - 2, 3);
    Result := BinTripletToOct(Triplet) + Result;
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToOctN: Intermediate result := ',Result);
    if Assigned(CallBack) then CallBack('NumberToOctN: Intermediate result := ' + Result, True);
    System.Delete(Bin, Length(Bin) - 2, 3);
  end;
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToOctN: After loop: Bin = ',Bin);
  if IsTrue(Length(Bin) > 0) then
  begin
    while IsTrue(Length(Bin) < 3) do Bin := '0' + Bin;
    Result := BinTripletToOct(Bin) + Result;
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToOctN: Intermediate result := ',Result);
  end;
  while IsTrue(Length(Result) > 1) and IsTrue(Result[1] = '0') do System.Delete(Result, 1, 1);
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('NumberToBinN End.');
end;


function IsOctString(S: String; out TrimmedS: String): OPBool;
var
  i: Integer;
begin
  Result := ToBool(False);
  TrimmedS := Trim(S);
  if IsTrue(Length(TrimmedS) > 0) and IsTrue(TrimmedS[1] = '&') then
  begin
    System.Delete(TrimmedS, 1, 1);
    //allow space between prefix and value
    TrimmedS := Trim(TrimmedS);
  end;
  if IsTrue(Length(TrimmedS) = 0) then
  begin
    TrimmedS := S;
    Exit;
  end;
  for i := 1 to Length(TrimmedS) do
  begin
    if IsFalse(TrimmedS[i] in ['0'..'7']) then
    begin
      TrimmedS := S;
      Exit;
    end;
  end;
  Result := ToBool(True);
end;


function OctOctetToNumber(S: String): TValue;
var
  Count, N: TValue;
  Digit: Char;
begin
  Count := Prime_Zero;
  Result := Prime_Zero;
  while IsFalse(Length(S) = 0) do
  begin
    Digit := S[Length(S)];
    System.Delete(S, Length(S), 1);
    N := TPositiveValue(Digit);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('OctOct: Digit = ',Digit,' Count = ',Count,' OctToDigit(',Digit,') = ',N);
    if IsFalse(IsZeroN(Count)) then
    begin
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('HexOct: MulN(',N,'ExpN(',HexBase_Exp_1,',',Count,')) = ');
      N := MulN(N, ExpN('8', Count));
      //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(N);
    end;
    Result := AddN(Result, N);
    //if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('HexOct: Result = ',Result);
    Count := AddN(Count, '1');
  end;
end;


function TryOctToNumber(S: String; out N: TPositiveValue; CallBack: TCalcFeedBackEvent): OPBool;
var
  SubStr, STrim: String;
  Len: Integer;
  Counter, InterMed: TValue;
const
  OctBase_Exp_8 = '16777216';
begin
  Result := ToBool(False);
  //The out parameter has the prefix stripped and leading and trialing zero's removed if the function returns True
  if not IsOctString(S, STrim) then
  begin
    Exit;
  end;
  S := STrim;
  N := Prime_Zero;
  Len := Length(S);
  Counter := Prime_Zero;
  if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryOctToNumber: S = "',S,'" Len = ',Len);
  while IsFalse(Len = 0) do
  //pars the string by chunks of 8 (less loops here -> more loops in DivN/ExpN, this number (8) is a bit of a guess)
  begin
    if IsTrue(Len >= 8) then
    begin
      SubStr := System.Copy(S, Len - (8 - 1), 8);
      System.Delete(S, Len - (8 - 1), 8);
      Len := Length(S);
    end
    else
    begin
      SubStr := S;
      S := '';
      Len := 0;
    end;
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryOctToNumber:');
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  SubStr = "',SubStr,'"');
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  S      = "',S,'"');
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('  Len    = ',Len);
    InterMed := OctOctetToNumber(SubStr);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('OctOctetToNumber(',SubStr,') = ',InterMed);
    if IsFalse(IsZeroN(Counter)) then
    begin
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then write('TryOctTuNumber: MulN(',InterMed,'ExpN(',OctBase_Exp_8,',',Counter,')) = ');
      InterMed := MulN(InterMed, ExpN(OctBase_Exp_8, Counter));
      if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln(InterMed);
    end;
    N := AddN(N, InterMed);
    if IsTrue(DebugNCalc) and IsTrue(IsConsole) then writeln('TryOctToNumber: intermediate Result for N = ',N);
    if Assigned(CallBack) then CallBack(Format('TryOctToNumber: intermediate Result for out parameter = ',[N]), True);
    Counter := AddN(Counter, '1');
  end;
  Result := ToBool(True);
end;

function OctToNumber(S: String; CallBack: TCalcFeedbackEvent = nil): TPositiveValue;
begin
  if IsFalse(TryOctToNumber(S, Result, CallBack)) then
    Raise EConvertError.CreateFmt(SIsNotAOctNumber,[S]);
end;


function OPBoolToValue(ABool: OPBool): TValue;
begin
  if IsTrue(ABool) then
    Result := 'TRUE'
  else
    Result := 'FALSE';
end;

function ValueToOPBool(AValue: TValue): OPBool;
begin
  if IsTrue(CompareText(AValue, 'TRUE') = 0) then
    Result := ToBool(True)
  else
  begin
    if IsTrue(CompareText(AValue, 'FALSE') = 0) then
      Result := ToBool(False)
    else
      Raise EInvalidOPBool.CreateFmt('Found %s, expected type was OPBool',[Avalue]);
  end;
end;


procedure naclcfoolct; //leave at end of includefile
begin
end;
