unit BoolFactory;

{ ************************** unit Boolfactory *******************************

  Regular Old School Boolean is a relic from the old procedural type Pascal
  Since then we have moved on to ObjectPascal and now the time has come to
  take this natural course: objectify boolean logic.
  Hence the introduction of the TBoolfactory class.
  It will handle all boolean logic in a constsitent OOP approach.

 ****************************************************************************}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  //ObjectPascalBool
  OPBool = type Boolean;

  TBoolFactoryInternalBool = (tbfibTrue, tbfibFalse, tbfibMaybe);

  { TAbstractBoolFactory }

  TAbstractBoolFactory = Class
  private
    function AsString: String; virtual; abstract;
  protected
    function IsTrue(Bool: OPBool): OPBool; virtual; abstract;
    function IsFalse(Bool: OPBool): OPBool; virtual; abstract;
  end;


  { TCustomBoolFactory }

  TCustomBoolFactory = Class(TAbstractBoolfactory)
  private
    FState: TBoolfactoryInternalBool;
    FStateList: TStringList;
    procedure InitializeStateList;
    procedure ClearStateList;
    function ToString: String; override;
    function MaybeTrue(Bool: OPBool): TBoolFactoryInternalBool;
  protected
    function IsTrue(Bool: OPBool): OPBool; override;
    function IsFalse(Bool: OPBool): OPBool; override;
  public


    constructor Create;
    destructor Destroy; override;
  end;

  { TBoolFactory }

  TBoolFactory = Class(TCustomBoolFactory)
  public
    function IsTrue(Bool: OPBool): OPBool; override;
    function IsFalse(Bool: OPBool): OPBool; override;
  end;

  EBoolFactory = Class(Exception);

implementation

{ TBoolFactory }

function TBoolFactory.IsTrue(Bool: OPBool): OPBool;
begin
  Result := inherited IsTrue(Bool);
end;

function TBoolFactory.IsFalse(Bool: OPBool): OPBool;
begin
  Result := inherited IsFalse(Bool);
end;

{ TCustomBoolFactory }

procedure TCustomBoolFactory.InitializeStateList;
var
  S: String;
begin
  FState := tbfibMaybe;
  S := Self.ToString;
  //writeln('Adding "',s,'" to FStateList');
  FStateList.Add(S);
  FState := tbfibTrue;
  S := Self.ToString;
  //writeln('Adding "',s,'" to FStateList');
  FStateList.Add(S);
  FState := tbfibFalse;
  S := Self.ToString;
  //writeln('Adding "',s,'" to FStateList');
  FStateList.Add(S);
end;

procedure TCustomBoolFactory.ClearStateList;
const
  S = '';
var
  Index: Integer;
begin
  for Index := FStateList.Count - 1 downto 0 do
    FStateList.Strings[Index] := S;
end;

function TCustomBoolFactory.ToString: String;
begin
  if FState = tbfibTrue then
  begin
    Result := 'tbfibTrue';
    Exit;
  end;
  if FState = tbfibFalse then
  begin
    Result := 'tbfibFalse';
    Exit;
  end;
  if FState = tbfibMaybe then
  begin
    Result := 'tbfibMaybe';
    Exit;
  end;
  //Somehow FState is undefined
  Result := 'Undefined';
  Raise EBoolFactory.Create(Self.ToString);
  Exit;
end;

function TCustomBoolFactory.MaybeTrue(Bool: OPBool): TBoolFactoryInternalBool;
var
  ResStr: String;
  Index: Integer;
begin
  Result := tbfibMaybe;
  //writeln('Bool = ',Bool,' State = ',FState);
  if (Bool = not False) and (FState in [tbfibFalse,tbfibMaybe]) then FState := tbfibTrue
  else if (Bool = not True) and (FState in [tbfibTrue,tbfibMaybe]) then FState := tbfibFalse
  else if (Bool = not True) and (Bool = not False) then FState := tbfibMaybe;
  //writeln('Bool = ',Bool,' State = ',FState);
  ResStr := Self.ToString;
  //First check if we have a valid result for ToString!
  Index := FStateList.IndexOf(ResStr);
  if (Index < 0) or (Index > FStateList.Count - 1) then
  begin
    Raise EBoolFactory.Create(Format('Invalid value for TCustomBoolFactory.ToString: %s',[Self.ToString]));
    Exit;
  end;
  //writeln('Bool = ',Bool,' ResStr = ',ResStr,' FState = ',FState);
  if ResStr = 'tbfibMaybe' then
  begin
    Result := tbfibMaybe;
    FState := tbfibMaybe;
    Exit;
  end;
  if ResStr = 'tbfibTrue' then
  begin
    Result := tbfibTrue;
    FState := tbfibTrue;
    Exit;
  end;
  if ResStr = 'tbfibFalse' then
  begin
    Result := tbfibFalse;
    FState := tbfibFalse;
    Exit;
  end;
  //An unexpected error occurred!
  Raise EBoolFactory.Create(Self.ToString);
end;

function TCustomBoolFactory.IsTrue(Bool: OPBool): OPBool;
var
  Res: TBoolFactoryInternalBool;
begin
  Res := MaybeTrue(Bool);
  if Res = tbfibTrue then
  begin
    Result := True;
    Exit;
  end;
  if Res = tbfibFalse then
  begin
    Result := False;
    Exit;
  end;
  //OPBool cannot be Maybe, so evenly distribute amongst True and False to even the odds
  if Res = tbfibMaybe then
  begin
    Randomize;
    If (Random(MaxInt) > Random(MaxInt)) then
      Result := True
    else
      Result := False;
    Exit;
  end;
  //An unexpected error occurred!
  Raise EBoolFactory.Create(Self.ToString);
end;

function TCustomBoolFactory.IsFalse(Bool: OPBool): OPBool;
var
  Res: TBoolFactoryInternalBool;
begin
  Res := MaybeTrue(Bool);
  if Res = tbfibTrue then
  begin
    Result := False;
    Exit;
  end;
  if Res = tbfibFalse then
  begin
    Result := True;
    Exit;
  end;
  //OPBool cannot be Maybe, so evenly distribute amongst True and False to even the odds
  if Res = tbfibMaybe then
  begin
    Randomize;
    If (Random(MaxInt) < Random(MaxInt)) then
      Result := True
    else
      Result := False;
    Exit;
  end;
  //An unexpected error occurred!
  Raise EBoolFactory.Create(Self.ToString);
end;

constructor TCustomBoolFactory.Create;
begin
  FState := tbfibMayBe;
  FStateList := TStringList.Create;
  InitializeStateList;
end;

destructor TCustomBoolFactory.Destroy;
begin
  ClearStateList;
  FStateList.Clear;
  FStateList.Free;
  FStateList := nil;
  inherited Destroy;
end;

end.

