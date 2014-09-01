unit Kontakt_Edit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Buttons, EditBtn, sqldb, db;

type

  { TKontakt_Edit }

  TKontakt_Edit = class(TForm)
    Button7: TButton;
    Button8: TButton;
    ButtonSave: TButton;
    ButtonAbort: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    ListView2: TListView;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Shape1: TShape;
    TabSheet1: TTabSheet;
    TabSheet4: TTabSheet;
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    edit_ID : string;
    procedure formbauen;
  end;

var
  Kontakt_Edit: TKontakt_Edit;

implementation

uses main1,global;

{$R *.lfm}

{ TKontakt_Edit }

procedure TKontakt_Edit.formbauen;
var tempquery : TSQLQuery;
    scr : TScrollBox;
    pl1,pl2 : TPanel;
    customTab : TTabSheet;
    customLabel : TLabel;
    lastTab : string;
    lastTopLeft,lastTopRight : integer;
    customEdit : TEdit;
begin
  lastTab := 'none';
  lastTopLeft := 0;
  lastTopRight := 0;
  try
       tempquery := querysql('SELECT * FROM formular WHERE formular_modul='+QuotedStr('kontakt')+' ORDER BY formular_tab,formular_seite,formular_position ASC');
       while not (tempquery.EOF) do
       begin
         // Wenn Tab neu dann Tab und Scroll erstellen und Position hoch setzen
         if (tempquery.FieldByName('formular_tab').AsString<>lastTab) then
         begin
           customTab := TTabSheet.Create(PageControl1);
           customTab.PageControl := PageControl1;
           scr := TScrollBox.Create(customTab);
           scr.Parent := customTab;
           scr.Align := alClient;
           scr.HorzScrollBar.Visible:=False;
           scr.BorderStyle := bsNone;
         end;

         // Panel auf der richtigen Seite erstellen
         pl1 := TPanel.Create(customTab);
         pl1.Parent := customTab;
         pl1.Height:=34;
         pl1.Width:=PageControl1.Width div 2 - 25;
         pl1.BorderStyle := bsNone;
         pl1.BevelInner:=bvNone;
         pl1.BevelOuter:=bvNone;
         if (tempquery.FieldByName('formular_seite').AsString='0') then
         begin
            pl1.Top := lastTopleft;
            pl1.Left := 0;
            lastTopleft := lastTopleft + pl1.Height;
         end else
         begin
            pl1.Top := lastTopRight;
            pl1.Left := pl1.Width;
            lastTopRight := lastTopRight + pl1.Height;
         end;

         // Bezeichner
         customLabel := TLabel.Create(pl1);
         customLabel.Parent := pl1;
         customLabel.Caption := tempquery.FieldByName('formular_bezeichnung').AsString+':';
         customLabel.AutoSize := false;
         customLabel.Align := alLeft;
         customLabel.Width := 120;
         customLabel.Layout := tlCenter;
         customLabel.WordWrap := true;
         customLabel.Alignment:= taRightJustify;

         // Text
         if (tempquery.FieldByName('formular_feldtyp').AsString = 'text') then
         begin
            customEdit := Tedit.Create(pl1);
            customEdit.Parent := pl1;
            customEdit.Left:=customLabel.Width + 10;
            customEdit.Width := pl1.Width - customEdit.Left - 10;
            customEdit.Top := (pl1.Height div 2) - (customEdit.Height div 2);
         end;

         lastTab := tempquery.FieldByName('formular_tab').AsString;

         tempquery.Next;
       end;
    finally
       tempquery.Close;
       FreeAndNil(tempquery);
    end;
end;

// Bei Formularerstellung Tab auf den ersten setzen
procedure TKontakt_Edit.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TKontakt_Edit.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then ModalResult:=mrCancel;
end;

procedure TKontakt_Edit.ButtonSaveClick(Sender: TObject);
begin

end;

procedure TKontakt_Edit.FormShow(Sender: TObject);
begin
  formbauen;
end;

end.

