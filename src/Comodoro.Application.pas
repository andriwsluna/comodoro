unit Comodoro.Application;

interface

uses
  System.Generics.Collections,
  Comodoro.Core,
  Comodoro.Command;


Type
  TCLIApplication = class(TBaseClass)
  private
    FCommands: TObjectList<TCommand>;

  public
    property Commands: TObjectList<TCommand> read FCommands write FCommands;
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
  Commands.Add(ACommand);
  Result := Self;
end;

constructor TCLIApplication.Create(AName, ADescription: string);
begin
  inherited;
  FCommands := TObjectList<TCommand>.Create();
end;

destructor TCLIApplication.Destroy;
begin
  FCommands.Free;
  inherited Destroy;
end;

procedure TCLIApplication.Run;
begin
  inherited;

  if HasFlag('--debug','--verbose') then
  begin
    ShowParameters();
    ShowFlags();
  end;


  {$IFDEF  DEBUG}
    var c : char;
    Readln(c);
    writeln(c);
  {$ENDIF}

  Self.Free;
end;

end.
