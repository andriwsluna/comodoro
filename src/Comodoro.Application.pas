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
    procedure Run(Args : string); Override;
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

procedure TCLIApplication.Run(Args : string);
begin
  inherited;

  if HasFlag('--debug','--verbose') then
  begin
    ShowParameters();
    ShowFlags();
  end;

  RunCommand();


  {$IFDEF  DEBUG}
    writeln('');
    writeln('Press any key to exit');
    var c : char;
    Readln(c);
    writeln(c);
  {$ENDIF}

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
    Parameters.Remove(Parameters.Items[0]);
    Command.Prepare(Parameters,SingleFlags, Flags);
    if Command.CanExecute then
    begin
      Command.Execute();
    end;

  end;

end;

end.
