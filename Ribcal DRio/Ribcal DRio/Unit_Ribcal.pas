// *** dZ *** // oulkaci.rabah@yandex.com

unit Unit_Ribcal;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ImgList, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Samples.Spin,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons,
  IniFiles, RxToolEdit, RxCurrEdit, StrUtils,
  Themes, Styles, Timestop, System.ImageList, VersInfo, cxClasses,
  cxPropertiesStore;

type
  TForm_Ribcal = class(TForm)
    StyleMenu: TPopupMenu;
    ImageList1: TImageList;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel1: TCategoryPanel;
    CategoryPanel2: TCategoryPanel;
    CategoryPanel4: TCategoryPanel;
    CategoryPanel3: TCategoryPanel;
    StatusBar1: TStatusBar;
    Curr_SP: TCurrencyEdit;
    Curr_Imp: TCurrencyEdit;
    Curr_Net_a_payé: TCurrencyEdit;
    Curr_Rss: TCurrencyEdit;
    Curr_Irg: TCurrencyEdit;
    Curr_zone_I: TCurrencyEdit;
    Curr_Net_Sans_ifri: TCurrencyEdit;
    Curr_zone_II: TCurrencyEdit;
    SpeedButton_Clear: TSpeedButton;
    SpeedButton_S: TSpeedButton;
    Spin_base: TSpinEdit;
    Rib_Panel: TPanel;
    E_Banque: TLabeledEdit;
    E_Agence: TLabeledEdit;
    E_Compte: TLabeledEdit;
    E_Cle: TLabeledEdit;
    E_Rib: TLabeledEdit;
    E_Vérifier_Rib_: TLabeledEdit;
    SS_panel: TPanel;
    E_Vérifier_NSS_: TLabeledEdit;
    E_Vérifier_CléSS_: TLabeledEdit;
    L_SP: TLabel;
    Retenu_Ss: TLabel;
    L_SI: TLabel;
    Retenu_irg: TLabel;
    l_NET: TLabel;
    L_FZ1: TLabel;
    L_net_SZ: TLabel;
    L_FZ2: TLabel;
    SB_VSS: TSpeedButton;
    SB_Rib: TSpeedButton;
    SB_VRib: TSpeedButton;
    Nom_Banque: TEdit;
    E_CCPv: TLabeledEdit;
    Signe_Panal: TPanel;
    Memo: TMemo;
    TimeStop1: TTimeStop;
    SMVersionInfo: TSMVersionInfo;
    SpeedButton1: TSpeedButton;
    cxPropertiesStore1: TcxPropertiesStore;
    procedure SB_RibClick(Sender: TObject);
    procedure SB_VRibClick(Sender: TObject);
    procedure SpeedButton_ClearClick(Sender: TObject);
    procedure SB_VSSClick(Sender: TObject);
    procedure StyleClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure E_CompteExit(Sender: TObject);
    procedure E_Vérifier_Rib_6Exit(Sender: TObject);
    procedure E_Vérifier_NSS_Exit(Sender: TObject);
    procedure E_Vérifier_Rib_Exit(Sender: TObject);
    procedure SpeedButton_SClick(Sender: TObject);
    procedure démarrage(Sender: TObject);
    procedure Curr_SPExit(Sender: TObject);
    procedure Curr_ImpExit(Sender: TObject);
    procedure Curr_zone_IIExit(Sender: TObject);
    procedure Curr_Net_a_payéExit(Sender: TObject);
    procedure E_BanqueChange(Sender: TObject);
    procedure IniWrite(Sender: TObject);
    procedure FileRUB(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Déclarations publiques }
  end;

var
  Form_Ribcal: TForm_Ribcal;
  IniFile: TINIFile;
  Inidir: string;
  IniListe: TStringList;

implementation

{$R *.dfm}

{ E_Banque,E_Agence,E_Compte,E_Cle,E_Rib,E_Vérifier_Rib_, E_Vérifier_NSS_
  E_Vérifier_CléSS_ }
uses
  Unit_Function;

procedure TForm_Ribcal.FileRUB(Sender: TObject);
var
  s: TStringList;
  dirRUB: string;
  textf: textFile;
begin
  dirRUB := ExtractFilePath(Application.ExeName) + 'A003.RUB';
  AssignFile(textf, dirRUB);
  Reset(textf);
  s := TStringList.create();
  s.LoadFromFile(dirRUB);
  CloseFile(textf);
  s.SaveToFile(dirRUB);
end;

procedure TForm_Ribcal.IniWrite(Sender: TObject);
var
  FTStringList: TStringList;
  index: Integer;
begin
  // if not DirectoryExists(ExtractFilePath(Application.ExeName)) then
  // if not CreateDir(ExtractFilePath(Application.ExeName)) then
  // raise Exception.Create('Impossible de créer un calcule pour ce compte');
  // if FileExists(IniDir) then
  // begin
  SMVersionInfo.FileName := Application.ExeName;
  Inidir := ExtractFilePath(Application.ExeName) + 'Parametres.ini';
  DeleteFile(Inidir);
  IniFile := TINIFile.create(Inidir);
  try
    with IniFile do
    begin
      EraseSection('Paramètres_Listes des Banaque');
      EraseSection('Paramètres');
      EraseSection('Paramètres_Application');
      UpdateFile;
      WriteString('Paramètres_Listes des Banaque', '001',
        'Banque Nationale d''Algerie');
      WriteString('Paramètres_Listes des Banaque', '002',
        'Banque Exterieur d''Algerie');
      WriteString('Paramètres_Listes des Banaque', '003',
        'Banque Algerienne Developp Rural');
      WriteString('Paramètres_Listes des Banaque', '004',
        'CREDIT POPULAIRE D''ALGERIE');
      WriteString('Paramètres_Listes des Banaque', '005',
        'Banque Developpement Local');
      WriteString('Paramètres_Listes des Banaque', '006', 'El Baraka');
      WriteString('Paramètres_Listes des Banaque', '007',
        'Centre des Cheques Postaux');
      WriteString('Paramètres_Listes des Banaque', '008', 'Trésor  Central');
      WriteString('Paramètres_Listes des Banaque', '010', 'CNMA');
      WriteString('Paramètres_Listes des Banaque', '011', 'CNEP');
      WriteString('Paramètres_Listes des Banaque', '012', 'CITY BANK');
      WriteString('Paramètres_Listes des Banaque', '014', 'A B C COR');
      WriteString('Paramètres_Listes des Banaque', '020', 'NATEXIS');
      WriteString('Paramètres_Listes des Banaque', '021',
        'SOCIETE GENERALE Algerie');
      WriteString('Paramètres_Listes des Banaque', '026', 'ARAB BANK PLC');
      WriteString('Paramètres_Listes des Banaque', '027', 'B N P');
      WriteString('Paramètres_Listes des Banaque', '029', 'RUST BANK');
      WriteString('Paramètres_Listes des Banaque', '031', 'HOUSING BANK AG');
      WriteString('Paramètres_Listes des Banaque', '032', 'ALGERIA GULF BANK');
      WriteString('Paramètres_Listes des Banaque', '035', 'FRANSABANK');
      WriteString('Paramètres_Listes des Banaque', '036', 'CALYON');
      WriteString('Paramètres_Listes des Banaque', '037', 'HSBC ALGERIA');
      WriteString('Paramètres_Listes des Banaque', '038',
        'AL SALAM BANK ALGERIA');
      WriteString('Paramètres_Listes des Banaque', '111', 'Banque d''Algerie');
      // ************************************************************************
      WriteInteger('Paramètres', 'fHeight', Form_Ribcal.Height);
      WriteInteger('Paramètres', 'fWidth', Form_Ribcal.Width);
      WriteInteger('Paramètres', 'fleft', Form_Ribcal.Left);
      WriteInteger('Paramètres', 'ftop', Form_Ribcal.Top);
      // ************************************************************************
      WriteString('Paramètres_Application', 'Version',
      SMVersionInfo.FileVersion);
      WriteBool('Paramètres_Application', 'Build', true);
      WriteDate('Paramètres_Application', 'accés Le', Now);
      IniFile := TINIFile.create(ExtractFilePath(Application.ExeName) + 'Parametres.ini');
      WriteString('StyleMan','Styl', TStyleManager.ActiveStyle.Name);
      // WriteString('Paramètres_Application','=','========================='+ #13#10);
      // *************************************************************************
    end;
  finally
    IniFile.Free;
  end;

  FTStringList := TStringList.create();
  FTStringList.LoadFromFile(Inidir);
  index := 0;
  while (index < FTStringList.Count) do
  begin
    if FTStringList.Strings[index][1] = '[' then
    begin
      FTStringList.Insert(index, '------------------------------------------');
      index := index + 1;
    end;
    index := index + 1;
  end;
  FTStringList.SaveToFile(Inidir);
  FTStringList.Free;
  // FileSetAttr(Inidir, faHidden);
end;

procedure TForm_Ribcal.démarrage(Sender: TObject);
var
  J: Integer;
begin
  ConfigureRegion;
  for J := 0 to Form_Ribcal.ComponentCount - 1 do
  begin
    if (Form_Ribcal.Components[J] is TEdit) then
      (Form_Ribcal.Components[J] as TEdit).Font.Style := [fsBold];
    if (Form_Ribcal.Components[J] is TLabeledEdit) then
      (Form_Ribcal.Components[J] as TLabeledEdit).Font.Style := [fsBold];
    if (Form_Ribcal.Components[J] is TSpeedButton) then
      (Form_Ribcal.Components[J] as TSpeedButton).Font.Style := [fsBold];
    if (Form_Ribcal.Components[J] is TCurrencyEdit) then
      (Form_Ribcal.Components[J] as TCurrencyEdit).Font.Style := [fsBold];
  end;

  with Signe_Panal do
  begin
    Alignment := taCenter;
    Caption := ' ***** ouldkaci.rabah@gmail.com ***** ';
    Font.Name := 'symbol';
    Font.Size := 8;
  end;
  SB_Rib.Glyph.Assign(nil);
  SB_VRib.Glyph.Assign(nil);
  SB_VSS.Glyph.Assign(nil);
  SpeedButton_Clear.Glyph.Assign(nil);
  ImageList1.GetBitmap(4, SB_Rib.Glyph);
  ImageList1.GetBitmap(5, SB_VRib.Glyph);
  ImageList1.GetBitmap(11, SB_VSS.Glyph);
  ImageList1.GetBitmap(18, SpeedButton_Clear.Glyph);
end;

procedure TForm_Ribcal.CMDialogKey(var Message: TCMDialogKey);
begin
  if Message.CharCode = VK_RETURN then
    Message.CharCode := VK_TAB;
  inherited;
end;

procedure TForm_Ribcal.StyleClick(Sender: TObject);
var
  StyleName: String;
  i: Integer;
begin
  StyleName := StringReplace(TMenuItem(Sender).Caption, '&', '',
    [rfReplaceAll, rfIgnoreCase]); // get style name
  TStyleManager.SetStyle(StyleName); // set active style
  (Sender as TMenuItem).Checked := true; // check currently selected menu item
  for i := 0 to StyleMenu.Items.Count - 1 do // uncheck other style menu items
  begin // get style name
    if not StyleMenu.Items[i].Equals(Sender) then
      StyleMenu.Items[i].Checked := false;
  end;
end;

procedure TForm_Ribcal.SpeedButton_SClick(Sender: TObject);
begin
  if SpeedButton_S.Caption = 'S' then
  begin
    Form_Ribcal.FormStyle := fsStayOnTop;
    SpeedButton_S.Caption := 'N';
  end
  else if SpeedButton_S.Caption = 'N' then
  begin
    Form_Ribcal.FormStyle := fsNormal;
    SpeedButton_S.Caption := 'S';
  end;
end;

procedure TForm_Ribcal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IniWrite(Sender); // save inifiles

  SMVersionInfo.FileName := Application.ExeName;
  ShowMessage('Version: ' + SMVersionInfo.FileVersion + #13#10 + 'Produit: ' +
    SMVersionInfo.ProductVersion + '.3' + GetVersion(Application.ExeName)    +
    #13#10 + 'Sarl IlassalI' + #13#10 + 'com.liamg@habar.icakdluo' + #13#10  +
    'ouldkaci.rabah@yandex.com ou gmail.com ' + #13#10  +
    '**********************************************');
end;

procedure TForm_Ribcal.FormCreate(Sender: TObject);
var
  Style: String;
  Item: TMenuItem;
begin
  Inidir := ExtractFilePath(Application.ExeName) + 'A003.Rub';
  DeleteMenu(GetSystemMenu(Handle, false), SC_MOVE, MF_BYCOMMAND);
  GetSystemMenu(Handle, true);
  // Add child menu items based on available styles.
  for Style in TStyleManager.StyleNames do
  begin
    Item := TMenuItem.create(StyleMenu);
    Item.Caption := Style;
    Item.OnClick := StyleClick;
    if TStyleManager.ActiveStyle.Name = Style then
      Item.Checked := true;
    StyleMenu.Items.Add(Item);
  end;
    démarrage(Sender);
end;

procedure TForm_Ribcal.FormDestroy(Sender: TObject);
begin

end;

///////////////////////////////////////////////////////////////////////////////
procedure TForm_Ribcal.SpeedButton1Click(Sender: TObject);
begin
  SMVersionInfo.FileName := Application.ExeName;
  Memo.Lines.Clear;
  Memo.Lines.BeginUpdate;
  try
    // mome.Lines.Add('FileName: ' + SMVersionInfo.FileName);
    { Major } Memo.Lines.Add('Version: ' +
      IntToStr(SMVersionInfo.MajorVersion) + '.' +
      { Minor } IntToStr(SMVersionInfo.MinorVersion));
    with  Memo.Lines do begin
    Add('Release: ' + IntToStr(SMVersionInfo.Release));
    Add('Build: ' + IntToStr(SMVersionInfo.Build));
    // memo.Lines.Add('DateTime: ' + DateToStr(SMVersionInfo.DateTime));
    // memo.Lines.Add('CompanyName: ' + SMVersionInfo.CompanyName);
    // memo.Lines.Add('FileDescription: ' + SMVersionInfo.FileDescription);
    Add('FileVersion: ' + SMVersionInfo.FileVersion);
    // Memo.Lines.Add('InternalName: ' + SMVersionInfo.InternalName);
    // Memo.Lines.Add('LegalCopyright: ' + SMVersionInfo.LegalCopyright);
    // Memo.Lines.Add('OriginalFilename: ' + SMVersionInfo.OriginalFilename);
    Add('ProductName: ' + SMVersionInfo.ProductName);
    Add('ProductVersion: ' + SMVersionInfo.ProductVersion);
    Add('Comments: ' + SMVersionInfo.Comments);
    // memo.Lines.Add('LegalTrademarks: ' + SMVersionInfo.LegalTrademarks);
    Add(GetHardDiskSerial('C'));
    end;
  finally
    Memo.Lines.EndUpdate;
  end;
end;
////////////////////////////////////////////////////////////////////////////
procedure TForm_Ribcal.SpeedButton_ClearClick(Sender: TObject);
begin
  Effacetout(Form_Ribcal);
end;//*********************************************************************
procedure TForm_Ribcal.SB_RibClick(Sender: TObject);
begin
  if E_Banque.Text = '' then
    E_Banque.Text := '007';
  if E_Agence.Text = '' then
    E_Agence.Text := '99999';
  if E_Compte.Text = '' then
    E_Compte.Text := addzeros('', 10);

  E_Rib.Text := CleRIb(E_Banque.Text, E_Agence.Text, E_Compte.Text, E_Rib.Text);
  E_Cle.Text := CleRip(addzeros(E_Compte.Text, 10));
  StatusBar1.Panels[0].Text := status;
  begin
  end;
  E_Rib.SelectAll;
  E_Rib.CopyToClipboard;
end;  //*********************************************************************
procedure TForm_Ribcal.E_BanqueChange(Sender: TObject);
begin
  Nom_Banque.Clear;
  if FileExists(ExtractFilePath(Application.ExeName) + 'Parametres.ini') then
  begin
    IniFile := TINIFile.create(ExtractFilePath(Application.ExeName) +
      'Parametres.ini');
    Nom_Banque.Text :=
      UpperCase(IniFile.ReadString('Paramètres_Listes des Banaque',
      E_Banque.Text, ''));
    IniFile.Free;
  end;
end;//*********************************************************************
procedure TForm_Ribcal.SB_VSSClick(Sender: TObject);
begin
  // NSScontrole(E_Vérifier_NSS_.Text);
  E_Vérifier_CléSS_.Clear;
  E_Vérifier_CléSS_.Text := IntToStr(NSScontrole(E_Vérifier_NSS_.Text));
  if (E_Vérifier_CléSS_.Text = 'SS') or (StrToInt(E_Vérifier_CléSS_.Text) < 0)
  then
    E_Vérifier_CléSS_.Text := 'ER';
  StatusBar1.Panels[0].Text := status;
end;//*********************************************************************
procedure TForm_Ribcal.SB_VRibClick(Sender: TObject);
var
  Compte: string;
begin
  ControleRib(E_Vérifier_Rib_.Text);
  StatusBar1.Panels[0].Text := status;
  if E_Vérifier_Rib_.Text <> '' then
  begin
    Compte := LeftStr(RightStr(E_Vérifier_Rib_.Text, 12), 10);
    E_CCPv.Text := CleRip(Compte);
  end;
end;//*********************************************************************
procedure TForm_Ribcal.E_CompteExit(Sender: TObject);
begin
  SB_Rib.Click;
end;//*********************************************************************
procedure TForm_Ribcal.E_Vérifier_NSS_Exit(Sender: TObject);
begin
  SB_VSS.Click;
end;//*********************************************************************
procedure TForm_Ribcal.E_Vérifier_Rib_6Exit(Sender: TObject);
begin
  SB_VRib.Click;
end;//*********************************************************************
procedure TForm_Ribcal.E_Vérifier_Rib_Exit(Sender: TObject);
begin
  SB_VRib.Click;
end;//*********************************************************************
procedure TForm_Ribcal.Curr_ImpExit(Sender: TObject);
begin
  Curr_SP.Value := Curr_Imp.Value / 0.91;
  Form_Ribcal.Curr_SPExit(Sender);
  Form_Ribcal.Curr_Net_a_payéExit(Sender);
end;//*********************************************************************
procedure TForm_Ribcal.Curr_Net_a_payéExit(Sender: TObject);
begin
  Curr_zone_I.Value := (Curr_Net_a_payé.Value - Curr_Net_Sans_ifri.Value -
    Curr_zone_II.Value) / 30;
  if Curr_zone_I.Value <= 0 then
    Curr_zone_I.Value := 0;
end;//*********************************************************************
procedure TForm_Ribcal.Curr_SPExit(Sender: TObject);
begin
  Curr_Rss.Value := Curr_SP.Value * 0.09;
  Curr_Imp.Value := Curr_SP.Value * 0.91;
  Curr_Irg.Value := CalcIrg(Curr_Imp.Value, StrToInt(Spin_base.Text));
  Curr_Net_Sans_ifri.Value := Curr_Imp.Value - Curr_Irg.Value;
  Form_Ribcal.Curr_Net_a_payéExit(Sender);
end;//*********************************************************************
procedure TForm_Ribcal.Curr_zone_IIExit(Sender: TObject);
begin
  Form_Ribcal.Curr_SPExit(Sender);
  Form_Ribcal.Curr_Net_a_payéExit(Sender);
end;
    //*********************************************************************
end.
