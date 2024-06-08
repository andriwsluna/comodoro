unit Comodoro.Samples.Basic.Commands;

interface

uses
  System.SysUtils,
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

  TMakeURLCommand = class(TCommand)
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
  if TryGetParam('Name', Name, True) then
  begin
    writeln('Hello ' + Name);
  end;
end;

{ TMakeURLCommand }

constructor TMakeURLCommand.Create;
begin
  inherited Create('makeurl', 'This command makes a HTTP url by given args');
  Self.AddAvailableParamater('Hostname','The target host name');
  Self.AddAvailableFlag('--port','The target port number','-p');
  Self.AddAvailableFlag('--https','If informed, uses HTTPS protocol','-s');
end;

procedure TMakeURLCommand.Execute;
begin
  inherited;

  var URL : string;
  var Hostname : String;
  var PorNumber : String;
  TryGetParam('Hostname', Hostname, true);
  TryGetFlag('--port', PorNumber);

  URL := Hostname;

  if HasFlag('--https') then
  begin
    URL := 'https://' + URL;
  end
  else
  begin
     URL := 'http://' + URL;
  end;

  var p : integer;

  if TryStrToInt(PorNumber,p) then
  begin
    URL := URL + ':' + p.ToString;
  end;

  writeln('Your URL is ' + URL);

end;

end.
