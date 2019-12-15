unit testmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Expressions, BoolFactory, bignumbers, ncalc, math, lclproc, LCLIntf, LazFileUtils,
  CalculatorParentalGuide, strutils, types, NumberOperationsCache;

type
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    AbsBtn: TButton;
    BinToNBtn: TButton;
    BinomBtn: TButton;
    LucasBtn: TButton;
    FibBtn: TButton;
    OddBtn: TButton;
    OctToNBtn: TButton;
    ToOctBtn: TButton;
    RomToNBtn: TButton;
    ToRomanBtn: TButton;
    RandRBtn: TButton;
    RandBtn: TButton;
    SrtNBtn: TButton;
    ToBinBtn: TButton;
    ExpBtn: TButton;
    HexToNBtn: TButton;
    ToHexBtn: TButton;
    NormBtn: TButton;
    ZeroBtn: TButton;
    IsNeg: TButton;
    NegBtn: TButton;
    EqBtn: TButton;
    FacBtn: TButton;
    DirtyWordsBtn: TButton;
    AddBtn: TButton;
    SubBtn: TButton;
    RunTestBtn: TButton;
    MulBtn: TButton;
    DivBtn: TButton;
    MaxBtn: TButton;
    MinBtn: TButton;
    TestCacheBtn: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    procedure AbsBtnClick(Sender: TObject);
    procedure BinomBtnClick(Sender: TObject);
    procedure BinToNBtnClick(Sender: TObject);
    procedure EqBtnClick(Sender: TObject);
    procedure ExpBtnClick(Sender: TObject);
    procedure FacBtnClick(Sender: TObject);
    procedure DirtyWordsBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure FibBtnClick(Sender: TObject);
    procedure LucasBtnClick(Sender: TObject);
    procedure OctToNBtnClick(Sender: TObject);
    procedure OddBtnClick(Sender: TObject);
    procedure RandBtnClick(Sender: TObject);
    procedure RandRBtnClick(Sender: TObject);
    procedure RomToNBtnClick(Sender: TObject);
    procedure SrtNBtnClick(Sender: TObject);
    procedure ToHexBtnClick(Sender: TObject);
    procedure HexToNBtnClick(Sender: TObject);
    procedure IsNegClick(Sender: TObject);
    procedure NegBtnClick(Sender: TObject);
    procedure NormBtnClick(Sender: TObject);
    procedure SubBtnClick(Sender: TObject);
    procedure RunTestBtnClick(Sender: TObject);
    procedure MulBtnClick(Sender: TObject);
    procedure DivBtnClick(Sender: TObject);
    procedure MaxBtnClick(Sender: TObject);
    procedure MinBtnClick(Sender: TObject);
    procedure TestCacheBtnClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CallBack(Sender: TObject; const Msg: String; IsStartOfNewMessage: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure OnCleanValue(Sender: TObject; const AName: TValue; const AValue: String; var Cancel: OPBool);
    procedure ToBinBtnClick(Sender: TObject);
    procedure ToOctBtnClick(Sender: TObject);
    procedure ToRomanBtnClick(Sender: TObject);
    procedure ZeroBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

function VendorName: String;
begin
  Result := 'Flying Sheep Inc.';
end;

function AppName: String;
begin
  Result := 'WTF TesCase';
end;

{$R *.lfm}

{ TForm1 }

function IntToOct(Value: Longint; digits: Integer): string;
var
  rest: Longint;
  oct: string;
  i: Integer;
begin
  oct := '';
  while Value <> 0 do
  begin
    rest  := Value mod 8;
    Value := Value div 8;
    oct := IntToStr(rest) + oct;
  end;
  for i := Length(oct) + 1 to digits do
    oct := '0' + oct;
  Result := oct;
end;

function OctToInt(Value: string): Longint;
var
  i: Integer;
  int: Integer;
begin
  int := 0;
  for i := 1 to Length(Value) do
  begin
    int := int * 8 + StrToInt(Copy(Value, i, 1));
  end;
  Result := int;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  B1,B2: OPBool;
  x,y,z,carry: integer;
  S: String;
  Prim: TPrimitive;
  CPGD: TCaclculatorParentalGuideDictionary;
  Cleaner: TParentalGuideNumberCleaner;
  Hex: Uint64;
  i: Integer;
  HexS: String;
  Res: TValue;
  Googol: String;
begin

  for i := 0 to 7 do
  begin
    S := Format('''%s'': Result = ''%s''',[IntToBin(i,3), IntToOct(i,1)]);
    Memo1.Lines.Add(S);
  end;

  EXIT;

  SetLength(Googol,101);
  FillChar(Googol[1], 101, '0');
  Googol[1] := '1';
  Memo1.Lines.Add('Googol = '+Googol);

  EXIT;

  OnGetVendorName := @VendorName;
  OnGetApplicationName := @AppName;
  S := GetAppConfigDirUtf8(False);
  Memo1.Lines.Add(Format('GetAppConfigDirUtf8(False) = %s',[S]));
  S := GetAppConfigDirUtf8(True);
  Memo1.Lines.Add(Format('GetAppConfigDirUtf8(True) = %s',[S]));

  EXIT;


  for x := 1 to 32 do
  begin
    y := sqr(x);
    S := Format('''%d'': Result := ''%d'';',[y,x]);
    Memo1.Lines.Add(S);

  end;

  EXIT;

  //writeln('inttobin(-1,8) = ',inttobin(int64(-1),64));
  //writeln('IntToHex(-1,2) = ',IntToHex(Int64(-1),2));
  //EXIt;
  {
  HexS := 'HexBase_Exp_';
  Res := '1';
  Res := '340282366920938463463374607431768211456'; //HexBase_Exp_32
  //  HexBase_Exp_64 = '115792089237316195423570985008687907853269984665640564039457584007913129639936';
  Res := '115792089237316195423570985008687907853269984665640564039457584007913129639936';
  for i := 65 to 128 do
  begin
    HexS := 'HexBase_Exp_' + IntToStr(i);
    Res := MulN('16', Res);
    Memo1.Lines.Add(HexS + ' = ''' + Res + ''';');
  end;
  Memo1.Lines.add('');
  Memo1.Lines.Add('(');
  for i := 65 to 128 do
  begin
    HexS := 'HexBase_Exp_' + IntToStr(i) + ',';
    Memo1.Lines.Add(HexS);
  end;

  Memo1.Lines.Add('(');

  EXIT;
  }
  Cleaner := TParentalGuideNumberCleaner.Create;
  Cleaner.OnCleanValue := @OnCleanValue;
  S := Edit1.Text;
  S := '580089180007136007134631500C0B0100'; // bigboobs  geil siegheil
  //if not IsNumberN(S) then Exit;
  S := Cleaner.CleanValue(S, B1);
  Memo1.Lines.Add(S);
  Cleaner.Free;
  EXIT;

  {
  for x := 0 to 9 do for y := 0 to 9 do
  begin
    z := x * y;
    if z >= 10 then
    begin
      carry := z div 10;
      z := z mod 10;
    end
    else
      carry := 0;
    S := Format('{ %d x %d } Mul_%d_%d: TCalcRes = (Value: ''%d''; Carry: ''%d'');',[x,y,x,y,z,carry]);
    Memo1.Lines.Add(S);
  end;

  EXIT;
  }
  for x := 0 to 9 do
  begin
    for y := 0 to 9 do
    begin
      S := 'MulTable[' + IntToStr(x) + ',' + IntToStr(y) + '] := ' + 'Mul_'+inttostr(x)+'_'+inttostr(y) + ';';
      Memo1.Lines.Add(S);
    end;
  end;

  EXIT;




  EXIT;


  B1 := True;
  B2 := False;
  writeln('IsTrue(True)   = ',IsTrue(True));
  writeln('IsFalse(True)  = ',IsFalse(True));
  writeln('IsTrue(False)  = ',IsTrue(False));
  writeln('IsFalse(False) = ',IsFalse(False));


  writeln('IsTrueComplex(True,True)   = ',IsTrueComplex(True,True));
  writeln('IsTrueComplex(True,False)  = ',IsTrueComplex(True,False));
  writeln('IsTrueComplex(Fasle,True)  = ',IsTrueComplex(False,True));
  writeln('IsTrueComplex(False,False) = ',IsTrueComplex(False,False));

  writeln('IsFalseComplex(True,True)   = ',IsFalseComplex(True,True));
  writeln('IsFalseComplex(True,False)  = ',IsFalseComplex(True,False));
  writeln('IsFalseComplex(Fasle,True)  = ',IsFalseComplex(False,True));
  writeln('IsFalseComplex(False,False) = ',IsFalseComplex(False,False));

end;

procedure TForm1.EqBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      B := B1.EqualsN(B2);
      if B then N3 := 'TRUE' else N3 := 'FALSE';
      if V1 = V2 then S := 'TRUE' else S := 'FALSE';
      Memo1.Lines.Add(Format('EQulalsN(%s, %s) = %s [%s]',[N1, N2, N3,S]));
      if (B <> (V1=V2)) then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.ExpBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3: Int64;
  Big1, Big2: TNumber;
  F: float;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
  N3 := ExpN(N1, N2, nil);
  writeln('Exp(',N1,',',N2,') = ',N3);
  F := math.power(V1, V2);
  memo1.Lines.Add(Format('Exp(%s, %s) = %s [%30.0f]',[N1, N2, N3, F]));
  if (F < High(Int64)) then
  begin
    V3 := Round(F);
    if IntToStr(V3) <> N3 then Memo1.Lines.Add('[Fail]');
  end
  else Memo1.Lines.Add('[Cannot check]');
  except
    on E: ENumber do writeln(E.Message);
  end;
  writeln('======================================');
end;

procedure TForm1.AbsBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.AbsN;
      Memo1.Lines.Add(Format('AbsN(%s) = %s [%d]',[N1, N3,Abs(V1)]));
      if IntToStr(Abs(V1)) <> N3 then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.BinomBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2: Int64;
  Big1, Big2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  Big1 := TNumber.Create(N1);
  Big2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    //writeln('Big1 = ',DbgS(Big1));
    //writeln('Big2 = ',DbgS(Big2));
    N3 := Big1.BinomN(Big2);
    //N3 := BinomN(N1, N2);
    //writeln('After Big1.Add(Big2)');
    //writeln('Big1 = ',DbgS(Big1));
    //writeln('Big2 = ',DbgS(Big2));
    //write('Big1.Value = ');
    //writeln(Big1.Value);
    //write('Big2.Value = ');
    //writeln(Big2.Value);
    Memo1.Lines.Add(Format('Add(%s, %s) = %s [%s]',[N1, N2, N3,'Cannot Test']));
    //if IntToStr(V1+V2) <> N3 then Memo1.Lines.Add('[Fail!]');
    //writeln('After writing to memo');
  except
    on E: ENumber do
    begin
      writeln(E.Message);
      FreeAndNil(Big1);
      FreeandNil(Big2);
    end;
  end;
  //writeln('Big1.Free ',Assigned(Big1));
  if Assigned(Big1) then Big1.Free;
  //writeln('Big2.Free ',Assigned(Big2));
  if Assigned(Big2) then Big2.Free;
  //writeln('After Big2.Free');

  writeln('======================================');
end;

procedure TForm1.BinToNBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  B1 := TNumber.Create('0');
  try
    try
      B1.BinValue := N1;
      writeln('B1.Value = ',B1.value,' B1.BinValue = ',B1.BinValue);
      Memo1.Lines.Add(Format('B1.Value = (%s), B1.BinValue = %s',[B1.Value, B1.BinValue]));
    except
      on E: ENumber do writeln('ENumber ',E.Message);
      on E: eConvertError do writeln('EConvertError: ',E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

function Fact(N: Integer): UInt64;
var
  i: Integer;
begin
  if N < 1 then Exit(0);
  Result := 1;
  if N < 2 then Exit;
  try
    while N > 1 do
    begin
      Result := Result * N;
      Dec(N);
    end;
  except
    Result := 0;
  end;
end;

procedure TForm1.FacBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B1.OnNumberFeedback := @self.CallBack;
  //main.pp(249,26) Error: Incompatible types:
  //got      "<procedure variable type of procedure(const AnsiString,Boolean) of object;Register>"
  //expected "<procedure variable type of procedure(TObject,const AnsiString,Boolean) of object;Register>"

  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := 1;
  if not TryStrToInt64(N2, V2) then V2 := 1;
  try
    try
      N3 := B1.FacN;
      V3 := fact(V1);
      Memo1.Lines.Add(Format('FacN(%s) = %s [%d]',[N1, N3, V3]));
      if IntToSTr(V3) <> N3 then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.DirtyWordsBtnClick(Sender: TObject);
var
  SL: TStringList;
  i, j, Len: Integer;
  Line, S: String;
  Res: TStringList;
  MaxLen: Integer;
  Pad: String;
  function NrToS(S: String): String;
  var
    i: Integer;
    Illegal: Boolean;
  begin
    //i=1, z=2, E=3, s=5, q=6, L=7, b=9, o=0 h=4
    Result := '';
    Illegal := False;
    for i := length(S) downto 1 do
    begin
      case S[i] of
        '0': Result := Result + 'O';
        '1': Result := Result + 'I';
        '2': Result := Result + 'Z';
        '3': Result := Result + 'E';
        '4': Result := Result + 'H';
        '5': Result := Result + 'S';
        '6': Result := Result + 'Q';
        '7': Result := Result + 'L';
        '8': Result := Result + 'B';
        '9': Result := Result + 'B';
        '.': Result := Result + '';
        else
        begin
          Illegal := True;
          Result := Result + 'X';
        end;
      end;
    end;
    if Illegal then Result := Result + ' ILLEGAL!';
    //if (Length(Result) > 0) and (Result[1] = '0') then Result := '.' + Result;
  end;

begin
  writeln('=============================');
  SL := TStringList.Create;
  Res := TStringList.Create;
  try
    MaxLen := 0;
    SL.Assign(Memo1.Lines);
    Memo1.Lines.Clear;
    for i := 0 to SL.Count - 1 do
    begin
      Line := Sl.Strings[i];
      Line := Trim(Line);
      Len := Length(Line);
      S := '';
      if (Len = 0) then Continue;
      j := 1;
      while (j < Len) and not (Line[j] in ['0'..'9','.']) do Inc(j);
      writeln('After TrimLeft: j = ',j);
      while (j <= Len) do
      begin
        write('S = "',S,'" j = ',j,' Line[',j,'] = ',Line[j]);
        if (Line[j] in ['0'..'9','.'])
          then S := S + Line[j]
        else
          Break;
        writeln(' -> S = "',S,'"');
        Inc(j);
      end;
      writeln;
      writeln('S = "',S,'"');
      if (Length(S) > 0) then
      begin
        if Length(NrToS(S)) > 0 then
        begin
          Line := '{ ' + NrToS(S) + ' }  DirtyWords.Add(''' + S + ''');';
          Res.Add(S);
          if Length(S) > MaxLen then MaxLen := Length(S);
        end;
      end;
    end;
    for i := 0 to Res.Count - 1 do
    begin
      S := Res.Strings[i];
      writeln('Res[',i,'] = "',S,'" -> "',NrToS(S),'"');
      Len := Length(S);
      Len := MaxLen - Len;
      if Len > 0 then
        Pad := StringOfChar(#32,Len)
      else
        Pad := '';
      Line := '{ ' + NrToS(S) + Pad + ' }  DirtyWords.Add(''' + S + '=' + NrToS(S) + ''');';
      Res.Strings[i] := Line;
    end;
    Res.Sort;
    Memo1.Lines.Assign(Res);
  finally
    SL.Free;
    Res.Free;
  end;
  writeln('=============================');
end;

procedure TForm1.AddBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2: Int64;
  Big1, Big2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  Big1 := TNumber.Create(N1);
  Big2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    //writeln('Big1 = ',DbgS(Big1));
    //writeln('Big2 = ',DbgS(Big2));
    N3 := Big1.AddN(Big2);
    //writeln('After Big1.Add(Big2)');
    //writeln('Big1 = ',DbgS(Big1));
    //writeln('Big2 = ',DbgS(Big2));
    //write('Big1.Value = ');
    //writeln(Big1.Value);
    //write('Big2.Value = ');
    //writeln(Big2.Value);
    Memo1.Lines.Add(Format('Add(%s, %s) = %s [%d]',[N1, N2, N3,V1+V2]));
    if IntToStr(V1+V2) <> N3 then Memo1.Lines.Add('[Fail!]');
    //writeln('After writing to memo');
  except
    on E: ENumber do
    begin
      writeln(E.Message);
      FreeAndNil(Big1);
      FreeandNil(Big2);
    end;
  end;
  //writeln('Big1.Free ',Assigned(Big1));
  if Assigned(Big1) then Big1.Free;
  //writeln('Big2.Free ',Assigned(Big2));
  if Assigned(Big2) then Big2.Free;
  //writeln('After Big2.Free');

  writeln('======================================');
end;

procedure TForm1.FibBtnClick(Sender: TObject);
var
  N1, N2, N3, N4: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.FibN;
      N4 := FibN(N1);
      //N4 := FibN(N1);
      Memo1.Lines.Add(Format('FibN(%s) = %s, FibN(%s) = %s',[N1, N3, N1, N4]));
      if N4 <> N3 then Memo1.Lines.Add('[FAIL]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.LucasBtnClick(Sender: TObject);
var
  N1, N2, N3, N4: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.LucasN;
      N4 := LucasN(N1);
      Memo1.Lines.Add(Format('LucasN(%s) = %s',[N1, N3]));
      if N4 <> N3 then Memo1.Lines.Add('[FAIL]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

function _OctToInt(Value: string): Longint;
var
  i: Integer;
  int: Integer;
begin
  int := 0;
  for i := 1 to Length(Value) do
  begin
    int := int * 8 + StrToInt(Copy(Value, i, 1));
  end;
  Result := int;
end;

procedure TForm1.OctToNBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  B1 := TNumber.Create('0');
  try
    try
      B1.OctValue := N1;
      if not TryStrToInt64(N1, V1) then V1 := -999999;
      V3 := OctToInt(N1);
      if B then
      begin
        writeln('TryOctToNumber(',N1,') -> ',N3);
        Memo1.Lines.Add(Format('B1.Value = %s, B1.OctValue = %s, V3 = [%d]',[B1.Value,B1.OctValue, V3]));
        if IntToStr(V3) <> B1.Value then Memo1.Lines.Add('[FAIL]');
      end
      else
      begin
        writeln('TryOctToNumber(',N1,'): FAIL');
        Memo1.lines.Add('TryOctToNumber: [FAIL]');
      end;
      //writeln('B1.Value = ',N3,' B1.OctValue = ',B1.HexValue);

    except
      on E: ENumber do writeln('ENumber ',E.Message);
      on E: eConvertError do writeln('EConvertError: ',E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.OddBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      B := B1.OddN;
      if B then N3 := 'TRUE' else N3 := 'FALSE';
      if Odd(V1) then S := 'TRUE' else S := 'FALSE';
      Memo1.Lines.Add(Format('OddN(%s) = %s [%s]',[N1, N3,S]));
      if (B <> Odd(V1)) then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.RandBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  B1 := TNumber.Create(N1);
  try
    try
      N3 := B1.RandomN;
      writeln('B1.RandomN = ',N3);
      Memo1.Lines.Add(Format('B1.RandomN = %s',[N3]));
    except
      on E: ENumber do writeln('ENumber ',E.Message);
      on E: eConvertError do writeln('EConvertError: ',E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.RandRBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  B1 := TNumber.Create(N1);
  B1.UseCache := False;
  B2 := TNumber.Create(N2);
  try
    try
      N3 := B1.RandomRangeN(B2);
      writeln('B1.RandomRangeN(',B2.Value,') = ',N3);
      Memo1.Lines.Add(Format('B1.RandomRangeN(%s) = %s',[B2.Value,N3]));
    except
      on E: ENumber do writeln('ENumber ',E.Message);
      on E: eConvertError do writeln('EConvertError: ',E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.RomToNBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  writeln('RomanToInt(MDCLXVIVXLDM) = ',RomanToInt('MDCLXVIVXLDM'));
  writeln('RomanToInt(IIIIM) = ',RomanToInt('IIIIM'));
  writeln('RomanToInt(MCX) = ',RomantoInt('MCX'));

  N1 := Edit1.Text;
  N2 := Edit1.Text;
  B1 := TNumber.Create('0');
  try
    try
      B := B1.TryRomanToNumber(N1, N2);
      if B then
      begin
        writeln('B1.TryRomanToNumber(',N1,') -> ',N2);
        Memo1.lines.Add(Format('B1.TryRomanToNumber(%s) -> %s',[N1,N2]));
      end
      else
      begin
        Memo1.lines.Add(Format('B1.TryRomanToNumber(%s) -> FAIL',[N1]));
        writeln('B.1TryRomanToNumber(',N1,') -> FAIL');
      end;
      N1 := Trim(N1);
      V1 := RomanToInt(N1);
      writeln('RomanToInt(',N1,') = ',V1);
      if B then
      begin
        if IntToStr(V1) <> N2 then Memo1.Lines.Add(Format('FAIL: V1 = %d, N2 = %s',[V1,N2]));
      end;
      //B1.HexValue := N1;
      //writeln('B1.Value = ',B1.value,' B1.HexValue = ',B1.HexValue);
      //Memo1.Lines.Add(Format('B1.Value = (%s), B1.HexValue = %s',[B1.Value, B1.HexValue]));
    except
      on E: ENumber do writeln('ENumber ',E.Message);
      on E: eConvertError do writeln('EConvertError: ',E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.SrtNBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  B1 := TNumber.Create(N1);
  try
    try
      N3 := B1.SqrtN;
      writeln('B1.SqrtN = ',N3);
      Memo1.Lines.Add(Format('B1.SqrtN = (%s)',[N3]));
      writeln('SqrtN(',N1,') = ',N3);
    except
      on E: ENumber do writeln('ENumber ',E.Message);
      on E: eConvertError do writeln('EConvertError: ',E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.ToHexBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  B1 := TNumber.Create('0');
  try
    try
      B1.HexValue := N1;
      N3 := NumberToHexN(N1, nil);
      writeln('B1.Value = ',B1.value,' B1.HexValue = ',B1.HexValue);
      Memo1.Lines.Add(Format('B1.Value = (%s), B1.HexValue = %s',[B1.Value, B1.HexValue]));
    except
      on E: ENumber do writeln(E.Message);
      on E: eConvertError do writeln(E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.HexToNBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  B1 := TNumber.Create('0');
  try
    try
      B1.HexValue := N1;
      writeln('B1.Value = ',B1.value,' B1.HexValue = ',B1.HexValue);
      Memo1.Lines.Add(Format('B1.Value = (%s), B1.HexValue = %s',[B1.Value, B1.HexValue]));
    except
      on E: ENumber do writeln('ENumber ',E.Message);
      on E: eConvertError do writeln('EConvertError: ',E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.IsNegClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      B := B1.IsNegativeN;
      if B then N3 := 'TRUE' else N3 := 'FALSE';
      if V1 < 0 then S := 'TRUE' else S := 'FALSE';
      Memo1.Lines.Add(Format('IsNegative(%s) = %s [%s]',[N1, N3,S]));
      if (B <> (V1<0)) then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.NegBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.MakeNegativeN;
      Memo1.Lines.Add(Format('NegN(%s) = %s [%d]',[N1, N3, -V1]));
      if IntToStr(-V1) <> N3 then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.NormBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  DoAssert: OPBool;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  DoAssert := random < 0.5;
  if DoAssert then S := 'TRUE' else S := 'FALSE';

  B1 := TNumber.Create(N1);

  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.NormalizeNumberN(DoAssert);
      Memo1.Lines.Add(Format('NormN(%s, %s) = %s [%d]',[N1, S, N3,(V1)]));
      if IntToStr(V1) <> N3 then Memo1.Lines.Add('[Fail!]');
    except
      //on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.SubBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2: Int64;
  Big1, Big2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  Big1 := TNumber.Create(N1);
  Big2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    N3 := Big1.SubN(Big2);
    writeln('Big1.Subtract(Big2) = ',N3);
    Memo1.Lines.Add(Format('Add(%s, %s) = %s [%d]',[N1, N2, N3,V1-V2]));
    if IntToStr(V1-V2) <> N3 then Memo1.Lines.Add('[Fail!]');
  except
    on E: ENumber do
    begin
      writeln(E.Message);
      FreeAndNil(Big1);
      FreeandNil(Big2);
    end;
  end;
  if Assigned(Big1) then Big1.Free;
  if Assigned(Big2) then Big2.Free;
  writeln('======================================');
end;

procedure TForm1.RunTestBtnClick(Sender: TObject);
var
  N1, N2, N3, N4, NMod: TValue;
  V1, V2, V3, VMod, NtoV, NtoVMod: Int64;
  x,y: Integer;
  Fail: Boolean;
  Err: String;
  FailCount: Integer;
  TempV: Int64;
  SDiv: String;
  SMod: String;
  S1: String;
  T0,T1, Diff: types.DWORD;
const
  cycle = 30;
begin
  N1 := Edit1.Text;
  if not IsNumberN(N1) then N1 := '0';
  N1 := NormalizeNumberN(N1);
  Edit1.Text := N1;

  V1 := StrToInt64(N1);


  for x := 1 to 10 do
  begin
    N1 := IntToStr(x);
    N3 := LucasN(N1);
    N4 := FibN(N1);
    Memo1.Lines.Add(Format('Lucas(%2d) = %2s, Fib(%2d) = %2s',[x,N3,x,N4]));
  end;

  EXIT;

  T0 := GetTickCount;
  for x := 1 to cycle do
  begin
    N3 := _FibN(N1);
  end;
  T1 := GetTickCount;
  Diff := T1 - T0;
  Memo1.Lines.Add(Format('%d cycles of _Fib(%s): %d ticks',[cycle, N1, Diff]));


  T0 := GetTickCount;
  for x := 1 to cycle do
  begin
    N3 := FibN(N1);
  end;
  T1 := GetTickCount;
  Diff := T1 - T0;
  Memo1.Lines.Add(Format('%d cycles of  Fib(%s): %d ticks',[cycle, N1, Diff]));

  EXIT;



  Randomize;
  FailCount := 0;
  for x := 0 to cycle do
  begin
    Form1.Caption := Format('TestCase: %d of %d',[x,cycle]);
    Application.ProcessMessages;
    N1 := NumberToRomanN(IntToStr(x));
    S1 := StrUtils.IntToRoman(x);
    if S1 <> N1 then
    begin
      Inc(FailCount);
      Memo1.Lines.Add(Format('NumberToRoman(%d) = %s <> IntToRoman(%d) = %s',[x,N1,S1]));
    end;

  end;
  Memo1.Lines.Add(Format('FailCount = %d after %d iterations',[FailCount,cycle]));





  EXIT;

  for x := 1 to cycle do for y := 1 to cycle do
  begin
    Application.ProcessMessages;
    V1 := Random(MaxSmallInt);
    V2 := RandomRange(1,MaxSmallInt);
    if V2 > V1 then
    begin
      TempV := V1;
      V1 := V2;
      V2 := TempV;
    end;
    V1 := V1 * RandomRange(10,100);
    N1 := IntToStr(V1);
    N2 := IntToStr(V2);
    N3 := DivModN(N1,N2,NMod);
    V3 := V1 div V2;
    VMod := V1 mod v2;
    Fail := False;
    Err := '';
    Fail := not TryStrToInt64(N3, NtoV);
    if not Fail then Fail := not TryStrToInt64(NMod, NtoVMod);
    if Fail then
    begin
      Err := Format('Fail on TryStrToInt64: N1=%s N2=%s N3=%s NMod=%s [V1=%d V2=%d V3=%d VMod=%d]',[N1,N2,N3,NMod,V1,V2,V3,VMod]);
    end
    else
    begin
      Fail := (V3 <> NtoV) or (VMod <> NtoVMod);
      if V3 <> NtoV then SDiv := ' <> ' else SDiv := ' ';
      if VMod <> NtoVMod then
      begin
        SMod := ' <> ';
        writeln('"',VMod,'" <> "',NtoVMod,'", NMod="',NMod);
      end
      else SMod := ' ';
      Err := Format('Fail on result: N3=%s%sV3=%d NMod=%s%sVMod=%d',[N3,SDiv,V3,NMod,SMod,VMod]);
    end;
    if Fail then
    begin
      Memo1.Lines.Add(Err);
      Inc(FailCount);
    end;
  end;
  Memo1.Lines.Add(Format('FailCount = %d after %d iterations',[FailCount,UInt64(cycle)*cycle]));
{

}
end;

procedure TForm1.MulBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  try
    if not TryStrToInt64(N1, V1) then V1 := -99999999;
    if not TryStrToInt64(N2, V2) then V2 := -99999999;
  except
    V1 := -99999999;
    V2 := -99999999;
  end;
  try
    try
      N3 := B1.MulN(B2);
      Memo1.Lines.Add(Format('MulN(%s, %s) = %s [%d]',[N1, N2, N3,V1*V2]));
      if IntToStr(V1*V2) <> N3 then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.DivBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) or IsZeroN(N2) then N2 := '1';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.DivModN(B2);
      Memo1.Lines.Add(Format('DivModN(%s, %s) = %s / %s [%d / %d]',[N1, N2, N3, B1.DivModRemainder, V1 div V2, V1 mod V2]));
      if (IntToStr(V1 div V2) <> N3) or (IntToStr(V1 mod V2) <> B1.DivModRemainder) then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.MaxBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.MaxN(B2);
      Memo1.Lines.Add(Format('maxN(%s, %s) = %s [%d]',[N1, N2, N3,Max(V1,V2)]));
      if IntToStr(Max(V1,V2)) <> N3 then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.MinBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit2.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      N3 := B1.MinN(B2);
      Memo1.Lines.Add(Format('MinN(%s, %s) = %s [%d]',[N1, N2, N3,Min(V1,V2)]));
      if IntToStr(Min(V1,V2)) <> N3 then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

procedure TForm1.TestCacheBtnClick(Sender: TObject);
var
  B1, B2: TNumber;
  Res: OPBool;
  S1, S2: String;
begin
  S1 := Edit1.Text;
  S2 := Edit2.Text;
  if not IsNumberN(S1) then
  begin
    S1 := '0';
    Edit1.Text := S1;
  end;
  if not IsNumberN(S2) then
  begin
    S2 := '0';
    Edit2.Text := S2;
  end;
  B1 := TNumber.Create(S1,false);
  B2 := TNumber.Create(S2,false);
  try
    B1.AddN(B2);
    B2.Value := AddN(B2.Value, '1');
  finally
    B1.Free;
    B2.Free;
  end;

end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.CallBack(Sender: TObject; const Msg: String; IsStartOfNewMessage: Boolean);
begin
  if IsStartOfNewMessage then
  begin
    writeln;
    write(Sender.ClassName,': ');
  end;
  write(Msg);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  NCalc.DebugNCalc := True; //False;
  NumberOperationsCache.DebugNumberOperationsCache := False;
  BigNumbers.DebugBigNumbers := True;//False;
end;

procedure TForm1.OnCleanValue(Sender: TObject; const AName: TValue;
  const AValue: String; var Cancel: OPBool);
begin
  writeln('OnCleanValue: Name = "',Aname,'" Value = "',AValue,'"');
  //Cancel := True;
end;

procedure TForm1.ToBinBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Integer;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  B1 := TNumber.Create(N1);
  writeln('B1.UseCache := ',B1.UseCache);
  write('N1 = "',N1,'"');
  writeln(' B1.Value = "',B1.Value,'"');

  N3 := B1.NumberToBinN;
  writeln('B1.NumberToBinN(',N1,') = ');
  writeln(N3, '[',Length(N3),']');
  B := TryStrToInt(N1, V1);
  S := '?';
  if B then S := IntToBin(V1, Length(N3));
  Memo1.Lines.Add(Format('B1.NumerToBinN(%s) =',[N1]));
  Memo1.Lines.Add(Format('%s, [%s]',[N3, S]));
  if B and (S <> N3) then Memo1.Lines.Add('[Fail]');

  B1.Free;
  writeln('======================================');
end;

procedure TForm1.ToOctBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  if not TryStrToInt64(N1, V1) then V1 := -9999999;
  B1 := TNumber.Create(N1);
  try
    try
      N3 := B1.OctValue;
      //N3 := NumberToOctN(N1);
      writeln('B1.OctValue = ',B1.OctValue);
      S := IntToOct(V1,32);
      while(Length(S) > 1) and (S[1] = '0') do System.Delete(S,1,1);
      Memo1.Lines.Add(Format('B1.OctValue = %s [%s]',[B1.OctValue,S]));
      if S <>B1.OctValue then Memo1.Lines.Add('[Fail]');
    except
      on E: ENumber do writeln(E.Message);
      on E: eConvertError do writeln(E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.ToRomanBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;
  if not TryStrToInt64(N1, V1) then V1 := -9999999;
  B1 := TNumber.Create(N1);
  try
    try
      //B1.HexValue := N1;
      N3 := B1.RomanValue;
      writeln('B1.RomanValue = ',N3);
      S := StrUtils.IntToRoman(V1);
      Memo1.Lines.Add(Format('B1.RomanValue = %s [%s]',[N3,S]));
      if S <>N3 then Memo1.Lines.Add('[Fail]');
    except
      on E: ENumber do writeln(E.Message);
      on E: eConvertError do writeln(E.Message);
    end;
  finally
    B1.Free;
  end;
  writeln('======================================');
end;

procedure TForm1.ZeroBtnClick(Sender: TObject);
var
  N1, N2, N3: TValue;
  V1, V2, V3, NtoV: Int64;
  x,y: Integer;
  B1, B2: TNumber;
  B: Boolean;
  S: String;
begin
  writeln('======================================');
  N1 := Edit1.Text;
  N2 := Edit1.Text;
  if not IsNumberN(N1) Then N1 := '0';
  if not IsNumberN(N2) then N2 := '0';
  Edit1.Text := N1;
  Edit2.Text := N2;

  B1 := TNumber.Create(N1);
  B2 := TNumber.Create(N2);
  if not TryStrToInt64(N1, V1) then V1 := -99999999;
  if not TryStrToInt64(N2, V2) then V2 := -99999999;
  try
    try
      B := B1.IsZeroN;
      if B then N3 := 'TRUE' else N3 := 'FALSE';
      if V1 = 0 then S := 'TRUE' else S := 'FALSE';
      Memo1.Lines.Add(Format('IsZero(%s) = %s [%s]',[N1, N3,S]));
      if (B <> (V1=0)) then Memo1.Lines.Add('[Fail!]');
    except
      on E: ENumber do writeln(E.Message);
    end;
  finally
    B1.Free;
    B2.Free;
  end;

  writeln('======================================');
end;

end.

