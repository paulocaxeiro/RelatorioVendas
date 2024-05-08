unit UDMRelatorioVendas;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Datasnap.DBClient,
  Data.FMTBcd, Data.SqlExpr;

type
  TDMRelatorioVendas = class(TDataModule)
    ADOConnVendas: TADOConnection;
    ADOTabVendedores: TADOTable;
    ADOTabVendedoresCOD_VENDED: TIntegerField;
    ADOTabVendedoresNOM_VENDED: TStringField;
    DSVendedores: TDataSource;
    DSListaVendedores: TDataSource;
    DSVendas: TDataSource;
    ADOQryVendas: TADOQuery;
    ADOQryVendasnom_vended: TStringField;
    ADOQryVendasdat_venda: TWideStringField;
    ADOQryVendasval_venda: TFloatField;
    ADOQryVendasval_descon: TFloatField;
    ADOQryVendasval_total: TFloatField;
    ADOQryVendasval_soma_vendas_vended: TFloatField;
    ADOQryVendasvalor_comissao: TFloatField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMRelatorioVendas: TDMRelatorioVendas;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMRelatorioVendas.DataModuleCreate(Sender: TObject);
begin
  AdoConnVendas.Connected := True;
  ADOTabVendedores.Open;
end;

end.
