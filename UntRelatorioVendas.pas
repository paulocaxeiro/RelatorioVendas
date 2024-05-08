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

{  Ol� pessoal,
   segue o teste pr�tico, conforme foi orientado.

   Algumas observa��es e premissas importantes:

   - Fiz esse teste no meu computador pessoal, onde tenho o Delphi 12 Trial instalado somente.
     COmo nessa vers�o do Delphi n�o h� componentes de relat�rio nativos, e n�o consegui baixar vers�es
     compat�veis do QuickReport, FastReport e etc, Estou desenvolvendo o relat�rio em CSV.
     Longe do ideal sim, e tamb�m n�o era o que foi solicitado, mas tomei essa decisao devido as limita��es.
     Procurei seguir todos os outras solicita��es, de agrupamento por vendedor e crit�rio de pesquisa. Espero
     que n�o seja de todo perdido.

   - As vers�es utilizadas foram Delphi 12.1, e SQL Server Management Studio 20. No arquivo Readme anexo,
     passo as configura��es, e tamb�m em anexo, os scripts de configura��o das tabelas.

   - N�o utilizei padr�es de projeto, apenas centralizei os componentes de dados no data m�dulo DMRelatorioVendas
     e nesse form as regras de neg�cio.

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

  //valida se datas est�o preenchidas e preenchidas corretamente
  ValidarDatas;

  //se a op��o foi por exibir as informa��es de um vendedor espec�fico, valida se foi selecionado
  if VarisNull(DblVendedores.KeyValue) and  (RdgOpcao.ItemIndex = 1) then
    raise Exception.Create('� necess�rio selecionar o vendedor');


  With DmRelatorioVendas.ADOqryVendas do
  begin
        Close;
        Sql.Clear;
        Sql.Add(MontaSQL);

        {Aqui seria a boa pr�tica para passar os par�metro de data para a query, por�m, como comentei abaixo,
         n�o deu erro, mas tambpem n�o trouxe nada. A sintaxe est� correta. Decidi fazer da outra forma,
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
          sTotalComissao := 'Total Comiss�o ' +   sTempNomeVendedor + ' ' + sTempValorComissao;

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
                sTotalComissao := 'Total Comiss�o ' +   sTempNomeVendedor + ' ' + sTempValorComissao;



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
       else    //se n�o encontrou nada na tabela, exibe a mensagem
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
  //se a op��o for por um vendedor espec�fico, habilita o combo de lista de vendedores
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

//FUn��o que retorna para a query no datamodule, a consulta de vendas,
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

   //aqui,como logo abaixo, o correto seria passar os par�metros de data utilizando o params da query (aparambyname,
   //estou fazendo dessa forma porque n�o consegui descobrir o porque, utilizei parambyname e
   //ele n�o funcionou e tamb�m n�o deu erro, s� funcionou dessa forma.


   '           WHERE dat_venda >= ''' + edtDat_vendainicial.Text + ''''    + #13 +
   '             AND dat_venda <= ''' + edtDat_vendafinal.text + '''';
   if RdgOpcao.ItemIndex = 1 then
     Result := Result + ' and ven.cod_vended = ' + VartoStr(DblVendedores.KeyValue);

   Result := Result +  ' ) tmp on tmp.cod_vended = tmpv.cod_vended ' ;

   IF CKBExibirsemvendas.Checked then
     Result := REsult + ' left join      '
   else
     Result := REsult + ' inner join      '  ;

   //aqui,como logo abaixo, o correto seria passar os par�metros de data utilizando o params da query (aparambyname,
   //estou fazendo dessa forma porque n�o consegui descobrir o porque, utilizei parambyname e
   //ele n�o funcionou e tamb�m n�o deu erro, s� funcionou dessa forma.
   Result := Result +
             '(select cod_vended, isnull(sum(val_total),0) as val_soma_vendas_vended      ' + #13 +
             '  from tab_vendas vrns2                             ' + #13 +
             '           WHERE dat_venda >= ''' + edtDat_vendainicial.Text + ''''    + #13 +
             '             AND dat_venda <= ''' + edtDat_vendafinal.text + '''';

   //se optar por mostrar um vendedor em espec�fico, passa o par�metro escolhido no dblookupcombobox
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
    raise Exception.Create('Data inicial n�o pode ser nula');
  end;

  if Trim(EdtDat_vendafinal.Text) = '/  /' then
  begin
    raise Exception.Create('Data final n�o pode ser nula');
  end;

   dDataInicial := StrToDate(EdtDat_vendainicial.Text);
   dDataFInal := StrToDate(EdtDat_vendaFinal.Text);

   dDateDiff := CompareDate(dDataInicial, dDataFInal);

   if dDateDiff = 1 then
    raise Exception.Create('A Data final n�o pode ser menor que a data inicial');


  try

      StrToDate(EdtDat_vendainicial.Text);
    except

    on EConvertError do

      raise Exception.Create('Data Inicial Inv�lida!');

    end;


    try

      StrToDate(EdtDat_vendaFinal.Text);
    except

    on EConvertError do

      raise Exception.Create ('Data Final Inv�lida!');

    end;
  end;

end.
