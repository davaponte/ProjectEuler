{ WaCkO: The WTF Calculator

  The WaCkO Calculator performs calculations on Natrural numbers
  of almost infinite size (up to 2147483648 digits!) without loss of precision.

  Feautures:
  - Standard functions like
    * Add
    * Subtract
    * Multiply
    * Divide
    * Modulo,
    * Square
    * Square root
    * Exponentiation
    * Absolute
    * Factorial
  - Non-Standard functions like
    * Odd
    * Less
    * More
    * Min
    * Max
    * Equals
    * Googol (10^100)
    * GoogolPlex (10^(10^100))

  - Improved Random function
  - Memory (store, add, recall)
  - Full Object Oriented Boolean evaluation through the BoolFactory library
  - Can operate in Decimal, HexaDecimal, Octal, Binary and Roman mode
  - Parental Guidance (R) mode

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
unit WackoMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType, ExtCtrls, Buttons, ActnList,
  BigNumbers, NCalc, CalculatorDisplay, CalculatorParentalGuide,
  NumberOperationsCache,
  Calculator,
  Expressions, BoolFactory;

type


  { TCalcForm }

  TCalcForm = class(TForm)
    acMemClear: TAction;
    acMemSet: TAction;
    acMemRead: TAction;
    acMemAdd: TAction;
    acMemSub: TAction;
    acEditClearAll: TAction;
    acEditCopy: TAction;
    acEditCut: TAction;
    acEditPaste: TAction;
    acEditClear: TAction;
    acPGM: TAction;
    acNum0: TAction;
    acNum1: TAction;
    acNum2: TAction;
    acNum3: TAction;
    acNum4: TAction;
    acNum5: TAction;
    acNum6: TAction;
    acNum7: TAction;
    acNum8: TAction;
    acNum9: TAction;
    acAdd: TAction;
    acSub: TAction;
    acMul: TAction;
    acDiv: TAction;
    acBackSpace: TAction;
    acHexA: TAction;
    acHexB: TAction;
    acHexC: TAction;
    acHexD: TAction;
    acHexE: TAction;
    acHexF: TAction;
    acRomI: TAction;
    acRomV: TAction;
    acRomX: TAction;
    acRomL: TAction;
    acRomM: TAction;
    acNegate: TAction;
    acEquals: TAction;
    AlphaPnl: TPanel;
    EqualsPnl: TPanel;
    OperatorActionlist: TActionList;
    BasicOpPnl: TPanel;
    InputActionList: TActionList;
    DebugNCalcCB: TCheckBox;
    EditActions: TActionList;
    EdImgList: TImageList;
    NumPnl: TPanel;
    MemActions: TActionList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    DisplayPanel: TPanel;
    EditPnl: TPanel;
    MemPnl: TPanel;
    MemClrBtn: TSpeedButton;
    MemSetBtn: TSpeedButton;
    MemReadBtn: TSpeedButton;
    MemAddBtn: TSpeedButton;
    MemSubBtn: TSpeedButton;
    EditClearAllBtn: TSpeedButton;
    EditCopyBtn: TSpeedButton;
    EditCutBtn: TSpeedButton;
    EditPasteBtn: TSpeedButton;
    EditBsBtn: TSpeedButton;
    EditClearBtn: TSpeedButton;
    PGMToggle: TToggleBox;
    RadixPnl: TRadioGroup;
    Num7: TSpeedButton;
    Num0: TSpeedButton;
    Num8: TSpeedButton;
    Num9: TSpeedButton;
    Num4: TSpeedButton;
    Num5: TSpeedButton;
    Num6: TSpeedButton;
    Num1: TSpeedButton;
    Num2: TSpeedButton;
    Num3: TSpeedButton;
    opAdd: TSpeedButton;
    opMin: TSpeedButton;
    opMul: TSpeedButton;
    opDiv: TSpeedButton;
    HexA: TSpeedButton;
    RomL: TSpeedButton;
    RomM: TSpeedButton;
    HexB: TSpeedButton;
    HexC: TSpeedButton;
    HexD: TSpeedButton;
    HexE: TSpeedButton;
    HexF: TSpeedButton;
    RomI: TSpeedButton;
    RomV: TSpeedButton;
    RomX: TSpeedButton;
    opEquals: TSpeedButton;
    TestBtn: TButton;
    Display: TEdit;
    CleanCB: TCheckBox;
    RealEd: TEdit;
    OrgEd: TEdit;
    procedure acAddExecute(Sender: TObject);
    procedure acBackSpaceExecute(Sender: TObject);
    procedure acDivExecute(Sender: TObject);
    procedure acEditClearAllExecute(Sender: TObject);
    procedure acEditClearExecute(Sender: TObject);
    procedure acEditCopyExecute(Sender: TObject);
    procedure acEditCutExecute(Sender: TObject);
    procedure acEditPasteExecute(Sender: TObject);
    procedure acEqualsExecute(Sender: TObject);
    procedure acMemAddExecute(Sender: TObject);
    procedure acMemClearExecute(Sender: TObject);
    procedure acMemReadExecute(Sender: TObject);
    procedure acMemSetExecute(Sender: TObject);
    procedure acMemSubExecute(Sender: TObject);
    procedure acMulExecute(Sender: TObject);
    procedure acPGMExecute(Sender: TObject);
    procedure acInputExecute(Sender: TObject);
    procedure acSubExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DebugNCalcCBChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RadixPnlSelectionChanged(Sender: TObject);
    procedure TestBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    FCalculator: TCalculator;
    FParentalGuidanceMode: OPBool;
    FRadixMode: TRadixMode;
    procedure Layout({%H-}Dummy: PtrInt);
    procedure OnAppException(Sender: TObject; E: Exception);
    procedure SetParentalGuidanceMode(AValue: OPBool);
    procedure SetRadixMode(AValue: TRadixMode);
    procedure UpdateInputControls(AValue: TRadixMode);
    procedure OnClean(Sender: TObject; const AName, AValue: String; var Cancel: OPBool);
    procedure ProcessInput(Key: Char);
  public
    { public declarations }
    property ParentalGuidanceMode: OPBool read FParentalGuidanceMode write SetParentalGuidanceMode;
    property RadixMode: TRadixMode read FRadixMode write SetRadixMode;
  end;

var
  CalcForm: TCalcForm;

implementation

{$R *.lfm}

const
  idxDecimal = Ord(rmDecimal);
  idxHexadecimal = Ord(rmHexadecimal);
  idxBinary = Ord(rmBinary);
  idxOctal = Ord(rmOctal);
  idxRoman = Ord(rmRoman);
  RadixStr: Array[TRadixMode] of String = ('Decimal','Hexadecimal','Binary','Octal','Roman');
  DefRadixMode = rmDecimal;

{ TCalcForm }

procedure TCalcForm.FormCreate(Sender: TObject);
var
  rm: TRadixMode;
begin
  Application.OnException := @OnAppException;
  FParentalGuidanceMode := ToBool(False);
  DisplayPanel.Caption := '';
  FCalculator := TCalculator.Create;
  FCalculator.Display.Color := DisplayPanel.Color;
  FCalculator.Display.Width := DisplayPanel.Width - 10;
  FCalculator.Display.Height := DisplayPanel.Height - 10;
  FCalculator.Display.Left := 5;
  FCalculator.Display.Top := 5;
  FCalculator.Display.Text := '123456789';//'1234567890ABCDEF0123456789ABCDEF';
  FCalculator.Parent := DisplayPanel;
  FCalculator.ParentalGuidanceMode := FParentalGuidanceMode;
  FCalculator.Display.OnClean := @OnClean;
  PGMToggle.Action := acPGM;
  FRadixMode := rmDecimal;
  for rm := Low(TRadixMode) to High(TRadixMode) do
  begin
    RadixPnl.Items[Ord(rm)] := RadixStr[rm];
  end;
end;

procedure TCalcForm.TestBtnClick(Sender: TObject);
begin
  RadixMode := rmRoman;
  EXIT;


  FCalculator.ParentalGuidanceMode := CleanCB.Checked;
  ParentalGuidanceMode := CleanCB.Checked;
  FCalculator.Display.Text := OrgEd.Text;
  RealEd.Text := FCalculator.Display.RealText;

end;

procedure TCalcForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_LEFT) and (Shift = []) then
  begin
    Key := 0;
    FCalculator.Display.ScrollBy(-1);
  end
  else if (Key = VK_RIGHT) and (Shift = []) then
  begin
    FCalculator.Display.ScrollBy(1);
    Key := 0;
  end
  else if (Key = VK_HOME) and (Shift = []) then
  begin
    FCalculator.Display.ScrollToBegin;
    Key := 0;
  end
  else if (Key = VK_END) and (Shift = []) then
  begin
    FCalculator.Display.ScrollToEnd;
    Key := 0;
  end
end;

procedure TCalcForm.FormShow(Sender: TObject);
begin
  Application.QueueAsyncCall(@Layout, 0);
end;


procedure TCalcForm.RadixPnlSelectionChanged(Sender: TObject);
var
  Idx: Integer;
begin
  writeln('RadixRGSelectionChanged: ItemIndex = ',RadixPnl.ItemIndex);
  Idx := RadixPnl.ItemIndex;
  case Idx of
    idxDecimal: RadixMode := rmDecimal;
    idxHexadecimal: RadixMode := rmHexadecimal;
    idxBinary: RadixMode := rmBinary;
    idxOctal: RadixMode := rmOctal;
    idxRoman: RadixMode := rmRoman;
    else RadixMode := DefradixMode;
  end;
end;


procedure TCalcForm.Button1Click(Sender: TObject);
begin
  FCalculator.Display.CopyToClipBoard;
end;

procedure TCalcForm.acEditClearAllExecute(Sender: TObject);
begin
  FCalculator.Reset;
end;

procedure TCalcForm.acEditClearExecute(Sender: TObject);
begin
  FCalculator.ClearDisplay;
end;

procedure TCalcForm.acEditCopyExecute(Sender: TObject);
begin
  FCalculator.Display.CopyToClipBoard;
end;

procedure TCalcForm.acEditCutExecute(Sender: TObject);
begin
  FCalculator.Display.CutToClipBoard;
end;

procedure TCalcForm.acEditPasteExecute(Sender: TObject);
begin
  FCalculator.Display.PastFromClipBoard;
end;

procedure TCalcForm.acEqualsExecute(Sender: TObject);
begin
  FCalculator.CalculateImmediate;
end;

procedure TCalcForm.acMemAddExecute(Sender: TObject);
begin
  FCalculator.Memory.AddN(FCalculator.Display.Value);
end;

procedure TCalcForm.acMemClearExecute(Sender: TObject);
begin
  FCalculator.Memory.Clear;
end;

procedure TCalcForm.acMemReadExecute(Sender: TObject);
begin
  FCalculator.Display.Value := FCalculator.Memory.Value;
end;

procedure TCalcForm.acMemSetExecute(Sender: TObject);
begin
  FCalculator.Memory.Value := FCalculator.Display.Value;
end;

procedure TCalcForm.acMemSubExecute(Sender: TObject);
begin
  FCalculator.Memory.SubN(FCalculator.Display.Value);
end;

procedure TCalcForm.acMulExecute(Sender: TObject);
begin
  FCalculator.&Operator := nopMul;
end;


procedure TCalcForm.acBackSpaceExecute(Sender: TObject);
begin
  FCalculator.Input(BackSpaceChar);
end;

procedure TCalcForm.acDivExecute(Sender: TObject);
begin
  FCalculator.&Operator := nopDivMod;
end;

procedure TCalcForm.acAddExecute(Sender: TObject);
begin
  FCalculator.&Operator := nopAdd;
end;

procedure TCalcForm.acPGMExecute(Sender: TObject);
begin
  ParentalGuidanceMode := IsTrue(PGMToggle.Checked);
  //PGMToggle.Enabled := not FParentalGuidanceMode;
end;

procedure TCalcForm.acInputExecute(Sender: TObject);
var
  Key: Char;
  AAction: TAction;
begin
  writeln('TCalcForm.acInputExecute');
  Key := #0;
  if IsFalse(Sender is TAction) then
    Exit;
  AAction := TAction(Sender);
  if IsTrue(InputActionList.IndexOfName(AAction.Name) = -1) then
    Exit;
  case AAction.Tag of
    0: Key := '0';
    1: Key := '1';
    2: Key := '2';
    3: Key := '3';
    4: Key := '4';
    5: Key := '5';
    6: Key := '6';
    7: Key := '7';
    8: Key := '8';
    9: Key := '9';
    10: Key := 'A';
    11: Key := 'B';
    12: Key := 'C';
    13: Key := 'D';
    14: Key := 'E';
    15: Key := 'F';
    201: Key := 'I';
    202: Key := 'V';
    203: Key := 'X';
    204: Key := 'L';
    205: Key := 'C';
    206: Key := 'D';
    207: Key := 'M';
    255: Key := '_';
  end;
  ProcessInput(Key);
end;

procedure TCalcForm.acSubExecute(Sender: TObject);
begin
  FCalculator.&Operator := nopSub;
end;


procedure TCalcForm.Button2Click(Sender: TObject);
begin
  FCalculator.Display.CutToClipBoard;
end;

procedure TCalcForm.Button3Click(Sender: TObject);
begin
  FCalculator.Display.PastFromClipBoard;
end;

procedure TCalcForm.DebugNCalcCBChange(Sender: TObject);
begin
  DebugNCalc := DebugNcalcCB.Checked;
end;

procedure TCalcForm.FormDestroy(Sender: TObject);
begin
  FCalculator.Free;
end;

procedure TCalcForm.Layout(Dummy: PtrInt);
var
  TWidth: Integer;
  CompW, Space: Integer;
begin
  //
  TWidth := Width - (2 * DisplayPanel.Left);
  DisplayPanel.Width := TWidth;
  FCalculator.Display.Width := DisplayPanel.Width - (2 * FCalculator.Display.Left);
  RadixPnl.Width := TWidth;
  RadixPnl.AnchorToNeighbour(akTop, 5, DisplayPanel);
  //PGMToggle.AnchorToNeighbour(akTop, 5, RadixPnl);
  MemPnl.AnchorToNeighbour(akTop, 5, RadixPnl);
  PGMToggle.Top := MemPnl.Top;
  //PGMToggle.Height := MemPnl.Height;
  MemPnl.AnchorToNeighbour(akLeft, 5, PGMToggle);
  MemPnl.Width := Round((TWidth - PGMToggle.Width - 5- 5) * (5 / 11));
  PGMToggle.Top := MemPnl.Top + MemPnl.Height - PGMToggle.Height;

  writeln('MemGB.Top = ',MemPnl.Top,' PGMToggle.Top = ',PGMToggle.Top);
  writeln('MemClrBtn.ClientToParent.Y = ',MemClrBtn.ClientToParent(Point(MemClrBtn.Left, MemClrBtn.Top), CalcForm).Y);
  //PGMToggle.Top := MemClrBtn.ClientToParent(Point(MemClrBtn.Left, MemClrBtn.Top), CalcForm).Y;
  writeln('MemGB.Width = ',MemPnl.Width);

  CompW := MemPnl.ClientWidth;
  Space := (CompW - (2 * 5) - (5 * MemClrBtn.Width)) div 4;

  writeln('Space = ',Space);

  MemClrBtn.Left := 5;
  MemSetBtn.AnchorToNeighbour(akLeft, Space, MemClrBtn);
  MemReadBtn.AnchorToNeighbour(akLeft, Space, MemSetBtn);
  MemAddBtn.AnchorToNeighbour(akLeft, Space, MemReadBtn);
  MemSubBtn.AnchorToNeighbour(akLeft, Space, MemAddBtn);

  EditPnl.AnchorToNeighbour(akTop, 5, RadixPnl);
  EditPnl.AnchorToNeighbour(akLeft, 5, MemPnl);
  EditPnl.Width := TWidth - EditPnl.Left + 5;

  writeln('EditGB.Width = ',EditPnl.Width);
  //writeln('MemGB / EditGB = ', EditPnl.Width/MemPnl.Width:5:4,' 6/5 = ',6/5:5:4);

  CompW := EditPnl.ClientWidth;
  Space := (CompW - (2 * 5) - (6 * EditBsBtn.Width)) div 5;

  writeln('Space = ',Space);

  EditBsBtn.Left := 5;
  EditClearAllBtn.AnchorToNeighbour(akLeft, Space , EditBsBtn);
  EditClearBtn.AnchorToNeighbour(akLeft, Space , EditClearAllBtn);
  EditCopyBtn.AnchorToNeighbour(akLeft, Space , EditClearBtn);
  EditCutBtn.AnchorToNeighbour(akLeft, Space , EditCopyBtn);
  EditPasteBtn.AnchorToNeighbour(akLeft, Space , EditCutBtn);
end;

procedure TCalcForm.OnAppException(Sender: TObject; E: Exception);
begin
  writeln('An unhandled exception occurred');
  writeln('Exception type is: ',E.ClassName);
  writeln('Message is: ',E.Message);
  FCalculator.ForceError;
end;

procedure TCalcForm.SetParentalGuidanceMode(AValue: OPBool);
begin
  if IsTrue(FParentalGuidanceMode = AValue) then Exit;
  FParentalGuidanceMode := AValue;
  FCalculator.ParentalGuidanceMode := AValue;
//  FDisplay.ParentalGuidanceMode := FParentalGuidanceMode;
end;

procedure TCalcForm.SetRadixMode(AValue: TRadixMode);
begin
  FCalculator.Display.RadixMode := AValue;
  FRadixMode := FCalculator.Display.RadixMode;
  if IsFalse(RadixPnl.ItemIndex = Ord(FRadixMode)) then
    RadixPnl.ItemIndex := Ord(FRadixMode);
  UpdateInputControls(FRadixMode);
end;

procedure TCalcForm.UpdateInputControls(AValue: TRadixMode);
var
  i: Integer;
begin
  case AValue of
    rmDecimal:
    begin
      for i := 0 to InputActionList.ActionCount - 1 do
      begin
        if IsTrue((InputActionList.Actions[i] as TAction).Tag in [0..9]) then
          (InputActionList.Actions[i] as TAction).Enabled := True
        else
          (InputActionList.Actions[i] as TAction).Enabled := False;
      end;
    end;
    rmHexadecimal:
    begin
      for i := 0 to InputActionList.ActionCount - 1 do
      begin
        if IsTrue((InputActionList.Actions[i] as TAction).Tag in [0..15]) then
          (InputActionList.Actions[i] as TAction).Enabled := True
        else
          (InputActionList.Actions[i] as TAction).Enabled := False;
      end;
    end;
    rmBinary:
    begin
      for i := 0 to InputActionList.ActionCount - 1 do
      begin
        if IsTrue((InputActionList.Actions[i] as TAction).Tag in [0,1]) then
          (InputActionList.Actions[i] as TAction).Enabled := True
        else
        (InputActionList.Actions[i] as TAction).Enabled := False;
      end;
    end;
    rmOctal:
    begin
      for i := 0 to InputActionList.ActionCount - 1 do
      begin
        if IsTrue((InputActionList.Actions[i] as TAction).Tag in [0..7]) then
          (InputActionList.Actions[i] as TAction).Enabled := True
        else
          (InputActionList.Actions[i] as TAction).Enabled := False;
      end;
    end;
    rmRoman:
    begin
      for i := 0 to InputActionList.ActionCount - 1 do
      begin
        if IsTrue((InputActionList.Actions[i] as TAction).Tag in [1,5,12,13,201..208]) then
          (InputActionList.Actions[i] as TAction).Enabled := True
        else
          (InputActionList.Actions[i] as TAction).Enabled := False;
      end;
    end;
  end; //case
  acBackSpace.Enabled := True;
  acNegate.Enabled := True;
end;

procedure TCalcForm.OnClean(Sender: TObject; const AName, AValue: String; var Cancel: OPBool);
begin
  write('OnClean: FParentalGuidanceMode = ',FParentalGuidanceMode,' AName = ',AName,' AValue = ',AValue);
  Cancel := IsFalse(FParentalGuidanceMode);
  writeln(' Cancel = ',Cancel);
end;

procedure TCalcForm.ProcessInput(Key: Char);
begin
  writeln('TCalcForm.ProcessInput: Key = "',Key,'"');
  FCalculator.Input(Key);
end;


end.

