unit Comodoro.Application;

interface

uses
  System.Generics.Collections,
  Comodoro.Core,
  Comodoro.Command;


Type
  TCLIApplication = class(TBaseClass<TCLIApplication>)
  private
    FCommands: TObjectDictionary<string, TCommand>;
  protected
    function HelpCondition : Boolean; Override;
  public
    property Commands: TObjectDictionary<string, TCommand> read FCommands write FCommands;
    procedure RunCommand();
  public
    constructor Create(AName, ADescription: string);
    destructor Destroy; override;
  public
    function Run(Args : string) : Boolean; Override;
    function AddCommand(ACommand : TCommand) : TCLIApplication;
  end;

implementation



function TCLIApplication.AddCommand(ACommand: TCommand): TCLIApplication;
begin
  Commands.Add(ACommand.Name,ACommand);
  Result := Self;
end;

constructor TCLIApplication.Create(AName, ADescription: string);
begin
  inherited;
  FCommands := TObjectDictionary<string, TCommand>.Create();
  AddAvailableFlag('--version','Show the CLI Tool Version','-v');
  AddAvailableFlag('--debug','Show debug logs');
  AddAvailableFlag('--pause','Wait for any key pressed to exit application');
  AddAvailableParamater('command', 'The command to execute');
end;

destructor TCLIApplication.Destroy;
begin
  FCommands.Free;
  inherited Destroy;
end;

function TCLIApplication.HelpCondition: Boolean;
begin
  Result := inherited and HasNoValidArgs;
end;

function TCLIApplication.Run(Args : string): Boolean;
begin
  inherited;

  if
  HasFlag('--debug')
  then
  begin
    ShowParameters();
    ShowFlags();
  end;

  RunCommand();


  if HasFlag('--pause') then
  begin
    writeln('');
    writeln('Press any key to exit');
    var c : char;
    Readln(c);
    writeln(c);
  end;

  Self.Free;

  Result := True;
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

end.
