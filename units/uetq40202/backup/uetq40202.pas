unit uetq40202;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, RLReport, RLBarcode;

type

  { Tfrmetq40202 }

  Tfrmetq40202 = class(TForm)
    RLBarcode: TRLBarcode;
    Rlpreco: TRLLabel;
    RLDetailGrid1: TRLDetailGrid;
    RLLabel1: TRLLabel;
    RLDescricao: TRLLabel;
    RLReport1: TRLReport;
    procedure RLDetailGrid1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLReport1BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLReport1NeedData(Sender: TObject; var MoreData: Boolean);
  private
    QtdEtqImpressas: integer;
  public

  end;

var
  frmetq40202: Tfrmetq40202;

implementation

uses uprincipal;
{$R *.lfm}

{ Tfrmetq40202 }

procedure Tfrmetq40202.RLDetailGrid1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
    RLDescricao.Caption := frmprincipal.BufProdutos.FieldByName('descricao').AsString;
    Rlpreco.Caption :='R$ '+FormatFloat('##,##0.00',(StrToFloat(StringReplace(frmprincipal.BufProdutos.FieldByName('preco_venda').AsString, FormatSettings.ThousandSeparator,'', [rfReplaceAll]))));

    case frmprincipal.rg_tp.ItemIndex of
    0:
     RLBarcode.Caption := frmprincipal.BufProdutos.FieldByName('codigo').AsString;
    1:
     RLBarcode.Caption := frmprincipal.BufProdutos.FieldByName('gtin').AsString;
    end;
end;

procedure Tfrmetq40202.RLReport1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
   QtdEtqImpressas := 0;
   frmprincipal.BufProdutos.First;
   PrintIt := not frmprincipal.BufProdutos.Eof;

   RLReport1.Margins.BottomMargin:= StrToInt(frmprincipal.edtbottommargin.Text);
   RLReport1.Margins.LeftMargin:= StrToInt(frmprincipal.edtLeftMargin.Text);
   RLReport1.Margins.RightMargin:= StrToInt(frmprincipal.edtRightMargin.Text);
   RLReport1.Margins.TopMargin:= StrToInt(frmprincipal.edtTopMargin.Text);
end;

procedure Tfrmetq40202.RLReport1NeedData(Sender: TObject; var MoreData: Boolean
  );
begin

  if QtdEtqImpressas < frmprincipal.BufProdutos.FieldByName('qtdetq').AsInteger then
    begin
      Inc(QtdEtqImpressas);
      MoreData := true;
    end
    else
     begin
       QtdEtqImpressas := 1;
       frmprincipal.BufProdutos.Next;
       MoreData := not frmprincipal.BufProdutos.Eof;
     end;
end;

end.

