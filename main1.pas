unit main1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql51conn, sqldb, db, FileUtil, Forms, Controls,
  Graphics, Dialogs;

type

  { TMain }

  TMain = class(TForm)
    myConnect: TMySQL51Connection;
    SQLTransaction1: TSQLTransaction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Main: TMain;

implementation

uses Kontakt_Edit1,FormularDesigner1,global;

{$R *.lfm}

{ TMain }

procedure TMain.FormCreate(Sender: TObject);
var Kontakt_Edit : TKontakt_Edit;
    lang : TSQLQuery;
begin
  langdata := TStringList.Create;

  myConnect.Open;
  global.dbcon := myConnect;

  // Sprache einlesen
  lang := querysql('SELECT sprachen_id,sprachen_de FROM sprachen');
  while not lang.EOF do
  begin
    langdata.Values[lang.FieldByName('sprachen_id').AsString] := lang.FieldByName('sprachen_de').AsString;
    lang.Next;
  end;
  lang.Close;
  FreeAndNil(lang);
  // ******************


  FormularDesigner := TFormularDesigner.create(Self);
  FormularDesigner.showmodal;
  FormularDesigner.free;
  Application.Terminate;

  //Kontakt_Edit := TKontakt_Edit.create(Self);
  //Kontakt_Edit.showModal;
  //Kontakt_Edit.free;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  myConnect.Close(true);
end;

end.

