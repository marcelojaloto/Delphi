{******************************************************************************}
{                                                                              }
{  Jaloto Buscador de CEP e Endere�os de Localidade do Brasil                  }
{  Copyright (c) 2024 Marcelo Jaloto                                           }
{  https://github.com/marcelojaloto/Delphi/tree/master/samples/cep             }
{  https://www.linkedin.com/in/marcelojaloto                                   }
{                                                                              }
{******************************************************************************}
{                                                                              }
{ Licenciado sob a Licen�a Apache, Vers�o 2.0 (a "Licen�a");                   }
{ voc� n�o pode usar este arquivo, exceto em conformidade com a Licen�a.       }
{ Voc� pode obter uma c�pia da Licen�a em                                      }
{                                                                              }
{ http://www.apache.org/licenses/LICENSE-2.0                                   }
{                                                                              }
{ A menos que exigido pela lei aplic�vel ou acordado por escrito, o software   }
{ distribu�do sob a Licen�a � distribu�do "NO ESTADO EM QUE SE ENCONTRA",      }
{ SEM GARANTIAS OU CONDI��ES DE QUALQUER TIPO, expressas ou impl�citas.        }
{ Consulte a Licen�a para obter o idioma espec�fico que rege as permiss�es e   }
{ limita��es sob a Licen�a.                                                    }
{                                                                              }
{******************************************************************************}
unit Jaloto.CEP.DadosOnlineXml;

interface

uses
  System.Classes,
  Xml.XMLIntf,

  Jaloto.CEP.Dados,
  Jaloto.CEP.Interfaces,
  Jaloto.CEP.ViaCEP,
  Jaloto.CEP.DadosOnline;

type

  TDadosOnlineXmlCEP = class(TDadosOnlineCEP)
  strict private
    function DesserializarXmlParaDados(const pNode: IXMLNode): TDadosCEP;
  strict protected
    function ProcessarDadosDeResposta(const pDadosResposta: String): Boolean; override;
    function ProcessarListaDeDadosDeResposta(const pListaDadosResposta: String): Boolean; override;
  public
    constructor Create; override;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  Xml.XMLDoc,


  Jaloto.CEP.Comum;

{ TDadosOnlineXmlCEP }

constructor TDadosOnlineXmlCEP.Create;
begin
  inherited Create;
  fViaCEP.ModoFormatoResposta := mfXML;
end;

function TDadosOnlineXmlCEP.DesserializarXmlParaDados(const pNode: IXMLNode): TDadosCEP;
begin
  Result := TDadosCEP.Create;

  Result.CEP := pNode.ChildNodes['cep'].Text;
  Result.Logradouro := pNode.ChildNodes['logradouro'].Text;
  Result.Complemento := pNode.ChildNodes['complemento'].Text;
  Result.Bairro := pNode.ChildNodes['bairro'].Text;
  Result.Localidade := pNode.ChildNodes['localidade'].Text;
  Result.UF := pNode.ChildNodes['uf'].Text;
  Result.Estado := pNode.ChildNodes['estado'].Text;
end;

function TDadosOnlineXmlCEP.ProcessarDadosDeResposta(const pDadosResposta: String): Boolean;
begin
  Result := inherited ProcessarDadosDeResposta(pDadosResposta);

  // No XML quando ocorre um erro a regra de neg�cio do ViaCEP retorna a resposta com o texto "true"
  if SameText(pDadosResposta, 'true') then
    Result := FALSE;

  if not Result then
    Exit;

  Result := ProcessarResposta(
    function: Boolean
    begin
      var vXMLDoc: IXMLDocument := LoadXMLData(pDadosResposta);
      if not Assigned(vXMLDoc) then
        Exit(FALSE);

      var vDados := DesserializarXmlParaDados(vXMLDoc.DocumentElement);
      fListaDados.Add(vDados);
      Result := TRUE;
    end);

end;

function TDadosOnlineXmlCEP.ProcessarListaDeDadosDeResposta(const pListaDadosResposta: String): Boolean;
begin
  Result := inherited ProcessarListaDeDadosDeResposta(pListaDadosResposta);
  if not Result then
    Exit;

  Result := ProcessarResposta(
    function: Boolean
    begin
      var vXMLDoc: IXMLDocument := LoadXMLData(pListaDadosResposta);
      if not Assigned(vXMLDoc) then
        Exit(FALSE);

      var vEnderecos := vXMLDoc.DocumentElement.ChildNodes.FindNode('enderecos').ChildNodes;
      for var vNodeIndex := 0 to vEnderecos.Count - 1 do
      begin
        var vItem := vEnderecos[vNodeIndex];
        var vDados := DesserializarXmlParaDados(vItem);
        fListaDados.Add(vDados);
      end;

      Result := TRUE;
    end);
end;

end.
