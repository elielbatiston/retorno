unit UProcessarRetornoUseCaseFactory;

interface

uses Classes, UProcessarRetornoUseCase;

type
  TProcessarRetornoUseCaseFactory = class
  private
    class var FUseCases : array of IProcessarRetornoUseCase;
    class procedure Prepare;
    class function RetornaProcessador(dado: string): IProcessarRetornoUseCase;
  public
    class function Instantiate(dado: string): IProcessarRetornoUseCase;
  end;

implementation

uses UProcessarRetornoSicoobUseCase;

class function TProcessarRetornoUseCaseFactory.Instantiate(dado: string): IProcessarRetornoUseCase;
begin
    Prepare();
    Result := RetornaProcessador(dado);
end;

class procedure TProcessarRetornoUseCaseFactory.Prepare;
begin
  if Length(FUseCases) = 0 then
  begin
    SetLength(FUseCases, 1); // Alocando espaço para um elemento
    FUseCases[0] := TProcessarRetornoSicoobUseCase.Create;
  end;
end;

class function TProcessarRetornoUseCaseFactory.RetornaProcessador(dado: string): IProcessarRetornoUseCase;
var
  usecase: IProcessarRetornoUseCase;
  obj: Pointer;
begin
  Result := nil;
  for usecase in FUseCases do
    if usecase.isIt(dado) then begin
      Result := usecase;
      break;
    end;
end;

end.
