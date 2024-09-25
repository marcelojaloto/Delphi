{******************************************************************************}
{                                                                              }
{  Jaloto Buscador de CEP e Endereços de Localidade do Brasil                  }
{  Copyright (c) 2024 Marcelo Jaloto                                           }
{  https://github.com/marcelojaloto/Delphi/tree/master/samples/cep             }
{  https://www.linkedin.com/in/marcelojaloto                                   }
{                                                                              }
{******************************************************************************}
{                                                                              }
{ Licenciado sob a Licença Apache, Versão 2.0 (a "Licença");                   }
{ você não pode usar este arquivo, exceto em conformidade com a Licença.       }
{ Você pode obter uma cópia da Licença em                                      }
{                                                                              }
{ http://www.apache.org/licenses/LICENSE-2.0                                   }
{                                                                              }
{ A menos que exigido pela lei aplicável ou acordado por escrito, o software   }
{ distribuído sob a Licença é distribuído "NO ESTADO EM QUE SE ENCONTRA",      }
{ SEM GARANTIAS OU CONDIÇÕES DE QUALQUER TIPO, expressas ou implícitas.        }
{ Consulte a Licença para obter o idioma específico que rege as permissões e   }
{ limitações sob a Licença.                                                    }
{                                                                              }
{******************************************************************************}
unit Jaloto.CEP.View.Buscador;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
  System.Skia,

  Data.DB,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Grid.Style,
  FMX.ListBox,
  FMX.Edit,
  FMX.ScrollBox,
  FMX.Grid,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Skia,
  FMX.DialogService,

  FireDAC.Comp.Client,

  Jaloto.CEP,
  Jaloto.CEP.Controller.Enderecos;

type
  TViewBuscador = class(TForm)
    fGroupCabecalho: TRectangle;
    fLabelTituloLinha1: TLabel;
    fImageSvgLogo: TSkSvg;
    fButtonNovaBusca: TButton;
    fGroupFiltros: TRectangle;
    fGroupFiltroPorCEP: TRectangle;
    fLabelFiltroCEP: TLabel;
    fEditFiltroCEP: TEdit;
    fLabelFiltroPorCEP: TLabel;
    fImageSvgFiltroPorCEP: TSkSvg;
    fGroupFiltroPorEndereco: TRectangle;
    fLabelFiltroLogradouro: TLabel;
    fEditFiltroLogradouro: TEdit;
    fEditFiltroLocalidade: TEdit;
    fLabelFiltroLocalidade: TLabel;
    fOptionsFiltroUF: TComboBox;
    fLabelFiltroUF: TLabel;
    fLabelFiltroPorEndereco: TLabel;
    fImageSvgFiltroPorEndereco: TSkSvg;
    fGroupResultadosBusca: TRectangle;
    fSubGroupResultadosBusca: TRectangle;
    fLabelResultadoCEP: TLabel;
    fEditResultadoCep: TEdit;
    fImageSvgMapa: TSkSvg;
    fImageSvgLocal: TSkSvg;
    fEditResultadoLogradouro: TEdit;
    fLabelResultadoLogradouro: TLabel;
    fEditResultadoComplemento: TEdit;
    fLabelResultadoComplemento: TLabel;
    fEditResultadoBairro: TEdit;
    fLabelResultadoBairro: TLabel;
    fEditResultadoLocalidade: TEdit;
    fLabelResultadoLocalidade: TLabel;
    fLabelResultadoEstado: TLabel;
    fEditResultadoEstado: TEdit;
    fLabelResultadosBusca: TLabel;
    fGroupDadosBancoDados: TRectangle;
    fStyleBook: TStyleBook;
    fLabelTituloLinha2: TLabel;
    fButtonBuscaPorCEP: TButton;
    fImageSvgBuscaPorCEP: TSkSvg;
    fButtonBuscaPorEndereco: TButton;
    fImageSvgBuscaPorEndereco: TSkSvg;
    fGroupModoResposta: TRectangle;
    fLabelModoResposta: TLabel;
    fOptionModoJson: TRadioButton;
    fOptionModoXml: TRadioButton;
    fCEP: TCEP;
    fButtonResultadoSubsequenteCEP: TButton;
    fImageSvgResultadoSubsequenteCEP: TSkSvg;
    fButtonResultadoAntecedenteCEP: TButton;
    fImageSvgResultadoAntecedenteCEP: TSkSvg;
    fSubGroupDadosBancoDados: TRectangle;
    fLabelDadosBancoDados: TLabel;
    fBordaGridEnderecos: TRectangle;
    fGridEnderecos: TGrid;
    fGridColumnCEP: TColumn;
    fGridColumnLogradouro: TColumn;
    fGridColumnComplemento: TColumn;
    fGridColumnBairro: TColumn;
    fGridColumnLocalidade: TColumn;
    fGridColumnUF: TColumn;
    fStatusBar: TStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    procedure fButtonBuscaPorCEPClick(Sender: TObject);
    procedure fButtonBuscaPorEnderecoClick(Sender: TObject);
    procedure fOptionModoJsonChange(Sender: TObject);
    procedure fOptionModoXmlChange(Sender: TObject);
    procedure fButtonNovaBuscaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fButtonResultadoAntecedenteCEPClick(Sender: TObject);
    procedure fButtonResultadoSubsequenteCEPClick(Sender: TObject);
    procedure fGridEnderecosGetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
    procedure FormDestroy(Sender: TObject);
  strict private
    fItemIndexResultado: Integer;
    fDadosEnderecos: TFDMemTable;

    function FormatarCEP(const pCEP: String): String;
    function ExibirMensagemDadosEncontradosNoBancoDeDados(pCEP: String): Boolean;

    procedure LimparTela;
    procedure LimparResultadosDaBusca;
    procedure ProcessarResultadosDaBusca;
    procedure SetarDadosItemResultado;
    procedure ListarEnderecosDoBancoDeDados;
  public
    { Public declarations }
  end;

var
  ViewBuscador: TViewBuscador;

implementation

uses
  System.StrUtils,
  FMX.Platform,

  Jaloto.CEP.Comum,
  Jaloto.CEP.Helper.Grid;

{$R *.fmx}

procedure TViewBuscador.fButtonNovaBuscaClick(Sender: TObject);
begin
  LimparTela;
  fEditFiltroCEP.SetFocus;
end;

procedure TViewBuscador.fOptionModoJsonChange(Sender: TObject);
begin
  fCEP.ModoFormatoResposta := mfJSON;
end;

procedure TViewBuscador.fOptionModoXmlChange(Sender: TObject);
begin
  fCEP.ModoFormatoResposta := mfXML;
end;

function TViewBuscador.FormatarCEP(const pCEP: String): String;
begin
  Result := TStringUtils.ExtrairApenasNumeros(pCEP);
  if Length(Result) = 8 then
    Result := LeftStr(Result, 5) + '-' + RightStr(Result, 3);
end;

procedure TViewBuscador.FormDestroy(Sender: TObject);
begin
  if Assigned(fDadosEnderecos) then
    fDadosEnderecos.Free;
end;

procedure TViewBuscador.FormShow(Sender: TObject);
begin
  ListarEnderecosDoBancoDeDados;
  fEditFiltroCEP.SetFocus;
end;

procedure TViewBuscador.LimparResultadosDaBusca;
begin
  fEditResultadoCep.Text := '';
  fEditResultadoLogradouro.Text := '';
  fEditResultadoComplemento.Text := '';
  fEditResultadoBairro.Text := '';
  fEditResultadoLocalidade.Text := '';
  fEditResultadoEstado.Text := '';

  fCEP.ListaDados.Clear;
end;

procedure TViewBuscador.LimparTela;
begin
  fEditFiltroCEP.Text := '';

  fOptionsFiltroUF.ItemIndex := 0;
  fEditFiltroLocalidade.Text := '';
  fEditFiltroLogradouro.Text := '';

  LimparResultadosDaBusca;
end;

procedure TViewBuscador.ListarEnderecosDoBancoDeDados;
begin
  fGridEnderecos.RowCount := 0;

  if Assigned(fDadosEnderecos) then
  begin
    fDadosEnderecos.Free;
    fDadosEnderecos := nil;
  end;

  fDadosEnderecos := TEnderecosController.ListarTodosEnderecosDoBancoDados;
  if not Assigned(fDadosEnderecos) then
    Exit;

  fGridEnderecos.BeginUpdate;
  try
    fGridEnderecos.RowCount := fDadosEnderecos.RecordCount;
  finally
    fGridEnderecos.EndUpdate;
  end;
end;

procedure TViewBuscador.SetarDadosItemResultado;
begin
  if fCEP.ListaDados.Count = 0 then
    Exit;

  fEditResultadoCep.Text := fCEP.ListaDados.Items[fItemIndexResultado].CEP;
  fEditResultadoLogradouro.Text := fCEP.ListaDados.Items[fItemIndexResultado].Logradouro;
  fEditResultadoComplemento.Text := fCEP.ListaDados.Items[fItemIndexResultado].Complemento;
  fEditResultadoBairro.Text := fCEP.ListaDados.Items[fItemIndexResultado].Bairro;
  fEditResultadoLocalidade.Text := fCEP.ListaDados.Items[fItemIndexResultado].Localidade;
  fEditResultadoEstado.Text := fCEP.ListaDados.Items[fItemIndexResultado].Estado;
end;

procedure TViewBuscador.ProcessarResultadosDaBusca;
begin
  fItemIndexResultado := 0;

  if fCEP.ListaDados.Count = 0 then
  begin
    LimparResultadosDaBusca;
    TDialogService.ShowMessage('Nenhum endereço foi encontrado na busca.');
    Exit;
  end;

  SetarDadosItemResultado;

  TEnderecosController.SalvarEmLoteNoBancoDados(fCEP.ListaDados);
  ListarEnderecosDoBancoDeDados;
end;

function TViewBuscador.ExibirMensagemDadosEncontradosNoBancoDeDados(pCEP: String): Boolean;
begin
  pCEP := FormatarCEP(pCEP);
  fGridEnderecos.FindRowByCol(0, pCEP);

  var vOpcaoResposta: TModalResult := mrNo;
  TDialogService.MessageDialog(
    Format('O CEP %s foi encontrado no banco de dados.', [pCEP]) + #13#10 +
           'Deseja atualizá-lo com dados do cadastro nacional de CEP?',
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbYes,
    0,
    procedure(const pResult: TModalResult)
    begin
      vOpcaoResposta := pResult;
    end);

  Result := (vOpcaoResposta = mrYes);
end;

procedure TViewBuscador.fButtonBuscaPorCEPClick(Sender: TObject);
begin
  if TEnderecosController.ChecarSeExisteCEPnoBancoDados(fEditFiltroCEP.Text.Trim) then
  begin
    if not ExibirMensagemDadosEncontradosNoBancoDeDados(fEditFiltroCEP.Text) then
      Exit;
  end;

  fCEP.BuscarDadosPorCEP(fEditFiltroCEP.Text.Trim);
  ProcessarResultadosDaBusca;
end;

procedure TViewBuscador.fButtonBuscaPorEnderecoClick(Sender: TObject);
begin
  var vResultadoAmostraCEP: String;
  if TEnderecosController.ChecarSeExisteEnderecoNoBancoDados(
    fOptionsFiltroUF.Text,
    fEditFiltroLocalidade.Text,
    fEditFiltroLogradouro.Text,
    vResultadoAmostraCEP) then
  begin
    if not ExibirMensagemDadosEncontradosNoBancoDeDados(vResultadoAmostraCEP) then
      Exit;
  end;

  fCEP.BuscarDadosPorEndereco(fOptionsFiltroUF.Text, fEditFiltroLocalidade.Text, fEditFiltroLogradouro.Text);
  ProcessarResultadosDaBusca;
end;

procedure TViewBuscador.fButtonResultadoAntecedenteCEPClick(Sender: TObject);
begin
  if (fItemIndexResultado = 0) then
    Exit;
  Dec(fItemIndexResultado);
  SetarDadosItemResultado;
end;

procedure TViewBuscador.fButtonResultadoSubsequenteCEPClick(Sender: TObject);
begin
  if (fCEP.ListaDados.Count = fItemIndexResultado+1) then
    Exit;
  Inc(fItemIndexResultado);
  SetarDadosItemResultado;
end;

procedure TViewBuscador.fGridEnderecosGetValue(Sender: TObject; const ACol,
  ARow: Integer; var Value: TValue);
begin
  if not Assigned(fDadosEnderecos) or not fDadosEnderecos.Active or fDadosEnderecos.IsEmpty then
    Exit;

  // Posiciona o cursor atual do fDadosEnderecos
  fDadosEnderecos.RecNo := ARow + 1;

  case ACol of
    0: Value := FormatarCEP(fDadosEnderecos.FieldByName('CEP').AsString);
    1: Value := fDadosEnderecos.FieldByName('Logradouro').AsString;
    2: Value := fDadosEnderecos.FieldByName('Complemento').AsString;
    3: Value := fDadosEnderecos.FieldByName('Bairro').AsString;
    4: Value := fDadosEnderecos.FieldByName('Localidade').AsString;
    5: Value := fDadosEnderecos.FieldByName('UF').AsString;
  end;
end;

end.
