unit Comodoro.Core.Parameters;

interface
uses
  System.SysUtils,
  System.Generics.Collections;


Type
  TParameterRecord = record
  private
    FDescription: string;
    FName: string;
    FPosition: Integer;
    FShortName: string;


    function GetFullName: string;
    procedure SetDescription(const Value: string);
    procedure SetName(const Value: string);
    procedure SetPosition(const Value: Integer);
    procedure SetShortName(const Value: string);


  public
    property Description: string read FDescription write SetDescription;
    property FullName: string read GetFullName;
    property Name: string read FName write SetName;
    property Position: Integer read FPosition write SetPosition;
    property ShortName: string read FShortName write SetShortName;

  end;

  TAvailableParameters = Class(TDictionary<string,TParameterRecord>)
  private
    MaxName : integer;
    procedure CalculateMaxName();
  public
    procedure Show();
  end;

  TAvailableNamedParameters = Class(TDictionary<string,TParameterRecord>)
  private
    MaxName : integer;
    procedure CalculateMaxName();

  public
    procedure Show();
  end;

implementation

function TParameterRecord.GetFullName: string;
begin
  if Not ShortName.IsEmpty then
  begin
    Result :=  ShortName + ', ' + Name;
  end
  else
  begin
    Result :=  Name;
  end;


end;

procedure TParameterRecord.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TParameterRecord.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TParameterRecord.SetPosition(const Value: Integer);
begin
  FPosition := Value;
end;

procedure TParameterRecord.SetShortName(const Value: string);
begin
  FShortName := Value;
end;

{ AvailableParameters }

procedure TAvailableParameters.CalculateMaxName;
begin
  MaxName := 0;
  for var Param in self do
  begin
    if Param.Value.Name.Length > MaxName then
    begin
      MaxName := Param.Value.Name.Length;
    end;
  end;
end;

procedure TAvailableParameters.Show;
begin
  if Count > 0 then
  begin
    CalculateMaxName();
    writeln('');
    writeln('Positional Parameters:');
    writeln('');
    for var Param in self do
    begin
      writeln
      (
        '  [' + Param.Value.Position.ToString + ']-' + Param.Value.Name +
        StringOfChar(' ',MaxName - Length(Param.Value.Name)) + '   -   ' +
        Param.Value.Description
      );
    end;
  end;

end;

{ TAvailableNamedParameters }

procedure TAvailableNamedParameters.CalculateMaxName;
begin
  MaxName := 0;
  for var Param in self do
  begin
    if Param.Value.FullName.Length > MaxName then
    begin
      MaxName := Param.Value.FullName.Length;
    end;
  end;
end;

procedure TAvailableNamedParameters.Show;
begin
  if Count > 0 then
  begin
    CalculateMaxName();
    writeln('');
    writeln('Named Parameters:');
    writeln('');
    for var Param in self do
    begin
      writeln
      (
        '  ' + Param.Value.FullName +
        StringOfChar(' ',MaxName - Length(Param.Value.Name)) + '   -   ' +
        Param.Value.Description
      );
    end;
  end;
end;

end.
