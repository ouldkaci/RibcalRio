unit Unit_Function;

interface

uses DateUtils,StrUtils,SysUtils,Windows, Messages,  Variants, Classes, Graphics,
     Controls, Forms,Dialogs, Menus,StdCtrls,Math,ShellApi,Registry,Buttons,
     ComCtrls,ExtCtrls,RxCurrEdit,RxToolEdit;

  var status,info,Check:string;


{$WARNINGS OFF}
{$WARN SYMBOL_PLATFORM OFF}
Function addzeros(const source:string;len:integer):string;
Function ControleRib(Rib:String):boolean;
Function CleRIB(banque:string;agence:string;compte:string;RIB:string):String;
Function CleRip(Compte:string):string;
Function CalcIrg(SImposabl:Currency;base:integer):Currency;
Function NSScontrole(Nss:string):integer;//Extended;

procedure Effacetout(Fenetre:Tform);
function properCase(sBuffer: string):string;
Function TextToCurrency(Const S: String):Currency;

procedure ConfigureRegion;
function GetHardDiskSerial(const DriveLetter: char): string;
function AppVersion(const Filename: string):string;
function GetVersion(ExeName : string):string;


///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
implementation

function GetVersion(ExeName : string):string;
var
  S         : String;
  Taille    : DWord;
  Buffer    : PChar;
  pVersionPC: PChar;
  VersionL  : DWord;
begin
  result := '';
  S := ExeName;
  Taille := GetFileVersionInfoSize(PChar(S), Taille);
  If Taille>0
  Then Try

    Buffer := AllocMem(Taille);

    GetFileVersionInfo(PChar(S), 0, Taille, Buffer);

    If VerQueryValue(Buffer, PChar('\StringFileInfo\040C04E4\FileVersion'), Pointer(pVersionPC), VersionL) then
    begin
      result := pVersionPC;
    end;

  Finally
    FreeMem(Buffer, Taille);
  End;
end;

{code}
Function CalcIrg(SImposabl:Currency;base:integer):Currency;
var IRG:Currency;
begin
irg:=0;
if SImposabl<=15000  then  IRG:=0 else
if SImposabl>=120010 then  IRG:=(SImposabl-120000)/10*3.5+29500 else
if SImposabl>=30010  then  IRG:=(SImposabl-30000)/10*3+2500 else
if SImposabl>=28760  then  IRG:=(SImposabl-28750)/10*2+2250 else
if SImposabl>=22510  then  IRG:=(SImposabl-22500)/10*1.2+1500 else
if SImposabl>=15010  then  IRG:=(SImposabl-15000)/10*2 ;
irg:=(irg*base)/30;
Result:=irg;
//Result:=FloatToStrf(Irg,ffCurrency,8,2);
//Result:=FormatFloat('0.00',irg);
end;
{code}

 Function TextToCurrency(Const S: String):Currency;
   Var
     i, k: Integer;
     Numerals: Set Of Char;
     temp: String;
   Begin
     Numerals := ['0'..'9','-', '+',FormatSettings.DecimalSeparator,
FormatSettings.ThousandSeparator];
     i := 1;
     While (i<=Length(S)) and not (S[i] In Numerals) Do
       Inc(i);
     Exclude(Numerals, '-');
     Exclude(Numerals, '+');
     k:= i+1;
     While (k<=Length(S)) and (S[k] In Numerals) Do Begin
       If S[k] = FormatSettings.DecimalSeparator Then Begin
         Exclude(Numerals, '.'); //FormatSettings.DecimalSeparator
         Exclude(Numerals, ',');
         Exclude(Numerals, ' ');//FormatSettings.ThousandSeparator
       End;
       Inc(k);
     End; {While}
     If (i <= Length(S)) Then Begin
       temp := Copy(S,i,k-i);
       For i:= length(temp) downto 1 Do
         If temp[i] = FormatSettings.ThousandSeparator Then
           Delete(temp, i, 1);
       Result := StrToFloat(temp)
     End
     Else
       raise EConvertError.CreateFmt('%s is not a valid currency value!',
                                      [S] );
   End; {TextToCurrency}

function AppVersion(const Filename: string):string;
var dwHandle: THandle;
    dwSize: DWORD;
    lpData, lpData2: Pointer;
    uiSize: UINT;
begin
  Result := '';
  dwSize := GetFileVersionInfoSize(PChar(FileName), dwSize);
  if dwSize <> 0 then
  begin
    GetMem(lpData, dwSize);
    if GetFileVersionInfo(PChar(FileName), dwHandle, dwSize, lpData) then
      begin
        uiSize := Sizeof(TVSFixedFileInfo);
        VerQueryValue(lpData, '', lpData2, uiSize);
        with PVSFixedFileInfo(lpData2)^ do
          Result := Format('%d.%02d.%02d.%02d', [HiWord(dwProductVersionMS), LoWord(dwProductVersionMS),HiWord(dwProductVersionLS), LoWord(dwProductVersionLS)]);
      end;
    FreeMem(lpData, dwSize);
  end;
end;

function GetHardDiskSerial(const DriveLetter: char): string;
var NotUsed, VolumeFlags, VolumeSerialNumber: dWord;
    VolumeInfo: array[0..MAX_PATH] of char;
begin
  GetVolumeInformation(PChar(DriveLetter + ':'), VolumeInfo, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed, VolumeFlags, nil, 0);
//  Result := Format('%sHDiskSerial = %8.8X', [VolumeInfo, VolumeSerialNumber]);
Result := Format(DriveLetter+'%s%8.8X', [VolumeInfo, VolumeSerialNumber]);
end;

procedure ConfigureRegion;
var
  FormatBr: TFormatSettings;
begin
  // Create new setting and configure for the brazillian format
  FormatBr                     := TFormatSettings.Create;
  FormatBr.DecimalSeparator    := ',';
  FormatBr.ThousandSeparator   := ' ';
  FormatBr.CurrencyDecimals    := 2;
  FormatBr.DateSeparator       := '/';
  FormatBr.ShortDateFormat     := 'dd/mm/yyyy';
  FormatBr.LongDateFormat      := 'dd/mm/yyyy';
  FormatBr.TimeSeparator       := ':';
  FormatBr.TimeAMString        := 'AM';
  FormatBr.TimePMString        := 'PM';
  FormatBr.ShortTimeFormat     := 'hh:nn';
  FormatBr.LongTimeFormat      := 'hh:nn:ss';
  FormatBr.CurrencyString      := 'Dz';
  // Assign the App region settings to the newly created format
  SysUtils.FormatSettings := FormatBr;
end;

Function addzeros(const source:string;len:integer):string;
  var
  i:integer;
  begin
  result:=source;
  for i:=1 to (len-length(source)) do
  result:='0'+result;
end ;

Function CleRIb(banque:string;agence:string;compte:string;RIB:string):String;
begin
Status:='';
banque:=addzeros(banque,3);
agence:=addzeros(agence,5);
compte:=addzeros(compte,10);
RIB:=inttostr(97-(strtoint64(agence+compte)*100) mod 97);
RIB:=banque+agence+compte+Addzeros(RIB,2);
Result:=RIB;
if compte='0000000000' then
Status:='*** Operations incomplet  ***'
else
Status:='*** Operations Calc.Rib effectué ***';
end;

Function CleRip(Compte:string):string;
var som,i:integer;
begin
//Status:='';
som:=0;
for i:=1 to length(Compte) do
som:=som+(strtoint(compte[i])*(14-i));
Result:=Addzeros(inttostr(som mod 100),2);
if compte='0000000000' then
//Status:='*** Operations incomplet  ***'
else
//Status:='*** Operations Cle.Rip effectué avec succès ***';
end;

Function ControleRib(Rib:String):boolean;
var Cle:string;
begin
if length(Rib)<20 then Status:='*** Le Relevé d''Identité Bancaire incomplet ***'
else
begin
cle:=Rib;
Rib:=Addzeros(inttostr(97-StrToInt64(midbStr(Rib,4,15))*100 mod 97),2);
if Rib=RightStr(CLE,2) then Result:=true;
if Result=true then Status:='*** Le Relevé d''identité Bancaire conforme *** '
else Status:='*** Le numéro de compte est irrégulier ***' end;
end;

Function NSScontrole(Nss:string):integer;//Extended;
var I,somme,Som:integer;
begin
if (Nss<>'')and(length(Nss)=12) then begin
somme:=0;
for i := 1 to length(NSS)-2 do begin
if i mod 2 =1 then som:=strtoint(Nss[i])*2 else som:=strtoint(Nss[i])*1;
somme:=somme+som;
end;
Result:=99-somme;
if Result=strtoint(RightStr(NSS,2)) then begin
Status:='Le numéro de sécurité social est Conforme ***';
end else begin
Status:='*** Le numéro de sécurité social Irrégulier ***';
end;
end else begin
result:=99;//Extended; 0.1E99
Status:='*** Le numéro de sécurité social inexistant ***';
end;
end;


procedure Effacetout(Fenetre:Tform);
var
  i : integer;
begin
for i := 0 to Fenetre.ComponentCount-1 do   begin
//if (Fenetre.Components[i] is TEdit) then (Fenetre.Components[i] as TEdit).Text:= '';
if (Fenetre.Components[i] is TEdit) then  (Fenetre.Components[i] as TEdit).Clear;
//if (Fenetre.Components[i] is TEdit) then (Fenetre.Components[i] as TEdit).Font.Style:=[fsBold];
if (Fenetre.Components[i] is TLabeledEdit) then (Fenetre.Components[i] as TLabeledEdit).Text := '';
if (Fenetre.Components[i] is TButtonedEdit) then (Fenetre.Components[i] as TButtonedEdit).Text := '';
if (Fenetre.Components[i] is TMemo) then (Fenetre.Components[i] as TMemo).Text := '';
if (Fenetre.Components[i] is TCurrencyEdit) then (Fenetre.Components[i] as TCurrencyEdit).Text := '';
  end;
end;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
function properCase(sBuffer: string):string;
var
    iLen, iIndex: integer;
begin
    iLen := Length(sBuffer);
    sBuffer:= Uppercase(MidStr(sBuffer, 1, 1)) + Lowercase(MidStr(sBuffer,2, iLen));
    for iIndex := 0 to iLen do
    begin
      if MidStr(sBuffer, iIndex, 1) = ' ' then
          sBuffer := MidStr(sBuffer, 0, iIndex) + Uppercase(MidStr(sBuffer, iIndex + 1, 1)) + Lowercase(MidStr(sBuffer, iIndex + 2, iLen));
    end;
    Result := sBuffer;
end;

end.



