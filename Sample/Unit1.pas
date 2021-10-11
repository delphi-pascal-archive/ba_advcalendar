unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, BAAdvCal;

type
  TForm1 = class(TForm)
    BAAdvCalendar1: BAAdvCalendar;
    procedure BAAdvCalendar1DaySelect(Sender: TObject; SelDate: TDateTime);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BAAdvCalendar1DaySelect(Sender: TObject;
  SelDate: TDateTime);
begin
  Caption:='Дата: '+datetostr(BAAdvCalendar1.Date);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ClientWidth:=BAAdvCalendar1.Width;
  ClientHeight:=BAAdvCalendar1.Height;
  BAAdvCalendar1.Date:=Now;
end;

end.
