unit Uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, IBConnection, SQLDB, SQLite3Conn, DB, BufDataset,
  memds, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, DBGrids,
  ComCtrls, Buttons, DBCtrls, ZDataset, ZConnection, ZSqlUpdate, Types,inifiles;

type

  { Tfrmprincipal }

  Tfrmprincipal = class(TForm)
    BufProdutos: TBufDataset;
    BufProdutoscodigo: TStringField;
    BufProdutosdescricao: TStringField;
    BufProdutosgtin: TStringField;
    BufProdutospreco_venda: TFloatField;
    BufProdutosqtdetq: TLongintField;
    BufProdutosref1: TStringField;
    BufProdutosref2: TStringField;
    ComboBox1: TComboBox;
    ConfETQmargemdir: TMemoField;
    ConfETQmargemesq: TMemoField;
    ConfETQmargeminf: TMemoField;
    ConfETQmargemsup: TMemoField;
    ConfETQmodeloindex: TLongintField;
    dsConfetiq: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dsitens: TDataSource;
    dsConsulta: TDataSource;
    edtbottommargin: TEdit;
    edtLeftMargin: TEdit;
    edtproduto: TEdit;
    edtRightMargin: TEdit;
    edtTopMargin: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    QrProdutos: TSQLQuery;
    QrProdutosCODIGO: TStringField;
    QrConsultaCODIGO1: TStringField;
    QrProdutosDESCRICAO: TStringField;
    QrConsultaDESCRICAO1: TStringField;
    QrProdutosGTIN: TStringField;
    QrConsultaGTIN1: TStringField;
    QrProdutosPRECO_VENDA: TFloatField;
    QrConsultaPRECO_VENDA1: TFloatField;
    QrProdutosREF1: TStringField;
    QrProdutosREF2: TStringField;
    QrConsultaREF3: TStringField;
    QrConsultaREF4: TStringField;
    RGConsulta: TRadioGroup;
    rg_tp: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SQLite3Connection: TSQLite3Connection;
    ConfETQ: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure ComboBox1Select(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure edtbottommarginExit(Sender: TObject);
    procedure edtprodutoKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure EtiquetasEmBranco;
    procedure SpeedButton2Click(Sender: TObject);
  private

  public

  end;

var
  frmprincipal: Tfrmprincipal;

implementation

  uses uetq40202;

{$R *.lfm}



{ Tfrmprincipal }

  procedure Tfrmprincipal.EtiquetasEmBranco;
  var
    li: Integer;
  begin
   { for li := 0 to StrToInt(edtBottomMargin.Text) - 1 do begin
      BufProdutos.Append;
      BufProdutos.Post;
    end; }
  end;

procedure Tfrmprincipal.SpeedButton2Click(Sender: TObject);
var
  Ini: TIniFile;
begin
   Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
   try
     case ComboBox1.ItemIndex of
     0:
       begin
         Ini.WriteString('40202', 'BottomMargin', edtbottommargin.text);
         Ini.WriteString('40202', 'LeftMargin', edtLeftMargin.text);
         Ini.WriteString('40202', 'RightMargin', edtRightMargin.text) ;
         Ini.WriteString('40202', 'TopMargin',  edtTopMargin.text);
       end;
     end;
    except
       on E:Exception do
       begin
               MessageDlg('Ocorreu erro ao salvar as configurações da etiqueta' +
               E.Message, mtWarning, [mbOK], 0);
               Abort;
       end;
    end;

end;

procedure Tfrmprincipal.SpeedButton1Click(Sender: TObject);
begin

  if BufProdutos.IsEmpty then begin
    Application.MessageBox(Pchar('Nemhum produto selecionado'), Pchar(Caption));
    Exit;
  end;

  frmetq40202 := Tfrmetq40202.Create(self);

  frmetq40202.RLReport1.Preview();
end;



procedure Tfrmprincipal.FormCreate(Sender: TObject);
var
banco : string;
begin
 try
    banco := 'sistema.db';

    // Verifica se o banco de dados já existe
    if not FileExists(banco) then
    begin
      ShowMessage('Banco de dados não encontrado. Criando um novo...');

      // Criar conexão SQLite

      SQLite3Connection.DatabaseName := banco;
      SQLTransaction.DataBase := SQLite3Connection;

      SQLite3Connection.Connected:= True;  // Abre conexão com o banco de dados
      SQLTransaction.Active := True;

      // Criar tabela se não existir
      SQLite3Connection.ExecuteDirect(
        'CREATE TABLE IF NOT EXISTS produtos ('+
        ' codigo VARCHAR (30), '+
        ' gtin VARCHAR (13), '+
        ' descricao VARCHAR (200), '+
        ' ref1 VARCHAR (200), '+
        ' ref2 VARCHAR (200), '+
        ' preco_venda DOUBLE PRECISION '+
        ');'
      );

      SQLTransaction.Commit;  // Confirma criação da tabela
      ShowMessage('Banco de dados criado com sucesso!');
    end
    //else
    //  ShowMessage('Banco de dados já existe.');
    //
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao criar/verificar o banco de dados: ' + E.Message);
       Application.Terminate;
    end;
  end;


  try
    SQLite3Connection.close;
    SQLite3Connection.DatabaseName:= ExtractFilePath(Application.ExeName)+'\sistema.db';
    SQLite3Connection.Open;
    QrProdutos.open;

    except
         on  E:Exception do
         begin
            ShowMessage('Erro ao conectar com o banco de dados, verifique se na pasta do diretório contém o arquivo: sistema.db');
            Application.Terminate;
            end;
    end;
  Width:= 800;
  Height:=600;;
  PageControl1.ActivePageIndex:= 0;
  PageControl2.ActivePageIndex:= 0;
  BufProdutos.CreateDataset;
  BufProdutos.open;
  ConfETQ.Open;

end;

procedure Tfrmprincipal.GroupBox1Click(Sender: TObject);
begin

end;

procedure Tfrmprincipal.edtprodutoKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin

         try
            QrProdutos.Close;
            QrProdutos.SQL.Clear;
            QrProdutos.SQL.Add('select codigo,descricao,gtin,ref1,ref2,preco_venda FROM Produtos ');

            case  RGConsulta.ItemIndex of
             0:
              begin
                  QrProdutos.SQL.Add('where codigo like:p1');
                  QrProdutos.ParamByName('p1').AsString := edtproduto.Text;
              end;
              1:
               begin
                    QrProdutos.SQL.Add('where upper(descricao) like upper(:p1)');
                    QrProdutos.ParamByName('p1').AsString := '%'+(edtproduto.Text)+'%';
               end;
              2:
               begin
                   QrProdutos.SQL.Add('where gtin like:p1');
                   QrProdutos.ParamByName('p1').AsString := '%'+(edtproduto.Text)+'%';
               end;
            end;
            QrProdutos.Open;
         except
            on E:Exception do
            begin
                    MessageDlg('Ocorreu erro ao localizar o produto ' +
                    E.Message, mtWarning, [mbOK], 0);
                    Abort;
            end;
         end;
  end;
    if QrProdutos.IsEmpty then
    begin
        ShowMessage('Produto não localizado');
        edtproduto.SetFocus;
     end;
end;

procedure Tfrmprincipal.DBGrid1DblClick(Sender: TObject);
begin
  try
    BufProdutos.Append;
    BufProdutos.fieldbyname('codigo').AsString        := QrProdutos.fieldbyname('codigo').AsString;
    BufProdutos.fieldbyname('gtin').AsString         := QrProdutos.fieldbyname('gtin').AsString;
    BufProdutos.fieldbyname('descricao').AsString     := QrProdutos.fieldbyname('descricao').AsString;
    BufProdutos.fieldbyname('preco_venda').AsCurrency := QrProdutos.fieldbyname('preco_venda').AsCurrency;
    BufProdutos.fieldbyname('qtdetq').AsInteger       := 1;
    BufProdutos.fieldbyname('ref1').AsString          := QrProdutos.fieldbyname('ref1').AsString;
    BufProdutos.fieldbyname('ref2').AsString          := QrProdutos.fieldbyname('ref2').AsString;
    BufProdutos.Post;

  except
     on E:Exception do
     begin
             MessageDlg('Ocorreu erro ao selecionar o produto ' +
             E.Message, mtWarning, [mbOK], 0);
             Abort;
     end;
  end;
end;

procedure Tfrmprincipal.ComboBox1Select(Sender: TObject);
var
  Ini: TIniFile;
begin
   Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
   try
     case ComboBox1.ItemIndex of
     0:
       begin
         edtbottommargin.text := Ini.ReadString('40202', 'BottomMargin', '');
         edtLeftMargin.text := Ini.ReadString('40202', 'LeftMargin', '');
         edtRightMargin.text := Ini.ReadString('40202', 'RightMargin', '') ;
         edtTopMargin.text := Ini.ReadString('40202', 'TopMargin', '');
       end;
     end;
    except
       on E:Exception do
       begin
               MessageDlg('Ocorreu erro ao carregar as configurações da etiqueta' +
               E.Message, mtWarning, [mbOK], 0);
               Abort;
       end;
    end;
end;

procedure Tfrmprincipal.DBGrid2DblClick(Sender: TObject);
begin
  BufProdutos.Delete;
end;

procedure Tfrmprincipal.edtbottommarginExit(Sender: TObject);
begin

end;



end.

