unit Comodoro.Core;

interface
uses
  Comodoro.Utils,
  System.StrUtils,
  System.Classes,
  System.SysUtils,
  Comodoro.Core.Flags,
  System.Generics.Collections, Comodoro.Core.Parameters;

Type

  TBaseClass<T : Class> = class abstract
  private
    FDescription: string;
    FName: string;
    FParameters :  TList<string>;
    FFlags : TDictionary<string, string>;
    FSingleFlags :  TList<string>;
    FAvailableFlags : TAvailableFlags;
    FAvailableParameters: TAvailableParameters;
  protected
    property Parameters : TList<string> read FParameters;
    property Flags : TDictionary<string, string> read FFlags;
    property SingleFlags : TList<string> read FSingleFlags;
    property AvailableFlags : TAvailableFlags  read FAvailableFlags;
    property AvailableParameters: TAvailableParameters read FAvailableParameters;


    procedure ResolveArgs(Args : string);
    procedure ShowFlags();
    procedure ShowParameters();
    procedure ShowAvailableFlags();
    procedure ShowAvailableParameters();
    function AddAvailableFlag(Const Flag, Description : string ; ShortFormat : String = '') : T;
    function AddAvailableParamater(Const Name, Description : string) : T;

    function HasFlag(Const flag : string ; Const otherFormat : String = '') : Boolean;
    function HasNoValidArgs() : Boolean;
    function HelpCondition : Boolean; Virtual;
  public
    constructor Create(AName, ADescription: string);
    destructor Destroy; override;
  public
    property Description: string read FDescription write FDescription;
    property Name: string read FName write FName;

    procedure ShowHelp();
    procedure Run(Args : string); virtual;
  end;

implementation


function TBaseClass<T>.AddAvailableFlag(const Flag, Description: string;
  ShortFormat: String): T;
begin
  if (Not Flag.IsEmpty) then
  begin
    var  FlagRecord : TFlagRecord;
    FlagRecord.CompleteName := Flag;
    FlagRecord.Description := Description;
    FlagRecord.ShortFormat := ShortFormat;
    FAvailableFlags.Add(Flag,FlagRecord);
  end;
end;

function TBaseClass<T>.HelpCondition: Boolean;
begin
  Result :=  HasFlag('--help','-h');

end;

function TBaseClass<T>.AddAvailableParamater(const Name,
  Description: string): T;
begin
  if (Not Name.IsEmpty) then
  begin
    var  ParamRecord : TParameterRecord;
    ParamRecord.Name := Name;
    ParamRecord.Description := Description;
    ParamRecord.Position := AvailableParameters.Count+1;
    AvailableParameters.Add(Name,ParamRecord);
  end;
end;

constructor TBaseClass<T>.Create(AName, ADescription: string);
begin
  inherited Create;
  Name := AName;
  Description := ADescription;
  FParameters := TList<string>.Create;
  FFlags := TDictionary<string, string>.Create;
  FSingleFlags :=  TList<string>.Create();
  FAvailableFlags := TAvailableFlags.Create();
  FAvailableParameters := TAvailableParameters.Create();

  Self.AddAvailableFlag('--help','Show help to list available args and flags','-h');
end;

destructor TBaseClass<T>.Destroy;
begin
  inherited Destroy;
end;

function TBaseClass<T>.HasFlag(const flag, otherFormat: String): Boolean;
begin


  Result :=
    (Not HasNoValidArgs) and
    (
      FFlags.ContainsKey(flag) or
      FSingleFlags.Contains(flag) or
      (
        Not otherFormat.IsEmpty and
        (
          FFlags.ContainsKey(otherFormat) or
          FSingleFlags.Contains(otherFormat)
        )
      )
    );
end;

function TBaseClass<T>.HasNoValidArgs: Boolean;
begin
  Result := (FParameters.Count = 0) and (FFlags.Count = 0) And (FSingleFlags.Count = 0);
end;

procedure TBaseClass<T>.ShowHelp;
begin
  Writeln(Name + ' - ' + Description);
  ShowAvailableFlags();
  ShowAvailableParameters();
end;


procedure TBaseClass<T>.ResolveArgs(Args: string);
begin

  var List := TStringList.Create(TDuplicates.dupAccept, false,false);
  List.Delimiter := ' ';
  List.StrictDelimiter := true;
  List.DelimitedText := Args.Replace('"' + ParamStr(0) + '" ','');
  if List.Count = 0 then
  begin
    exit;
  end;
  var index := 0;
  repeat
    var Arg := List[index];
    if IsFlag(Arg) then
    begin
      if index < List.Count-1 then
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

procedure TBaseClass<T>.Run(Args : string);
begin
  ResolveArgs(Args);
  if HelpCondition then
  begin
    ShowHelp();
  end;
end;

procedure TBaseClass<T>.ShowAvailableFlags;
begin
  FAvailableFlags.Show();
end;

procedure TBaseClass<T>.ShowAvailableParameters;
begin
  AvailableParameters.Show();
end;

procedure TBaseClass<T>.ShowFlags;
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

procedure TBaseClass<T>.ShowParameters;
begin
  for var i := 0 to FParameters.Count -1 do
  begin
    writeln('P[' + i.ToString + '] = ' + FParameters[i]);
  end;
end;

end.
