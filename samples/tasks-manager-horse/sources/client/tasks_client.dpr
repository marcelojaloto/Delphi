program tasks_client;

uses
  Vcl.Forms,
  Tasks.Client.Form.Main in 'Tasks.Client.Form.Main.pas' {fmTasks},
  Vcl.Themes,
  Vcl.Styles,
  Tasks.Client.View.Task in 'Tasks.Client.View.Task.pas',
  Tasks.Client.View in 'Tasks.Client.View.pas',
  Tasks.Client.Form in 'Tasks.Client.Form.pas' {FormBase},
  Tasks.Client.Core.Token in 'Tasks.Client.Core.Token.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TfmTasks, fmTasks);
  Application.CreateForm(TFormBase, FormBase);
  Application.Run;
end.
