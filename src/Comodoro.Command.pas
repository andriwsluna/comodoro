unit Comodoro.Command;

interface

type
  TCommand = class
  private
    FDescription: string;
    FName: string;
  public
    constructor Create(AName, ADescription: string);
    destructor Destroy; override;
  public
    property Description: string read FDescription write FDescription;
    property Name: string read FName write FName;
    procedure Show();
  end;

implementation

constructor TCommand.Create(AName, ADescription: string);
begin
  inherited Create;
  Name := AName;
  Description := ADescription;
end;

destructor TCommand.Destroy;
begin
  inherited Destroy;
end;

procedure TCommand.Show;
begin
  Writeln(Name + ' - ' + Description);
end;

{ TCommand }



end.
