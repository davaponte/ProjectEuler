{
  The CalculatorParentalGuide unit provides a class that can clean
  numbers (as seen upside down) on a calculator, from words that
  can be percived as offending.
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

unit CalculatorParentalGuide;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Expressions, BoolFactory, NCalc, LCLProc;

type

  { TCaclculatorParentalGuideDictionary }

  TCaclculatorParentalGuideDictionary = class
  private
    FDictionary: TStringList;
    function GetCount: Integer;
  protected
    function GetName(Index: Integer): String;
    function GetValue(Name: String): String;
  public
    property Names[Index: Integer]: String read GetName;
    property Value[const Name: String]: String read GetValue;
    property Count: Integer read GetCount;
    constructor Create;
  end;

  { TParentalGuideNumberCleaner }

  TCleanValueEvent = procedure(Sender: TObject; const AName, AValue: String; var Cancel: OPBool) of Object;

  TParentalGuideNumberCleaner = class
  private
    FDictionary: TCaclculatorParentalGuideDictionary;
    FOnCleanValue: TCleanValueEvent;
  protected
    procedure DoOnCleanValue(const AName, AValue: String; var Cancel: OPBool);
  public
    constructor Create;
    destructor Destroy; override;

    function CleanValue(N: String; out NeededCleaning: OPBool): String;

    property OnCleanValue: TCleanValueEvent read FOnCleanValue write FOnCleanValue;
  end;

implementation

var
  __InternalCalculatorParentalGuideDictionary: TStringList;

function DictionarySortByLengthOfName(List: TStringList; Index1, Index2: Integer): Integer;
var
  P1, P2: SizeInt;
begin
  P1 := Pos('=',List.Strings[Index1]);
  P2 := Pos('=',List.Strings[Index2]);
  Result := P2 - P1;
end;

procedure PrepareCalculatorParentalGuideDictionary(ADictionary: TStringList);
var
  i: Integer;
begin
  //writeln('PrepareCalculatorParentalGuideDictionary');
  ADictionary.Clear;

  { BIBBOOBS    }  ADictionary.Add('58008918=BIBBOOBS');
  { BIBOS       }  ADictionary.Add('50919=BIBOS');
  { BIGBOOBS    }  ADictionary.Add('58008618=BIGBOOBS');
  { BLOESLOS    }  ADictionary.Add('50753078=BLOESLOS');      //Dutch for Blouse that got unbuttoned
  { BOBBEL      }  ADictionary.Add('738808=BOBBEL');          //Dutch: if you (m) have that in youre trousers, you are "glad to see me (f)"
  { BOE         }  ADictionary.Add('308=BOE');
  { BOLSHIE     }  ADictionary.Add('3145709=BOLSHIE');      //Bolshevik
  { BOOB        }  ADictionary.Add('8008=BOOB');
  { BOOB        }  ADictionary.Add('9009=BOOB');
  { BOOBEZZ     }  ADictionary.Add('2238008=BOOBEZZ');
  { BOOBIEBOOB  }  ADictionary.Add('8008318008=BOOBIEBOOB');
  { BOOBIES     }  ADictionary.Add('5318008=BOOBIES');
  { BOOBLESS    }  ADictionary.Add('55378008=BOOBLESS');
  { BOOBOISIE   }  ADictionary.Add('315109009=BOOBOISIE');   // A class of people regarded as stupid and gullible. [boob + (bourge)oisie.]
  { BOOBS       }  ADictionary.Add('58008=BOOBS');
  { BOOLE       }  ADictionary.Add('37009=BOOLE');
  { BOOZE       }  ADictionary.Add('32008=BOOZE');
  { BOOZE       }  ADictionary.Add('32009=BOOZE');
  { BOZO        }  ADictionary.Add('0209=BOZO');
  { BS          }  ADictionary.Add('59=BS');   // Bullshit
  { HEL         }  ADictionary.Add('734=HEL');
  { HELL        }  ADictionary.Add('7734=HELL');
  { HELLHOLE    }  ADictionary.Add('37047734=HELLHOLE');
  { HELLISH     }  ADictionary.Add('4517734=HELLISH');
  { HELLO       }  ADictionary.Add('07734=HELLO');
  { HILLBILLIES }  ADictionary.Add('53177187714=HILLBILLIES');
  { HO          }  ADictionary.Add('04=HO');      // Short for Whore
  { HOBO        }  ADictionary.Add('0904=HOBO');
  { HOSE        }  ADictionary.Add('3504=HOSE');   //Slang for penis or sexual intercourse
  { LESBIE      }  ADictionary.Add('318537=LESBIE');     // Dutch for Lesbo
  { LESBIES     }  ADictionary.Add('5318537=LESBIES');
  { LESBO       }  ADictionary.Add('0.8537=LESBO');
  { LESBOS      }  ADictionary.Add('509537=LESBOS');
  { OBESE       }  ADictionary.Add('35380=OBESE');
  { OBESE       }  ADictionary.Add('35390=OBESE');
  { OLIEBOL     }  ADictionary.Add('7083170=OLIEBOL');  // Dutch: often used as curse word
  { GEIL        }  ADictionary.Add('7136=GEIL');  // Dutch: Horny
  { SHOO        }  ADictionary.Add('0045=SHOO');   // Shoo means, "go away, I hate you, you don't belong here, why are you still here, you're not supposed to be here, go away!"
  { SIEGHEIL    }  ADictionary.Add('71346315=SIEGHEIL');  //Needs no further explanation I hope
  { SLOB        }  ADictionary.Add('9075=SLOB');
  { SS          }  ADictionary.Add('55=SS');  // Remember WW II ?
  // HexaDecimal words (not upside down)
  ADictionary.Add('A1D5=AIDS');
  ADictionary.Add('A55=ASS');
  ADictionary.Add('A55E55=ASSESS');
  ADictionary.Add('BA1D=BALD');
  ADictionary.Add('BEF001=BEFOOL');
  ADictionary.Add('B0BB1E=BOBBLE');
  ADictionary.Add('B00B=BOOB');
  ADictionary.Add('B00B0151E=BOOBOISIE');
  ADictionary.Add('B020=BOZO');
  ADictionary.Add('C10ACA=CLOACA');
  ADictionary.Add('C0B01=COBOL');    //Can't allow COBOL, this is a Pascalprogram!
  ADictionary.Add('DEF11E=DEFILE');
  ADictionary.Add('DEF11ED=DEFILED');
  ADictionary.Add('D1AB011C=DIABOLIC');
  ADictionary.Add('D1AB011CA1=DIABOLICAl');
  ADictionary.Add('D1AB0115E=DIABOLISE');
  ADictionary.Add('D1AB0112E=DIABOLIZE');
  ADictionary.Add('D11D0=DILDO');
  ADictionary.Add('EC0BABB1E=ECOBABBLE');
  ADictionary.Add('FAECA1=FAECAL');
  ADictionary.Add('FAECE5=FAECES');
  ADictionary.Add('FECA1=FECAL');
  ADictionary.Add('FECE5=FECES');
  ADictionary.Add('F10021E=FLOOZIE');
  ADictionary.Add('1AB1A=LABIA');
  ADictionary.Add('1AB1A1=LABIAL');
  ADictionary.Add('1AB1A115E=LABIALISE');
  ADictionary.Add('1AB1A112E=LABIALIZE');
  ADictionary.Add('1A1D=LAID');
  ADictionary.Add('11B1D0=LIBIDO');
  ADictionary.Add('11D=LID');      //Dutch: it can mean penis
  ADictionary.Add('10ADED=LOADED');
  ADictionary.Add('10C0=LOCO');
  ADictionary.Add('15D=LSD');
  ADictionary.Add('0BE5E=OBESE');
  ADictionary.Add('55=SS');

  //Sort the list with longest "name" first
  ADictionary.CustomSort(@DictionarySortByLengthOfName);
  //writeln('PrepareCalculatorParentalGuideDictionary: after CustomSort');
  //for i := 0 to ADictionary.Count - 1 do
  //begin
  //  writeln(Adictionary.Strings[i]);
  //end;

  //Add these after sorting, because these will only ever be found if any f the above
  //has been applied!!
  ADictionary.Add('5EX=SEX');
  ADictionary.Add('X35=SEX');

end;

function GetInternalCalculatorParentalGuideDictionary: TStringList;
begin
  if not Assigned(__InternalCalculatorParentalGuideDictionary) then
  begin
    __InternalCalculatorParentalGuideDictionary := TStringList.Create;
    PrepareCalculatorParentalGuideDictionary(__InternalCalculatorParentalGuideDictionary);
  end;
  Result := __InternalCalculatorParentalGuideDictionary;
end;

{ TParentalGuideNumberCleaner }

procedure TParentalGuideNumberCleaner.DoOnCleanValue(const AName: TValue; const AValue: String; var Cancel: OPBool);
begin
  if Assigned(FOnCleanValue) then
  begin
    FOnCleanValue(Self, AName, AValue, Cancel);
  end;
end;

constructor TParentalGuideNumberCleaner.Create;
begin
  FDictionary := TCaclculatorParentalGuideDictionary.Create;
end;

destructor TParentalGuideNumberCleaner.Destroy;
begin
  FDictionary.Free;
  inherited Destroy;
end;

function TParentalGuideNumberCleaner.CleanValue(N: String; out
  NeededCleaning: OPBool): String;
var
  i, Len: Integer;
  Name, Value, XXX: String;
  Cancel, IsHex, IsBin: OPBool;
begin
  //writeln('TParentalGuideNumberCleaner.CleanValue: N = ',N);
  {
  IsHex := IsTrue(IsHexString(N, N));
  if IsFalse(IsHex) then
  begin
    IsBin := IsTrue(IsBinString(N, N));
    if IsFalse(IsBin) then
    begin
      AssertIsNumberN(N);
      N := NormalizeNumberN(N);
    end;
  end;}
  if IsTrue(IsNumberN(N)) then N := NormalizeNumberN(N);

  for i := 0 to FDictionary.Count - 1 do
  begin
    Name := FDictionary.Names[i];
    Len := Length(Name);
    if IsFalse(Len = 0) then
    begin
      Value := FDictionary.Value[Name];
      //writeln('Scanning for ',Name,' [',Value,'] -> ',Pos(Name, UpperCase(N)));
      if IsFalse(Pos(Name, UpperCase(N)) = 0) then
      begin
        Cancel := ToBool(False);
        DoOnCleanValue(Name, Value, Cancel);
        //DebugLn(Format('TParentalGuideNumberCleaner: found illegal sequence %s [%s]',[Name, Value]));
        if IsFalse(Cancel) then
        begin
          XXX := StringOfChar('X',Len);
          N := StringReplace(N, Name, XXX, [rfReplaceAll, rfIgnoreCase]);
        end;
      end;
    end;
  end;
  Result := N;
  NeededCleaning := IsFalse(Pos('X', N) = 0);
end;

{ TCaclculatorParentalGuideDictionary }

function TCaclculatorParentalGuideDictionary.GetCount: Integer;
begin
  Result := FDictionary.Count;
end;

function TCaclculatorParentalGuideDictionary.GetName(Index: Integer): String;
begin
  Result := FDictionary.Names[Index];
end;

function TCaclculatorParentalGuideDictionary.GetValue(Name: String): String;
begin
  Result := FDictionary.Values[Name];
end;

constructor TCaclculatorParentalGuideDictionary.Create;
begin
  FDictionary := GetInternalCalculatorParentalGuideDictionary;
end;

Initialization
  __InternalCalculatorParentalGuideDictionary := nil;

Finalization
  FreeAndNil(__InternalCalculatorParentalGuideDictionary);

end.

