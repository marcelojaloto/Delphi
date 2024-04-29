{*********************************************************************************}
{                                                                                 }
{ Task Manager App                                                                }
{ Copyright (c) 2024 Marcelo Jaloto                                               }
{ https://github.com/marcelojaloto/Delphi/tree/master/samples/tasks-manager-horse }
{                                                                                 }
{*********************************************************************************}
unit Tasks.Client.Form.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Tasks.Client.Form,
  Tasks.Client.View.Task;

type

  TfmTasks = class(TFormBase)
    pnList: TPanel;
    pnEdit: TPanel;
    pnNavigate: TPanel;
    pnTask: TPanel;
    edTitle: TEdit;
    mmNotes: TMemo;
    lbTitle: TLabel;
    lbNotes: TLabel;
    cbStatus: TComboBox;
    cbPriority: TComboBox;
    lbStatus: TLabel;
    lbPriority: TLabel;
    lbCreatedDate: TLabel;
    lbEndDate: TLabel;
    edEndDate: TEdit;
    gdTasksList: TDBGrid;
    dsTasks: TDataSource;
    cbStatusGrid: TComboBox;
    pnStatistics: TPanel;
    gbStatistics: TGroupBox;
    lbCount: TLabel;
    lbAveragePending: TLabel;
    lbCountDoneLast7days: TLabel;
    lbCountValue: TLabel;
    sbStatusBar: TStatusBar;
    pnActions: TPanel;
    btInsert: TButton;
    btDelete: TButton;
    btSave: TButton;
    bvAveragePending: TBevel;
    bvCountDoneLast7days: TBevel;
    bvCount: TBevel;
    bvCountValue: TBevel;
    lbAveragePendingValue: TLabel;
    bvAveragePendingValue: TBevel;
    lbCountDoneLast7daysValue: TLabel;
    bvCountDoneLast7daysValue: TBevel;
    btReload: TButton;
    edCreatedDate: TEdit;

    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure DoTableTasksAfterScroll(DataSet: TDataSet);

    procedure gdTasksListDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cbStatusGridChange(Sender: TObject);
    procedure btReloadClick(Sender: TObject);
    procedure cbStatusGridExit(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);

    procedure btInsertClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
  strict private
    FTaskView: TTaskView;

    procedure AllowFieldsEditing(const Value: Boolean);
    procedure ClearTaskFields;
    procedure ClearScreen;
    procedure PrepareEditing;
    procedure RefreshTaskStatistic;
    procedure CreateNewTask;
    procedure DeleteTask;
    procedure RefreshTasks;
    procedure UpdateTaskStatus;
    procedure SetItemDataToView;
    procedure InsertTask;
    procedure EditTask;
    procedure PopulateStatusItens(Combobox: TComboBox);
  public
    { Public declarations }
  end;

var
  fmTasks: TfmTasks;

implementation

{$R *.dfm}

procedure TfmTasks.FormCreate(Sender: TObject);
begin
  inherited FormCreate(Sender);

  FTaskView := TTaskView.Create;
  FTaskView.OnTableAfterScroll := DoTableTasksAfterScroll;
  FTaskView.BaseURL := 'http://127.0.0.1:9000/api';

  dsTasks.DataSet := FTaskView.Table;

  PopulateStatusItens(cbStatus);
  PopulateStatusItens(cbStatusGrid);

  RefreshTasks;
end;

procedure TfmTasks.FormDestroy(Sender: TObject);
begin
  FTaskView.Free;

  inherited FormDestroy(Sender);
end;

procedure TfmTasks.btDeleteClick(Sender: TObject);
begin
  DeleteTask;
end;

procedure TfmTasks.btInsertClick(Sender: TObject);
begin
  CreateNewTask;
end;

procedure TfmTasks.btReloadClick(Sender: TObject);
begin
  RefreshTasks;
end;

procedure TfmTasks.btSaveClick(Sender: TObject);
begin
  if (FTaskView.Table.State = dsInsert) then
    InsertTask
  else if (FTaskView.Table.State = dsEdit) then
    EditTask
  else
    PrepareEditing;
end;

procedure TfmTasks.cbStatusGridChange(Sender: TObject);
begin
  if not FTaskView.Table.Active then
    Exit;

  FTaskView.Table.Edit;
  FTaskView.Table.FieldByName('status').AsInteger := cbStatusGrid.ItemIndex;
  FTaskView.Table.Post;

  UpdateTaskStatus;
  RefreshTaskStatistic;
end;

procedure TfmTasks.cbStatusGridExit(Sender: TObject);
begin
  cbStatusGrid.Visible := False;
end;

procedure TfmTasks.gdTasksListDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not FTaskView.Table.Active then
    Exit;

  if AnsiSameText(Column.FieldName, 'status') then
  begin
    var valor := TStatusStr[TStatus(FTaskView.Table.FieldByName('status').AsInteger)];
    gdTasksList.Canvas.TextRect(Rect, Rect.Left, Rect.Top, valor);

    if gdFocused in State then
    begin
      cbStatusGrid.ItemIndex := FTaskView.Table.FieldByName('status').AsInteger;
      cbStatusGrid.Left := Rect.Left + gdTasksList.Top + 1;
      cbStatusGrid.Top := Rect.Top + gdTasksList.Top + 1;
      cbStatusGrid.Width := Rect.Width;
      cbStatusGrid.Color := gdTasksList.Color;
      cbStatusGrid.Visible := True;
      cbStatusGrid.SetFocus;
    end;
  end;
end;

procedure TfmTasks.DeleteTask;
begin
  if FTaskView.Delete then
    RefreshTaskStatistic;
end;

procedure TfmTasks.DoTableTasksAfterScroll(DataSet: TDataSet);
begin
  if DataSet.isEmpty or (DataSet.state <> dsBrowse) then
    Exit;

  AllowFieldsEditing(False);

  edTitle.Text := FTaskView.Title;
  cbStatus.ItemIndex := Ord(FTaskView.Status);
  cbPriority.ItemIndex := Ord(FTaskView.Priority);
  mmNotes.Text := FTaskView.Notes;
  edCreatedDate.Text := FTaskView.CreatedDateStr;
  edEndDate.Text := FTaskView.EndDateStr;
end;

procedure TfmTasks.AllowFieldsEditing(const Value: Boolean);
begin
  edTitle.ReadOnly := not Value;
  mmNotes.ReadOnly := not Value;
  cbStatus.Enabled := Value;
  cbPriority.Enabled := Value;

  if Value then
  begin
    edTitle.Font.Color := clWhite;
    mmNotes.Font.Color := clWhite;
    btSave.Caption := '&Salvar';
  end
  else
  begin
    edTitle.Font.Color := clGray;
    mmNotes.Font.Color := clGray;
    btSave.Caption := 'E&ditar';
  end;
end;

procedure TfmTasks.ClearTaskFields;
begin
  edTitle.Text := '';
  cbStatus.ItemIndex := -1;
  cbPriority.ItemIndex := -1;
  edCreatedDate.Text := '';
  edEndDate.Text := '';
  mmNotes.Clear;
end;

procedure TfmTasks.ClearScreen;
begin
  FTaskView.Table.Close;
  cbStatusGrid.Visible := False;
  ClearTaskFields;
  AllowFieldsEditing(False);
end;

procedure TfmTasks.PopulateStatusItens(Combobox: TComboBox);
begin
  Combobox.Items.Clear;
  for var i := Low(TStatus) to High(TStatus) do
    Combobox.Items.Add(TStatusStr[i]);
end;

procedure TfmTasks.PrepareEditing;
begin
  if not FTaskView.HasRecordsInTable then
    Exit;

  AllowFieldsEditing(True);
  FTaskView.Table.Edit;
  edTitle.SetFocus;
end;

procedure TfmTasks.CreateNewTask;
begin
  FTaskView.CreateNewItem;
  ClearTaskFields;
  AllowFieldsEditing(True);
  edTitle.SetFocus;
end;

procedure TfmTasks.RefreshTasks;
begin
  ClearScreen;
  if FTaskView.Refresh then
    RefreshTaskStatistic;
end;

procedure TfmTasks.RefreshTaskStatistic;
begin
  lbCountValue.Caption := FTaskView.Statistic.Count.ToString;
  lbAveragePendingValue.Caption := FormatFloat('#0.0', FTaskView.Statistic.AveragePending);
  lbCountDoneLast7daysValue.Caption := FTaskView.Statistic.CountDoneLast7days.ToString;
end;

procedure TfmTasks.SetItemDataToView;
begin
  FTaskView.Title := edTitle.Text;
  FTaskView.Notes := mmNotes.Text;
  FTaskView.Status := TStatus(cbStatus.ItemIndex);
  FTaskView.Priority := TPriority(cbPriority.ItemIndex);
end;

procedure TfmTasks.UpdateTaskStatus;
begin
  if FTaskView.UpdateStatus then
    RefreshTaskStatistic;
end;

procedure TfmTasks.EditTask;
begin
  SetItemDataToView;
  if not FTaskView.Edit then
    Exit;
  AllowFieldsEditing(False);
  RefreshTaskStatistic;
end;

procedure TfmTasks.InsertTask;
begin
  SetItemDataToView;
  if not FTaskView.Insert then
    Exit;
  AllowFieldsEditing(False);
  RefreshTaskStatistic;
end;



end.
