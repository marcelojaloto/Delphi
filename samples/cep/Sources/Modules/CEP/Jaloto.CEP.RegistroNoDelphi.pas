unit Jaloto.CEP.RegistroNoDelphi;

interface

uses
  System.Classes;

procedure Register;

implementation

uses
  Jaloto.CEP;

procedure Register;
begin
  RegisterComponents('Jaloto CEP', [TCEP]);
end;

end.
