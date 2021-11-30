unit Horse.CacheControl;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
    SysUtils,
  {$ELSE}
    System.SysUtils,
  {$ENDIF}
  Horse;

type
  HorseCacheControlConfig = {$IF DEFINED(FPC)} class {$ELSE} record {$ENDIF}
  public
    function MaxAge(AMaxAge: Integer): HorseCacheControlConfig;
    function NoCache: HorseCacheControlConfig;
    function NoStore: HorseCacheControlConfig;
    function &Private : HorseCacheControlConfig;
    function &Public : HorseCacheControlConfig;
  end;

function HorseCacheControl(): HorseCacheControlConfig; overload;
procedure CacheControl(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)}TNextProc{$ELSE}TProc{$ENDIF}); overload;

implementation

uses
  {$IF DEFINED(FPC)}
  StrUtils, HTTPDefs
  {$ELSE}
  System.StrUtils, Web.HTTPApp
  {$ENDIF}
  ;

var
  LMaxAge: string;
  LNoCache: string;
  LNoStore: string;
  LPublic : string;
  LPrivate : string;
  HorseConfig : HorseCacheControlConfig;

procedure CacheControl(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)}TNextProc{$ELSE}TProc{$ENDIF}
  );
var
  LWebResponse: {$IF DEFINED(FPC)} TResponse {$ELSE} TWebResponse {$ENDIF};
  aCache : String;
begin
  LWebResponse := THorseResponse(Res).RawWebResponse;
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
  {$IF DEFINED(FPC)}
    Result := HorseCacheControlConfig(HorseConfig.Create);
  {$ELSE}
  Result := HorseConfig;
  {$ENDIF}
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
