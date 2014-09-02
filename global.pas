unit global;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql51conn, FileUtil,sqldb, db, Forms, Controls, Graphics, Dialogs;

var dbcon : TDatabase;
var langdata : TStringList;

function querysql(sqlstr : string) : TSqlQuery;

implementation

uses main1;

function querysql(sqlstr : string) : TSqlQuery;
begin
  result := TSQLQuery.create(nil);
  result.DataBase := dbcon;
  result.SQL.Text := sqlstr;
  result.Open;
end;

end.

