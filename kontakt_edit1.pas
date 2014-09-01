unit Kontakt_Edit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Buttons, EditBtn;

type

  { TKontakt_Edit }

  TKontakt_Edit = class(TForm)
    Button7: TButton;
    Button8: TButton;
    ButtonSave: TButton;
    ButtonAbort: TButton;
    kontakt_land: TComboBox;
    kontakt_email2: TEdit;
    kontakt_email3: TEdit;
    kontakt_typ: TComboBox;
    kontakt_nicht_anrufen: TCheckBox;
    kontakt_nicht_faxen: TCheckBox;
    kontakt_nicht_mailen: TCheckBox;
    kontakt_geburtstag: TDateEdit;
    kontakt_anrede: TComboBox;
    kontakt_faxprivat: TEdit;
    kontakt_abteilung: TEdit;
    kontakt_mobilprivat: TEdit;
    kontakt_telefon: TEdit;
    kontakt_fax: TEdit;
    kontakt_telefonprivat: TEdit;
    kontakt_vorname: TEdit;
    kontakt_nachname: TEdit;
    kontakt_email: TEdit;
    kontakt_strasse: TEdit;
    kontakt_strasse2: TEdit;
    kontakt_plz: TEdit;
    kontakt_ort: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListView2: TListView;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Shape1: TShape;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet4: TTabSheet;
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    edit_ID : string;
  end;

var
  Kontakt_Edit: TKontakt_Edit;

implementation

uses main1;

{$R *.lfm}

{ TKontakt_Edit }

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
  kontakt_vorname.SetFocus;
end;

end.

