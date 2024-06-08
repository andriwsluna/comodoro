unit Comodoro.Core.Flags;

interface

uses
  System.SysUtils,
  System.Generics.Collections;


Type
  TFlagRecord = record
  private
    FDescription: string;
    FCompleteName: string;
    FShortFormat: string;
    function GetFullName: string;
    procedure SetDescription(const Value: string);
    procedure SetCompleteName(const Value: string);
    procedure SetShortFormat(const Value: string);

  public
    property Description: string read FDescription write SetDescription;
    property CompleteName: string read FCompleteName write SetCompleteName;
    property FullName: string read GetFullName;
    property ShortFormat: string read FShortFormat write SetShortFormat;

  end;

  TAvailableFlags = Class(TDictionary<string,TFlagRecord>)
  private
    MaxFlagName : integer;
    procedure CalculateMaxFlagName();
  public
    procedure Show();
  end;

implementation

{ TAvailableFlags }

procedure TAvailableFlags.CalculateMaxFlagName;
begin
  MaxFlagName := 0;
  for var Flag in self do
  begin
    if Flag.Value.FullName.Length > MaxFlagName then
    begin
      MaxFlagName := Flag.Value.FullName.Length;
    end;
  end;
end;

procedure TAvailableFlags.Show;
begin
  CalculateMaxFlagName();
  writeln('');
  writeln('Available Flags:');
  writeln('');
  for var Flag in self do
  begin
    writeln
    (
      '  ' + Flag.Value.FullName + 
      StringOfChar(' ',MaxFlagName - Length(Flag.Value.FullName)) + '   -   ' + 
      Flag.Value.Description
    );
  end;
end;

function TFlagRecord.GetFullName: string;
begin
  if ShortFormat.IsEmpty then
  begin
    Result := CompleteName;
  end
  else
  begin
    Result := ShortFormat + ', ' + CompleteName;
  end;
end;

procedure TFlagRecord.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TFlagRecord.SetCompleteName(const Value: string);
begin
  FCompleteName := Value;
end;

procedure TFlagRecord.SetShortFormat(const Value: string);
begin
  FShortFormat := Value;
end;

end.
