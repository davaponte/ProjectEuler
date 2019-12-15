{
  The CalculatorDisplay unit provides a class that can dislay static text
  (i.e. it cannot be focussed, and it not an editable control),
  with the ability to scroll text that is wider than the width of the control,
  and can clean any displayed numbers in it(as seen upside down)
  on a calculator, from words that can be percived as offending.
  It provides a callback event cancel cleaning of a given input on a per
  word basis.

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

unit CalculatorDisplay;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, Types, LCLType, ClipBrd,
  Expressions, BoolFactory, NCalc, CalculatorParentalGuide;

type

  TRadixMode = (rmDecimal, rmHexadecimal, rmBinary, rmOctal, rmRoman);

{ TCalculatorDisplay }

  TCalculatorDisplay = class(TGraphicControl)
  private
    FScrollChars: integer;
    FWidthInChars: integer;
    FRealText: String;
    FCleaner: TParentalGuideNumberCleaner;
    FOnClean: TCleanValueEvent;
    FParentalGuidanceMode: OPBool;
    FRadixMode: TRadixMode;
    FOnError: TNotifyEvent;
    FError: OPBool;
    function GetValue: TValue;
    function GetWidthInChars: integer;
    procedure DoOnClean(Sender: TObject; const AName: TValue; const AValue: String; var Cancel: OPBool);
    procedure CalculatorDisplaySetText(AValue: String);
    function CalculatorDisplayGetText: String;
    procedure SetParentalGuidanceMode(AValue: OPBool);
    procedure SetRadixMode(AValue: TRadixMode);
    procedure SetValue(AValue: TValue);
    procedure Error;
  protected
    class function GetControlClassDefaultSize: TSize; override;
    procedure Paint; override;
    procedure RealSetText(const Value: TCaption); override;
  public
    constructor Create(anOwner: TComponent); override;
    destructor Destroy; override;
    function ScrollBy(numChars: integer): OPBool;
    function ScrollToEnd: OPBool;
    function ScrollToBegin: OPBool;
    procedure CopyToClipBoard;
    procedure CutToClipBoard;
    procedure PastFromClipBoard;
    procedure Clear;
    procedure Reset;
    property RealText: String read FRealText;
    property WidthInChars: Integer read GetWidthInChars;
  published
    property Text: String read CalculatorDisplayGetText write CalculatorDisplaySetText;
    property OnClean: TCleanValueEvent read FOnClean write FOnClean;
    property ParentalGuidanceMode: OPBool read FParentalGuidanceMode write SetParentalGuidanceMode;
    property RadixMode: TRadixMode read FRadixMode write SetRadixMode;
    property Value: TValue read GetValue write SetValue;

    property OnError: TNotifyEvent read FOnError write FOnError;
  end;

implementation

const
  SError = 'Error';

{ TCalculatorDisplay }

function TCalculatorDisplay.GetWidthInChars: integer;
begin
  Result := Width div Canvas.TextWidth('M');
end;

function TCalculatorDisplay.GetValue: TValue;
var
  S: String;
  B: OPBool;
begin
  S := Text;
  if IsTrue(S = '') then
    Result := '0'
  else
  begin
    case FRadixMode of
      rmDecimal:
      begin
        Result:= S;
        B := ToBool(True);
      end;
      rmHexadecimal: B := TryHexToNumber(S, Result);
      rmBinary: B := TryBinToNumber(S, Result);
      rmOctal: B := TryOctToNumber(S, Result);
      rmRoman: B := TryRomanToNumber(S, Result);
    end; //case
  end;
  if IsFalse(B) then
    Result := '0';
end;

class function TCalculatorDisplay.GetControlClassDefaultSize: TSize;
begin
  Result.cx:=50;
  Result.cy:=15;
end;

procedure TCalculatorDisplay.Paint;
var
  ts: TTextStyle;
  r: TRect;
  start, stop: integer;
begin
  FWidthInChars:=GetWidthInChars;
  FillChar(ts,SizeOf(ts),0);
  with ts do begin
    Alignment := BidiFlipAlignment(taRightJustify, UseRightToLeftAlignment);
    Layout := tlCenter;
    Opaque := (Color<>clNone);
    SingleLine:= True;
    Clipping := True;
    RightToLeft := UseRightToLeftReading;
    ExpandTabs := True;
  end;
  r := ClientRect;
  Canvas.Brush.Color := Color;
  if (Color<>clNone) then begin
    Canvas.Brush.Style := bsSolid;
    Canvas.FillRect(R);
  end;
  Canvas.Brush.Style := bsClear;
  Canvas.Font := Font;
  r.Left := r.Left;

  stop := GetTextLen - FScrollChars;
  start := stop - FWidthInChars;
  if (start < 1) then start := 1;
  //start := GetTextLen - (FWidthInChars + FScrollChars) + 1;

  Canvas.TextRect(r, 0, 0, Copy(Text, start, stop - start + 1), ts);
  inherited Paint;
end;

procedure TCalculatorDisplay.RealSetText(const Value: TCaption);
begin
//  FScrollChars := 0;
  inherited RealSetText(Value);
  Invalidate;
end;

constructor TCalculatorDisplay.Create(anOwner: TComponent);
begin
  inherited Create(anOwner);
  with GetControlClassDefaultSize do begin
    SetInitialBounds(Left, Top, cx, cy);
  end;
  FScrollChars := 0;
  FRadixMode := rmDecimal;
  FCleaner := TParentalGuideNumberCleaner.Create;
  FParentalGuidanceMode := ToBool(False);
  FCleaner.OnCleanValue := @DoOnClean;
  FError := ToBool(False);
end;

destructor TCalculatorDisplay.Destroy;
begin
  FCleaner.Free;
  inherited Destroy;
end;

function TCalculatorDisplay.ScrollBy(numChars: integer): OPBool;
var
  textLen, OldScrollChars: integer;
begin
  Result := False;
  textLen := GetTextLen;
  OldScrollChars := FScrollChars;
  if IsTrue(textLen <= FWidthInChars) or IsTrue(numChars > Pred(textLen))
    then Exit;
  FScrollChars := FScrollChars - numChars;
  if IsTrue(FScrollChars < 0) then FScrollChars := 0;
  if IsTrue(FScrollChars > textLen) then FScrollChars := textLen;
  if IsFalse(OldScrollChars = FScrollChars) then
  begin
    Invalidate;
    Result := True;
  end;
end;

function TCalculatorDisplay.ScrollToEnd: OPBool;
begin
  if IsFalse(FScrollChars = 0) then
  begin
    FScrollChars := 0;
    Result := ToBool(True);
    Invalidate;
  end
  else
    Result := ToBool(False);
end;

function TCalculatorDisplay.ScrollToBegin: OPBool;
var
  NewScrollChars, TextLen: Integer;
begin
  TextLen := GetTextLen;
  writeln('TextLen = ',TextLen);
  NewScrollChars := TextLen - (GetWidthInChars - 1);
  write('NewScrollChars = ',NewScrollChars,' -> ');
  if IsTrue(NewScrollChars > TextLen) then NewScrollChars := TextLen;
  writeln(NewScrollChars);
  if IsFalse(FScrollChars = NewScrollChars) then
  begin
    FScrollChars := NewScrollChars;
    Result := ToBool(True);
    Invalidate;
  end
  else
    Result := ToBool(False);
end;

procedure TCalculatorDisplay.CopyToClipBoard;
begin
  if IsTrue(FError) then Exit;
  ClipBoard.AsText := Text;
end;

procedure TCalculatorDisplay.CutToClipBoard;
begin
  if IsTrue(FError) then Exit;
  CopyToClipBoard;
  Clear;
end;

procedure TCalculatorDisplay.PastFromClipBoard;
begin
  if IsTrue(FError) then Exit;
  if IsTrue(ClipBoard.HasFormat(CF_Text)) then
    Text := ClipBoard.AsText
end;

procedure TCalculatorDisplay.Clear;
begin
  Value := '0';
end;

procedure TCalculatorDisplay.Reset;
begin
  FError := ToBool(False);
  Clear;
end;

procedure TCalculatorDisplay.DoOnClean(Sender: TObject; const AName: TValue;
  const AValue: String; var Cancel: OPBool);
begin
  if IsTrue(Assigned(FOnClean)) then FOnClean(Sender, AName, AValue, Cancel);
end;

procedure TCalculatorDisplay.CalculatorDisplaySetText(AValue: String);
var
  Needed: OPBool;
begin
  if IsFalse(CalculatorDisplayGetText = AValue) then
  begin
    writeln('SetText: FParentalGuidanceMode = ',FParentalGuidanceMode);
    FScrollChars := 0;
    FRealText := AValue;
    if IsTrue(FParentalGuidanceMode) then
    begin
      AValue := FCleaner.CleanValue(AValue, Needed);
    end;
    inherited Text := AValue;
  end;
end;

function TCalculatorDisplay.CalculatorDisplayGetText: String;
begin
  Result := inherited Text;
end;

procedure TCalculatorDisplay.SetParentalGuidanceMode(AValue: OPBool);
var
  S: String;
  Needed: OPBool;
begin
  if IsTrue(FParentalGuidanceMode = AValue) then Exit;
  FParentalGuidanceMode := AValue;
  if IsTrue(FParentalGuidanceMode) then
  begin
    S := FCleaner.CleanValue(FRealText, Needed);
    if IsFalse(S = FRealText) then
    begin
      FScrollChars := 0;
      inherited Text := S;
      //Invalidate;
    end;
  end
  else
  begin
    Text := FRealText;
  end;
end;

procedure TCalculatorDisplay.SetRadixMode(AValue: TRadixMode);
var
  OldN: TValue;
  S: String;
begin
  //writeln('TCalculatorDisplay.SetRadixmode: FRadixMode = ',FRadixMode,' AValue = ',AValue,' FError = ',FError);
  if IsTrue(FRadixMode = AValue) or IsTrue(FError) then Exit;
  OldN := GetValue;
  //writeln(' OldN = ',OldN);
  FRadixMode := AValue;
  SetValue(OldN);
  //writeln(' After conversion: Text = ',Text);
end;

procedure TCalculatorDisplay.SetValue(AValue: TValue);
var
  S: TValue;
begin
  writeln('TCalculatorDisplay.SetValue: AValue = ',AValue);
  writeln('  FRadixMode = ',FRadixMode);
  if IsTrue(FError) then Exit;
  try
    case FRadixMode of
      rmDecimal: S := AValue;
      rmHexadecimal: S := NumberToHexN(AValue);
      rmBinary: S := NumberToBinN(AValue);
      rmOctal: S := NumberToOctN(AValue);
      rmRoman: S := NumberToRomanN(AValue);
    end;
    writeln(' After conversion: S = ',S);
    Text := S;
  except
    on E: ENumber do Error;
  end;
end;

procedure TCalculatorDisplay.Error;
begin
  FError := ToBool(True);
  Text := SError;
  if IsTrue(Assigned(FOnError)) then
    FOnError(Self);
end;


end.

