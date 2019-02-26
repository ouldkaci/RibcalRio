
  program Ribcal;

uses
  Vcl.Forms, inifiles,SysUtils, Windows,
  Dialogs,
  Unit_Ribcal in 'Unit_Ribcal.pas' {Form_Ribcal} ,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}
var IniFi: TINIFile;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //TStyleManager.TrySetStyle('Windows10 Green');
  // TStyleManager.TrySetStyle('Stylename');
    IniFi := TINIFile.create(ExtractFilePath(Application.ExeName) +
      'Parametres.ini');
    try
      with IniFi do
      begin
        TStyleManager.TrySetStyle(ReadString('StyleMan','Styl',
          TStyleManager.ActiveStyle.Name));
      end;
    finally
      IniFi.Free;
    end;
    // TStyleManager.TrySetStyle('Stylename');

  Application.CreateForm(TForm_Ribcal, Form_Ribcal);
  Application.Run;
end.
