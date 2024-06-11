unit Comodoro.Application;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Comodoro.Core,
  Comodoro.Utils,
  Comodoro.Command;


Type
  TCLIApplication = class(TBaseClass<TCLIApplication>)
  private
    FCommands: TObjectDictionary<string, TCommand>;
    MaxCommandName : Integer;
  protected
    function HelpCondition : Boolean; Override;
    procedure ShowAvailableCommands();
    procedure CalculateMaxCommandName;
  protected
    property Commands: TObjectDictionary<string, TCommand> read FCommands write FCommands;
    procedure RunCommand();
  public
    constructor Create(AName, ADescription: string);
    destructor Destroy; override;
  public
    function Run(Args : string) : Boolean; Override;
    procedure ShowHelp(); Override;
    procedure ShowApplicationVersion();
    function AddCommand(ACommand : TCommand) : TCLIApplication;
  end;

implementation



function TCLIApplication.AddCommand(ACommand: TCommand): TCLIApplication;
begin
  Commands.Add(ACommand.Name,ACommand);
  Result := Self;
end;

procedure TCLIApplication.CalculateMaxCommandName;
begin
  MaxCommandName := 0;
  for var Commanmd in Commands do
  begin
    if Commanmd.Key.Length > MaxCommandName then
    begin
      MaxCommandName := Commanmd.Key.Length;
    end;
  end;
end;

constructor TCLIApplication.Create(AName, ADescription: string);
begin
  inherited;
  FCommands := TObjectDictionary<string, TCommand>.Create();
  AddAvailableFlag('--version','Show the CLI Tool Version','-v');
  AddAvailableFlag('--debug','Show debug logs','-d');
  AddAvailableFlag('--pause','Wait for any key pressed to exit application','-p');
  AddAvailableParamater('command', 'The command to execute');
end;

destructor TCLIApplication.Destroy;
begin
  FCommands.Free;
  inherited Destroy;
end;

function TCLIApplication.HelpCondition: Boolean;
begin
  Result := HasNoValidArgs or
  (
    (Parameters.Count = 0) and inherited
  );
end;

function TCLIApplication.Run(Args : string): Boolean;
begin
  Result := false;
  if inherited then
  begin
    if
    HasFlag('--debug')
    then
    begin
      ShowParameters();
      ShowFlags();
    end;

    if (Parameters.Count = 0) and HasFlag('--version') then
    begin
      ShowApplicationVersion();
    end
    else
    begin
      RunCommand();


      if HasFlag('--pause') then
      begin
        writeln('');
        writeln('Press any key to exit');
        var c : char;
        Readln(c);
        writeln(c);
      end;



      Result := True;
    end;


  end;

  Self.Free;
end;

procedure TCLIApplication.RunCommand;
begin

  if Parameters.Count = 0 then
  begin
    ShowHelp();
    Exit;
  end;

  var Command : TCommand;
  if Commands.TryGetValue(Parameters.Items[0], Command) then
  begin
    if Command.Run(ReceivedArgs.Replace(Parameters.Items[0],'')) then
    begin
      Command.Execute();
    end;
  end
  else
  begin
    writeln('The command ' + Parameters.Items[0] + ' is not available');
  end;

end;

procedure TCLIApplication.ShowApplicationVersion;
begin
  writeln('');
  Writeln(Name + ' - v' + GetBuildInfoAsString);
end;

procedure TCLIApplication.ShowAvailableCommands;
begin
  if Commands.Count > 0 then
  begin
    CalculateMaxCommandName();
    writeln('');
    writeln('Available Commands:');
    writeln('');
    for var Command in Commands do
    begin
      writeln
      (
        '  ' + Command.Key +
        StringOfChar(' ',MaxCommandName - Length(Command.Key)) + '   -   ' +
       Command.Value.Description
      );
    end;
  end
  else
  begin
    writeln('');
    writeln('No Commands are available:');
    writeln('');
  end;
end;

procedure TCLIApplication.ShowHelp;
begin
  writeln('');
  Writeln(Name + ' - ' + GetBuildInfoAsString);
  writeln(Description);
  ShowAvailableCommands();
  ShowAvailableFlags();
end;

end.
