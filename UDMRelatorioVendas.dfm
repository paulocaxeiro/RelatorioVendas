object DMRelatorioVendas: TDMRelatorioVendas
  OnCreate = DataModuleCreate
  Height = 642
  Width = 1218
  PixelsPerInch = 120
  object ADOConnVendas: TADOConnection
    ConnectionString = 
      'Provider=MSOLEDBSQL.1;Integrated Security=SSPI;Persist Security ' +
      'Info=False;User ID="";Initial Catalog=Database_vendas;Data Sourc' +
      'e=PauloCaxeiro;Initial File Name="";Server SPN="";Authentication' +
      '="";Access Token="";'
    LoginPrompt = False
    Provider = 'MSOLEDBSQL.1'
    Left = 504
    Top = 368
  end
  object ADOTabVendedores: TADOTable
    Connection = ADOConnVendas
    CursorType = ctStatic
    TableName = 'TAB_VENDEDORES'
    Left = 664
    Top = 328
    object ADOTabVendedoresCOD_VENDED: TIntegerField
      FieldName = 'COD_VENDED'
    end
    object ADOTabVendedoresNOM_VENDED: TStringField
      FieldName = 'NOM_VENDED'
      Size = 100
    end
  end
  object DSVendedores: TDataSource
    DataSet = ADOTabVendedores
    Left = 672
    Top = 432
  end
  object DSListaVendedores: TDataSource
    DataSet = ADOTabVendedores
    Left = 520
    Top = 480
  end
  object DSVendas: TDataSource
    Left = 416
    Top = 240
  end
  object ADOQryVendas: TADOQuery
    Connection = ADOConnVendas
    CursorType = ctStatic
    DataSource = DSVendas
    Parameters = <>
    Prepared = True
    SQL.Strings = (
      '   select tmpv.nom_vended,            '
      '          format(dat_venda, '#39'dd/MM/yyyy'#39') as dat_venda,     '
      '          isnull(round(val_venda,2), 0) as val_venda,    '
      '          isnull(VAL_DESCON,0) as val_descon,  '
      '          isnull(VAL_TOTAL,0) as val_total,    '
      '          vsom.val_soma_vendas_vended,          '
      
        '          round(val_soma_vendas_vended*0.10,2) as valor_comissao' +
        ' '
      '       from tab_vendedores tmpv            '
      '       left join                          '
      '       (select vdd.cod_vended,            '
      '                 nom_vended,                '
      '                 val_venda,                 '
      '                 val_total,                 '
      '                 val_descon,                '
      '                 dat_venda,                 '
      '                 cod_venda                  '
      '            from TAB_VENDEDORES vdd          '
      
        '           join tab_vendas ven on ven.COD_VENDED = vdd.COD_VENDE' +
        'D    '
      '           WHERE DAT_VENDA >= '#39'22/12/2023'#39
      
        '             AND DAT_VENDA <= '#39'22/12/2024'#39' ) tmp on tmp.cod_vend' +
        'ed = tmpv.COD_VENDED  inner join      (select cod_vended, isnull' +
        '(sum(val_total),0) as val_soma_vendas_vended      '
      '  from tab_vendas vrns2                             '
      '           WHERE DAT_VENDA >= '#39'22/12/2023'#39
      
        '             AND DAT_VENDA <= '#39'22/12/2024'#39'    group by cod_vende' +
        'd)  vsom                  '
      '    on vsom.cod_vended = tmp.COD_VENDED     '
      'GROUP BY tmpv.NOM_VENDED,   '
      '         DAT_VENDA,                  '
      '         VAL_VENDA,                  '
      '         VAL_TOTAL,                  '
      '         VAL_DESCON,                 '
      '         val_soma_vendas_vended      '
      'order by nom_vended,dat_venda ')
    Left = 832
    Top = 240
    object ADOQryVendasnom_vended: TStringField
      FieldName = 'nom_vended'
      Size = 100
    end
    object ADOQryVendasdat_venda: TWideStringField
      FieldName = 'dat_venda'
      ReadOnly = True
      Size = 4000
    end
    object ADOQryVendasval_venda: TFloatField
      FieldName = 'val_venda'
      ReadOnly = True
    end
    object ADOQryVendasval_descon: TFloatField
      FieldName = 'val_descon'
      ReadOnly = True
    end
    object ADOQryVendasval_total: TFloatField
      FieldName = 'val_total'
      ReadOnly = True
    end
    object ADOQryVendasval_soma_vendas_vended: TFloatField
      FieldName = 'val_soma_vendas_vended'
      ReadOnly = True
    end
    object ADOQryVendasvalor_comissao: TFloatField
      FieldName = 'valor_comissao'
      ReadOnly = True
    end
  end
end
