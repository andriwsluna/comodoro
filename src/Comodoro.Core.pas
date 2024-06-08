unit Comodoro.Core;

interface
uses
  Comodoro.Utils,
  System.StrUtils,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

Type
  TBaseClass = class abstract
  protected
    FDescription: string;
    FName: string;
    FParameters :  TList<string>;
    FFlags : TDictionary<string, string>;
    FSingleFlags :  TList<string>;
  protected
    procedure ResolveArgs(Args : string);
    procedure ShowFlags();
    procedure ShowParameters();

    function HasFlag(Const flag : string ; Const otherFormat : String = '') : Boolean;

  public
    constructor Create(AName, ADescription: string);
    destructor Destroy; override;
  public
    property Description: string read FDescription write FDescription;
    property Name: string read FName write FName;
    procedure Help();
    procedure Run(Args : string); virtual;
  end;

implementation


constructor TBaseClass.Create(AName, ADescription: string);
begin
  inherited Create;
  Name := AName;
  Description := ADescription;
  FParameters := TList<string>.Create;
  FFlags := TDictionary<string, string>.Create;
  FSingleFlags :=  TList<string>.Create();
end;

destructor TBaseClass.Destroy;
begin
  inherited Destroy;
end;

function TBaseClass.HasFlag(const flag, otherFormat: String): Boolean;
begin
  Result :=
    FFlags.ContainsKey(flag) or
    FSingleFlags.Contains(flag) or
    (
      Not otherFormat.IsEmpty and
      (
        FFlags.ContainsKey(otherFormat) or
        FSingleFlags.Contains(otherFormat)
      )
    );
end;

procedure TBaseClass.Help;
begin
  Writeln(Name + ' - ' + Description);
end;


procedure TBaseClass.ResolveArgs(Args: string);
begin

  var List := TStringList.Create(TDuplicates.dupIgnore, true,false);
  List.Delimiter := ' ';
  List.StrictDelimiter := true;
  List.DelimitedText := Args.Replace(ParamStr(0),'');

  var index := 0;
  repeat
    var Arg := List[index];
    if IsFlag(Arg) then
    begin
      var Value := List[index+1];
      if IsValue(Value) then
      begin
        FFlags.Add(Arg,value);
        Inc(index);
      end
      else
      begin
        FSingleFlags.Add(Arg);
      end;
    end
    else
    if IsValue(Arg) then
    begin
       FParameters.Add(Arg);
    end;

    Inc(index);
  until index = List.Count;

end;

procedure TBaseClass.Run(Args : string);
begin
  ResolveArgs(Args);
  
end;

procedure TBaseClass.ShowFlags;
begin
  for var flag in FFlags do
  begin
    writeln('Flag ' + Flag.Key + ' = ' + Flag.Value);
  end;

  for var flag in FSingleFlags do
  begin
    writeln('Flag ' + flag);
  end;
end;

procedure TBaseClass.ShowParameters;
begin
  for var i := 0 to FParameters.Count -1 do
  begin
    writeln('P[' + i.ToString + '] = ' + FParameters[i]);
  end;
end;

end.
