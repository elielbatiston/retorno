unit UDomainException;

interface

uses
  SysUtils;

type
  TDomainException = class(Exception)
  public
    constructor Create(const Msg: string); reintroduce;
  end;

implementation

constructor TDomainException.Create(const Msg: string);
begin
  inherited Create(Msg);
end;

end.
