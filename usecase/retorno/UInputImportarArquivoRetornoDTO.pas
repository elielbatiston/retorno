unit UInputImportarArquivoRetornoDTO;

interface

type
  TInputImportarArquivoRetornoDTO = class
  private
    FDado: string;
    FPosition: integer;
  public
    constructor Create(const ADado: string; const APosition: Integer);
    function Dado: string;
    function Position: integer;
  end;

implementation

constructor TInputImportarArquivoRetornoDTO.Create(const ADado: string; const APosition: Integer);
begin
  FDado := ADado;
  FPosition := APosition;
end;

function TInputImportarArquivoRetornoDTO.Dado: string;
begin
  Result := FDado;
end;

function TInputImportarArquivoRetornoDTO.Position: integer;
begin
  Result := FPosition;
end;

end.
