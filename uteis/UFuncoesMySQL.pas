unit UFuncoesMySQL;

interface

uses Dialogs, SqlExpr, SysUtils, Forms, ZAbstractRODataset, ZAbstractDataset, ZDataset;

var
  SqlTransacaoErro : boolean;
  mShowMsgRollBack : boolean = true;

Procedure IniciaTransacao;
procedure FinalizaTransacao;
Function SQLFast(mSQL:String):Boolean;
Function _SQLFast(mSQL : String):Boolean;

implementation

uses UDataModule, UFuncoes;

Procedure IniciaTransacao;
Begin
  SqlFast('Begin');
  SqlTransacaoErro := False;
End;

procedure FinalizaTransacao;
Begin
  If SqlTransacaoErro then begin
    SqlFast('RollBack');
    if mShowMsgRollBack then
      MessageDlg('Erro ao atualizar dados, tente novamente', mtError, [mbOk], 0);
  End Else SqlFast('Commit');
end;

Function SQLFast(mSQL:String):Boolean;
var
  mRowAffected: integer;
Begin
  Result := _SQLFast(mSql);
End;

Function _SQLFast(mSQL:String): Boolean;
var
  qrySqlFast : TZQuery;
Begin
  Result := False;

  try
    qrySqlFast := TZQuery.create(Application);
    qrySqlFast.Connection := DM.connection;

    If Empty(mSQL) or ((TemTexto(UpperCase(mSql), 'BEGIN COMMIT ROLLBACK')) ) then begin
      Result := True
    end else begin
      with qrySqlFast do begin
        Active := False;
        Sql.Clear;

        Sql.Add(mSql);
        try
          qrySqlFast.ExecSQL;

          Result := True;
        Except
          on E: Exception do begin
            SqlTransacaoErro := True;
          End;
        End;
      end;
    end;
  finally
    FreeAndNil(qrySqlFast);
  end;
End;

end.
