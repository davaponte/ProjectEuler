{
  The CalculatorMemory unit provides a Memory class for a Calculator
  based on the BigNumbers unit.
  Capabilities:
  - Set value (all values must be TValue !)
  - Get value
  - Add to value
  - Subtract from value
  - Clear

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

unit CalculatorMemory;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  BigNumbers, NCalc, Expressions, BoolFactory;

type

  { TCalculatorMemory }

  TCalculatorMemory = class
  private
    FValue: TValue;
    procedure SetValue(AValue: TValue);
  public
    constructor Create;

    procedure Clear;
    procedure AddN(N: TValue);
    procedure SubN(N: TValue);

    property Value: TValue read FValue write SetValue;
  end;

implementation

{ TCalculatorMemory }

procedure TCalculatorMemory.SetValue(AValue: TValue);
begin
  AssertIsNumberN(AValue);
  if IsTrue(EqualsN(FValue, AValue)) then Exit;
  FValue := NormalizeNumberN(AValue);
end;

constructor TCalculatorMemory.Create;
begin
  FValue := '0';
end;

procedure TCalculatorMemory.Clear;
begin
  FValue := '0';
end;

procedure TCalculatorMemory.AddN(N: TValue);
begin
  AssertIsNumberN(N);
  FValue := NCalc.AddN(FValue, N);
end;

procedure TCalculatorMemory.SubN(N: TValue);
begin
  AssertIsNumberN(N);
  FValue := NCalc.SubN(FValue, N);
end;

end.

