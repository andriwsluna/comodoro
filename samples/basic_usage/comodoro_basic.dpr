program comodoro_basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Comodoro in '..\..\src\Comodoro.pas',
  Comodoro.Samples.Basic.Commands in 'Comodoro.Samples.Basic.Commands.pas',
  Comodoro.Core.Parameters in '..\..\src\Comodoro.Core.Parameters.pas';

begin
  try
    TCLIApplication.Create
    (
      'Comodoro Basic CLI Sample',
      'This a basic functional CLI tool made with Delphi and Comodoro Package'
    )
    .AddCommand(TGreetingsFlaggedCommand.Create())
    .AddCommand(TGreetingsCommand.Create())
    .AddCommand(TMakeURLCommand.Create())
    {$IFDEF MSWINDOWS}
    .Run(CmdLine);
    {$ELSE IF defined(LINUX) or defined(MACOS) or defined(ANDROID)}
    .Run(ArgValues);
    {$ENDIF}
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
