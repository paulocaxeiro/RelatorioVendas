object FrmRelatorioVendas: TFrmRelatorioVendas
  Left = 0
  Top = 0
  Caption = 'Relat'#243'rio de vendas'
  ClientHeight = 343
  ClientWidth = 721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 15
  object PnlGeralSelecao: TPanel
    Left = 0
    Top = 0
    Width = 721
    Height = 343
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    ExplicitWidth = 719
    ExplicitHeight = 335
    object LblEdtDAT_VENDAInicial: TLabel
      Left = 18
      Top = 47
      Width = 59
      Height = 15
      Alignment = taRightJustify
      Caption = 'Data Venda'
    end
    object LblEdtDAT_VENDAFinal: TLabel
      Left = 184
      Top = 46
      Width = 16
      Height = 15
      Alignment = taRightJustify
      Caption = 'at'#233
    end
    object LblCbxVENDEDOR: TLabel
      Left = 27
      Top = 80
      Width = 50
      Height = 15
      Alignment = taRightJustify
      Caption = 'Vendedor'
    end
    object EdtDAT_VENDAInicial: TMaskEdit
      Left = 99
      Top = 39
      Width = 66
      Height = 23
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
    end
    object EdtDAT_VENDAFinal: TMaskEdit
      Left = 230
      Top = 39
      Width = 69
      Height = 23
      EditMask = '!99/99/9999;1; '
      MaxLength = 10
      TabOrder = 2
      Text = '  /  /    '
    end
    object RdgOpcao: TRadioGroup
      Left = 14
      Top = 113
      Width = 435
      Height = 91
      Caption = 'Op'#231#245'es de Visualiza'#231#227'o'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Todos os vendedores'
        'Um vendedor espec'#237'fico')
      TabOrder = 0
      OnClick = RdgOpcaoClick
    end
    object SbxControleBotoes: TScrollBox
      Left = 2
      Top = 314
      Width = 717
      Height = 27
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      Align = alBottom
      Anchors = [akLeft, akRight]
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 3
      ExplicitTop = 306
      ExplicitWidth = 715
      object PnlControleBotoesAuxiliar: TPanel
        Left = 717
        Top = 0
        Width = 0
        Height = 27
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 715
      end
      object PnlControleBotoesTbrControle: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 4
        Width = 717
        Height = 23
        Margins.Left = 0
        Margins.Top = 4
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        AutoSize = True
        BevelOuter = bvLowered
        TabOrder = 1
        ExplicitWidth = 715
        object TbrControle: TToolBar
          Left = 1
          Top = 1
          Width = 35
          Height = 21
          Align = alLeft
          AutoSize = True
          ButtonHeight = 21
          ButtonWidth = 31
          List = True
          ShowCaptions = True
          TabOrder = 0
          Wrapable = False
          object BtnSair: TToolButton
            Left = 0
            Top = 0
            AutoSize = True
            Caption = '&Sair'
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            OnClick = BtnSairClick
          end
        end
        object TbrControleExtended: TToolBar
          Left = 36
          Top = 1
          Width = 680
          Height = 21
          Align = alClient
          AutoSize = True
          ButtonHeight = 21
          ButtonWidth = 64
          Caption = 'TbrControleExtended'
          List = True
          ShowCaptions = True
          TabOrder = 1
          ExplicitWidth = 678
          object BtnInicializar: TToolButton
            Left = 0
            Top = 0
            Hint = 'Inicializa o m'#243'dulo com os parametros originais'
            AutoSize = True
            Caption = 'Iniciali&zar'
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            OnClick = BtnInicializarClick
          end
          object BtnImprimir: TToolButton
            Left = 65
            Top = 0
            Hint = 'Impress'#227'o do Relat'#243'rio'
            AutoSize = True
            Caption = 'G&erar CSV'
            ImageIndex = 1
            ParentShowHint = False
            ShowHint = True
            OnClick = BtnImprimirClick
          end
        end
      end
    end
    object CkbExibirsemVendas: TCheckBox
      Left = 38
      Top = 210
      Width = 328
      Height = 17
      Caption = 'Exibir tamb'#233'm vendedores sem vendas no per'#237'odo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object DBLVendedores: TDBLookupComboBox
      Left = 99
      Top = 74
      Width = 267
      Height = 23
      BevelInner = bvSpace
      BevelOuter = bvNone
      BevelKind = bkSoft
      Color = clBtnFace
      Enabled = False
      KeyField = 'COD_VENDED'
      ListField = 'NOM_VENDED'
      ListSource = DMRelatorioVendas.DSListaVendedores
      TabOrder = 5
    end
  end
end
