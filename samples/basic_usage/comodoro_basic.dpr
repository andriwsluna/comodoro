program comodoro_basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Comodoro in '..\..\src\Comodoro.pas',
  Comodoro.Core in '..\..\src\Comodoro.Core.pas',
  Comodoro.Utils in '..\..\src\Comodoro.Utils.pas';

function CreateGreetingsCommand : TCommand;
begin
  Result := TCommand.Create
  (
    'greetings',
    'This command say hello to a given name'
  );
end;

begin
  try
    TCLIApplication.Create
    (
      'Comodoro Basic CLI Sample',
      'This a basic functional CLI tool made with Delphi and Comodoro Package'
    )
    .AddCommand(CreateGreetingsCommand())

    {$WARN SYMBOL_PLATFORM OFF}
    {$IFDEF MSWINDOWS}
    .Run(CmdLine);
    {$ENDIF}
    {$IF defined(LINUX) or defined(MACOS) or defined(ANDROID)}
    .Run(ArgValues);
    {$ENDIF}
    {$WARN SYMBOL_PLATFORM ON}
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
