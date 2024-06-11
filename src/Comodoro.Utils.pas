unit Comodoro.Utils;

interface

uses
  System.StrUtils,
  System.SysUtils;

function IsLowerCaseEquals(Const AStr1, AStr2 : String) : Boolean;
function IsFlag(Const Str : String) : Boolean;
function IsValue(Const Str : String) : Boolean;
function GetBuildInfoAsString: string;

implementation

uses
  Winapi.Windows;

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


procedure GetBuildInfo(var V1, V2, V3, V4, V5: word);
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize > 0 then
  begin
      GetMem(VerInfo, VerInfoSize);
      try
        if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
        begin
          VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
          with VerValue^ do
          begin
            V1 := dwFileVersionMS shr 16;
            V2 := dwFileVersionMS and $FFFF;
            V3 := dwFileVersionLS shr 16;
            V4 := dwFileVersionLS and $FFFF;
            V5 := dwFileFlags and $FFFF;
          end;
        end;
      finally
        FreeMem(VerInfo, VerInfoSize);
      end;
  end;
end;

function GetBuildInfoAsString: string;
var
  V1, V2, V3, V4, V5: word;
begin
  GetBuildInfo(V1, V2, V3, V4,V5);
  Result := IntToStr(V1) + '.' + IntToStr(V2) + '.' +
    IntToStr(V3);

  if (V5 = 2)then
  begin
    Result := Result + '-alpha';
  end;



end;

end.
