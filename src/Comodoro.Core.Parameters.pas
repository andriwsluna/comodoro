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


    procedure SetDescription(const Value: string);
    procedure SetName(const Value: string);
    procedure SetPosition(const Value: Integer);


  public
    property Description: string read FDescription write SetDescription;
    property Name: string read FName write SetName;
    property Position: Integer read FPosition write SetPosition;
  end;

  TAvailableParameters = Class(TDictionary<string,TParameterRecord>)
  private
    MaxName : integer;
    procedure CalculateMaxName();
  public
    procedure Show();
  end;

implementation

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
    writeln('Available Flags:');
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
  end
  else
  begin
    writeln('');
    writeln('No Parameters are available.');
    writeln('');
  end;

end;

end.
