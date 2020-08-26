unit Horse.CacheControl;

interface

uses
  System.SysUtils,
  Horse;

type
  HorseCacheControlConfig = record
  public
    function MaxAge(AMaxAge: Integer): HorseCacheControlConfig;
    function NoCache: HorseCacheControlConfig;
    function NoStore: HorseCacheControlConfig;
    function &Private : HorseCacheControlConfig;
    function &Public : HorseCacheControlConfig;
  end;

function HorseCacheControl(): HorseCacheControlConfig; overload;
procedure CacheControl(Req: THorseRequest; Res: THorseResponse; Next: TProc); overload;

implementation

uses
  System.StrUtils, Web.HTTPApp;

var
  LMaxAge: string;
  LNoCache: string;
  LNoStore: string;
  LPublic : string;
  LPrivate : string;
  HorseConfig : HorseCacheControlConfig;

procedure CacheControl(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LWebResponse: TWebResponse;
  aCache : String;
begin
  LWebResponse := THorseHackResponse(Res).GetWebResponse;
  try
    Next();
  finally
    aCache := LPublic + LPrivate + LMaxAge + LNoCache + LNoStore;
    aCache := Copy(aCache, 1, Length(aCache) -2);
    LWebResponse.SetCustomHeader('Cache-Control', aCache);
  end;
end;




function HorseCacheControl(): HorseCacheControlConfig;
begin
  Result := HorseConfig;
end;

{ HorseCacheControlConfig }

function HorseCacheControlConfig.&Private: HorseCacheControlConfig;
begin
  Result := Self;
  LPrivate := 'private, ';
end;

function HorseCacheControlConfig.&Public: HorseCacheControlConfig;
begin
  Result := Self;
  LPublic := 'public, ';
end;

function HorseCacheControlConfig.MaxAge(
  AMaxAge: Integer): HorseCacheControlConfig;
begin
  Result := Self;
  LMaxAge := 'max-age=' + IntToStr(AMaxAge) + ', ';
end;

function HorseCacheControlConfig.NoCache: HorseCacheControlConfig;
begin
  Result := Self;
  LNoCache := 'no-cache, ';
end;

function HorseCacheControlConfig.NoStore: HorseCacheControlConfig;
begin
  Result := Self;
  LNoStore := 'no-store, ';
end;

initialization

end.
