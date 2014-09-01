unit Kontakt_Edit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Buttons, EditBtn, sqldb, db, types;

type

  { TKontakt_Edit }

  TKontakt_Edit = class(TForm)
    Button7: TButton;
    Button8: TButton;
    ButtonSave: TButton;
    ButtonAbort: TButton;
    Label1: TLabel;
    Label17: TLabel;
    ListView2: TListView;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Shape1: TShape;
    TabSheet4: TTabSheet;
    procedure ButtonSaveClick(Sender: TObject);
    procedure CBDraw(Control: TWinControl; Index: Integer; ARect: TRect; State: TOwnerDrawState);
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
    customPanel : TPanel;
    customTab : TTabSheet;
    customLabel : TLabel;
    customEdit : TEdit;
    customCombo : TComboBox;
    lastTab : string;
    lastTopLeft,lastTopRight : integer;
    dataList : TStringList;
    i : integer;
begin
  lastTab := 'none';
  lastTopLeft := 10;
  lastTopRight := 10;
  try
       tempquery := querysql('SELECT * FROM formular WHERE formular_modul='+QuotedStr('kontakt')+' ORDER BY formular_tab,formular_seite,formular_position ASC');
       while not (tempquery.EOF) do
       begin
         // Wenn Tab neu dann Tab und Scroll erstellen und Position hoch setzen
         if (tempquery.FieldByName('formular_tab').AsString<>lastTab) then
         begin
           customTab := TTabSheet.Create(PageControl1);
           customTab.PageControl := PageControl1;
           customTab.Caption := tempquery.FieldByName('formular_tabbez').AsString;
           scr := TScrollBox.Create(customTab);
           scr.Parent := customTab;
           scr.Align := alClient;
           scr.HorzScrollBar.Visible:=False;
           scr.BorderStyle := bsNone;
         end;

         // Panel auf der richtigen Seite erstellen
         customPanel := TPanel.Create(customTab);
         customPanel.Parent := customTab;
         customPanel.Height:=34;
         customPanel.Width:=PageControl1.Width div 2 - 25;
         customPanel.BorderStyle := bsNone;
         customPanel.BevelInner:=bvNone;
         customPanel.BevelOuter:=bvNone;
         if (tempquery.FieldByName('formular_seite').AsString='0') then
         begin
            customPanel.Top := lastTopleft;
            customPanel.Left := 0;
            lastTopleft := lastTopleft + customPanel.Height;
         end else
         begin
            customPanel.Top := lastTopRight;
            customPanel.Left := customPanel.Width;
            lastTopRight := lastTopRight + customPanel.Height;
         end;

         // Bezeichner
         customLabel := TLabel.Create(customPanel);
         customLabel.Parent := customPanel;
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
            customEdit := Tedit.Create(customPanel);
            customEdit.Parent := customPanel;
            customEdit.Left:=customLabel.Width + 10;
            customEdit.Width := customPanel.Width - customEdit.Left - 10;
            customEdit.Top := (customPanel.Height div 2) - (customEdit.Height div 2);
         end;

         // Combobox
         if (tempquery.FieldByName('formular_feldtyp').AsString = 'dropdown') then
         begin
            customCombo := TComboBox.Create(customPanel);
            customCombo.Parent := customPanel;
            customCombo.Left:=customLabel.Width + 10;
            customCombo.Width := customPanel.Width - customCombo.Left - 10;
            customCombo.Top := (customPanel.Height div 2) - (customCombo.Height div 2);
            customCombo.Style:=csOwnerDrawFixed;
            customCombo.ReadOnly:=true;
            customCombo.OnDrawItem:=@CBDraw;
            dataList := TStringList.Create;
            dataList.Delimiter:='|';
            dataList.DelimitedText:=tempquery.FieldByName('formular_auswahlinhalt').AsString;
            for i := 0 to dataList.Count-1 do customCombo.Items.Add(dataList.Strings[i]);
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

procedure TKontakt_Edit.CBDraw(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin
  TComboBox(Control).Canvas.FillRect(ARect);
  TComboBox(Control).Canvas.TextOut(ARect.left+2,ARect.top,Copy(TComboBox(Control).Items.Strings[index],pos('=',TComboBox(Control).Items.Strings[index])+1,length(TComboBox(Control).Items.Strings[index])));
end;

procedure TKontakt_Edit.FormShow(Sender: TObject);
begin
  formbauen;
end;

end.

