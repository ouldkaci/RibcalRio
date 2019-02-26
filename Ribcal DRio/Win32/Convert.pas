unit Convert;

interface

uses
  SysUtils ;


Const QuoiEntier = 'Dinars';
Const QuoiDecimales = 'Centime';


var
  Txt, PartieEntiere, PartieDecimale, TxtEntier :String;
  TxtUnites:array[0..19] of String= ('', 'un', 'deux', 'trois', 'quatre', 'cinq', 'six', 'sept', 'huit', 'neuf', 'dix',
    'onze', 'douze', 'treize', 'quatorze', 'quinze', 'seize', 'dix-sept', 'dix-huit', 'dix-neuf');
  TxtDizaines : Array[0..10] of String= ('', '', 'vingt', 'trente', 'quarante', 'cinquante', 'soixante', 'soixante', 'quatre-vingt', 'quatre-vingt', 'Cent');
  TxtMilliers : Array[0..4] of String= (' ', ' ', 'mille', 'Million', 'Milliard');

Procedure Centaine(Valeur:integer);
function NombreTexte(Chiffre:Currency):String;
function iif(a: boolean; b,c: String):String;
function StrRight(s: string; nb: Integer): string;
function StrLeft(s: string; nb: Integer): string;

implementation

function iif(a: boolean; b,c: String):String;
begin
    if a then iif := b
    else iif := c
end;

function StrRight(s: string; nb: Integer): string;
begin
  StrRight := iif(nb >= Length(s), s, copy(S, Length(s) - nb + 1, nb));
end;

function StrLeft(s: string; nb: Integer): string;
begin
  StrLeft := iif(nb >= Length(s), s, copy(S, 1, nb));
end;


Procedure Centaine(Valeur:integer);
var CentaineNb,DizaineNb,UnitesNb :Integer;
    Lien:String;
begin
//Extraction des trois chiffres
CentaineNb := Valeur div 100;
DizaineNb  := (Valeur - CentaineNb * 100) div 10;
UnitesNb   := Valeur - CentaineNb * 100 - DizaineNb * 10;
//Pour les valeurs 10 à 19, 70 à 79 et 90 à 99
If (DizaineNb = 1) Or (DizaineNb = 7) Or (DizaineNb = 9) Then
    UnitesNb := UnitesNb + 10;
//Le séparateur : -, et ou espace
Case UnitesNb of
    1:Lien := ' et ';
   11:  If DizaineNb = 7 Then
            Lien := ' et '
        Else
            Lien := '-';
   Else
        Lien := '-';
end;
If UnitesNb = 0  Then Lien := '';
If DizaineNb = 1 Then Lien := '';

//Les dizaines en lettres
If DizaineNb > 0 Then
    Txt := TxtDizaines[DizaineNb] + Lien + TxtUnites[UnitesNb] + ' '
Else
    Txt := TxtUnites[UnitesNb] + ' ';

//Les centaines en lettres
if CentaineNb =1 then Txt := ' cent ' + Txt else if CentaineNb > 1 then
    If (DizaineNb > 0) Or (UnitesNb > 0) Then
        Txt := TxtUnites[CentaineNb] + ' Cent ' + Txt
    Else
        Txt := TxtUnites[CentaineNb] + ' Cents' + Txt;
end;

function NombreTexte(Chiffre:Currency):String;
var j,i:integer; TxtDecimales,Valeur,reel:String;
      TrancheNb : Array[1..5] of String;
begin
   reel:=FormatFloat('###0.00',Chiffre);
   PartieEntiere:=inttostr(trunc(strtofloat(Reel)));
   PartieDecimale:=FloatToStr(round((StrToFloat(Reel)-strToInt64(PartieEntiere))*100));
   for i:=1 to 5 do
       TrancheNb[i]:='';
   j := 1;
   While (Length(PartieEntiere) > 0) do
   begin
      TrancheNb[j]  := StrRight(PartieEntiere, 3);
      PartieEntiere := StrLeft(PartieEntiere, Length(PartieEntiere) - Length(TrancheNb[j]));
      j := j + 1;
   end;
   //------------>>>>>>>>>> Conversion en texte de chaque tranche de la partie entière
   TxtEntier := '';
   For i := j DownTo 1 do
   begin
      If TrancheNb[i] <> '' Then
      begin
        Centaine (strtoint(TrancheNb[i]));
        If Txt <> ' ' Then
        begin
            if (Txt ='un ') and (i=2) then Txt:='';
            TxtEntier := TxtEntier + Txt + TxtMilliers[i];
        end;
   //------------>>>>>>>>>>> Ajout du s à million et milliard
        If (i >= 3) And (Txt <> 'un') And (Txt <> ' ') Then
            TxtEntier := TxtEntier + 's '
        Else
            TxtEntier := TxtEntier + ' ';
      end;
      If StrRight(TxtEntier, 2) = '  ' Then TxtEntier := StrLeft(TxtEntier, length(TxtEntier) - 1);
   end;
   If StrLeft(TxtEntier, 1) = ' ' Then TxtEntier := StrRight(TxtEntier, length(TxtEntier) - 1);

   If (StrRight(TxtEntier, 3) = 'ns ') Or (StrRight(TxtEntier, 3) = 'ds ') Then TxtEntier := TxtEntier + 'de ';

   //----Si le nombre égale zéro
   If (TxtEntier = '  ') Or (TxtEntier = ' ') Or (TxtEntier = '') Then TxtEntier := 'zero ';

   //----Introduction du s à l'unité de mesure si la valeur du nombre dépasse 1,99
   TxtEntier := TxtEntier + QuoiEntier + IIf(StrToInt(iif(Valeur='','0',valeur)) > 1.99, 's', '');

   //---->>>> Conversion en texte de la partie décimale du nombre
   TxtDecimales := '';
   If PartieDecimale <> '' Then
   begin
      Txt := '';
      Centaine (StrToInt(PartieDecimale));
      if trim(Txt)='' then Txt:='zero ';
      TxtDecimales := ' et ' + Txt + QuoiDecimales + IIf(Txt <> '', 's', '');
   end;
   TxtEntier[1]:=chr(ord(TxtEntier[1])-32);
   result := TxtEntier + TxtDecimales
end;
end.