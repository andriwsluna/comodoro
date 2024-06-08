unit Comodoro.Utils;

interface

uses
  System.StrUtils,
  System.SysUtils;

function IsLowerCaseEquals(Const AStr1, AStr2 : String) : Boolean;
function IsFlag(Const Str : String) : Boolean;
function IsValue(Const Str : String) : Boolean;

implementation

function IsValue(Const Str : String) : Boolean;
begin
  Result :=  (not Str.IsEmpty) and (Str.ToLower[1] <> '-');
end;

function IsLowerCaseEquals(Const AStr1, AStr2 : String) : Boolean;
begin
  Result :=  (AStr1.ToLower = AStr2.ToLower);
end;

function IsFlag(Const Str : string) : Boolean;
begin
  Result := (not Str.IsEmpty) and ((Str.ToLower[1] = '-'));
end;

end.
