unit UntRelatorioVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.DBCtrls;

type
  TFrmRelatorioVendas = class(TForm)
    PnlGeralSelecao: TPanel;
    LblEdtDAT_VENDAInicial: TLabel;
    LblEdtDAT_VENDAFinal: TLabel;
    LblCbxVENDEDOR: TLabel;
    EdtDAT_VENDAInicial: TMaskEdit;
    EdtDAT_VENDAFinal: TMaskEdit;
    RdgOpcao: TRadioGroup;
    SbxControleBotoes: TScrollBox;
    PnlControleBotoesAuxiliar: TPanel;
    PnlControleBotoesTbrControle: TPanel;
    TbrControle: TToolBar;
    BtnSair: TToolButton;
    TbrControleExtended: TToolBar;
    BtnInicializar: TToolButton;
    BtnImprimir: TToolButton;
    CkbExibirsemVendas: TCheckBox;
    DBLVendedores: TDBLookupComboBox;
    procedure RdgOpcaoClick(Sender: TObject);
    procedure BtnImprimirClick(Sender: TObject);
    procedure BtnInicializarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnSairClick(Sender: TObject);
  private
    { Private declarations }
    function MontaSQL:string;
    procedure ControleTela;
    procedure LimparCampos;
    procedure ValidarDatas;
  public
    { Public declarations }
  end;

var
  FrmRelatorioVendas: TFrmRelatorioVendas;

implementation

uses UDmRelatorioVendas, Data.db, System.DateUtils;

{$R *.dfm}

{  Olá pessoal,
   segue o teste prático, conforme foi orientado.

   Algumas observações e premissas importantes:

   - Fiz esse teste no meu computador pessoal, onde tenho o Delphi 12 Trial instalado somente.
     COmo nessa versão do Delphi não há componentes de relatório nativos, e não consegui baixar versões
     compatíveis do QuickReport, FastReport e etc, Estou desenvolvendo o relatório em CSV.
     Longe do ideal sim, e também não era o que foi solicitado, mas tomei essa decisao devido as limitações.
     Procurei seguir todos os outras solicitações, de agrupamento por vendedor e critério de pesquisa. Espero
     que não seja de todo perdido.

   - As versões utilizadas foram Delphi 12.1, e SQL Server Management Studio 20. No arquivo Readme anexo,
     passo as configurações, e também em anexo, os scripts de configuraçõo das tabelas.

   - Não utilizei padrões de projeto, apenas centralizei os componentes de dados no data módulo DMRelatorioVendas
     e nesse form as regras de negócio.

     Obrigado pela oportunidade e espero trabalharmos juntos!


 }

procedure TFrmRelatorioVendas.BtnImprimirClick(Sender: TObject);
var
  Stream: TFileStream;
  i: Integer;
  OutLine: string;
  sTemp: string;
  sTempNomeVendedor,
  sTempValorTotal,
  sTempValorComissao,
  sTotalVendedor,
  sTotalComissao, Stitulo: String;
begin

  STitulo := 'Nome Vendedor; Data Venda; Valor Venda; Valor Desconto; Valor FInal Venda';
  sTempNomeVendedor := '';
  sTempValorTotal   := '';
  sTempValorComissao := '';

  //valida se datas estão preenchidas e preenchidas corretamente
  ValidarDatas;

  //se a opção foi por exibir as informações de um vendedor específico, valida se foi selecionado
  if VarisNull(DblVendedores.KeyValue) and  (RdgOpcao.ItemIndex = 1) then
    raise Exception.Create('è necessário selecionar o vendedor');


  With DmRelatorioVendas.ADOqryVendas do
  begin
        Close;
        Sql.Clear;
        Sql.Add(MontaSQL);

        {Aqui seria a boa prática para passar os parâmetro de data para a query, porém, como comentei abaixo,
         não deu erro, mas tambpem não trouxe nada. A sintaxe está correta. Decidi fazer da outra forma,
         mas deixo registrado que o correto seria conforme abaixo}

        //Parameters.ParamByName('DAT_VENDA_INICIAL').Value := Strtodate(Edtdat_vendaInicial.Text);
        //Parameters.ParamByName('DAT_VENDA_FINAL').Value := Strtodate(Edtdat_vendaInicial.Text);

        //abre a query com a consulta montada,e posiciona no primeiro registro.
        Open;
        First;

        if RecordCOunt > 0 then
        begin
          Stream := TFileStream.Create('Relatorio.csv', fmCreate) ;


          SetLength(sTitulo, Length(sTitulo));

          Stream.Write(sTitulo[1], Length(sTitulo) * SizeOf(Char));

          Stream.Write(sLineBreak, Length(sLineBreak));



          sTempNomeVendedor := FieldbyName('NOM_VENDED').AsString;
          sTempValorTotal   := FieldbyName('val_soma_vendas_vended').AsString;
          sTempValorComissao := FieldbyName('valor_comissao').AsString;
          sTotalVendedor:= 'Total Venda ' +  sTempNomeVendedor + ' ' + sTempValorTotal;
          sTotalComissao := 'Total Comissão ' +   sTempNomeVendedor + ' ' + sTempValorComissao;

          while not Eof do
          begin
            try

              if  sTempNomeVendedor <> FieldbyName('NOM_VENDED').AsString then
              begin

                SetLength(sTotalVendedor, Length(sTotalVendedor));

                Stream.Write(sTotalVendedor[1], Length(sTotalVendedor) * SizeOf(Char));

                Stream.Write(sLineBreak, Length(sLineBreak));

                SetLength(sTotalCOmissao, Length(sTotalComissao));
                Stream.Write(sTotalCOmissao[1], Length(sTotalCOmissao) * SizeOf(Char));

                //quebra de linha para agrupar vendedores
                Stream.Write(sLineBreak, Length(sLineBreak));
                Stream.Write(sLineBreak, Length(sLineBreak));

                sTempNomeVendedor := FieldbyName('NOM_VENDED').AsString;
                sTempValorTotal   := FieldbyName('val_soma_vendas_vended').AsString;


                sTempValorComissao := FieldbyName('valor_comissao').AsString;

                sTotalVendedor:= 'Total Venda ' +  sTempNomeVendedor + ' ' + sTempValorTotal;
                sTotalComissao := 'Total Comissão ' +   sTempNomeVendedor + ' ' + sTempValorComissao;



              end;


              OutLine := '';
              for i := 0 to FieldCount - 3 do
              begin
                sTemp := Fields[i].AsString;

                OutLine := OutLine + sTemp + ',';
              end;

              SetLength(OutLine, Length(OutLine) - 1);

              Stream.Write(OutLine[1], Length(OutLine) * SizeOf(Char));

              Stream.Write(sLineBreak, Length(sLineBreak));
              Next;

            finally
             // Stream.Free;
            end;

          end;

          SetLength(sTotalVendedor, Length(sTotalVendedor));
          Stream.Write(sTotalVendedor[1], Length(sTotalVendedor) * SizeOf(Char));
          Stream.Write(sLineBreak, Length(sLineBreak));

          SetLength(sTotalCOmissao, Length(sTotalComissao));
          Stream.Write(sTotalCOmissao[1], Length(sTotalCOmissao) * SizeOf(Char));
          Stream.Write(sLineBreak, Length(sLineBreak));

          Stream.Free;

          Showmessage('Arquivo Relatorio.csv gerado com sucesso');
       end
       else    //se não encontrou nada na tabela, exibe a mensagem
          Showmessage('Nenhum registro encontrado');
  end;


end;

procedure TFrmRelatorioVendas.BtnInicializarClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TFrmRelatorioVendas.BtnSairClick(Sender: TObject);
begin
  CLose;
end;

procedure TFrmRelatorioVendas.ControleTela;
begin
  //se a opção for por um vendedor específico, habilita o combo de lista de vendedores
  if (RdgOpcao.ItemIndex = 1) then
  begin
    DBLVendedores.Enabled := True;
    DBLVendedores.Color := clWhite;
  end
  else
  begin
    DBLVendedores.Enabled := False;
    DBLVendedores.Color := clBtnFace;
  end;
end;


procedure TFrmRelatorioVendas.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(DMRelatorioVendas);
end;

procedure TFrmRelatorioVendas.LimparCampos;
begin
  //limpa os campos, para nova pesquisa
  EdtDAT_VENDAInicial.Clear;
  EdtDAT_VENDAFinal.Clear;
  RdgOpcao.ItemIndex := 0;
  CKBExibirsemvendas.Checked := False;
end;

//FUnção que retorna para a query no datamodule, a consulta de vendas,
//dependendo dos filtros

function TFrmRelatorioVendas.MontaSQL: string;
begin
  Result :=
   '   select tmpv.nom_vended,            ' + #13 +
   '          format(dat_venda, ''dd/mm/yyyy'') as dat_venda,     ' + #13 +
   '          isnull(round(val_venda,2), 0) as val_venda,    ' + #13 +
   '          isnull(val_descon,0) as val_descon,  ' + #13 +
   '          isnull(val_total,0) as val_total,    ' + #13 +
   '          isnull(vsom.val_soma_vendas_vended,0) as val_soma_vendas_vended,          ' + #13 +
   '          round(isnull(vsom.val_soma_vendas_vended,0)*0.10,2) as valor_comissao '  + #13 +
   '       from tab_vendedores tmpv            ' + #13 +
   '       left join                          ' + #13 +
   '       (select vdd.cod_vended,            ' + #13 +
   '                 nom_vended,                ' + #13 +
   '                 val_venda,                 ' + #13 +
   '                 val_total,                 ' + #13 +
   '                 val_descon,                ' + #13 +
   '                 dat_venda,                 ' + #13 +
   '                 cod_venda                  ' + #13 +
   '            from tab_vendedores vdd          ' + #13 +
   '           join tab_vendas ven on ven.cod_vended = vdd.cod_vended    ' + #13 +

   //aqui,como logo abaixo, o correto seria passar os parâmetros de data utilizando o params da query (aparambyname,
   //estou fazendo dessa forma porque não consegui descobrir o porque, utilizei parambyname e
   //ele não funcionou e também não deu erro, só funcionou dessa forma.


   '           WHERE dat_venda >= ''' + edtDat_vendainicial.Text + ''''    + #13 +
   '             AND dat_venda <= ''' + edtDat_vendafinal.text + '''';
   if RdgOpcao.ItemIndex = 1 then
     Result := Result + ' and ven.cod_vended = ' + VartoStr(DblVendedores.KeyValue);

   Result := Result +  ' ) tmp on tmp.cod_vended = tmpv.cod_vended ' ;

   IF CKBExibirsemvendas.Checked then
     Result := REsult + ' left join      '
   else
     Result := REsult + ' inner join      '  ;

   //aqui,como logo abaixo, o correto seria passar os parâmetros de data utilizando o params da query (aparambyname,
   //estou fazendo dessa forma porque não consegui descobrir o porque, utilizei parambyname e
   //ele não funcionou e também não deu erro, só funcionou dessa forma.
   Result := Result +
             '(select cod_vended, isnull(sum(val_total),0) as val_soma_vendas_vended      ' + #13 +
             '  from tab_vendas vrns2                             ' + #13 +
             '           WHERE dat_venda >= ''' + edtDat_vendainicial.Text + ''''    + #13 +
             '             AND dat_venda <= ''' + edtDat_vendafinal.text + '''';

   //se optar por mostrar um vendedor em específico, passa o parâmetro escolhido no dblookupcombobox
   if RdgOpcao.ItemIndex = 1 then
     Result := Result + ' AND vrns2.cod_vended = ' + VartoStr(DblVendedores.KeyValue);

   Result := Result +
     '    group by cod_vended)  vsom                  ' + #13 +
     '    on vsom.cod_vended = tmp.cod_vended     ' + #13 +
     'group by  tmpv.cod_vended,                  ' + #13 +
     '          tmpv.nom_vended,                  ' + #13 +
     '          tmp.dat_venda,                    ' + #13 +
     '          tmp.val_venda,                    ' + #13 +
     '          val_descon,                       ' + #13 +
     '          val_total,                         ' + #13 +
     '          vsom.val_soma_vendas_vended  ';


end;



procedure TFrmRelatorioVendas.RdgOpcaoClick(Sender: TObject);
begin
  ControleTela;
end;

procedure TFrmRelatorioVendas.ValidarDatas;
 var
 dDataInicial, dDataFinal: TDate;
 dDateDiff: Integer;
begin

  if Trim(EdtDat_vendainicial.Text) = '/  /' then
  begin
    raise Exception.Create('Data inicial não pode ser nula');
  end;

  if Trim(EdtDat_vendafinal.Text) = '/  /' then
  begin
    raise Exception.Create('Data final não pode ser nula');
  end;

   dDataInicial := StrToDate(EdtDat_vendainicial.Text);
   dDataFInal := StrToDate(EdtDat_vendaFinal.Text);

   dDateDiff := CompareDate(dDataInicial, dDataFInal);

   if dDateDiff = 1 then
    raise Exception.Create('A Data final não pode ser menor que a data inicial');


  try

      StrToDate(EdtDat_vendainicial.Text);
    except

    on EConvertError do

      raise Exception.Create('Data Inicial Inválida!');

    end;


    try

      StrToDate(EdtDat_vendaFinal.Text);
    except

    on EConvertError do

      raise Exception.Create ('Data Final Inválida!');

    end;
  end;

end.
