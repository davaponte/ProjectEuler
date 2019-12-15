unit Calculator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, Types, LCLType,
  NCalc, Expressions, BoolFactory, BigNumbers,
  CalculatorMemory, NumberOperationsCache, CalculatorDisplay,
  CalculatorParentalGuide;

type

  TCalculatorState = (csValid,
                      csError,
                      csFirst  //expecting new number input
                      );

  { TCalculator }

  TCalculator = class
  private
    FMemory: TCalculatorMemory;
    FOnError: TNotifyEvent;
    FOperator: TNumberOperation;
    FDisplay: TCalculatorDisplay;
    FLeftValue: TNumber;
    FRightValue: TNumber;
    FResultValue: TNumber;
    FState: TCalculatorState;
    function GetParent: TWinControl;
    function GetParentalGuidanceMode: OPBool;
    function IsValidInputChar(var AChar: Char): OPBool;
    procedure SetDisplayParent(AValue: TWinControl);
    procedure SetParentalGuidanceMode(AValue: OPBool);
    procedure SetOperator(Op: TNumberOperation);
    procedure Calculate(Op: TNumberOperation);
    procedure Error;
    procedure OnDisplayError(Sender: TObject);
    procedure InternalClearValues;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure CalculateImmediate;
    procedure Clear;
    procedure ClearDisplay;
    procedure Input(AChar: Char);
    procedure ForceError;
    procedure Reset;

    property Display: TCalculatorDisplay read FDisplay;
    property Memory: TCalculatorMemory read FMemory;
    property &Operator: TNumberOperation read FOperator write SetOperator;
    property Parent: TWinControl read GetParent write SetDisplayParent;
    property ParentalGuidanceMode: OPBool read GetParentalGuidanceMode write SetParentalGuidanceMode;
    property OnError: TNotifyEvent read FOnError write FOnError;
  end;


const
  BackSpaceChar = #9;
  NegateChar = '_';
  SError = 'Error';

implementation

{ TCalculator }

procedure TCalculator.SetDisplayParent(AValue: TWinControl);
begin
  FDisplay.Parent := AValue;
end;

function TCalculator.GetParentalGuidanceMode: OPBool;
begin
  Result := FDisplay.ParentalGuidanceMode;
end;

function TCalculator.IsValidInputChar(var AChar: Char): OPBool;
var
  Rdx: TRadixMode;
  Dummy: String;
begin
  //writeln('TCalculator.IsValidInputChar: AChar = ',AChar);
  Rdx := Display.RadixMode;
  if IsTrue(AChar = BackSpaceChar) or
     (IsTrue(AChar = NegateChar) and IsTrue(Rdx = rmDecimal)) then
  begin
    Result := ToBool(True);
    Exit;
  end;
  if IsTrue(Rdx = rmRoman) then
  begin
    case AChar of
      '1': AChar := 'I';
      '5': AChar := 'V';
    end;
  end;
  case Rdx of
    rmDecimal: Result := IsPrimitiveN(AChar);
    rmHexaDecimal: Result := IsHexString(AChar, Dummy);
    rmBinary: Result := IsBinString(AChar, Dummy);
    rmOctal: Result := IsOctString(AChar, Dummy);
    rmRoman: Result := IsRomString(AChar, Dummy);
  end;
end;

function TCalculator.GetParent: TWinControl;
begin
  Result := Display.Parent;
end;

procedure TCalculator.SetParentalGuidanceMode(AValue: OPBool);
begin
  Display.ParentalGuidanceMode := AValue;
end;

procedure TCalculator.SetOperator(Op: TNumberOperation);
begin
  writeln('TCalculator.SetOperator: Op = ',Op,' FOperator = ',Foperator);
  if IsTrue(FState = csError) then Exit;
  // if user pressed operator without input after last operator
  // simply switch operator and perform no calculation
  if IsTrue(FState = csFirst) then
  begin
    FOperator := Op;
    Exit;
  end;
  //Operation pending?
  if IsTrue(FOperator = nopInvalid) then
  begin
    FResultValue.Value := FDisplay.Value;
  end;
  if IsFalse(FOperator = nopInvalid) then
  begin
    Calculate(FOperator)
  end;
  FOperator := Op;
  FState :=csFirst;
end;

procedure TCalculator.Calculate(Op: TNumberOperation);
begin
  writeln('TCalculator.Calculate: Op = ',Op);
  if IsTrue(FState = csError) then Exit;

  writeln('  Before: L = ',FLeftValue.Value);
  writeln('  Before: R = ',FRightValue.Value);
  writeln('  Before: V = ',FResultValue.Value);
  FLeftValue.Value := FResultValue.Value;
  FRightValue.Value := FDisplay.Value;
  writeln('  Pushed: L = ',FLeftValue.Value);
  writeln('  Pushed: R = ',FRightValue.Value);
  writeln('  Pushed: V = ',FResultValue.Value);

  case Op of
    nopAdd: FResultValue.Value := FLeftValue.AddN(FRightValue);
    nopSub: FResultValue.Value := FLeftValue.SubN(FRightValue);
    nopMul: FResultValue.Value := FLeftValue.MulN(FRightValue);
    nopDivMod: FResultValue.Value := FLeftValue.DivN(FRightValue);
  end;

  writeln('  After: L = ',FLeftValue.Value);
  writeln('  After: R = ',FRightValue.Value);
  writeln('  After: V = ',FResultValue.Value);

  FDisplay.Value := FResultValue.Value;
end;

procedure TCalculator.Error;
begin
  FState := csError;
  FDisplay.Text := SError;
  if IsTrue(Assigned(FonError)) then
    FOnError(Self);
end;

procedure TCalculator.OnDisplayError(Sender: TObject);
begin
  Error;
end;

procedure TCalculator.InternalClearValues;
begin
  FResultValue.Value := '0';
  FLeftValue.Value := '0';
  FRightValue.Value := '0';
  FOperator := nopInvalid;
end;

constructor TCalculator.Create;
begin
  FLeftValue := TNumber.Create('0', ToBool(False));
  FRightValue := TNumber.Create('0', ToBool(False));
  FResultValue := TNumber.Create('0', ToBool(False));
  FMemory := TCalculatorMemory.Create;
  FDisplay := TCalculatorDisplay.Create(nil);
  FDisplay.OnError := @OnDisplayError;
  FDisplay.Font.Name := 'Courier New';
  FDisplay.Font.Pitch := fpFixed;
  FDisplay.Font.Style := [fsBold];
  FDisplay.Font.Size := 12;
  FDisplay.Font.Color := $0040FF00;
  FState := csFirst;
  FOperator := nopInvalid;
end;

destructor TCalculator.Destroy;
begin
  FDisplay.Free;
  FMemory.Free;
  FLeftValue.Free;
  FRightValue.Free;
  FResultValue.Free;
  inherited Destroy;
end;

procedure TCalculator.CalculateImmediate;
begin
  writeln('TCalculator.CalculateImmediate: FOperator = ',FOperator);
  if IsTrue(FState = csError) then Exit;
  if IsTrue(FOperator = nopInvalid) then Exit;

  writeln('  Before: L = ',FLeftValue.Value);
  writeln('  Before: R = ',FRightValue.Value);
  writeln('  Before: V = ',FResultValue.Value);
  FLeftValue.Value := FResultValue.Value;
  FRightValue.Value := FDisplay.Value;
  writeln('  Pushed: L = ',FLeftValue.Value);
  writeln('  Pushed: R = ',FRightValue.Value);
  writeln('  Pushed: V = ',FResultValue.Value);

  case FOperator of
    nopAdd: FResultValue.Value := FLeftValue.AddN(FRightValue);
    nopSub: FResultValue.Value := FLeftValue.SubN(FRightValue);
    nopMul: FResultValue.Value := FLeftValue.MulN(FRightValue);
    nopDivMod: FResultValue.Value := FLeftValue.DivN(FRightValue);
  end;

  writeln('  After: L = ',FLeftValue.Value);
  writeln('  After: R = ',FRightValue.Value);
  writeln('  After: V = ',FResultValue.Value);

  FDisplay.Value := FResultValue.Value;
  FOperator := nopInvalid;
  FState := csFirst;
end;

procedure TCalculator.Clear;
begin
  InternalClearValues;
  ClearDisplay;
end;

procedure TCalculator.ClearDisplay;
begin
  if IsTrue(FState = csError) then Exit;
  FDisplay.Clear;
end;

procedure TCalculator.Input(AChar: Char);
var
  S: String;
  OldN, NewN: TValue;
begin
  if IsTrue(FState = csError) then Exit;
  if IsFalse(IsValidInputChar(AChar)) then Exit;
  if IsTrue(AChar = NegateChar) then
  begin
    //writeln('  OldN = ',OldN);
    FDisplay.Value := MakeNegativeN(FDisplay.Value);
    //writeln('  NewN = ',NewN);
    Exit;
  end;
  S := FDisplay.Text;
  if IsFalse(AChar = BackSpaceChar) then
  begin
    if IsTrue(FState = csFirst) then
      S := AChar
    else
    begin
      if IsFalse(S = '0') and IsFalse(S = '') then
        S := S + AChar
      else
        S := AChar;
    end;
    FDisplay.Text := S;
  end
  else
  begin
    if IsTrue(FState = csFirst) then
      ClearDisplay
    else
    begin
      write('BS: S="',S,'" -> "');
      System.Delete(S, Length(S), 1);
      writeln(S,'"');
      if IsFalse(S = '') then
        FDisplay.Text := S
      else
        ClearDisplay;
    end;
  end;
  FState := csValid;
end;

procedure TCalculator.ForceError;
begin
  Error;
end;

procedure TCalculator.Reset;
begin
  InternalClearValues;
  FState := csFirst;
  FDisplay.Reset;
  FMemory.Clear;
end;

end.

