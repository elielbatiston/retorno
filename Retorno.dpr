program Retorno;

uses
  Forms,
  UPrincipal in 'frontend\UPrincipal.pas' {frmPrincipal},
  UInputImportarArquivoRetornoDTO in 'usecase\retorno\UInputImportarArquivoRetornoDTO.pas',
  UDomainException in 'domain\exception\UDomainException.pas',
  UDataModule in 'frontend\UDataModule.pas' {DM: TDataModule},
  UFuncoesMySQL in 'uteis\UFuncoesMySQL.pas',
  UProcessarRetornoUseCase in 'usecase\retorno\UProcessarRetornoUseCase.pas',
  UProcessarRetornoSicoobUseCase in 'usecase\retorno\sicoob\UProcessarRetornoSicoobUseCase.pas',
  URetorno in 'domain\URetorno.pas',
  UProcessarRetornoUseCaseFactory in 'usecase\retorno\UProcessarRetornoUseCaseFactory.pas',
  UBancosAceitos in 'usecase\retorno\UBancosAceitos.pas',
  UFuncoes in 'uteis\UFuncoes.pas';

{$R *.res}

begin
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.Title := 'Leitor de arquivo CNAB';
    Application.CreateForm(TDM, DM);
    if (DM.connection.Connected) then begin
      Application.CreateForm(TfrmPrincipal, frmPrincipal);
    end;

    Application.Run;
  finally
    DM.Free;
    DM := nil;
  end;
end.
