unit Formulardesigner1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Buttons,sqldb, db;

type

  { TFormulardesigner }

  TFormulardesigner = class(TForm)
    Bevel1: TBevel;
    ButtonAbort: TButton;
    ButtonSave: TButton;
    ImageList1: TImageList;
    Label1: TLabel;
    FieldList: TListView;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    ScrollBox1: TScrollBox;
    Shape1: TShape;
    buttonColumnOne: TSpeedButton;
    buttonColumnTwo: TSpeedButton;
    buttonColumnThree: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    procedure buttonColumnOneClick(Sender: TObject);
    procedure buttonColumnTwoClick(Sender: TObject);
    procedure buttonColumnThreeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    PanelInMove : TPanel;
    PanelOldPos : integer;
    MouseOldPos : integer;
    GlobalShapeList : TStringList;
    procedure MyDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure MyDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure MyPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MyPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MyPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure loadfields;
    function makeShape(cols : integer; onScroll : TScrollBox) : TShape;
  public
    { public declarations }
  end;

var
  Formulardesigner: TFormulardesigner;

implementation

uses global;

{$R *.lfm}

{ TFormulardesigner }

procedure TFormulardesigner.loadfields;
var qdata : TSqlQuery;
begin
  qdata := querysql('SHOW FIELDS FROM kontakt');
  while not qdata.EOF do
  begin
    if (qdata.FieldByName('Key').AsString<>'PRI') then
    begin
      FieldList.Items.Add;

      if (langdata.IndexOfName('COLUMN_'+qdata.FieldByName('FIELD').AsString)>=0) then
      begin
         FieldList.Items.Item[FieldList.Items.Count-1].Caption := langdata.Values['COLUMN_'+qdata.FieldByName('FIELD').AsString]
      end else
      begin
         FieldList.Items.Item[FieldList.Items.Count-1].Caption := qdata.FieldByName('FIELD').AsString;
      end;

      FieldList.Items.Item[FieldList.Items.Count-1].SubItems.add(qdata.FieldByName('FIELD').AsString);
      FieldList.Items.Item[FieldList.Items.Count-1].ImageIndex:=0;
    end;
    qdata.Next;
  end;
end;

function TFormulardesigner.makeShape(cols : integer; onScroll : TScrollBox) : TShape;
var customShape : TShape;
    customPanel : TPanel;
    customLabel : TLabel;
    customEdit  : TEdit;
    i : integer;
    Glo : TStringList;
    customMovePanel : TPanel;
begin
  customPanel := TPanel.Create(onScroll);
  customPanel.Parent := onScroll;
  customPanel.BorderStyle:=bsNone;
  customPanel.BevelInner:=bvNone;
  customPanel.BevelOuter:=bvNone;
  customPanel.Height:=36;
  customPanel.Align:=alTop;
  customPanel.Top:=10000;
  customPanel.OnMouseDown:=@MyPanelMouseDown;
  customPanel.OnMouseMove:=@MyPanelMouseMove;
  customPanel.OnMouseUp:=@MyPanelMouseUp;
  customPanel.ParentColor:=False;
  customPanel.Color:=clWhite;
  customPanel.Cursor:=crHandPoint;



  for i := 0 to cols-1 do
  begin
    customShape := TShape.Create(customPanel);
    customShape.Top:=2;
    customShape.parent := customPanel;
    customShape.Pen.Style:=psDot;
    customShape.Pen.Color:=clBlack;
    customShape.Height:=customPanel.Height-4;
    customShape.Width:=(customPanel.Width div cols);
    customShape.Left:=i*(customShape.Width);
    customShape.Brush.Style:=bsSolid;
    customShape.Brush.Color:=clWhite;

    customShape.Left:=customShape.Left+2;
    customShape.Width:=customShape.Width-4;
    customShape.OnDragOver:=@MyDragOver;
    customShape.OnDragDrop:=@MyDragDrop;
    customShape.OnMouseDown:=@MyPanelMouseDown;
    customShape.OnMouseMove:=@MyPanelMouseMove;
    customShape.OnMouseUp:=@MyPanelMouseUp;
    customShape.Cursor:=crHandPoint;

    customLabel := TLabel.Create(customPanel);
    customLabel.AutoSize:=False;
    customLabel.Parent := customPanel;
    customLabel.Caption:='Hallo Welt';
    customLabel.WordWrap:=True;
    customLabel.Left:=customShape.Left +4;
    customLabel.Top:=customShape.Top;
    customLabel.Height:=customShape.Height;
    customLabel.Layout:=tlCenter;
    customLabel.Width:=120;
    customLabel.Visible:=false;
    customLabel.DragMode:=dmAutomatic;
    customLabel.OnDragOver:=@MyDragOver;
    customLabel.OnDragDrop:=@MyDragDrop;

    if i = 0 then
    begin
      customShape.Left:=customShape.Left+6;
      customShape.Width:=customShape.Width-6;
      customLabel.Left:=customLabel.Left+6;
      customLabel.Width:=customLabel.Width-6;
    end;

    customEdit := TEdit.Create(customPanel);
    customEdit.Parent := customPanel;
    customEdit.Text := 'Hallo Welt';
    customEdit.Enabled := false;
    customEdit.Left := customLabel.Left + customLabel.Width +4;
    customEdit.Top := ((customShape.Top+customShape.Height)div 2)-(customEdit.Height div 2);
    customEdit.Width := customShape.Width - customLabel.Width -12 ;
    customEdit.Visible:=false;

    Glo := TStringList.Create;
    Glo.AddObject('',customShape);
    Glo.AddObject('',customLabel);
    Glo.AddObject('',customEdit);
    GlobalShapeList.AddObject('',Glo);
  end;
end;

procedure TFormulardesigner.buttonColumnOneClick(Sender: TObject);
begin
  makeShape(1,ScrollBox1);
end;

procedure TFormulardesigner.buttonColumnTwoClick(Sender: TObject);
begin
  makeShape(2,ScrollBox1);
end;

procedure TFormulardesigner.buttonColumnThreeClick(Sender: TObject);
begin
  makeShape(3,ScrollBox1);
end;

procedure TFormulardesigner.FormShow(Sender: TObject);
begin
  GlobalShapeList := TStringList.Create;
  loadfields;
end;



procedure TFormulardesigner.MyDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var i : integer;
    theSender : TObject;
begin
  theSender := sender;
  if theSender is TLabel then
  begin
     for i := 0 to GlobalShapeList.Count-1 do
     if (TStringList(GlobalShapeList.Objects[i]).Objects[1]=theSender) then
     begin
       theSender := TStringList(GlobalShapeList.Objects[i]).Objects[0];
       break;
     end;
  end;
  for i := 0 to GlobalShapeList.Count-1 do
  if (TStringList(GlobalShapeList.Objects[i]).Objects[0] = theSender) then
  begin
    TLabel(TStringList(GlobalShapeList.Objects[i]).Objects[1]).Caption:=FieldList.Selected.Caption;
    TLabel(TStringList(GlobalShapeList.Objects[i]).Objects[1]).Visible:=true;
    TEdit(TStringList(GlobalShapeList.Objects[i]).Objects[2]).text:=FieldList.Selected.Caption;
    TEdit(TStringList(GlobalShapeList.Objects[i]).Objects[2]).Visible:=true;
    break;
  end;
end;

procedure TFormulardesigner.MyDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source = FieldList then Accept:=true else Accept:=false;
end;


procedure TFormulardesigner.MyPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
     if sender is TPanel then
       PanelInMove := TPanel(Sender)
     else
       PanelInMove := TPanel(TShape(Sender).Parent);
     PanelOldPos:= PanelInMove.Top;
     MouseOldPos:= Y;
     PanelInMove.Color:=$00F3E2D1;
  end;
end;

procedure TFormulardesigner.MyPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if PanelInMove <> nil then
  begin
    Caption:=IntTOStr(Y-MouseOldPos);
    PanelInMove.Top:=PanelOldPos+(Y-MouseOldPos);
    PanelInMove.Color:=$00F3E2D1;
  end;
end;

procedure TFormulardesigner.MyPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if PanelInMove = nil then exit;
  PanelInMove.Color:=clWhite;
  PanelInMove := nil;
end;


end.

