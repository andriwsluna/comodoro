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
    FNamedParameters : TDictionary<string, string>;
    FFlags :  TList<string>;
    FAvailableFlags : TAvailableFlags;
    FAvailableShortFlags : TAvailableFlags;
    FAvailableParameters: TAvailableParameters;
    FAvailableNamedParameters: TAvailableNamedParameters;

  protected
    ReceivedArgs : string;
    property Parameters : TList<string> read FParameters;
    property NamedParamenters : TDictionary<string, string> read FNamedParameters;
    property Flags : TList<string> read FFlags;
    property AvailableFlags : TAvailableFlags  read FAvailableFlags;
    property AvailableParameters: TAvailableParameters read FAvailableParameters;

    function TryGetFlag(Const CompleteFlagName : string; var Value : string ; IsMandatory : Boolean = False) : Boolean;
    function TryGetParam(Const Name : string; var Value : string ; IsMandatory : Boolean = False) : Boolean;
    function HasFlag(const CompleteFlagName : string): Boolean;


    procedure ResolveArgs(Args : string);
    function IsValidFlag(FlagName: String): boolean;
    function  IsValidParam(ParamName : String) : boolean;
    function IsValidNamedParamter(ParamName : String) : Boolean;
    procedure ShowFlags();
    procedure ShowParameters();
    procedure ShowAvailableFlags();
    procedure ShowAvailableParameters();
    function AddAvailableFlag(Const Flag, Description : string ; ShortFormat : String = '') : T;
    function AddAvailableNamedParameter(Const Name, Description : string ; ShortFormat : String = '') : T;
    function AddAvailableParamater(Const Name, Description : string) : T;

    function HasNoValidArgs() : Boolean;
    function HelpCondition : Boolean; Virtual;
  public
    constructor Create(AName, ADescription: string);
    destructor Destroy; override;
  public
    property Description: string read FDescription write FDescription;
    property Name: string read FName write FName;

    procedure ShowHelp(); Virtual;
    function Run(Args : string) : Boolean; virtual;
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
    if Not ShortFormat.IsEmpty then
    begin
      FAvailableShortFlags.Add(ShortFormat,FlagRecord);
    end;

  end;
end;

function TBaseClass<T>.HelpCondition: Boolean;
begin
  Result :=  HasFlag('--help');
end;

function TBaseClass<T>.IsValidFlag(FlagName: String): boolean;
begin
  Result := False;
  if IsFlag(FlagName) then
  begin
    var Flag : TFlagRecord;
    if AvailableFlags.TryGetValue(FlagName,Flag) then
    begin
      Result := True;
    end
    else if FAvailableShortFlags.TryGetValue(FlagName,Flag) then
    begin
      Result := True;
    end;
  end;
end;

function TBaseClass<T>.IsValidNamedParamter(ParamName: String): Boolean;
begin
  Result := FAvailableNamedParameters.ContainsKey(ParamName);
end;

function TBaseClass<T>.IsValidParam(ParamName: String): boolean;
begin
  Result := False;
  if IsValue(ParamName) then
  begin
    Result := FParameters.Count < FAvailableParameters.Count;
  end;
end;

function TBaseClass<T>.AddAvailableNamedParameter(const Name,
  Description: string; ShortFormat: String): T;
begin
  if (Not Name.IsEmpty) and IsFlag(Name) then
  begin
    var  ParamRecord : TParameterRecord;
    ParamRecord.Name := Name;
    ParamRecord.Description := Description;
    ParamRecord.Position := FAvailableNamedParameters.Count+1;
    ParamRecord.ShortName := ShortFormat;
    FAvailableNamedParameters.Add(Name,ParamRecord);
  end;
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
  FNamedParameters := TDictionary<string, string>.Create;
  FFlags :=  TList<string>.Create();
  FAvailableFlags := TAvailableFlags.Create();
  FAvailableParameters := TAvailableParameters.Create();
  FAvailableShortFlags := TAvailableFlags.Create;
  FAvailableNamedParameters := TAvailableNamedParameters.Create();
  Self.AddAvailableFlag('--help','Show help to list available args and flags','-h');
end;

destructor TBaseClass<T>.Destroy;
begin
  inherited Destroy;
end;

function TBaseClass<T>.HasNoValidArgs: Boolean;
begin
  Result := (FParameters.Count = 0) and (FNamedParameters.Count = 0) And (FFlags.Count = 0);
end;

procedure TBaseClass<T>.ShowHelp;
begin
  Writeln(Name + ' - ' + Description);
  ShowAvailableParameters();
  ShowAvailableFlags();
end;


procedure TBaseClass<T>.ResolveArgs(Args: string);
begin

  var List := TStringList.Create(TDuplicates.dupAccept, false,false);
  List.Delimiter := ' ';
  List.StrictDelimiter := true;
  List.DelimitedText := Args;
  if List.Count = 0 then
  begin
    exit;
  end;
  var index := 0;
  repeat
    var Arg := List[index];
    if IsValidFlag(Arg) then
    begin
      FFlags.Add(Arg);
    end
    else
    if IsValidNamedParamter(Arg) then
    begin
      if (index < List.Count-1) then
      begin
        var Value := List[index+1];
        if IsValue(Value) then
        begin
          FNamedParameters.Add(Arg,value);
          Inc(index);
        end;
      end;
    end;
    if IsValidParam(Arg) then
    begin
       FParameters.Add(Arg);
    end;

    Inc(index);
  until index = List.Count;

end;

function TBaseClass<T>.Run(Args : string): Boolean;
begin
  ReceivedArgs := TRIM(Args.Replace('"' + ParamStr(0) + '"',''));
  ResolveArgs(ReceivedArgs);
  if HelpCondition then
  begin
    ShowHelp();
    result := False;
  end
  else
  begin
    result := True;
  end;
end;

procedure TBaseClass<T>.ShowAvailableFlags;
begin
  FAvailableFlags.Show();
end;

procedure TBaseClass<T>.ShowAvailableParameters;
begin
  AvailableParameters.Show();
  FAvailableNamedParameters.Show();
end;

procedure TBaseClass<T>.ShowFlags;
begin
  for var flag in FNamedParameters do
  begin
    writeln('Flag ' + Flag.Key + ' = ' + Flag.Value);
  end;

  for var flag in FFlags do
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


function TBaseClass<T>.HasFlag(const CompleteFlagName : string): Boolean;
begin
  var Flag : TFlagRecord;

  if AvailableFlags.TryGetValue(CompleteFlagName,Flag) then
  begin
    var Vl : String;
    if
      Flags.Contains(CompleteFlagName) or
      Flags.Contains(Flag.ShortFormat)
    then
    begin
      Result := true;
    end
    else
    begin
      Result := False;
    end

  end
  else
  begin
    raise Exception.Create('Internal Error : Flag ' + CompleteFlagName + ' is not available');
  end;
end;

function TBaseClass<T>.TryGetFlag(Const CompleteFlagName : string; var Value :
    string ; IsMandatory : Boolean = False): Boolean;
begin
  var Flag : TFlagRecord;

  if AvailableFlags.TryGetValue(CompleteFlagName,Flag) then
  begin
    var Vl : String;
    if
      FNamedParameters.TryGetValue(Flag.CompleteName, Vl) or
      FNamedParameters.TryGetValue(Flag.ShortFormat, Vl)
    then
    begin
      Value := Vl;
      Result := true;
    end
    else if IsMandatory then
    begin
      Writeln('The named parameter "' + CompleteFlagName + '" is mandatory');
      Result := False;
      System.Halt(1);
    end
    Else
    begin
      Value := '';
      Result := False;
    end

  end
  else
  begin
    raise Exception.Create('Internal Error : Flag ' + CompleteFlagName + ' is not available');
  end;
end;

function TBaseClass<T>.TryGetParam(const Name: string; var Value: string;
  IsMandatory: Boolean): Boolean;
begin
  var Param : TParameterRecord;

  if AvailableParameters.TryGetValue(Name,Param) then
  begin
    if Parameters.Count  >= Param.Position then
    begin
        Value := Parameters[Param.Position-1];
        Result := true;
    end
    else if IsMandatory then
    begin
      Writeln('The paramter "' + Name + '" ['+param.Position.ToString+'] is mandatory');
      Result := False;
      System.Halt(1);
    end
    Else
    begin
      Value := '';
      Result := False;
    end;


  end
  else
  begin
    raise Exception.Create('Internal Error : Paramter ' + Name + ' is not available');
  end;
end;


end.
