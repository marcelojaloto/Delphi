inherited fmTasks: TfmTasks
  Caption = 'Gerenciador de Tarefas'
  ClientHeight = 654
  ClientWidth = 944
  ExplicitWidth = 958
  ExplicitHeight = 689
  TextHeight = 15
  object pnList: TPanel [0]
    Left = 0
    Top = 0
    Width = 444
    Height = 635
    Align = alLeft
    TabOrder = 1
    ExplicitHeight = 631
    object pnNavigate: TPanel
      Left = 1
      Top = 1
      Width = 442
      Height = 489
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 485
      DesignSize = (
        442
        489)
      object gdTasksList: TDBGrid
        Left = 1
        Top = 1
        Width = 440
        Height = 487
        Hint = 'Lista de todas as tarefas'
        Align = alClient
        DataSource = dsTasks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clTeal
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = [fsBold]
        OnDrawColumnCell = gdTasksListDrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'title'
            ReadOnly = True
            Title.Caption = 'Tarefas'
            Width = 320
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'status'
            Title.Caption = 'Status'
            Width = 82
            Visible = True
          end>
      end
      object cbStatusGrid: TComboBox
        Left = 338
        Top = 21
        Width = 82
        Height = 23
        Style = csDropDownList
        TabOrder = 1
        Visible = False
        OnChange = cbStatusGridChange
        OnExit = cbStatusGridExit
      end
      object btReload: TButton
        Left = 352
        Top = 459
        Width = 69
        Height = 26
        Hint = 'Recarrega a lista de tarefas e atualiza as estat'#237'sticas.'
        Anchors = [akLeft]
        Caption = '&Recarregar'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btReloadClick
        ExplicitTop = 455
      end
    end
    object pnStatistics: TPanel
      Left = 1
      Top = 490
      Width = 442
      Height = 144
      Align = alBottom
      TabOrder = 1
      ExplicitTop = 486
      object gbStatistics: TGroupBox
        Left = 13
        Top = 6
        Width = 416
        Height = 123
        Caption = 'Estat'#237'sticas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        StyleElements = [seClient, seBorder]
        DesignSize = (
          416
          123)
        object bvAveragePendingValue: TBevel
          Left = 318
          Top = 53
          Width = 83
          Height = 27
        end
        object bvCountDoneLast7daysValue: TBevel
          Left = 318
          Top = 80
          Width = 83
          Height = 27
        end
        object bvCountValue: TBevel
          Left = 318
          Top = 26
          Width = 83
          Height = 27
        end
        object bvCountDoneLast7days: TBevel
          Left = 16
          Top = 80
          Width = 302
          Height = 27
        end
        object bvAveragePending: TBevel
          Left = 16
          Top = 53
          Width = 302
          Height = 27
        end
        object bvCount: TBevel
          Left = 16
          Top = 26
          Width = 302
          Height = 27
        end
        object lbCount: TLabel
          Left = 28
          Top = 32
          Width = 83
          Height = 15
          Caption = 'Total de Tarefas:'
        end
        object lbAveragePending: TLabel
          Left = 28
          Top = 58
          Width = 226
          Height = 15
          Caption = 'M'#233'dia de prioridade das tarefas pendentes:'
        end
        object lbCountDoneLast7days: TLabel
          Left = 28
          Top = 84
          Width = 277
          Height = 15
          Caption = 'Quantidade de tarefas conclu'#237'das nos '#250'ltimos 7 dias:'
        end
        object lbCountValue: TLabel
          Left = 332
          Top = 30
          Width = 56
          Height = 17
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object lbAveragePendingValue: TLabel
          Left = 332
          Top = 57
          Width = 56
          Height = 17
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
        object lbCountDoneLast7daysValue: TLabel
          Left = 332
          Top = 84
          Width = 56
          Height = 17
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          AutoSize = False
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clTeal
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          StyleElements = [seClient, seBorder]
        end
      end
    end
  end
  object pnEdit: TPanel [1]
    Left = 444
    Top = 0
    Width = 500
    Height = 635
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 498
    ExplicitHeight = 631
    object pnTask: TPanel
      Left = 1
      Top = 1
      Width = 498
      Height = 594
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 496
      ExplicitHeight = 590
      DesignSize = (
        498
        594)
      object lbTitle: TLabel
        Left = 13
        Top = 6
        Width = 57
        Height = 15
        Caption = 'Descri'#231#227'o:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object lbNotes: TLabel
        Left = 13
        Top = 105
        Width = 35
        Height = 15
        Caption = 'Notas:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object lbStatus: TLabel
        Left = 15
        Top = 56
        Width = 38
        Height = 15
        Caption = 'Status:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object lbPriority: TLabel
        Left = 111
        Top = 55
        Width = 60
        Height = 15
        Caption = 'Prioridade:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object lbCreatedDate: TLabel
        Left = 207
        Top = 56
        Width = 64
        Height = 15
        Caption = 'Data Criada:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object lbEndDate: TLabel
        Left = 347
        Top = 56
        Width = 82
        Height = 15
        Caption = 'Data Finalizada:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        StyleElements = [seClient, seBorder]
      end
      object edTitle: TEdit
        Left = 13
        Top = 27
        Width = 469
        Height = 23
        Hint = 'Informe a descri'#231#227'o da tarefa'
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 100
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        StyleElements = [seClient, seBorder]
        ExplicitWidth = 467
      end
      object mmNotes: TMemo
        Left = 13
        Top = 126
        Width = 469
        Height = 460
        Hint = 'Descreva as notas sobre a tarefa'
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        MaxLength = 1000
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 4
        StyleElements = [seClient, seBorder]
        ExplicitWidth = 467
        ExplicitHeight = 456
      end
      object cbStatus: TComboBox
        Left = 13
        Top = 76
        Width = 90
        Height = 23
        Hint = 'Informe o status da tarefa'
        Style = csDropDownList
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object cbPriority: TComboBox
        Left = 109
        Top = 76
        Width = 90
        Height = 23
        Hint = 'Informe o grau de prioridade da tarefa'
        Style = csDropDownList
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Items.Strings = (
          'Nenhuma'
          'Baixa'
          'M'#233'dia'
          'Alta'
          'Urgente')
      end
      object edEndDate: TEdit
        Left = 347
        Top = 76
        Width = 136
        Height = 23
        Hint = 
          'Data de quando a tarefa foi finalizada com o status de finaliza'#231 +
          #227'o. Este campo '#233' gerado autom'#225'tico e somente de leitura.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 3
        StyleElements = [seClient, seBorder]
      end
      object edCreatedDate: TEdit
        Left = 205
        Top = 76
        Width = 136
        Height = 23
        Hint = 
          'Data de quando a tarefa foi criada. Este campo '#233' gerado autom'#225'ti' +
          'co e somente de leitura.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 5
        StyleElements = [seClient, seBorder]
      end
    end
    object pnActions: TPanel
      Left = 1
      Top = 595
      Width = 498
      Height = 39
      Align = alBottom
      TabOrder = 0
      ExplicitTop = 591
      ExplicitWidth = 496
      DesignSize = (
        498
        39)
      object btInsert: TButton
        Left = 422
        Top = 7
        Width = 59
        Height = 24
        Hint = 'Ativa o cadastramento de uma nova tarefa'
        Anchors = [akTop, akRight]
        Caption = '&Nova'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btInsertClick
        ExplicitLeft = 420
      end
      object btDelete: TButton
        Left = 72
        Top = 7
        Width = 59
        Height = 24
        Hint = 'Exclui a tarefa que est'#225' sendo visualizada.'
        Caption = '&Excluir'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btDeleteClick
      end
      object btSave: TButton
        Left = 7
        Top = 7
        Width = 59
        Height = 24
        Hint = 
          'Ativa a edi'#231#227'o de uma tarefa. Salva a edi'#231#227'o ou inclus'#227'o de uma ' +
          'tarefa.'
        Caption = 'E&ditar'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btSaveClick
      end
    end
  end
  object sbStatusBar: TStatusBar [2]
    Left = 0
    Top = 635
    Width = 944
    Height = 19
    Panels = <
      item
        Text = 'Marcelo Jaloto'
        Width = 50
      end>
    SimpleText = 'm'
    ExplicitTop = 631
    ExplicitWidth = 942
  end
  object dsTasks: TDataSource [3]
    Left = 177
    Top = 241
  end
end
