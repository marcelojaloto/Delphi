program JalotoBuscadorCEP;

uses
  System.StartUpCopy,
  MidasLib,
  FMX.Forms,
  Jaloto.CEP.View.Buscador in 'Jaloto.CEP.View.Buscador.pas' {ViewBuscador},
  Jaloto.CEP.Controller in 'Jaloto.CEP.Controller.pas',
  Jaloto.CEP.Model in 'Jaloto.CEP.Model.pas',
  Jaloto.CEP.BancoDados in 'Jaloto.CEP.BancoDados.pas',
  Jaloto.CEP.DAO.Enderecos in 'Jaloto.CEP.DAO.Enderecos.pas',
  Jaloto.CEP.Model.Enderecos in 'Jaloto.CEP.Model.Enderecos.pas',
  Jaloto.CEP.Controller.Enderecos in 'Jaloto.CEP.Controller.Enderecos.pas',
  Jaloto.CEP.Helper.Grid in 'Jaloto.CEP.Helper.Grid.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TViewBuscador, ViewBuscador);
  Application.Run;
end.
