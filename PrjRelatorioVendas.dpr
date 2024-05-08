program PrjRelatorioVendas;

uses
  Vcl.Forms,
  UntRelatorioVendas in 'UntRelatorioVendas.pas' {FrmRelatorioVendas},
  UDMRelatorioVendas in 'UDMRelatorioVendas.pas' {DMRelatorioVendas: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmRelatorioVendas, FrmRelatorioVendas);
  Application.CreateForm(TDMRelatorioVendas, DMRelatorioVendas);
  Application.Run;
end.
