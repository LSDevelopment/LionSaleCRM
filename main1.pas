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

uses Kontakt_Edit1,global;

{$R *.lfm}

{ TMain }

procedure TMain.FormCreate(Sender: TObject);
var Kontakt_Edit : TKontakt_Edit;
begin
  myConnect.Open;
  global.dbcon := myConnect;
  Kontakt_Edit := TKontakt_Edit.create(Self);
  Kontakt_Edit.showModal;
  Kontakt_Edit.free;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  myConnect.Close(true);
end;

end.

