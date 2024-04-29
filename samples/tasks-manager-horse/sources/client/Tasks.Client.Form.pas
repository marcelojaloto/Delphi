{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Client.Form;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs;

type
  TFormBase = class(TForm)
    bhHint: TBalloonHint;
    procedure FormCreate(Sender: TObject); virtual;
    procedure FormDestroy(Sender: TObject); virtual;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBase: TFormBase;

implementation

{$R *.dfm}

procedure TFormBase.FormCreate(Sender: TObject);
begin
  //
end;

procedure TFormBase.FormDestroy(Sender: TObject);
begin
  //
end;

end.
