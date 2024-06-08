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

  public

  public
    procedure Execute(); virtual; abstract;



  end;

implementation

{ TCommand }


end.
