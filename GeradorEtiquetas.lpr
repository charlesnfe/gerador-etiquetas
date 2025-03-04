program GeradorEtiquetas;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Uprincipal, zcomponent, memdslaz, uetq40202;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tfrmprincipal, frmprincipal);
  Application.CreateForm(Tfrmetq40202, frmetq40202);
  Application.Run;
end.

