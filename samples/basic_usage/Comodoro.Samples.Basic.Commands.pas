unit Comodoro.Samples.Basic.Commands;

interface

uses
  System.Generics.Collections,
  Comodoro;

type
  TGreetingsCommand = class(TCommand)
  public
    Constructor Create(); reintroduce;
    procedure Execute(

    ); Override;
  end;

  TGreetingsFlaggedCommand = class(TCommand)
  public
    Constructor Create(); reintroduce;
    procedure Execute(

    ); Override;
  end;



implementation

{ TGreetingsCommand }

constructor TGreetingsFlaggedCommand.Create;
begin
  inherited Create('greetingsf', 'This command say hello to a given flag --name');
  Self.AddAvailableFlag('--name','The name of person to Say Hello')
end;

procedure TGreetingsFlaggedCommand.Execute;
begin
  inherited;
  var Name : String;
  if TryGetFlag('--name', Name, True) then
  begin
    writeln('Hello ' + Name);
  end;
end;

{ TGreetingsCommand }

constructor TGreetingsCommand.Create;
begin
  inherited Create('greetings', 'This command say hello to a given flag --name');
  Self.AddAvailableParamater('Name','The name of person to Say Hello');
end;

procedure TGreetingsCommand.Execute;
begin
  inherited;
  var Name : String;
  if TryGetParam('--name', Name, True) then
  begin
    writeln('Hello ' + Name);
  end;
end;

end.
