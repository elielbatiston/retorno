unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, UInputImportarArquivoRetornoDTO,
  UDomainException, ComCtrls, UProcessarRetornoUseCase, rxToolEdit;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    btnFechar: TButton;
    btnProcessar: TButton;
    Progress: TProgressBar;
    btnParar: TButton;
    edtArquivo: TFilenameEdit;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnProcessarClick(Sender: TObject);
    procedure btnPararClick(Sender: TObject);
  private
    { Private declarations }

    procedure Importar();
    procedure Processar(AArquivoRetorno: TStringList; AUseCase: IProcessarRetornoUseCase);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  mPara : boolean;

implementation

uses UDataModule, UFuncoes, UFuncoesMySqL, UProcessarRetornoUseCaseFactory;

{$R *.dfm}

procedure TfrmPrincipal.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btnPararClick(Sender: TObject);
begin
  mPara := true;
  btnParar.Enabled := false;
end;

procedure TfrmPrincipal.btnProcessarClick(Sender: TObject);
var
  input : TInputImportarArquivoRetornoDTO;
begin
  if not FileExists(edtArquivo.Text) then begin
    MessageBox(Handle, 'Arquivo informado n�o existe', 'Warning', mb_OK);
    edtArquivo.SetFocus();
  end else begin
    IniSetingStr(mSystemIni, 'Retorno', 'DirectoryName', ExtractFilePath(edtArquivo.Text));
    Importar();
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  mDir: string;
begin
  mDir := IniSetingStr(mSystemIni, 'Retorno', 'DirectoryName', '-1');
  if Empty(mDir) then begin
     mDir := 'c:\temp';
  end;

  edtArquivo.InitialDir := mDir;
  edtArquivo.Text       := '';
end;

procedure TfrmPrincipal.Importar();
var
  ArqRetorno : TStringList;
  usecase: IProcessarRetornoUseCase;
begin
  try
    ArqRetorno := TStringList.Create;

    ArqRetorno.LoadFromFile(edtArquivo.Text);

    Progress.Position    := 0;
    Progress.Visible     := True;
    Progress.Max         := ArqRetorno.Count;
    btnFechar.Visible    := false;
    btnParar.Visible     := true;
    btnProcessar.Visible := false;

    usecase := TProcessarRetornoUseCaseFactory.Instantiate(ArqRetorno.Strings[0]);
    Processar(ArqRetorno, usecase);
  finally
    Progress.Visible     := false;
    btnParar.Visible     := False;
    btnFechar.Visible    := True;
    btnParar.Enabled     := True;
    btnProcessar.Visible := true;
    edtArquivo.Text      := '';
    FreeAndNil(ArqRetorno);
    usecase := nil;
  end;
end;

procedure TfrmPrincipal.Processar(AArquivoRetorno: TStringList; AUseCase: IProcessarRetornoUseCase);
var
  NumeroRegistro : Integer;
  mSai : Boolean;
  input: TInputImportarArquivoRetornoDTO;
begin
  try
    IniciaTransacao;

    NumeroRegistro := 0;
    mSai           := False;
    mPara          := False;

    while((NumeroRegistro < AArquivoRetorno.Count - 1)and(not mSai))do begin
      Progress.Position := NumeroRegistro;
      Application.ProcessMessages;

      if(mPara)then begin
          mSai := MessageDlg('Tem certeza que deseja interromper a baixa?', mtConfirmation,[mbYes, mbNo],0) = mrYes;
          mPara := False;
          btnParar.Enabled := True;
      end;

      if(not mSai)then begin
        input := TInputImportarArquivoRetornoDTO.Create(AArquivoRetorno.Strings[NumeroRegistro], NumeroRegistro);
        AUseCase.Execute(input);
        FreeAndNil(input);
      end;

      inc(NumeroRegistro);
    end;

    FinalizaTransacao;

    if(mSai)or(mPara) then begin
      MessageBox(Handle, 'Processo interrompido pelo usu�rio.', 'Informa��o', mb_OK);
    end else begin
      MessageBox(Handle, 'Arquivo processado com sucesso', 'Informa��o', mb_ok);
    end;
  except
    on E: Exception do begin
      SqlTransacaoErro := true;
      FinalizaTransacao;
      MessageBox(Handle, PWideChar('Ocorreu o seguinte erro: ' + e.Message), 'Erro', mb_ok);
    end;
    on E: TDomainException do begin
      SqlTransacaoErro := true;
      FinalizaTransacao;
      MessageBox(Handle, PWideChar(E.Message), 'Error', mb_OK);
    end;
  end;
end;

end.
