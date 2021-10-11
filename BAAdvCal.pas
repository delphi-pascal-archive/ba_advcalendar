//***************************//
//  BAAdvCalendar component  //
//                           //
//***************************//

unit BAAdvCal;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

const
  ADaysInMonth: array[1..13] of word = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 29);
  MonthNames: array[1..12] of string[5] = ('JAN', 'FEB', 'MAR', 'APR',
    'MAY', 'JUNE', 'JULY', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');

type
  TBAAdvCustomCalPanel = class;
  BAAdvCalendar = class;

  TDayStr = string;
  TMonthStr = string;

  TDayArray = array[1..14] of TDayStr;
  TMonthArray = array[1..12] of TMonthStr;

  TDaySelectEvent = procedure(Sender: TObject; SelDate: TDateTime) of object;
  TDateChangeEvent = procedure(Sender: TObject; origDate, newDate: TDateTime) of object;

  TCancelledChangeEvent = procedure(Sender: TObject; CancelledDate: TDateTime) of object;

  TGetDateEvent = procedure(Sender: TObject; dt: tdatetime; var isEvent: Boolean) of object;

  TGetDateEventHint = procedure(Sender: TObject; dt: tdatetime;
    var isEvent: Boolean; var EventHint: string) of object;

  TEventShape = (evsRectangle, evsCircle, evsSquare, evsTriangle, evsNone);
  TGradientDirection = (gdHorizontal, gdVertical);

  TTodayStyle = (tsSunken, tsRaised, tsFlat);

  TSelDateItem = class(TCollectionItem)
  private
    FDate: TDateTime;
    FHint: string;
    FColor: TColor;
    FEventShape: TEventShape;
    FFontColor: TColor;
    FObject: TObject;
    FTag: Integer;
    procedure SetDate(const Value: TDateTime);
    procedure SetColor(const Value: TColor);
    procedure SetEventShape(const Value: TEventShape);
    procedure SetFontColor(const Value: TColor);
    procedure SetHint(const Value: string);
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Date: TDateTime read FDate write SetDate;
    property Hint: string read FHint write SetHint;
    property FontColor: TColor read FFontColor write SetFontColor;
    property Color: TColor read FColor write SetColor;
    property Shape: TEventShape read FEventShape write SetEventShape;
    property ItemObject: TObject read FObject write FObject;
    property Tag: Integer read FTag write FTag;
  end;

  TEventProp = class(TSelDateItem);
  TEventPropEvent = procedure(Sender: TObject; dt: tdatetime; var Event: TEventProp) of object;

  TMinMaxDate = class(TPersistent)
  private
    FOwner: BAAdvCalendar;
    FDay: smallint;
    FMonth: smallint;
    FYear: smallint;
    FUse: Boolean;
    procedure SetDay(avalue: smallint);
    procedure SetMonth(avalue: smallint);
    procedure SetYear(avalue: smallint);
    procedure SetUse(avalue: Boolean);
    function GetDate: TDateTime;
    procedure SetDate(const Value: TDateTime);
  public
    constructor Create(aOwner: BAAdvCalendar);
    property Date: TDateTime read GetDate write SetDate;
  published
    property Day: smallint read fDay write SetDay;
    property Month: smallint read fMonth write SetMonth;
    property Year: smallint read fYear write SetYear;
    property Use: Boolean read fUse write SetUse;
  end;

  TYearStartAt = class(TPersistent)
  private
    FOwner: TBAAdvCustomCalPanel;
    FStartDay: integer;
    FStartMonth: integer;
    FPrevYearStartDay: integer;
    FPrevYearStartMonth: integer;
    FNextYearStartDay: integer;
    FNextYearStartMonth: integer;
    FOnChange: TNotifyEvent;
    procedure SetStartDay(d: integer);
    procedure SetStartMonth(m: integer);
    procedure SetPrevYearStartDay(d: integer);
    procedure SetPrevYearStartMonth(m: integer);
    procedure SetNextYearStartDay(d: integer);
    procedure SetNextYearStartMonth(m: integer);
    function ValidateDay(d: integer): Boolean;
    function ValidateMonth(m: integer): Boolean;
    procedure Changed;
  public
    constructor Create(AOwner: TBAAdvCustomCalPanel);
    destructor Destroy; override;
  published
    property StartDay: integer read FStartDay write SetStartDay;
    property StartMonth: integer read FStartMonth write SetStartMonth;
    property PrevYearStartDay: integer read FPrevYearStartDay write SetPrevYearStartDay;
    property PrevYearStartMonth: integer read FPrevYearStartMonth write SetPrevYearStartMonth;
    property NextYearStartDay: integer read FNextYearStartDay write SetNextYearStartDay;
    property NextYearStartMonth: integer read FNextYearStartMonth write SetNextYearStartMonth;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNameOfMonths = class(TPersistent)
  private
    FJanuary: TMonthStr;
    FFebruary: TMonthStr;
    FMarch: TMonthStr;
    FApril: TMonthStr;
    FMay: TMonthStr;
    FJune: TMonthStr;
    FJuly: TMonthStr;
    FAugust: TMonthStr;
    FSeptember: TMonthStr;
    FOctober: TMonthStr;
    FNovember: TMonthStr;
    FDecember: TMonthStr;
    FOnChange: TNotifyEvent;
    FUseIntlNames: Boolean;
    procedure SetApril(const Value: TMonthStr);
    procedure SetAugust(const Value: TMonthStr);
    procedure SetDecember(const Value: TMonthStr);
    procedure SetFebruary(const Value: TMonthStr);
    procedure SetJanuary(const Value: TMonthStr);
    procedure SetJuly(const Value: TMonthStr);
    procedure SetJune(const Value: TMonthStr);
    procedure SetMarch(const Value: TMonthStr);
    procedure SetMay(const Value: TMonthStr);
    procedure SetNovember(const Value: TMonthStr);
    procedure SetOctober(const Value: TMonthStr);
    procedure SetSeptember(const Value: TMonthStr);
    procedure SetUseIntlNames(const Value: Boolean);
  protected
    procedure Changed;
    procedure InitIntl;
  public
    constructor Create;
    destructor Destroy; override;
    function GetMonth(i: integer): string;
  published
    property January: TMonthStr read FJanuary write SetJanuary;
    property February: TMonthStr read FFebruary write SetFebruary;
    property March: TMonthStr read FMarch write SetMarch;
    property April: TMonthStr read FApril write SetApril;
    property May: TMonthStr read FMay write SetMay;
    property June: TMonthStr read FJune write SetJune;
    property July: TMonthStr read FJuly write SetJuly;
    property August: TMonthStr read FAugust write SetAugust;
    property September: TMonthStr read FSeptember write SetSeptember;
    property October: TMonthStr read FOctober write SetOctober;
    property November: TMonthStr read FNovember write SetNovember;
    property December: TMonthStr read FDecember write SetDecember;
    property UseIntlNames: Boolean read FUseIntlNames write SetUseIntlNames;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TNameOfDays = class(TPersistent)
  private
    FMonday: TDayStr;
    FTuesday: TDayStr;
    FWednesday: TDayStr;
    FThursday: TDayStr;
    FFriday: TDayStr;
    FSaturday: TDayStr;
    FSunday: TDayStr;
    FOnChange: TNotifyEvent;
    FUseIntlNames: Boolean;
    procedure SetFriday(const Value: TDayStr);
    procedure SetMonday(const Value: TDayStr);
    procedure SetSaturday(const Value: TDayStr);
    procedure SetSunday(const Value: TDayStr);
    procedure SetThursday(const Value: TDayStr);
    procedure SetTuesday(const Value: TDayStr);
    procedure SetWednesday(const Value: TDayStr);
    procedure SetUseIntlNames(const Value: Boolean);
  protected
    procedure Changed;
    procedure InitIntl;
  public
    constructor Create;
    destructor Destroy; override;
    function GetDay(i: integer): string;
  published
    property Monday: TDayStr read FMonday write SetMonday;
    property Tuesday: TDayStr read FTuesday write SetTuesday;
    property Wednesday: TDayStr read FWednesday write SetWednesday;
    property Thursday: TDayStr read FThursday write SetThursday;
    property Friday: TDayStr read FFriday write SetFriday;
    property Saturday: TDayStr read FSaturday write SetSaturday;
    property Sunday: TDayStr read FSunday write SetSunday;
    property UseIntlNames: Boolean read FUseIntlNames write SetUseIntlNames;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TCalendarBrowsers = class(TPersistent)
  private
    FPrevMonth: Boolean;
    FNextMonth: Boolean;
    FPrevYear: Boolean;
    FNextYear: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetNextMonth(const Value: Boolean);
    procedure SetNextYear(const Value: Boolean);
    procedure SetPrevMonth(const Value: Boolean);
    procedure SetPrevYear(const Value: Boolean);
  public
    constructor Create;
    procedure Changed;
  published
    property PrevMonth: Boolean read FPrevMonth write SetPrevMonth default True;
    property PrevYear: Boolean read FPrevYear write SetPrevYear default True;
    property NextMonth: Boolean read FNextMonth write SetNextMonth default True;
    property NextYear: Boolean read FNextYear write SetNextYear default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  BAAdvCalendarLook = (lookFlat, look3D);

  TBAAdvCustomCalPanel = class(TCustomPanel)
  protected
    procedure UpdateYearStart; virtual;
    procedure DoPaint; virtual;
    procedure RepaintDate(dt: TDateTime); virtual;
  end;

  BAAdvCalendar = class(TBAAdvCustomCalPanel)
  private
    xoffset, yoffset: integer;
    seldate: TDatetime;
    thedate: TDatetime;
    clkdate: TDatetime;
    movdate: TDatetime;
    initdate: TDatetime;
    mousesel: Boolean;
    showhintbusy: Boolean;
    fLastHintPos: TPoint;
    dx, dy: word;
    lblx1, lblx2, lblx3: word;
    fFont: TFont;
    xposin, yposin: integer;
    flgl, flgr, flgla, dflgl, dflgr, flgt: Boolean;
    labels: string[20];
    EventHint: string;
    BrowserHint: string;
    FLook: BAAdvCalendarLook;
    FBrowsers: TCalendarBrowsers;
    FMonthSelect: Boolean;
    FYearStartAt: TYearStartAt;
    FNameOfDays: TNameOfDays;
    FNameOfMonths: TNameOfMonths;
    FMaxDate: TMinMaxDate;
    FMinDate: TMinMaxDate;
    FTextcolor: TColor;
    FSelectColor: TColor;
    FSelectFontColor: TColor;
    FInactiveColor: TColor;
    FFocusColor: TColor;
    FInverscolor: TColor;
    FHeaderColor: TColor;
    FStartDay: Integer;
    FDay, FMonth, FYear: word;
    FDayFont: TFont;
    FOnDaySelect: TDaySelectEvent;
    FOnMonthSelect: TNotifyEvent;
    FOnGetDateEvent: TGetDateEvent;
    FOnMonthChange: TDateChangeEvent;
    FOnYearChange: TDateChangeEvent;
    FOnDayChange: TDateChangeEvent;
    FShowDaysAfter: Boolean;
    FShowDaysBefore: Boolean;
    FShowSelection: Boolean;
    FOnCancelledChange: TCancelledChangeEvent;
    FUpdateCount: Integer;
    FCaptionColor: TColor;
    FReturnIsSelect: Boolean;
    FLineColor: TColor;
    FLine3D: Boolean;
{    FGradientStartColor: TColor;
    FGradientEndColor: TColor;
    FGradientDirection: TGradientDirection;
    FMonthGradientStartColor: TColor;
    FMonthGradientEndColor: TColor;
    FMonthGradientDirection: TGradientDirection; }
    FHandCursor,
    FOldCursor: TCursor;
    FHintPrevYear: String;
    FHintPrevMonth: String;
    FHintNextMonth: String;
    FHintNextYear: String;
    FCanvas: TCanvas;
    FCaptionTextColor: TColor;
    FCaption3D: boolean;
    FSetBorders: Boolean;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMSize (var Msg : TWMSize); message WM_SIZE;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure SetLabel(mo, ye: word);
    procedure ChangeMonth(dx: integer);
    procedure ChangeYear(dx: integer);
    procedure DiffCheck(dt1, dt2: tdatetime);
    function DiffMonth(dx: integer): TDateTime;
    function DiffYear(dx: integer): tdatetime;
    function CheckDateRange(dt: TDateTime): Boolean;
    function CheckMonth(dt: TDateTime): Boolean;
    function DaysInMonth(mo, ye: word): word;
    procedure PaintArrowLeft;
    procedure PaintArrowRight;
    procedure PaintDblArrowLeft;
    procedure PaintDblArrowRight;
    procedure PaintLabel;
    procedure PaintProc;
//    procedure PaintToday;
    procedure SetBorders;
    procedure SetLook(AValue: BAAdvCalendarLook);
    procedure SetDayFont(AValue: TFont);
    procedure SetTextColor(AColor: TColor);
    procedure SetFocusColor(AColor: TColor);
    procedure SetInversColor(AColor: TColor);
    procedure SetSelectColor(AColor: TColor);
    procedure SetSelectFontColor(AColor: TColor);
    procedure SetInactiveColor(AColor: TColor);
    procedure SetHeaderColor(AColor: TColor);
    procedure FontChanged(Sender: TObject);
    procedure SetFont(Value: TFont);
    procedure SetNameofDays(ANameofDays: TNameOfDays);
    procedure SetNameofMonths(ANameofMonths: TNameOfMonths);
    procedure SetStartDay(AValue: integer);
    procedure SetCalDay(AValue: word);
    procedure SetCalMonth(AValue: word);
    procedure SetCalYear(AValue: word);
    function GetCalDay: word;
    function GetCalMonth: word;
    function GetMonth(var dt: TDateTime): word;
    function GetCalYear: word;
//    function GetYear(dt: TDatetime): integer;
    function DateToRect(dt: TDateTime): TRect;
    function XYToDate(X, Y: integer; Change: Boolean): TDateTime;
    function GetDateProc: TDateTime;
    procedure SetDateProc(const Value: TDatetime);
    procedure DoMonthPopup;
    procedure DoYearPopup;
    procedure PropsChanged(Sender: TObject);
    procedure SetShowDaysAfter(const Value: Boolean);
    procedure SetShowDaysBefore(const Value: Boolean);
    procedure SetShowSelection(const Value: Boolean);
    procedure SetCaptionColor(const Value: TColor);
    procedure SetHintPrevYear(AValue: String);
    procedure SetHintPrevMonth(AValue: String);
    procedure SetHintNextMonth(AValue: String);
    procedure SetHintNextYear(AValue: String);
    function NumRows: Integer;
    function NumCols: Integer;
    procedure SetCaptionTextColor(const Value: TColor);
    procedure SetCaption3D(Value: boolean);
    function IsVisibleDay(dt:TDateTime): Boolean;
  protected
    procedure DoPaint; override;
    procedure RepaintDate(dt: TDateTime); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure KeyPress(var Key: char); override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Loaded; override;
    function HasEvent(dt: TDateTime; var EventItem: TSelDateItem): Boolean; virtual;
    procedure DoChangeMonth(dt1, dt2: TDateTime); virtual;
    procedure DoChangeYear(dt1, dt2: TDateTime); virtual;
    procedure YearStartChanged(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetDate(da, mo, ye: word);
    procedure GetDate(var da, mo, ye: word);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure ResetUpdate;
    function DateAtXY(x,y: Integer; var ADate: TDateTime): Boolean;
    function DateToXY(dt: TDateTime): TPoint;    
    property Date: TDatetime read GetDateProc write SetDateProc;
  published
    property Align;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property Browsers: TCalendarBrowsers read FBrowsers write FBrowsers;
    property Caption3D: boolean read FCaption3D write SetCaption3D;
    property Color;
    property Cursor;
    property DragMode;

    property Look: BAAdvCalendarLook read fLook write SetLook;
    property DayFont: TFont read FDayFont write SetDayFont;
    property TextColor: TColor read FTextColor write SetTextColor;
    property SelectColor: TColor read FSelectColor write SetSelectColor;
    property SelectFontColor: TColor read FSelectFontColor write SetSelectFontColor;
    property InActiveColor: TColor read FInactiveColor write SetInactiveColor;
    property HeaderColor: TColor read FHeaderColor write SetHeaderColor;
    property FocusColor: TColor read FFocusColor write SetFocusColor;
    property InversColor: TColor read FInversColor write SetInversColor;
    property NameOfDays: TNameOfDays read FNameOfDays write SetNameOfDays;
    property NameOfMonths: TNameOfMonths read FNameOfMonths write SetNameOfMonths;
    property MaxDate: TMinMaxDate read FMaxDate write FMaxDate;
    property MinDate: TMinMaxDate read FMinDate write FMinDate;
    property PopupMenu;
    property ShowDaysBefore: Boolean read FShowDaysBefore write SetShowDaysBefore default True;
    property ShowDaysAfter: Boolean read FShowDaysAfter write SetShowDaysAfter default True;
    property ShowSelection: Boolean read FShowSelection write SetShowSelection default True;
    property StartDay: integer read FStartDay write SetStartDay;
    property YearStartAt: TYearStartAt read FYearStartAt write FYearStartAt;

    property Day: word read GetCalDay write SetCalDay default 1;
    property Month: word read GetCalMonth write SetCalMonth default 1;
    property Year: word read GetCalYear write SetCalYear default 1;
    property ShowHint;
    property ParentShowHint;
    property TabStop;
    property TabOrder;
    property Font: TFont read fFont write SetFont;
    property CaptionColor: TColor read FCaptionColor write SetCaptionColor;
    property CaptionTextColor: TColor read FCaptionTextColor write SetCaptionTextColor;
    property OnDaySelect: TDaySelectEvent read FOnDaySelect write FOnDaySelect;
    property OnMonthSelect: TNotifyEvent read FOnMonthSelect write FOnMonthSelect;
    property OnMonthChange: TDateChangeEvent read FOnMonthChange write FOnMonthChange;
    property OnYearChange: TDateChangeEvent read FOnYearChange write FOnYearChange;
    property OnDayChange: TDateChangeEvent read FOnDayChange write FOnDayChange;
    property OnCancelledChange: TCancelledChangeEvent read FOnCancelledChange write FOnCancelledChange;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property HintPrevYear: String read FHintPrevYear write SetHintPrevYear;
    property HintPrevMonth: String read FHintPrevMonth write SetHintPrevMonth;
    property HintNextMonth: String read FHintNextMonth write SetHintNextMonth;
    property HintNextYear: String read FHintNextYear write SetHintNextYear;
  end;

  procedure Register;

implementation

constructor BAAdvCalendar.Create(AOwner: TComponent);
var
  VerInfo: TOSVersioninfo;
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls];
  FNameOfDays := TNameofDays.Create;
  FNameOfDays.OnChange := PropsChanged;
  FNameOfMonths := TNameofMonths.Create;
  FNameOfMonths.OnChange := PropsChanged;
  FYearStartAt := TYearStartAt.Create(self);
  FYearStartAt.OnChange := YearStartChanged;
  FDayFont := TFont.Create;
  FFont := TFont.Create;
  FMinDate := TMinMaxDate.Create(self);
  FMaxDate := TMinMaxDate.Create(self);
  FMonthSelect := True;
  xoffset := 0;
  yoffset := 16;
  thedate := Now;
  seldate := thedate;
  ChangeMonth(0);
  flgl := False;
  flgr := False;
  flgla := False;
  flgt := False;
  dflgl := False;
  dflgr := False;
  FUpdateCount := 0;
  Width := 180;
  Height := 180;
  FSelectColor := clTeal;
  FSelectFontColor := clWhite;
  FInactiveColor := clGray;
  FInversColor := clTeal;
  FFocusColor := clHighLight;
  FTextColor := clBlack;
  FHeaderColor := clNone;
  FStartDay := 7;
  BorderWidth := 1;
  BevelOuter := bvNone;
  DecodeDate(theDate, FYear, FMonth, FDay);
  Caption := '';
  Showhintbusy := False;
  FLastHintPos := Point(-1, - 1);
  FFont.OnChange := FontChanged;
  FDayFont.OnChange := FontChanged;
  FBrowsers := TCalendarBrowsers.Create;
  FBrowsers.OnChange := PropsChanged;
  FShowDaysBefore := True;
  FShowDaysAfter := True;
  FShowSelection := True;
  FCaptionColor := clNone;
  FLineColor := clGray;
  FLine3D := true;
{  FGradientStartColor := clWhite;
  FGradientEndColor := clBtnFace;
  FGradientDirection := gdHorizontal;
  FMonthGradientStartColor := clNone;
  FMonthGradientEndColor := clNone;
  FMonthGradientDirection := gdHorizontal;}

  if (csDesigning in ComponentState) then
  begin
    FHintPrevYear := 'Предыдущий год';
    FHintPrevMonth := 'Предыдущий месяц';
    FHintNextMonth := 'Следующий месяц';
    FHintNextYear := 'Следующий год';
  end;

  FCaption3D:= false;

  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(verinfo);
end;

destructor BAAdvCalendar.Destroy;
begin
  FNameOfDays.Destroy;
  FNameOfMonths.Destroy;
  FYearStartAt.Destroy;
  FFont.Free;
  FDayFont.Free;
  FMinDate.Free;
  FMaxDate.Free;
  FBrowsers.Free;
  inherited Destroy;
end;

procedure BAAdvCalendar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure BAAdvCalendar.SetFont(Value: tFont);
begin
  FFont.Assign(Value);
  Canvas.Font.Assign(FFont);
end;

procedure BAAdvCalendar.FontChanged(Sender: TObject);
begin
  Canvas.Font.Assign(Font);
  DoPaint;
end;

procedure BAAdvCalendar.DoEnter;
begin
  inherited DoEnter;
  DoPaint;
end;

procedure BAAdvCalendar.DoExit;
begin
  inherited DoExit;
  DoPaint;
end;

procedure BAAdvCalendar.Loaded;

begin
  inherited Loaded;
  SelDate := EncodeDate(FYear, FMonth, FDay);
  TheDate := SelDate;
  // Make sure all names are initialized to intl. settings when used.
  NameOfDays.UseIntlNames := NameOfDays.UseIntlNames;
  NameOfMonths.UseIntlNames := NameOfMonths.UseIntlNames;
  FHandCursor := LoadCursorW(0, IDC_SIZE);
  FOldCursor := Cursor;
end;

procedure BAAdvCalendar.SetLook(avalue: BAAdvCalendarLook);
begin
  FLook := AValue;
  Invalidate;
end;

procedure BAAdvCalendar.SetDayFont(AValue: TFont);
begin
  if Assigned(AValue) then
    FDayFont.Assign(AValue);
  Invalidate;
end;

procedure BAAdvCalendar.SetTextColor(aColor: TColor);
begin
  FTextColor := AColor;
  Invalidate;
end;

procedure BAAdvCalendar.SetInversColor(AColor: TColor);
begin
  FInversColor := AColor;
  Invalidate;
end;

procedure BAAdvCalendar.SetFocusColor(AColor: TColor);
begin
  FFocusColor := AColor;
  Invalidate;
end;

procedure BAAdvCalendar.SetSelectColor(AColor: TColor);
begin
  FSelectColor := AColor;
  Invalidate;
end;

procedure BAAdvCalendar.SetSelectFontColor(AColor: TColor);
begin
  FSelectFontColor := AColor;
  Invalidate;
end;


procedure BAAdvCalendar.SetInActiveColor(AColor: TColor);
begin
  FInactiveColor := AColor;
  Invalidate;
end;

procedure BAAdvCalendar.SetHeaderColor(AColor: TColor);
begin
  FHeaderColor := Acolor;
  Invalidate;
end;

procedure BAAdvCalendar.SetLabel(mo, ye: word);
begin
  Labels := FNameofMonths.GetMonth(mo) + ' ' + IntToStr(ye);
end;

function BAAdvCalendar.DaysInMonth(mo, ye: word): word;
begin
  if mo <> 2 then
    DaysInMonth := ADaysInMonth[mo]
  else
  begin
    if (ye mod 4 = 0) then DaysInMonth := 29
    else
      DaysInMonth := 28;
    if (ye mod 100 = 0) then DaysInMonth := 28;
    if (ye mod 400 = 0) then DaysInmonth := 29;
  end;
end;

procedure BAAdvCalendar.SetStartDay(AValue: integer);
begin
  if AValue < 1 then
    AValue := 1;
  if AValue > 7 then
    AValue := 7;
  FStartDay := AValue;
  Invalidate;
end;

procedure BAAdvCalendar.SetCalDay(AValue: word);
begin
  try
    SetDate(AValue, FMonth, FYear);
    FDay := AValue;
  except
    MessageDlg('Invalid date', mtError, [mbOK], 0);
  end;
  Invalidate;
end;

procedure BAAdvCalendar.SetCalMonth(AValue: word);
begin
  try
    SetDate(FDay, AValue, FYear);
    FMonth := AValue;
  except
    MessageDlg('Invalid date', mtError, [mbOK], 0);
  end;
  Invalidate;
end;

procedure BAAdvCalendar.SetCalYear(AValue: word);
begin
  try
    SetDate(FDay, FMonth, AValue);
    FYear := AValue;
  except
    MessageDlg('Invalid date', mtError, [mbOK], 0);
  end;
  Invalidate;
end;

function BAAdvCalendar.GetCalDay: word;
var
  da, mo, ye: word;
begin
  GetDate(da, mo, ye);
  Result := da;
end;

function BAAdvCalendar.GetCalMonth: word;
var
  da, mo, ye: word;
begin
  GetDate(da, mo, ye);
  Result := mo;
end;

function BAAdvCalendar.GetMonth(var dt: TDateTime): word;
var
  da, mo, ye: word;
begin
  DecodeDate(dt, ye, mo, da);
  Result := mo;
end;


function BAAdvCalendar.GetCalYear: word;
var
  da, mo, ye: word;
begin
  GetDate(da, mo, ye);
  Result := ye;
end;
{
function BAAdvCalendar.GetYear(dt: tdatetime): integer;
var
  da, mo, ye: word;
begin
  DecodeDate(dt, ye, mo, da);
  Result := ye;
end;
}
procedure BAAdvCalendar.SetNameofDays(ANameofDays: TNameofDays);
begin
  FNameofDays := ANameofDays;
  Invalidate;
end;

procedure BAAdvCalendar.SetNameofMonths(ANameofMonths: TNameofMonths);
begin
  FNameofMonths := ANameofMonths;
  Invalidate;
end;

procedure BAAdvCalendar.ChangeMonth(dx: integer);
var
  ye, mo, da: word;
  dt: TDateTime;
begin
  DecodeDate(thedate, ye, mo, da);

  mo := mo + dx;

  while mo > 12 do
  begin
    Inc(ye);
    mo := mo - 12;
  end;

  if mo = 0 then
  begin
    Dec(ye);
    mo := 12;
  end;

  if da > DaysInMonth(mo, ye) then
    da := DaysInMonth(mo, ye);

  dt := EncodeDate(ye, mo, da);

  if CheckDateRange(dt) then
  begin
    thedate := dt;
    seldate := thedate;
    SetLabel(mo, ye);
    Invalidate;
  end
  else
  begin
    if MinDate.Use then
      if dt < MinDate.Date then
        dt := MinDate.Date;

    if MaxDate.Use then
      if dt > MaxDate.Date then
        dt := MaxDate.Date;


    thedate := dt;

    DecodeDate(dt,ye,mo,da);

    seldate := thedate;
    SetLabel(mo, ye);
    Invalidate;
  end;
end;

function BAAdvCalendar.CheckDateRange(dt: TDatetime): Boolean;
begin
  Result :=
    (not FMinDate.Use or (EncodeDate(FMinDate.Year, FMinDate.Month, FMinDate.Day) <= dt))
    and
    (not FMaxDate.Use or (EncodeDate(FMaxDate.Year, FMaxDate.Month, FMaxDate.Day) >= dt));
end;

function BAAdvCalendar.CheckMonth(dt: TDatetime): Boolean;
begin
  Result :=
    (not FMinDate.Use or (EncodeDate(FMinDate.Year, FMinDate.Month, 1) <= dt))
    and
    (not FMaxDate.Use or (EncodeDate(FMaxDate.Year, FMaxDate.Month, DaysInMonth(FMaxDate.Month,FMaxDate.Year)) >= dt));
end;


procedure BAAdvCalendar.DiffCheck(dt1, dt2: tdatetime);
var
  da1, da2, mo1, mo2, ye1, ye2: word;
begin
  DecodeDate(dt1, ye1, mo1, da1);
  DecodeDate(dt2, ye2, mo2, da2);

  if da1 <> da2 then
  begin
    if Assigned(FOnDayChange) then
      FOnDayChange(self, dt1, dt2);
  end;

  if mo1 <> mo2 then
  begin
    DoChangeMonth(dt1, dt2);
  end;

  if ye1 <> ye2 then
  begin
    DoChangeYear(dt1, dt2);
  end;
end;

function BAAdvCalendar.DiffMonth(dx: integer): tdatetime;
var
  ye, mo, da: word;
  nmo: smallint;
begin
  DecodeDate(thedate, ye, mo, da);
  nmo := mo + dx;
  if nmo > 12 then
  begin
    nmo := nmo - 12;
    Inc(ye);
  end;
  if nmo < 1 then
  begin
    nmo := nmo + 12;
    Dec(ye);
  end;

  if dx < 0 then
    da := DaysInMonth(nmo,ye)
  else
    da := 1;

  Result := EncodeDate(ye, nmo, da);
end;

function BAAdvCalendar.DiffYear(dx: integer): tdatetime;
var
  ye, mo, da: word;
begin
  DecodeDate(thedate, ye, mo, da);
  ye := ye + dx;
  if da > DaysInMonth(mo, ye) then
    da := DaysInMonth(mo, ye);
  Result := EncodeDate(ye, mo, da);
end;

procedure BAAdvCalendar.ChangeYear(dx: integer);
var
  ye, mo, da: word;
  dt: TDatetime;
begin
  DecodeDate(thedate, ye, mo, da);
  ye := ye + dx;
  dt := EncodeDate(ye, mo, da);
  if CheckDateRange(dt) then
  begin
    thedate := dt;
    seldate := thedate;
    SetLabel(mo, ye);
    DoPaint;
  end;
end;

procedure BAAdvCalendar.PaintArrowLeft;
var
  xoffs: integer;
begin
  if Browsers.PrevYear then
    xoffs := XOffset + 20
  else
    xoffs := XOffset;

  with FCanvas do
    begin
      if flgl then
      begin
        Brush.Color := FSelectColor;
        Pen.Color := FSelectColor;
      end
      else
      begin
        Brush.Color := FCaptionTextColor;
        Pen.Color := FCaptionTextColor;
      end;

      if not CheckDateRange(Diffmonth(-1)) then
      begin
        Brush.Color := FInactiveColor;
        Pen.Color := FInactiveColor;
      end;
      Polygon([Point(xoffs + 10, 1 + BorderWidth+2), Point(xoffs + 5, 6 + BorderWidth+2), Point(xoffs + 10, 11 + BorderWidth+2)]);
      Brush.Color := Color;
  end;
end;

procedure BAAdvCalendar.PaintArrowRight;
var
  xoffs: Integer;
begin
  if Browsers.NextYear then
    xoffs := 25
  else
    xoffs := 5;

  with FCanvas do
  begin
    if flgr then
      begin
        Brush.Color := FSelectcolor;
        Pen.Color := FSelectcolor;
      end
      else
      begin
        Brush.Color := FCaptionTextColor;
        Pen.Color := FCaptionTextColor;
      end;

      if not CheckDateRange(diffmonth(+1)) then
      begin
        Brush.Color := FInactiveColor;
        Pen.Color := FInactiveColor;
      end;
    Polygon([Point(Width - 5 - xoffs, 1 + BorderWidth+2), Point(Width - 5 - xoffs, 11 + BorderWidth+2), Point(Width - xoffs, 6 + BorderWidth+2)]);
    Brush.Color := Color;
  end;
end;

procedure BAAdvCalendar.PaintDblArrowLeft;
begin
  with FCanvas do
  begin
    if dflgl then
      begin
        Brush.Color := FSelectColor;
        Pen.Color := FSelectColor;
      end
      else
      begin
        Brush.Color := FCaptionTextColor;
        Pen.Color := FCaptionTextColor;
      end;

      if not checkdaterange(diffyear(-1)) then
      begin
        Brush.Color := FInactiveColor;
        Pen.Color := FInactiveColor;
      end;

      Polygon([Point(xoffset + 10, 1 + BorderWidth+2), Point(xoffset + 5, 6 + BorderWidth+2), Point(xoffset + 10, 11 + BorderWidth+2)]);
      Polygon([Point(xoffset + 15, 1 + BorderWidth+2), Point(xoffset + 10, 6 + BorderWidth+2), Point(xoffset + 15, 11 + BorderWidth+2)]);

      Brush.Color := Color;
    end;
end;

procedure BAAdvCalendar.PaintDblArrowRight;
begin
  with FCanvas do
  begin
    if dflgr then
      begin
        Brush.Color := FSelectColor;
        Pen.Color := FSelectColor;
      end
      else
      begin
        Brush.Color := FCaptionTextColor;
        Pen.Color := FCaptionTextColor;
      end;

      if not Checkdaterange(diffyear(+1)) then
      begin
        Brush.Color := FInactiveColor;
        Pen.Color := FInactiveColor;
      end;

      Polygon([Point(Width - 10, 1 + BorderWidth+2), Point(Width - 10, 11 + BorderWidth+2), Point(Width - 5, 6 + BorderWidth+2)]);
      Polygon([Point(Width - 15, 1 + BorderWidth+2), Point(Width - 15, 11 + BorderWidth+2), Point(Width - 10, 6 + BorderWidth+2)]);

      Brush.Color := Color;
    end;
end;

procedure BAAdvCalendar.PaintLabel;
var
  l, yw: longint;
begin
  with FCanvas do
  begin
    FCanvas.Font.Assign(FFont);
    l := TextWidth(labels);
    yw := TextWidth(' 9999');

    if flgla then
      Font.Color := FSelectColor
    else
      Font.Color := FCaptionTextColor;

    SetBKMode(FCanvas.Handle, TRANSPARENT);

    TextOut(xoffset + ((self.Width - loword(l) - xoffset) shr 1), 2, labels);
    Font.Color := FTextColor;
    lblx1 := (self.Width - loword(l) - xoffset) shr 1;
    lblx2 := lblx1 + loword(l) - yw;
    lblx3 := lblx1 + loword(l);
  end;
end;

procedure BAAdvCalendar.PaintProc;
var
  i, j,w: word;
  da, mo, ye, pmo, pye, nmo, nye, sda, cda, cmo, cye, wfh: word;
  fd: integer;
  d: TDateTime;
  dstr: string;
  isEvent: Boolean;
  r: TRect;
  oldStyle: TFontStyles;
  EventDate: TSelDateItem;

  function SmallCaps(s: string): string;
  var
    buf: array[0..10] of char;
  begin
    strpcopy(buf, s);
    strlower(buf);
    s := strpas(buf);
    s[1] := upcase(s[1]);
    SmallCaps := s;
  end;

begin
  if not Assigned(FNameofDays) then
    Exit;
  if not Assigned(FNameofMonths) then
    Exit;

  DecodeDate(SelDate, ye, mo, sda);
  DecodeDate(TheDate, ye, mo, da);
  DecodeDate(Now, cye, cmo, cda);

  FCanvas.Font.Assign(FFont);

  dx := (self.Width - NumCols) div NumCols;
  dy := (Height + 8) div NumRows;

  XOffset := BorderWidth;

  if FBrowsers.FPrevMonth then PaintArrowLeft;
  if FBrowsers.FNextMonth then PaintArrowRight;
  if FBrowsers.FPrevYear then PaintDblArrowLeft;
  if FBrowsers.FNextYear then PaintDblArrowRight;

  PaintLabel;

  d := EncodeDate(ye, mo, 1);

  //first day of the month
  fd := DayOfWeek(d) - 1 - StartDay;

  if fd < 0 then
    fd := fd + 7;

  //determine previous month
  if mo = 1 then
  begin
    pmo := 12;
    pye := ye - 1;
  end
  else
  begin
    pmo := mo - 1;
    pye := ye;
  end;

  //determine next month
  if mo = 12 then
  begin
    nmo := 1;
    nye := ye + 1;
  end
  else
  begin
    nmo := mo + 1;
    nye := ye;
  end;

  with FCanvas do
  begin
    FCanvas.Font.Assign(FDayfont);
    SetBKMode(Handle, TRANSPARENT);

// вычисление максимальной высоты символов текста
    r := rect(0,0,100,100);
    dstr := '0';
    wfh := DrawText(FCanvas.Handle, PChar(dstr), length(dstr), r, DT_CENTER or DT_TOP or DT_SINGLELINE or DT_CALCRECT);
// ----------------------------------------------

    w:=Width div 7;
    if HeaderColor <> clNone then
      begin
        FCanvas.Brush.Color := HeaderColor;
        FCanvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);
      end;
    for i:=0 to 6 do
      begin
        dstr := FNameofDays.GetDay(i + startday);
        r:=rect(BorderWidth+w*i, dy-7, w+(w*i)+1, wfh+dy-4);
        Brush.Color:=clScrollBar;
        FillRect(r);
        Frame3D(FCanvas, r, clWhite, clGray, 1);
        DrawText(FCanvas.Handle, PChar(dstr), length(dstr), r, DT_CENTER or DT_SINGLELINE);
      end;

    FCanvas.Brush.Color := self.Color;
    FCanvas.Font.Assign(FFont);
    OldStyle := Font.Style;

    SetBKMode(FCanvas.Handle, TRANSPARENT);

    {draw day numbers}
    for i := 1 to 7 do
      for j := 1 to 6 do
      begin
        r.right := xoffset + i * dx + 2;
        r.top := j * dy + yoffset - 2;
        r.bottom := r.top + dy;
        r.left := r.right - dx + 2;

        Font.Style := OldStyle;

        if (fd >= (i + (j - 1) * 7)) then
        begin
          if FShowDaysBefore then
          begin
            d := EncodeDate(pye, pmo, daysinmonth(pmo, pye) - (fd - i));
            IsEvent := HasEvent(d, EventDate);

            Font.Color := FInversColor;

            if IsEvent then
            begin
              Font.Style := [fsBold];
             // Font.Color := clLime;
              FCanvas.Font.Color := EventDate.FontColor;
            end;

            if not CheckDateRange(d) then Font.Color := FInactiveColor;

            dstr := IntToStr(daysinmonth(pmo, pye) - (fd - i));

            SetBKMode(FCanvas.Handle, TRANSPARENT);

              Drawtext(FCanvas.Handle, PChar(dstr), length(dstr), r,
                DT_CENTER or DT_VCENTER or DT_SINGLELINE);

            Brush.Color := self.Color;
            Pen.Color := FTextcolor;
          end;
        end
        else
        begin
          if ((i + (j - 1) * 7 - fd) > DaysInMonth(mo, ye)) then
          begin
            if FShowDaysAfter then
            begin
              d := EncodeDate(nye, nmo, i + (j - 1) * 7 - fd - daysinmonth(mo, ye));
              Font.Color := FInversColor;
              Brush.Color := Color;
              if not checkdaterange(d) then font.color := fInactiveColor;

              IsEvent := HasEvent(d, EventDate);

              if IsEvent then
              begin
                Font.Style := [fsBold];
              //  Font.Color := clLime;
                FCanvas.Font.Color := EventDate.FontColor;
              end;

              dstr := IntToStr(i + (j - 1) * 7 - fd - daysinmonth(mo, ye));
              SetBKMode(FCanvas.Handle, TRANSPARENT);
              

              DrawText(FCanvas.Handle, PChar(dstr), length(dstr), r, DT_CENTER or DT_VCENTER or DT_SINGLELINE);

              Brush.Color := self.Color;
              Pen.Color := FTextColor;
            end;
          end
          else
          begin
            Brush.Color:=InversColor;
            Font.Color := FInActiveColor;
// -------- Выделяем текущий день --------------
        if (da = i + (j - 1) * 7 - fd) then
          begin
            Font.Color := SelectFontColor;
            Brush.Color:=SelectColor;
            FillRect(r);
          end;
// ---------------------------------------------

        if fLook = Look3d then
          Frame3d(canvas, r, clWhite, clGray, 1);
        SetBKMode(FCanvas.Handle, TRANSPARENT);
      //  Font.Style := [fsBold];

        DrawText(FCanvas.Handle, PChar(IntToStr(i + (j - 1) * 7 - fd)),length(IntToStr(i + (j - 1) * 7 - fd)), r, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
        Brush.Color := self.Color;
        Pen.Color := FTextColor;
      end;
    end;

// Рисуем рамку на выделенном поле с датой ---------------------------------------------------------------------------------
        if (GetFocus = self.Handle) and (da = i + (j - 1) * 7 - fd) then
          begin
            Pen.Color:=clRed;
            Brush.Color:=SelectColor;
            FillRect(r);
            DrawText(FCanvas.Handle, PChar(IntToStr(da)), length(IntToStr(da)), r, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
            WinProcs.DrawFocusRect(FCanvas.Handle, r);
          end;
// --------------------------------------------------------------------------------------------------------------------------

      end;
  end;
end;

procedure BAAdvCalendar.SetBorders;
var
  i: Integer;
begin
  if FSetBorders then exit;
  FSetBorders := true;
  i:=0;
  while (((width-i-BorderWidth*2) mod 7)<>0) do
    begin
      inc(i)
    end;
  SetBounds(Left, Top, width-i, height);
  FSetBorders := false;
end;

procedure BAAdvCalendar.SetDate(da, mo, ye: word);
var
  R: TRect;
  dt: TDateTime;
begin
  r := DateToRect(SelDate);

  dt := EncodeDate(ye, mo, da);
  TheDate := dt;
  SelDate := thedate;

  InvalidateRect(Handle, @r, False);

  SetLabel(mo, ye);
  InitDate := SelDate;

  Invalidate;
end;

procedure BAAdvCalendar.GetDate(var da, mo, ye: word);
begin
  DecodeDate(seldate, ye, mo, da);
end;

procedure BAAdvCalendar.RepaintDate(dt: tdatetime);
var
  pt: TPoint;
  r: TRect;
begin
  if FUpdateCount > 0 then
    Exit;
  pt := DateToXY(dt);
  if pt.x = 0 then pt.x := 7;
  r.top := yoffset + (pt.y) * dy - 2;
  r.bottom := r.top + dy;
  r.left := xoffset + (pt.x - 1) * dx;
  r.right := r.left + dx + 2;
  InvalidateRect(self.handle, @r, True);
end;

function BAAdvCalendar.DateToRect(dt: tdatetime): trect;
var
  pt: tpoint;
  r: trect;
begin
  pt := datetoxy(dt);
  if pt.x = 0 then pt.x := 7;
  r.top := yoffset + (pt.y) * dy - 2;
  r.bottom := r.top + dy;
  r.left := xoffset + (pt.x - 1) * dx;
  r.right := r.left + dx + 2;
  Result := r;
end;

function BAAdvCalendar.DateToXY(dt: tdatetime): tpoint;
var
  ye, mo, da: word;
  tmpdt: tdatetime;
  fd: integer;
  rx, ry: integer;

begin
  decodedate(thedate, ye, mo, da);

  tmpdt := encodedate(ye, mo, 1);  {first day of month}

  fd := dayofweek(tmpdt) - 1 - startday;

  if fd < 0 then fd := fd + 7;

  tmpdt := tmpdt - fd; {this is the first day of the calendar}
  fd := round(dt - tmpdt) + 1;

  rx := (fd mod 7);
  ry := (fd div 7) + 1;

  if (rx = 0) then
  begin
    rx := 7;
    dec(ry);
  end;
  Result.x := rx;
  Result.y := ry;
end;

function BAAdvCalendar.DateAtXY(X,Y: Integer; var ADate: TDateTime): Boolean;
begin
  Result := False;
  if (X > Xoffset) and (Y > dy) then
  begin
    ADate := XYToDate(X - Xoffset,Y,False);
    Result := True;
  end;
end;

function BAAdvCalendar.XYToDate(X, Y: integer; change: Boolean): tdatetime;
var
  ye, mo, da: word;
  xcal, ycal: integer;
  sda, fd: integer;
  tmpdt: tdatetime;
begin
  xposin := x;
  yposin := y;
  xcal := 0;
  ycal := 0;

  DecodeDate(seldate, ye, mo, da);

  tmpdt := EncodeDate(ye, mo, 1);

  fd := DayOfWeek(tmpdt) - 1 - StartDay;

  if (fd < 0) then fd := fd + 7;

  if (dx > 0) and (dy > 0) then
  begin
    xcal := x div dx;
    ycal := ((y - yoffset) - dy) div dy;
  end;

  if xcal > 6 then xcal := 6;
  if ycal > 5 then ycal := 5;

  sda := xcal + 7 * ycal - fd + 1;

  if sda < 1 then
  begin
    Dec(mo);
    if mo = 0 then
    begin
      mo := 12;
      Dec(ye);
    end;
    sda := DaysInMonth(mo, ye) + sda;
    if Change and FShowDaysBefore then
      ChangeMonth(-1);
  end;

  if sda > DaysInMonth(mo, ye) then
  begin
    sda := sda - DaysInMonth(mo, ye);
    Inc(mo);
    if mo > 12 then
    begin
      mo := 1;
      Inc(ye);
    end;
    if Change and FShowDaysAfter then
      ChangeMonth(+1);
  end;

  da := sda;
  Result := EncodeDate(ye, mo, da);
end;


procedure BAAdvCalendar.MouseMove(Shift: TShiftState; X, Y: integer);
var
  dt: TDateTime;
  newpt: TPoint;
  WidthX1, WidthX2,HeightY1, HeightY2: integer;

begin
  if Assigned(OnMouseMove) then
    OnMouseMove(Self, Shift, X, Y);

    WidthX1 := 0;
    WidthX2 := 0;
    HeightY1 := 0;
    HeightY2 := 0;

  x := x - xoffset;

  if (x >= lblx1) and (x <= lblx3) and (y > 0) and (y < 15) and FMonthSelect then
  begin
    if not flgla then
    begin
      flgla := True;
      PaintLabel;
    end;
  end
  else if flgla then
  begin
    flgla := False;
    PaintLabel;
  end;

    if flgt then
    begin
      flgt := False;
      Cursor := FOldCursor;
    end;

  BrowserHint := '';

  if FBrowsers.FPrevMonth then
  begin
    WidthX1 := 25;
    WidthX2 := 35;
    HeightY1 := 0;
    HeightY2 := 15;
    end;

    if not FBrowsers.FPrevYear then
    begin
      WidthX1 := WidthX1 - 20;
      WidthX2 := WidthX2 - 20;
    end;

    if (x > WidthX1) and (x < WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      Cursor := crHandPoint;
      BrowserHint := FHintPrevMonth;
      FLastHintPos := Point(WidthX1,-8);

      if not flgl then
      begin
        flgl := True;
        PaintArrowLeft;
      end;
    end
    else
    begin
      if flgl then
      begin
        Cursor := FOldCursor;
        flgl := False;
        PaintArrowLeft;
      end;
    end;

  if FBrowsers.FPrevYear then
  begin
    WidthX1 := 5;
    WidthX2 := 15;
    HeightY1 := 0;
    HeightY2 := 15;
  end;

    if (x > WidthX1) and (x < WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      Cursor := crHandPoint;
      BrowserHint := FHintPrevYear;
      FLastHintPos := Point(WidthX1,-8);

      if not dflgl then
      begin
        dflgl := True;
        PaintDblArrowLeft;
      end;
    end
    else
    begin
      if dflgl then
      begin
        Cursor := FOldCursor;
        dflgl := False;
        PaintDblArrowLeft;
      end;
    end;

  if FBrowsers.FNextMonth then
  begin
    WidthX1 := 30;
    WidthX2 := 25;
    HeightY1 := 0;
    HeightY2 := 15;
  end;

    if not FBrowsers.NextYear then
    begin
      WidthX1 := WidthX1 - 20;
      WidthX2 := WidthX2 - 20;
    end;

    if (x + xoffset > Width - WidthX1) and (x + xoffset < Width - WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      Cursor := crHandPoint;
      BrowserHint := FHintNextMonth;
      FLastHintPos := Point(Width - WidthX1,-8);
      if not flgr then
      begin
        flgr := True;
        PaintArrowRight;
      end;
    end
    else
    begin
      if flgr then
      begin
        Cursor := FOldCursor;
        flgr := False;
        PaintArrowRight;
      end;
    end;

  if FBrowsers.FNextYear then
  begin
    WidthX1 := 15;
    WidthX2 := 5;
    HeightY1 := 0;
    HeightY2 := 15;
  end;

    if (x + xoffset > Width - WidthX1) and (x + xoffset < Width - WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      Cursor := crHandPoint;
      BrowserHint := FHintNextYear;
      FLastHintPos := Point(Width - WidthX1,-8);
      if dflgr = False then
      begin
        dflgr := True;
        PaintDblArrowRight;
      end;
    end
    else
    begin
      if dflgr then
      begin
        Cursor := FOldCursor;
        dflgr := False;
        PaintDblArrowRight;
      end;
    end;

  if not (flgl or flgr or dflgl or dflgr or flgt) and (Cursor <> FOldCursor) then
  begin
    Cursor := FOldCursor;
  end;

  EventHint := '';

  if (y > dy + yoffset) and (MouseSel) then
  begin
    dt := XYToDate(X, Y, False);

    if (dx > 0) and (dy > 0) then
    begin
      newpt.x := x div dx;
      newpt.y := ((y - yoffset) - dy) div dy;
    end;

    if ((newpt.x <> flasthintpos.x) or
      (newpt.y <> flasthintpos.y)) and ShowHintBusy then
    begin
      Application.CancelHint;
      ShowHintbusy := False;
    end;

    FLastHintPos := newpt;

    if MouseSel and (MovDate <> dt) and CheckDateRange(dt) then
      MovDate := dt;
  end;

  if (EventHint = '') and (BrowserHint = '') then
   Application.CancelHint;
end;

function BAAdvCalendar.IsVisibleDay(dt: TDateTime): Boolean;
begin
  Result := False;
  if (GetMonth(dt) > GetMonth(SelDate)) and not FShowDaysAfter then
    Exit;

  if (GetMonth(dt) < GetMonth(SelDate)) and not FShowDaysBefore then
    Exit;

  Result := True;
end;

procedure BAAdvCalendar.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  ye, da, omo, nmo: word;
  origdate: TDatetime;
  r: TRect;
  flg: Boolean;
  WidthX1, WidthX2,HeightY1, HeightY2: integer;

begin
  if (Button <> mbLeft) then
  begin
    inherited;
    Exit;
  end
  else
    if Assigned(OnMouseDown) then
      OnMouseDown(Self,Button, Shift, X, Y);


  origdate := seldate;
  xposin := $7fff;
  yposin := $7fff;

    WidthX1 := 0;
    WidthX2 := 0;
    HeightY1 := 0;
    HeightY2 := 0;

  if not (GetFocus = self.Handle) then
    SetFocus;

  x := x - xoffset;

  if (x >= lblx1) and (x <= lblx2) and (y > 0) and (y < 15) then
  begin
    DoMonthPopup;
    Exit;
  end;

  if (x >= lblx2) and (x <= lblx3) and (y > 0) and (y < 15) then
  begin
    DoYearPopup;
    Exit;
  end;

  flg := False;

  if FBrowsers.FPrevMonth then
  begin
    WidthX1 := 25;
    WidthX2 := 35;
    HeightY1 := 0;
    HeightY2 := 15;
  end;

    if not FBrowsers.PrevYear then
    begin
      WidthX1 := WidthX1 - 20;
      WidthX2 := WidthX2 - 20;
    end;

    if (x > WidthX1) and (x < WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      ChangeMonth(-1);
      flg := True;
    end;

  if FBrowsers.FPrevYear then
  begin
    WidthX1 := 5;
    WidthX2 := 15;
    HeightY1 := 0;
    HeightY2 := 15;
  end;

    if (x > WidthX1) and (x < WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      ChangeYear(-1);
      flg := True;
    end;

  if FBrowsers.FNextMonth then
  begin
    WidthX1 := 30;
    WidthX2 := 25;
    HeightY1 := 0;
    HeightY2 := 15;
  end;

    if not FBrowsers.NextYear then
    begin
      WidthX1 := WidthX1 - 20;
      WidthX2 := WidthX2 - 20;
    end;


    if (x + xoffset > Width - WidthX1) and (x + xoffset < Width - WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      ChangeMonth(1);
      flg := True;
    end;

  if FBrowsers.FNextYear then
  begin
    WidthX1 := 15;
    WidthX2 := 5;
    HeightY1 := 0;
    HeightY2 := 15;
  end;

    if (x + xoffset > Width - WidthX1) and (x + xoffset < Width - WidthX2) and (y > HeightY1) and (y < HeightY2) then
    begin
      ChangeYear(1);
      flg := True;
    end;

  if flg then
  begin
    DiffCheck(origdate, seldate);
    Exit;
  end;
  movdate := -1;

  SetCapture(Handle);

  if (y > dy + yoffset) and (x > 0) and
     not ({FShowGotoToDay and} (y > dy * 8 - dy div 2)) then
  begin
    ClkDate := XYToDate(X, Y, True);

    if not IsVisibleDay(ClkDate) then
      Exit;

    if not CheckDateRange(clkdate) then
      Exit;

      seldate := clkdate;
      thedate := seldate;

    DecodeDate(origdate, ye, omo, da);
    DecodeDate(clkdate, ye, nmo, da);

    if (omo = nmo) then
    begin
      r := DateToRect(origdate);
      InvalidateRect(self.Handle, @r, True);
      r := DatetoRect(thedate);
      InvalidateRect(self.Handle, @r, True);
    end
    else
      DoPaint;

    SetLabel(nmo, ye);
    DiffCheck(origdate, seldate);
  end;
end;

procedure BAAdvCalendar.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (Button <> mbLeft) then
  begin
    inherited;
    Exit;
  end
  else
    if Assigned(OnMouseUp) then
      OnMouseUp(Self,Button, Shift, X, Y);

  mousesel := False;

  ReleaseCapture;

  x := x - xoffset;

  if (Abs(x - xposin) < 4) and (Abs(y - yposin) < 4) then
  begin
    if Assigned(FOnDaySelect) then
      FOnDaySelect(Self, XYToDate(x,y,false));
  end;
end;

procedure BAAdvCalendar.Paint;
var
  r,captionR: TRect;

  function Max(a, b: integer): integer;
  begin
    if a > b then
      Result := a
    else
      Result := b;
  end;

begin
  Caption := '';

  inherited Paint;

  FCanvas := Canvas;

  if FUpdateCount > 0 then
    Exit;

  r := ClientRect;
  InflateRect(r, - BorderWidth, - BorderWidth);
  if (BevelInner <> bvNone) or (BevelOuter <> bvNone) then
    InflateRect(r, - BevelWidth, - BevelWidth);

  Canvas.Brush.Color := Color;
  Canvas.Pen.Color := Color;
  Canvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);

  if CaptionColor <> clNone then
  begin
    captionR.Top := BorderWidth;
    captionR.Left := BorderWidth;
    captionR.Right := Width - BorderWidth;
    FCanvas.Font.Assign(Font);
    captionR.Bottom := Canvas.TextHeight('X') + 5;
    FCanvas.Brush.Color := CaptionColor;
    if FCaption3D then
      FCanvas.Pen.Color := clGray
    else
      FCanvas.Pen.Color := CaptionColor;
    FCanvas.Rectangle(captionR.Left,captionR.Top,captionR.Right,captionR.Bottom);
    if FCaption3D then
    begin
      FCanvas.Pen.Color := clWhite;
      FCanvas.MoveTo(captionR.Left,captionR.Bottom);
      FCanvas.LineTo(captionR.Left,captionR.Top);
      FCanvas.LineTo(captionR.Right,captionR.Top);
    end;
  end;

  PaintProc;
end;

procedure BAAdvCalendar.KeyPress(var Key: char);
begin
  if (key = #27) then seldate := initdate;
  inherited;
end;

procedure BAAdvCalendar.CMMouseLeave(var Message: TMessage);
var
  r: trect;
begin
  inherited;
  if flgl or flgr or flgla or dflgl or dflgr or flgt then
  begin
    flgl := False;
    flgr := False;
    flgla := False;
    dflgl := False;
    dflgr := False;
    flgt := False;
    r := GetClientRect;
    r.bottom := (r.bottom - r.top) div 7;
    Invalidaterect(self.handle, @r, True);
  end;
end;

procedure BAAdvCalendar.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if Msg.CharCode in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT] then
    Msg.Result := 1;
end;

procedure BAAdvCalendar.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Message.Result := 1;
end;

procedure BAAdvCalendar.WMSize (var Msg : TWMSize);
begin
  inherited;
  FSetBorders:=False;
  SetBorders;
end;

procedure BAAdvCalendar.WMKeyDown(var Msg: TWMKeydown);
var
  da, nmo, omo, ye: word;
  origdate: tdatetime;
  dt: tdatetime;
  pt: tpoint;
  r: trect;


begin
  inherited;
  origdate := SelDate;
  pt := DateToXY(seldate);

  DecodeDate(thedate, ye, omo, da);
  case msg.charcode of
    vk_left: dt := thedate - 1;
    vk_right: dt := thedate + 1;
    vk_up: dt := thedate - 7;
    vk_down: dt := thedate + 7;
    else
      dt := thedate;
  end;

  if (GetMonth(dt) > GetMonth(SelDate)) and not FShowDaysAfter then
  begin
    if Assigned(FOnCancelledChange) then
      FOnCancelledChange(Self, dt);
    Exit;
  end;


  if (GetMonth(dt) < GetMonth(SelDate)) and not FShowDaysBefore then
  begin
    if Assigned(FOnCancelledChange) then
      FOnCancelledChange(Self, dt);
    Exit;
  end;

  if CheckDateRange(dt) then
    thedate := dt
  else
    Exit;

  if (Msg.Charcode = VK_SPACE) or
     ((Msg.Charcode = VK_RETURN) and (FReturnIsSelect)) then
  begin
    Invalidate;
    SelDate := thedate;

    if Assigned(OnDaySelect) then
      OnDaySelect(self, theDate);
  end;

  if msg.charcode in [vk_up, vk_down, vk_left, vk_right] then
  begin
    Seldate := thedate;
    Decodedate(thedate, ye, nmo, da);
    SetLabel(nmo, ye);
    movdate := -1;

    if omo = nmo then
    begin
      pt := datetoxy(origdate);
      if pt.x = 0 then pt.x := 7;
      r.top := yoffset + (pt.y) * dy - 2;
      r.bottom := r.top + dy;
      r.left := xoffset + (pt.x - 1) * dx;
      r.right := r.left + dx + 2;
      invalidaterect(self.handle, @r, True);
      pt := datetoxy(thedate);
      if pt.x = 0 then pt.x := 7;
      r.top := yoffset + (pt.y) * dy - 2;
      r.bottom := r.top + dy;
      r.left := xoffset + (pt.x - 1) * dx;
      r.right := r.left + dx + 2;
      invalidaterect(self.handle, @r, True);
    end
    else
      Dopaint;
  end;

  if msg.charcode = VK_PRIOR then
  begin
    Self.Changemonth(-1);
  end;
  if msg.charcode = VK_NEXT then
  begin
    Self.Changemonth(+1);
  end;

  DiffCheck(origdate, seldate);

  if Msg.CharCode in [vk_up, vk_left, vk_right, vk_down, vk_next, vk_prior] then
    Msg.Result := 0;
end;

procedure BAAdvCalendar.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure BAAdvCalendar.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      Invalidate;
  end;
end;

procedure BAAdvCalendar.ResetUpdate;
begin
  FUpdateCount := 0;
end;

{ TNameOfDays }

procedure TNameOfDays.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TNameOfDays.Create;
begin
  inherited Create;
  FUseIntlNames := True;
  InitIntl;
end;

destructor TNameOfDays.Destroy;
begin
  inherited Destroy;
end;

function TNameOfDays.GetDay(i: integer): string;
begin
  case i of
    1, 8: Result := FMonday;
    2, 9: Result := FTuesday;
    3, 10: Result := FWednesday;
    4, 11: Result := FThursday;
    5, 12: Result := FFriday;
    6, 13: Result := FSaturday;
    7, 14: Result := FSunday;
    else
      Result := '';
  end;
end;

procedure TNameOfDays.InitIntl;
begin
  FSunday := ShortDayNames[1];
  FMonday := ShortDayNames[2];
  FTuesday := ShortDayNames[3];
  FWednesday := ShortDayNames[4];
  FThursday := ShortDayNames[5];
  FFriday := ShortDayNames[6];
  FSaturday := ShortDayNames[7];
  Changed;
end;

procedure TNameOfDays.SetFriday(const Value: TDayStr);
begin
  FFriday := Value;
  Changed;
end;

procedure TNameOfDays.SetMonday(const Value: TDayStr);
begin
  FMonday := Value;
  Changed;
end;

procedure TNameOfDays.SetSaturday(const Value: TDayStr);
begin
  FSaturday := Value;
  Changed;
end;

procedure TNameOfDays.SetSunday(const Value: TDayStr);
begin
  FSunday := Value;
  Changed;
end;

procedure TNameOfDays.SetThursday(const Value: TDayStr);
begin
  FThursday := Value;
  Changed;
end;

procedure TNameOfDays.SetTuesday(const Value: TDayStr);
begin
  FTuesday := Value;
  Changed;
end;

procedure TNameOfDays.SetUseIntlNames(const Value: Boolean);
begin
  FUseIntlNames := Value;
  if FUseIntlNames then InitIntl;
end;

procedure TNameOfDays.SetWednesday(const Value: TDayStr);
begin
  FWednesday := Value;
  Changed;
end;

{ TNameOfMonths }

constructor TNameofMonths.Create;
begin
  inherited Create;
  FUseIntlNames := True;
  InitIntl;
end;

destructor TNameOfMonths.Destroy;
begin
  inherited Destroy;
end;

procedure TNameOfMonths.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TNameOfMonths.InitIntl;
begin
  FJanuary := LongMonthNames[1];
  FFebruary := LongMonthNames[2];
  FMarch := LongMonthNames[3];
  FApril := LongMonthNames[4];
  FMay := LongMonthNames[5];
  FJune := LongMonthNames[6];
  FJuly := LongMonthNames[7];
  FAugust := LongMonthNames[8];
  FSeptember := LongMonthNames[9];
  FOctober := LongMonthNames[10];
  FNovember := LongMonthNames[11];
  FDecember := LongMonthNames[12];
  Changed;
end;

procedure TNameOfMonths.SetUseIntlNames(const Value: Boolean);
begin
  FUseIntlNames := Value;
  if FUseIntlNames then InitIntl;
end;

function TNameOfMonths.GetMonth(i: integer): string;
begin
  case i of
    1: Result := FJanuary;
    2: Result := FFebruary;
    3: Result := FMarch;
    4: Result := FApril;
    5: Result := FMay;
    6: Result := FJune;
    7: Result := FJuly;
    8: Result := FAugust;
    9: Result := FSeptember;
    10: Result := FOctober;
    11: Result := FNovember;
    12: Result := FDecember;
    else
      Result := '';
  end;
end;

procedure TNameofMonths.SetApril(const Value: TMonthStr);
begin
  FApril := Value;
  Changed;
end;

procedure TNameofMonths.SetAugust(const Value: TMonthStr);
begin
  FAugust := Value;
  Changed;
end;

procedure TNameofMonths.SetDecember(const Value: TMonthStr);
begin
  FDecember := Value;
  Changed;
end;

procedure TNameofMonths.SetFebruary(const Value: TMonthStr);
begin
  FFebruary := Value;
  Changed;
end;

procedure TNameofMonths.SetJanuary(const Value: TMonthStr);
begin
  FJanuary := Value;
  Changed;
end;

procedure TNameofMonths.SetJuly(const Value: TMonthStr);
begin
  FJuly := Value;
  Changed;
end;

procedure TNameofMonths.SetJune(const Value: TMonthStr);
begin
  FJune := Value;
  Changed;
end;

procedure TNameofMonths.SetMarch(const Value: TMonthStr);
begin
  FMarch := Value;
  Changed;
end;

procedure TNameofMonths.SetMay(const Value: TMonthStr);
begin
  FMay := Value;
  Changed;
end;

procedure TNameofMonths.SetNovember(const Value: TMonthStr);
begin
  FNovember := Value;
  Changed;
end;

procedure TNameofMonths.SetOctober(const Value: TMonthStr);
begin
  FOctober := Value;
  Changed;
end;

procedure TNameofMonths.SetSeptember(const Value: TMonthStr);
begin
  FSeptember := Value;
  Changed;
end;

procedure TYearStartAt.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;

constructor TYearStartAt.Create(AOwner: TBAAdvCustomCalPanel);
begin
  inherited Create;
  FStartDay := 1;
  FStartMonth := 1;
  FOwner := AOwner;
  NextYearStartDay := 1;
  NextYearStartMonth := 1;
  PrevYearStartDay := 1;
  PrevYearStartMonth := 1;
end;

destructor TYearStartAt.Destroy;
begin
  inherited Destroy;
end;

procedure TYearStartAt.SetNextYearStartDay(d: integer);
begin
  if not ValidateDay(d) then
    Exit;
  FNextYearStartDay := d;
  Changed;
end;

procedure TYearStartAt.SetNextYearStartMonth(m: integer);
begin
  if not ValidateMonth(m) then
    Exit;
  FNextYearStartMonth := m;
  Changed;
end;

procedure TYearStartAt.SetPrevYearStartDay(d: integer);
begin
  if not ValidateDay(d) then
    Exit;
  FPrevYearStartDay := d;
  Changed;
end;

procedure TYearStartAt.SetPrevYearStartMonth(m: integer);
begin
  if not ValidateMonth(m) then
    Exit;
  FPrevYearStartMonth := m;
  Changed;
end;

procedure TYearStartAt.SetStartDay(d: integer);
begin
  if not ValidateDay(d) then
    Exit;
  FStartDay := d;
  Changed;
end;

procedure TYearStartAt.SetStartMonth(m: integer);
begin
  if not ValidateMonth(m) then
    Exit;
  FStartMonth := m;
  Changed;
end;

function TYearStartAt.ValidateDay(d: integer): Boolean;
begin
  Result := True;
  if (d <= 0) or (d > 31) then
  begin
    Messagedlg('Invalid day. Should be in [1..31]', mtError, [mbOK], 0);
    Result := False;
  end;
end;

function TYearStartAt.ValidateMonth(m: integer): Boolean;
begin
  Result := True;
  if (m <= 0) or (m > 12) then
  begin
    MessageDlg('Invalid month. Should be in [1..12]', mtError, [mbOK], 0);
    Result := False;
  end;
end;

function BAAdvCalendar.GetDateProc: TDatetime;
begin
  Result := SelDate;
end;

procedure BAAdvCalendar.SetDateProc(const Value: TDatetime);
begin
  DecodeDate(Value, FYear, FMonth, FDay);
  SetDate(FDay, FMonth, FYear);
end;

procedure BAAdvCalendar.DoPaint;
begin
  InvalidateRect(Handle, nil, False);
end;

procedure BAAdvCalendar.DoMonthPopup;
var
  popmenu: THandle;
  buf: array[0..128] of char;
  pt: TPoint;
  ye, mo, da: word;
  flg: integer;
begin
  pt := ClientToScreen(point(0, 0));
  popmenu := CreatePopupMenu;

  DecodeDate(seldate, ye, mo, da);

  if not CheckMonth(EncodeDate(ye, 1, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 1,
    PChar(strpcopy(buf, fnameofmonths.january)));
  if not CheckMonth(encodedate(ye, 2, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 2,
    PChar(strpcopy(buf, fnameofmonths.february)));
  if not CheckMonth(encodedate(ye, 3, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 3,
    PChar(strpcopy(buf, fnameofmonths.march)));
  if not CheckMonth(encodedate(ye, 4, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 4,
    PChar(strpcopy(buf, fnameofmonths.april)));
  if not CheckMonth(encodedate(ye, 5, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 5,
    PChar(strpcopy(buf, fnameofmonths.may)));
  if not CheckMonth(encodedate(ye, 6, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 6,
    PChar(strpcopy(buf, fnameofmonths.june)));
  if not CheckMonth(encodedate(ye, 7, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 7,
    PChar(strpcopy(buf, fnameofmonths.july)));
  if not CheckMonth(encodedate(ye, 8, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 8,
    PChar(strpcopy(buf, fnameofmonths.august)));
  if not CheckMonth(encodedate(ye, 9, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 9,
    PChar(strpcopy(buf, fnameofmonths.september)));
  if not CheckMonth(encodedate(ye, 10, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 10,
    PChar(strpcopy(buf, fnameofmonths.october)));
  if not CheckMonth(encodedate(ye, 11, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 11,
    PChar(strpcopy(buf, fnameofmonths.november)));
  if not CheckMonth(encodedate(ye, 12, 1)) then flg := MF_GRAYED
  else
    flg := 0;
  InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, 12,
    PChar(strpcopy(buf, fnameofmonths.december)));

  TrackPopupMenu(popmenu, TPM_LEFTALIGN or TPM_LEFTBUTTON, pt.x + lblx1 + xoffset,
    pt.y, 0, self.handle, nil);

  DestroyMenu(popmenu);
end;

procedure BAAdvCalendar.DoYearPopup;
var
  popmenu: THandle;
  pt: TPoint;
  i: integer;
  ye, mo, da: word;
  flg: integer;

begin
  pt := ClientToScreen(point(0, 0));
  popmenu := CreatePopupMenu;
  Decodedate(thedate, ye, mo, da);
  if (mo = 2) and (da = 29) then da := 28;

  for i := 1 to 10 do
  begin
    if CheckDateRange(EncodeDate(i + ye - 5, mo, da)) then
      flg := 0
    else
      flg := MF_GRAYED;
    InsertMenu(popmenu, $FFFFFFFF, MF_BYPOSITION or flg, i + 15,
      PChar(IntToStr(i + ye - 5)));
  end;

  TrackPopupMenu(popmenu, TPM_LEFTALIGN or TPM_LEFTBUTTON, pt.x + lblx2 + xoffset,
    pt.y, 0, self.handle, nil);

  DestroyMenu(popmenu);
end;

procedure BAAdvCalendar.WMCommand(var Message: TWMCommand);
var
  ye, mo, da: word;
  origdate: TDateTime;
begin
  if (message.itemid <= 12) and (message.itemid >= 1) then
  begin
    origdate := seldate;
    DecodeDate(thedate, ye, mo, da);
    mo := Message.ItemId;
    thedate := EncodeDate(ye, mo, 1);
    SelDate := thedate;
    SetLabel(mo, ye);
    DoPaint;
    DoChangeMonth(origdate, seldate);
  end;

  if (message.itemid >= 15) and (message.itemid <= 25) then
  begin
    Origdate := SelDate;
    DecodeDate(thedate, ye, mo, da);
    ye := ye + Message.itemid - 20;
    if (mo = 2) and (da = 29) then da := 28;
    thedate := EncodeDate(ye, mo, da);
    seldate := thedate;
    SetLabel(mo, ye);
    DoPaint;
    DoChangeYear(origdate, seldate);
  end;

  inherited;
end;

{ TSelDateItem }

procedure TSelDateItem.Assign(Source: TPersistent);
begin
  FColor := TSelDateItem(Source).Color;
  FDate := TSelDateItem(Source).Date;
  FHint := TSelDateItem(Source).Hint;
  Shape := TSelDateItem(Source).Shape;
  FFontColor := TSelDateItem(Source).FontColor;
end;

destructor TSelDateItem.Destroy;
begin
  inherited;
end;

procedure TSelDateItem.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TSelDateItem.SetDate(const Value: TDateTime);
begin
  if Value <> FDate then
    FDate := Value;
end;

procedure TSelDateItem.SetEventShape(const Value: TEventShape);
begin
  FEventShape := Value;
end;

procedure TSelDateItem.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
end;

procedure TSelDateItem.SetHint(const Value: string);
begin
  FHint := Value;
end;

{ TMinMaxDate }

constructor TMinMaxDate.Create(AOwner: BAAdvCalendar);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TMinMaxDate.GetDate: TDateTime;
begin
  Result := EncodeDate(Year,Month,Day);
end;

procedure TMinMaxDate.SetDate(const Value: TDateTime);
var
  Da,Mo,Ye: word;
begin
  DecodeDate(Value, Ye, Mo, Da);
  FYear := Ye;
  FMonth := Mo;
  FDay := Da;
end;

procedure TMinMaxDate.SetDay(avalue: smallint);
begin
  FDay := AValue;
  FOwner.Invalidate;
end;

procedure TMinMaxDate.SetMonth(avalue: smallint);
begin
  FMonth := AValue;
  FOwner.Invalidate;
end;

procedure TMinMaxDate.SetUse(avalue: Boolean);
begin
  Fuse := AValue;
  FOwner.Invalidate;
end;

procedure TMinMaxDate.SetYear(avalue: smallint);
begin
  FYear := AValue;
  FOwner.Invalidate;
end;

function BAAdvCalendar.HasEvent(dt: TDateTime; var EventItem: TSelDateItem): Boolean;
var
  IsEvent: Boolean;

begin
  EventItem := nil;

  IsEvent := False;
  EventHint := '';

    if Assigned(FOnGetDateEvent) then
      FOnGetDateEvent(Self, dt, IsEvent);

  Result := IsEvent;
end;

procedure BAAdvCalendar.CMHintShow(var Msg: TMessage);
var
  hi: PHintInfo;
  CanShow: Boolean;
begin

  if (BrowserHint <> '') then
  begin
    hi := PHintInfo(Msg.LParam);

    Canshow := (EventHint <> '') and not ((FLastHintPos.x = -1) or (FLastHintPos.y = -1));
    ShowHintbusy := Canshow;
    if CanShow then
    begin
      Hi^.Hintpos.X := (FLastHintPos.x + 1) * dx;
      Hi^.Hintpos.y := FLastHintPos.y * dy + yoffset;
      Hi^.HintStr := EventHint;
      Hi^.Hintpos := ClientToScreen(Hi^.HintPos);
    end;

    if (BrowserHint <> '') then
    begin
      Hi^.Hintpos.X := FLastHintPos.x;
      Hi^.Hintpos.y := FLastHintPos.y;
      Hi^.HintStr := BrowserHint;
      Hi^.Hintpos := ClientToScreen(Hi^.HintPos);
    end;
  end;
end;

procedure BAAdvCalendar.PropsChanged(Sender: TObject);
begin
  SetLabel(Month, Year);
  Invalidate;
end;

procedure BAAdvCalendar.SetShowDaysAfter(const Value: Boolean);
begin
  FShowDaysAfter := Value;
  Invalidate;
end;

procedure BAAdvCalendar.SetShowDaysBefore(const Value: Boolean);
begin
  FShowDaysBefore := Value;
  Invalidate;
end;

procedure BAAdvCalendar.SetShowSelection(const Value: Boolean);
begin
  FShowSelection := Value;
  Invalidate;
end;

procedure BAAdvCalendar.DoChangeMonth(dt1, dt2: TDateTime);
begin
  if Assigned(FOnMonthChange) then
    FOnMonthChange(self, dt1, dt2);
end;

procedure BAAdvCalendar.DoChangeYear(dt1, dt2: TDateTime);
begin
  if Assigned(FOnYearChange) then
    FOnYearChange(self, dt1, dt2);
end;

function BAAdvCalendar.NumRows: Integer;
begin
  Result := 8;
end;

function BAAdvCalendar.NumCols: Integer;
begin
  Result := 7;
end;

procedure BAAdvCalendar.YearStartChanged(Sender: TObject);
begin
  UpdateYearStart;
end;

{ TCalendarBrowsers }

procedure TCalendarBrowsers.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

constructor TCalendarBrowsers.Create;
begin
  FNextMonth := True;
  FNextYear := True;
  FPrevMonth := True;
  FPrevYear := True;
end;

procedure TCalendarBrowsers.SetNextMonth(const Value: Boolean);
begin
  FNextMonth := Value;
  Changed;
end;

procedure TCalendarBrowsers.SetNextYear(const Value: Boolean);
begin
  FNextYear := Value;
  Changed;
end;

procedure TCalendarBrowsers.SetPrevMonth(const Value: Boolean);
begin
  FPrevMonth := Value;
  Changed;
end;

procedure TCalendarBrowsers.SetPrevYear(const Value: Boolean);
begin
  FPrevYear := Value;
  Changed;
end;

{ TBAAdvCustomCalPanel }

procedure TBAAdvCustomCalPanel.DoPaint;
begin
end;

procedure TBAAdvCustomCalPanel.RepaintDate(dt: TDateTime);
begin
end;

procedure TBAAdvCustomCalPanel.UpdateYearStart;
begin
  Invalidate;
end;

procedure BAAdvCalendar.SetCaptionColor(const Value: TColor);
begin
  if Value = FCaptionColor then exit;
  FCaptionColor := Value;
  Invalidate;
end;

procedure BAAdvCalendar.SetHintNextMonth(AValue: String);
begin
  FHintNextMonth := AValue;
end;

procedure BAAdvCalendar.SetHintNextYear(AValue: String);
begin
  FHintNextYear := AValue;
end;

procedure BAAdvCalendar.SetHintPrevMonth(AValue: String);
begin
  FHintPrevMonth := AValue;
end;

procedure BAAdvCalendar.SetHintPrevYear(AValue: String);
begin
  FHintPrevYear := AValue;
end;

procedure BAAdvCalendar.SetCaptionTextColor(const Value: TColor);
begin
  FCaptionTextColor := Value;
  Invalidate;
end;

procedure BAAdvCalendar.SetCaption3D(Value: boolean);
begin
  FCaption3D:= Value;
  Invalidate;
end;

procedure Register;
begin
 RegisterComponents('Samples', [BAAdvCalendar]);
end;

initialization
  RegisterClass(BAAdvCalendar);

end.
