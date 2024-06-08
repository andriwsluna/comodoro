unit Comodoro.Command;

interface

uses
  System.SysUtils,
  Comodoro.Core.Flags,
  Comodoro.Core.Parameters,
  Comodoro.Core, System.Generics.Collections;

type
  TCommand = class(TBaseClass<TCommand>)

  protected
    procedure CopyInfos(
      Parameters : TList<string>;
      SingleFlags : TList<string>;
      Flags : TDictionary<string, string>
    );


    function TryGetFlag(Const CompleteFlagName : string; var Value : string ; IsMandatory : Boolean = False) : Boolean;
    function TryGetParam(Const Name : string; var Value : string ; IsMandatory : Boolean = False) : Boolean;
  public

  public
    procedure Prepare(
      Parameters : TList<string>;
      SingleFlags : TList<string>;
      Flags : TDictionary<string, string>
    ); virtual; Final;

    Function CanExecute() : Boolean;

    procedure Execute(); virtual; abstract;



  end;

implementation





{ TCommand }



{ TCommand }

function TCommand.CanExecute: Boolean;
begin
  if
  (Parameters.Count = 0) and
  (Flags.Count = 0) and
  HasFlag('--help','-h')
  then
  begin
    ShowHelp();
    Result := False;
  end
  else
  begin
    Result := True;
  end;

end;

procedure TCommand.CopyInfos(Parameters, SingleFlags: TList<string>;
  Flags: TDictionary<string, string>);
begin
  for var p in Parameters do
  begin
    Self.Parameters.Add(p);
  end;

  for var f in SingleFlags do
  begin
    Self.SingleFlags.Add(f);
  end;

  for var f in Flags do
  begin
    Self.Flags.Add(f.Key, f.Value);
  end;

end;

procedure TCommand.Prepare(Parameters, SingleFlags: TList<string>;
  Flags: TDictionary<string, string>);
begin
  CopyInfos(Parameters, SingleFlags, Flags);
end;

function TCommand.TryGetFlag(Const CompleteFlagName : string; var Value :
    string ; IsMandatory : Boolean = False): Boolean;
begin
  var Flag : TFlagRecord;

  if AvailableFlags.TryGetValue(CompleteFlagName,Flag) then
  begin
    var Vl : String;
    if
      Flags.TryGetValue(Flag.CompleteName, Vl) or
      Flags.TryGetValue(Flag.ShortFormat, Vl)
    then
    begin
      Value := Vl;
      Result := true;
    end
    else if IsMandatory then
    begin
      Writeln('The flag "' + CompleteFlagName + '" is mandatory');
      Result := False;
      System.Halt(1);
    end
    Else
    begin
      Value := '';
      Result := False;
    end

  end
  else
  begin
    raise Exception.Create('Internal Error : Flag ' + CompleteFlagName + ' is not available');
  end;
end;

function TCommand.TryGetParam(const Name: string; var Value: string;
  IsMandatory: Boolean): Boolean;
begin
  var Param : TParameterRecord;

  if AvailableParameters.TryGetValue(Name,Name) then
  begin
    var Vl : String;
    if
      Parameters.TryGetValue(Flag.CompleteName, Vl) or
      Parameters.TryGetValue(Flag.ShortFormat, Vl)
    then
    begin
      Value := Vl;
      Result := true;
    end
    else if IsMandatory then
    begin
      Writeln('The flag "' + CompleteFlagName + '" is mandatory');
      Result := False;
      System.Halt(1);
    end
    Else
    begin
      Value := '';
      Result := False;
    end

  end
  else
  begin
    raise Exception.Create('Internal Error : Flag ' + CompleteFlagName + ' is not available');
  end;
end;

end.
