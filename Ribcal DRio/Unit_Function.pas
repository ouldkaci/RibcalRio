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
procedure agrandissement_central(at_element:wformes.tforme); 

///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
implementation
///////////////////////////////////////////////////////////////////////////////
Agrandir proportionnellement à partir d'une pastille la résolution d'une image quelconque. Visulalisateur Xavier}
  procedure agrandissement_central(at_element:wformes.tforme); {écrit par denis Bertin le 11.12.2016}
    var i,j:integer;
        anode:font_ob1.testnode;
        une_distance,rapport:real;
        un_at_element:wformes.tforme;
        control:boolean;
        attrib:wcarac.TUn_attrib;
        my_rect:trect;
    begin
    if at_element=nil then exit;
    control:=(wmsg.msg.wparam and mk_control)<>0;
    une_distance:=utile.distance_2pt(wformes.global_central_point,wmsg.point);
    rapport:=une_distance/utile.distance(
      wformes.global_central_point.x,
      wformes.global_central_point.Y,
        wformes.global_rect_central.Right,
        wformes.global_rect_central.bottom)/200;
    if rapport>=5 then rapport:=5;
    if at_element.ClassType=wformes1.tforme_dessin then
      begin
      for i:=0 to pred(wformes1.tforme_dessin(at_element).elements.count) do
        begin
        anode:=wformes1.tforme_dessin(at_element).elements.at(i);
        if control then
          begin
          anode.x:=round(anode.x-anode.x*rapport);
          anode.y:=round(anode.y-anode.y*rapport);
          anode.z:=round(anode.z-anode.z*rapport);
          end
        else
          begin
          anode.x:=round(anode.x+anode.x*rapport);
          anode.y:=round(anode.y+anode.y*rapport);
          anode.z:=round(anode.z+anode.z*rapport);
          end;
        end;
      at_element.calcul;
      end
    else if at_element.ClassType=wformes1.tforme_text then
      begin
      my_rect:=at_element.rect;
      if control then
        wformes1.tforme_text(at_element).af.raf.taille:=
          wformes1.tforme_text(at_element).af.raf.taille-
            round(wformes1.tforme_text(at_element).af.raf.taille*rapport)
      else
        wformes1.tforme_text(at_element).af.raf.taille:=
          wformes1.tforme_text(at_element).af.raf.taille+
            round(wformes1.tforme_text(at_element).af.raf.taille*rapport);
      if wformes1.tforme_text(at_element).af.raf.taille<=0 then
        wformes1.tforme_text(at_element).af.raf.taille:=1;
      if wformes1.tforme_text(at_element).af.raf.taille>999 then
        wformes1.tforme_text(at_element).af.raf.taille:=999;
      wformes1.tforme_text(at_element).af.raf.index:=0;
      at_element.calcul;
      wformes1.tforme_text(at_element).af.raf.x:=wformes1.tforme_text(at_element).af.raf.x-(at_element.right-my_rect.right) div 2;
      wformes1.tforme_text(at_element).af.raf.y:=wformes1.tforme_text(at_element).af.raf.y-((at_element.top-my_rect.top)+(at_element.bottom-my_rect.bottom)) div 2;
      at_element.calcul;
      end
    else if at_element.ClassType=wformes1.TForme_bloc_de_true_type then
      begin
      for j:=0 to pred(wformes1.TForme_bloc_de_true_type(at_element).une_collection.count) do
        begin
        attrib:=wformes1.TForme_bloc_de_true_type(at_element).une_collection.at(j);
        if attrib<>nil then
          begin
          if attrib.ClassType=wcarac.TUn_attrib then
            begin
            if control then
              attrib.size_font:=attrib.size_font-round(attrib.size_font*rapport)
            else
              attrib.size_font:=attrib.size_font+round(attrib.size_font*rapport);
            if attrib.size_font<=0 then attrib.size_font:=1;
            if attrib.size_font>500 then attrib.size_font:=500;
            end;
          end; {attrib<>nil}
        end; {for j}
      at_element.calcul;
      end
    else if at_element.ClassType=wformes1.tforme_ligne then
      begin
      if control then
        wformes1.tforme_ligne(at_element).size:=
          wformes1.tforme_ligne(at_element).size-
            round(wformes1.tforme_ligne(at_element).size*rapport)
      else
        wformes1.tforme_ligne(at_element).size:=
          wformes1.tforme_ligne(at_element).size+
            round(wformes1.tforme_ligne(at_element).size*rapport);
      if wformes1.tforme_ligne(at_element).size<=0 then
        wformes1.tforme_ligne(at_element).size:=1;
      if wformes1.tforme_ligne(at_element).size>500 then
        wformes1.tforme_ligne(at_element).size:=500;
      at_element.calcul;
      end
    else if at_element.ClassType=wformes1.tforme_little_texte then
      begin
      if control then
        wformes1.tforme_little_texte(at_element).size:=
          wformes1.tforme_little_texte(at_element).size-
            round(wformes1.tforme_little_texte(at_element).size*rapport)
      else
        wformes1.tforme_little_texte(at_element).size:=
          wformes1.tforme_little_texte(at_element).size+
            round(wformes1.tforme_little_texte(at_element).size*rapport);
      if wformes1.tforme_little_texte(at_element).size<=0 then
        wformes1.tforme_little_texte(at_element).size:=1;
      if wformes1.tforme_little_texte(at_element).size>999 then
        wformes1.tforme_little_texte(at_element).size:=999;
      at_element.calcul;
      end
    else if at_element.ClassType=wformebm.Tforme_TBitMap then
      begin
      my_rect:=at_element.rect;
      if control then
        begin
        wformebm.Tforme_TBitMap(at_element).rect.left:=wformebm.Tforme_TBitMap(at_element).rect.left+
          round(wformebm.Tforme_TBitMap(at_element).rect.left*rapport);
        wformebm.Tforme_TBitMap(at_element).rect.top:=wformebm.Tforme_TBitMap(at_element).rect.top+
          round(wformebm.Tforme_TBitMap(at_element).rect.top*rapport);
        wformebm.Tforme_TBitMap(at_element).rect.right:=wformebm.Tforme_TBitMap(at_element).rect.right-
          round(wformebm.Tforme_TBitMap(at_element).rect.right*rapport);
        wformebm.Tforme_TBitMap(at_element).rect.bottom:=wformebm.Tforme_TBitMap(at_element).rect.bottom-
          round(wformebm.Tforme_TBitMap(at_element).rect.bottom*rapport);
        end
      else
        begin
        wformebm.Tforme_TBitMap(at_element).rect.left:=wformebm.Tforme_TBitMap(at_element).rect.left-
          round(wformebm.Tforme_TBitMap(at_element).rect.left*rapport);
        wformebm.Tforme_TBitMap(at_element).rect.top:=wformebm.Tforme_TBitMap(at_element).rect.top-
          round(wformebm.Tforme_TBitMap(at_element).rect.top*rapport);
        wformebm.Tforme_TBitMap(at_element).rect.right:=wformebm.Tforme_TBitMap(at_element).rect.right+
          round(wformebm.Tforme_TBitMap(at_element).rect.right*rapport);
        wformebm.Tforme_TBitMap(at_element).rect.bottom:=wformebm.Tforme_TBitMap(at_element).rect.bottom+
          round(wformebm.Tforme_TBitMap(at_element).rect.bottom*rapport);
        end;
      at_element.deplace(
        ((my_rect.right+my_rect.left) div 2-(at_element.rect.right+at_element.rect.left) div 2),
        ((my_rect.bottom+my_rect.top) div 2-(at_element.rect.bottom+at_element.rect.top) div 2),0);
      {écrit par denis Bertin le 11.12.2016}
      my_rect:=at_element.rect;
      end
    else if (at_element.ClassType=wformes2.tforme_groupe)
    //or (at_element.ClassType=wformes2.Tforme_indice)
    or (at_element.ClassType=wformes2.tforme_symetrie_horizontale)
    or (at_element.ClassType=wformes2.tforme_symetrie_verticale)
    or (at_element.ClassType=wformes2.tforme_Interpolation) then
      begin
      for i:=0 to pred(wformes2.tforme_groupe(at_element).groupe.count) do
        begin
        un_at_element:=wformes.tforme(wformes2.tforme_groupe(at_element).groupe.at(i));
        if un_at_element<>nil then
          agrandissement_central(un_at_element);
        end;
      at_element.calcul;
      end;
    end; {agrandissement_central}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
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



