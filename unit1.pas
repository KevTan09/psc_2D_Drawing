unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, ColorBox;

type

  { TForm1 }
  TBangun = record
    x: integer;
    y: integer;
  end;

  TMovement = record
    x: real;
    y: real;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    status: TEdit;
    sleepBtn: TButton;
    timer: TButton;
    colSel: TColorBox;
    Label19: TLabel;
    Label20: TLabel;
    Panel3: TPanel;
    Setting: TLabel;
    sdtTimer: TTimer;
    sclTimer: TTimer;
    pSdtTimer: TTimer;
    pSclTimer: TTimer;
    trsTimer: TTimer;
    penSize: TTrackBar;
    trans: TButton;
    scale: TButton;
    pScale: TButton;
    rotate: TButton;
    pRotate: TButton;
    x1: TEdit;
    px: TEdit;
    py: TEdit;
    y1: TEdit;
    x2: TEdit;
    y2: TEdit;
    tx: TEdit;
    ty: TEdit;
    sx: TEdit;
    sy: TEdit;
    sudut: TEdit;
    papan: TImage;
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
    Panel1: TPanel;
    Panel2: TPanel;

    function cf(f: TEdit) : double;
    function cd(d: TEdit) : integer;
    function getMove(txn, tyn: double) : TMovement;
    function getScale(scxn, scyn: double) : TMoveMent;

    procedure Draw(Sender: TObject);
    procedure pSclTimerTimer(Sender: TObject);
    procedure pSdtTimerTimer(Sender: TObject);
    procedure Reset();
    procedure FormShow(Sender: TObject);

    procedure pRotateClick(Sender: TObject);
    procedure pScaleClick(Sender: TObject);
    procedure rotateClick(Sender: TObject);
    procedure scaleClick(Sender: TObject);
    procedure sclTimerTimer(Sender: TObject);
    procedure sdtTimerTimer(Sender: TObject);
    procedure transClick(Sender: TObject);
    procedure sleepBtnClick(Sender: TObject);
    procedure timerClick(Sender: TObject);

    procedure trsTimerTimer(Sender: TObject);

    procedure pRotation(degr : integer);
    procedure pScalation(x,y : double);
    procedure rotation(degr : integer);
    procedure scalation(x,y : double);
    procedure transation(x,y : integer);
  private

  public

  end;

var
  Form1: TForm1;
  midX, midY, i, x_1, y_1, x_2, y_2, t_x, t_y, p_x, p_y: integer;
  s_x, s_y, sdt_degree, simpan, sdt: double;
  bintang: array[1..5] of TBangun;
  animation: boolean; //true = dengan sleepBtn, false = dengan TTimer

  xtm, ytm, txt, tyt : integer;

  scxtm, scytm, scxt, scyt, scxm, scym: real;

  mt : TMovement;

  st, sdtt, sdtmt : integer;

implementation

{$R *.lfm}

{ TForm1 }

//Fungsi pembantu untuk convert string ke bilangan
function TForm1.cf(f : TEdit) : double;
begin
  cf := StrToFloat(f.Text);
end;

function TForm1.cd(d : TEdit) : integer;
begin
  cd := StrToInt(d.Text);
end;
//-------------------------------------------------

//Fungsi general
procedure TForm1.FormShow(Sender: TObject);
begin
  sleepBtnClick(nil);
  Reset()
end;

procedure TForm1.Reset();
begin
  papan.Canvas.Brush.Color:= clWhite;
  papan.Canvas.FillRect(papan.BoundsRect);
  papan.Canvas.Clear;
  midX:=papan.Width div 2;
  midY:=papan.Height div 2;
  papan.Canvas.Pen.Color:= clBlack;
  papan.Canvas.Pen.Style:= psDot;
  papan.Canvas.Pen.Width:= 2;
  papan.Canvas.MoveTo(midX, 0);
  papan.Canvas.LineTo(midX, papan.Height);
  papan.Canvas.MoveTo(0, midY);
  papan.Canvas.LineTo(papan.Width, midY);
  papan.Canvas.Pen.Style:= psSolid;
  papan.Canvas.Pen.Color:= colSel.Selected;
  papan.Canvas.Pen.Width:= penSize.Position;
end;

function TForm1.getMove(txn, tyn: double) : TMovement;
var
  m : TMovement;
begin
  if tyn = 0 then
  begin
     if txn > 0 then
        m.x := 2
     else if txn < 0 then
          m.x := -2
     else
         m.x := 0;
  end
  else
      m.x := (txn/tyn);

  if txn = 0 then
  begin
     if tyn > 0 then
        m.y := 2
     else if tyn < 0 then
          m.y := -2
     else
         m.y:= 0;
  end
  else
      m.y := (tyn/txn);


  if (txn > 0) and (tyn < 0) then
     m.x := -m.x
  else if (txn < 0) and (tyn > 0) then
       m.y := -m.y
  else if (txn < 0) and (tyn < 0) then
  begin
     m.y := -m.x;
     m.y := -m.y;
  end;

  getMove := m;
end;

function TForm1.getScale(scxn, scyn: double) : TMovement;
var
  m : TMovement;
begin
   if scxn > 0 then
   begin
      if (scxn >= 1)then
         m.x := 1.05
         else
             m.x := 0.95;
      scxm := 0.05;
   end
   else if scxn < 0 then
   begin
      if (scxn <= -1)then
       m.x := -1.05
       else
           m.x := -0.95;
      scxm := -0.05;
   end
   else
   begin
       m.x := 0;
       scxm := 0;
   end;

   if scyn > 0 then
   begin
      if (scyn >= 1)then
         m.y := 1.05
         else
             m.y := 0.95;
      scym := 0.05;
   end
   else if scyn < 0 then
   begin
      if (scyn <= -1)then
       m.y := -1.05
       else
           m.y := -0.95;
      scym := -0.05;
   end
   else
   begin
       m.y:= 0;
       scym := 0;
   end;

   getScale := m;
end;

procedure TForm1.transation(x,y : integer);
begin
  Reset();
  t_x := x;
  t_y := y;

  papan.Canvas.MoveTo((midX + (bintang[5].x + t_x)), (midY - (bintang[5].y + t_y)));
  for i:=1 to 5 do
  begin
    bintang[i].x := (bintang[i].x + t_x);
    bintang[i].y := (bintang[i].y + t_y);
    papan.Canvas.LineTo( (midX + bintang[i].x), (midY - bintang[i].y) );
  end;
end;

procedure TForm1.rotation(degr: integer);
begin
  Reset();
  sdt := degr;
  sdt_degree := (sdt*pi)/180;

  for i :=1 to 5 do
  begin
    simpan :=  bintang[i].x;
    bintang[i].x:= round(
                         (bintang[i].x *cos(sdt_degree))-(bintang[i].y*sin(sdt_degree))
                         );
    bintang[i].y:= round (
                         (simpan*sin(sdt_degree))+(bintang[i].y*cos(sdt_degree))
                         );
  end;

  papan.Canvas.MoveTo(midX+bintang[5].x, midY-bintang[5].y);
  for i:= 1 to 5 do
  begin
    papan.Canvas.LineTo(midX+bintang[i].x, midY-bintang[i].y);
  end;
end;

procedure TForm1.scalation(x,y : double);
begin
  Reset();
  s_x := x;
  s_y := y;

  papan.Canvas.MoveTo(midX+round(bintang[5].x*s_x), midY-round(bintang[5].y*s_y));

  for i:= 1 to 5 do
  begin
    bintang[i].x := round(bintang[i].x*s_x);
    bintang[i].y := round(bintang[i].y*s_y);
    papan.Canvas.LineTo(midX+round(bintang[i].x), midY-round(bintang[i].y));
  end;
end;

procedure TForm1.pRotation(degr: integer);
begin
  t_x := -p_x;
  t_y := -p_y;

  //geser ke tengah
  Reset();

  papan.Canvas.MoveTo((midX + (bintang[5].x + t_x)), (midY - (bintang[5].y + t_y)));
  for i:=1 to 5 do
  begin
    bintang[i].x := (bintang[i].x + t_x);
    bintang[i].y := (bintang[i].y + t_y);
  end;

  //putar
  sdt := degr;
  sdt_degree := (sdt*pi)/180;

  for i :=1 to 5 do
  begin
    simpan :=  bintang[i].x;
    bintang[i].x:= round(
                         (bintang[i].x *cos(sdt_degree))-(bintang[i].y*sin(sdt_degree))
                         );
    bintang[i].y:= round (
                         (simpan*sin(sdt_degree))+(bintang[i].y*cos(sdt_degree))
                         );
  end;

  //kembali
  t_x := p_x;
  t_y := p_y;

  papan.Canvas.MoveTo( (midX + (bintang[5].x + t_x) ), (midY - (bintang[5].y + t_y)));
  for i:=1 to 5 do
  begin
    bintang[i].x := (bintang[i].x + t_x);
    bintang[i].y := (bintang[i].y + t_y);
    papan.Canvas.LineTo( (midX + bintang[i].x), (midY - bintang[i].y) );
  end;
end;

procedure TForm1.pScalation(x,y : double);
begin
  t_x := -p_x;
  t_y := -p_y;

  //geser ke tengah
  Reset();

  papan.Canvas.MoveTo((midX + (bintang[5].x + t_x)), (midY - (bintang[5].y + t_y)));
  for i:=1 to 5 do
  begin
    bintang[i].x := (bintang[i].x + t_x);
    bintang[i].y := (bintang[i].y + t_y);
  end;

  //scale
  s_x := x;
  s_y := y;

  papan.Canvas.MoveTo(midX+round(bintang[5].x*s_x), midY-round(bintang[5].y*s_y));

  for i:= 1 to 5 do
  begin
    bintang[i].x := round(bintang[i].x*s_x);
    bintang[i].y := round(bintang[i].y*s_y);
  end;

  //kembali
  t_x := p_x;
  t_y := p_y;

  papan.Canvas.MoveTo( (midX + (bintang[5].x + t_x) ), (midY - (bintang[5].y + t_y)));
  for i:=1 to 5 do
  begin
    bintang[i].x := (bintang[i].x + t_x);
    bintang[i].y := (bintang[i].y + t_y);
    papan.Canvas.LineTo( (midX + bintang[i].x), (midY - bintang[i].y) );
  end;
end;

//--------------------------------------------------

//Fungsi ButtonCLick
procedure TForm1.Draw(Sender: TObject);
begin
  Reset();
  x_1 := cd(x1);
  y_1 := cd(y1);
  x_2 := cd(x2);
  y_2 := cd(y2);

  p_x := (x_2 + x_1) div 2;
  p_y := (y_2 + y_1) div 2;

  px.Text := p_x.ToString;
  py.Text := p_y.ToString;

  bintang[1].x := x_1;
  bintang[1].y := y_2;

  bintang[2].x := (x_1+x_2) div 2;
  bintang[2].y := y_1;

  bintang[3].x := x_2;
  bintang[3].y := y_2;

  bintang[4].x := x_1;
  bintang[4].y := ((y_2-y_1) div 3) + y_1;

  bintang[5].x := x_2;
  bintang[5].y := bintang[4].y;

  papan.Canvas.MoveTo(midX+bintang[5].x, midY-bintang[5].y);

  for i:= 1 to 5 do
  begin
    papan.Canvas.LineTo(midX+bintang[i].x, midY-bintang[i].y);
  end;

end;

//Normal (0, 0)
procedure TForm1.rotateClick(Sender: TObject);
var
  sdtn, sdtm, s: integer;
begin
  sdtn := cd(sudut);

  if(sdtn < 0) then
  sdtm := -2
  else if(sdtn > 0) then
  sdtm := 2
  else
      sdtm := 0;

  if(animation) then
  begin
    s := 0;
    while (s <> sdtn) do
    begin
      rotation(sdtm);
      if (s > 0) and (s > sdtn) then
         s := sdtn
         else if (s < 0) and (s < sdtn) then
         s := sdtn
         else
             s := s + sdtm;
      sleep(10);
      papan.Repaint;
    end;
  end
  else
  begin
    sdtt := cd(sudut);

    if(sdtn < 0) then
    sdtmt := -2
    else if(sdtn > 0) then
    sdtmt := 2
    else
      sdtmt := 0;

    st := 0;

    sdtTimer.Enabled := true;
  end;
end;

procedure TForm1.transClick(Sender: TObject);
var
  x, y, txn, tyn: integer;
  m : TMovement;
begin
  txn := cd(tx);
  tyn := cd(ty);

  m := getMove(txn, tyn);

  if(animation) then
  begin
    x := 0;
    y := 0;
    while (x <> txn) or (y <> tyn) do
    begin
      transation(round(m.x), round(m.y));
      if (x > 0) and (x > txn) then
         x := txn
         else if (x < 0) and (x < txn) then
         x := txn
         else
             x := round(x + m.x);

      if (y > 0) and (y > tyn) then
         y := tyn
         else if (y < 0) and (y < tyn) then
         y := tyn
         else
             y := round(y + m.y);

      sleep(10);
      papan.Repaint;
    end;
  end
  else
  begin
    txt := cd(tx);
    tyt := cd(ty);

    mt := getMove(txt, tyt);

    xtm := 0;
    ytm := 0;

    trsTimer.Enabled := true;
  end;
end;

procedure TForm1.scaleClick(Sender: TObject);
var
  scxn, scyn, scx, scy: real;
  m : TMovement;
begin
  scxn := cf(sx);
  scyn := cf(sy);

  m := getScale(scxn, scyn);

  if(animation) then
  begin
    if(scxn >= 1) then
    scx := 1
    else if (scxn <= -1) then
    scx := -1
    else
        scx := 0;

    if(scyn >= 1) then
    scy := 1
    else if (scyn <= -1) then
    scy := -1
    else
        scy := 0;

    while (scx <> scxn) or (scy <> scyn) do
    begin
      scalation(m.x, m.y);
      if (scx > 0) and (scx >= scxn) then
         scx := scxn
         else if (scx < 0) and (scx <= scxn) then
         scx := scxn
         else
             scx := scx + scxm;

      if (scy > 0) and (scy > scyn) then
         scy := scyn
         else if (scy < 0) and (scy < scyn) then
         scy := scyn
         else
             scy := scy +scym;

      sleep(10);
      papan.Repaint;
    end;
  end
  else
  begin
    scxt := cf(sx);
    scyt := cf(sy);

    mt := getScale(scxt, scyt);

    if(scxt >= 1) then
    scxtm := 1
    else if (scxt <= -1) then
    scxtm := -1
    else
        scxtm := 0;

    if(scyt >= 1) then
    scytm := 1
    else if (scyt <= -1) then
    scytm := -1
    else
        scytm := 0;

    sclTimer.Enabled := true;
  end;
end;

//Pivot Point
procedure TForm1.pRotateClick(Sender: TObject);
var
  sdtn, sdtm, s: integer;
begin
  sdtn := cd(sudut);

  if(sdtn < 0) then
  sdtm := -2
  else if(sdtn > 0) then
  sdtm := 2
  else
      sdtm := 0;

  if(animation) then
  begin
    s := 0;
    while (s <> sdtn) do
    begin
      pRotation(sdtm);
      if (s > 0) and (s > sdtn) then
         s := sdtn
         else if (s < 0) and (s < sdtn) then
         s := sdtn
         else
             s := s + sdtm;
      sleep(10);
      papan.Repaint;
    end;
  end
  else
  begin
    sdtt := cd(sudut);

    if(sdtn < 0) then
    sdtmt := -2
    else if(sdtn > 0) then
    sdtmt := 2
    else
      sdtmt := 0;

    st := 0;

    pSdtTimer.Enabled := true;
  end;
end;

procedure TForm1.pScaleClick(Sender: TObject);
var
  scxn, scyn, scx, scy: real;
  m : TMovement;
begin
  scxn := cf(sx);
  scyn := cf(sy);

  m := getScale(scxn, scyn);

  if(animation) then
  begin
    if(scxn >= 1) then
    scx := 1
    else if (scxn <= -1) then
    scx := -1
    else
        scx := 0;

    if(scyn >= 1) then
    scy := 1
    else if (scyn <= -1) then
    scy := -1
    else
        scy := 0;

    while (scx <> scxn) or (scy <> scyn) do
    begin
      pScalation(m.x, m.y);
      if (scx > 0) and (scx >= scxn) then
         scx := scxn
         else if (scx < 0) and (scx <= scxn) then
         scx := scxn
         else
             scx := scx + scxm;

      if (scy > 0) and (scy > scyn) then
         scy := scyn
         else if (scy < 0) and (scy < scyn) then
         scy := scyn
         else
             scy := scy +scym;

      sleep(10);
      papan.Repaint;
    end;
  end
  else
  begin
    scxt := cf(sx);
    scyt := cf(sy);

    mt := getScale(scxt, scyt);

    if(scxt >= 1) then
    scxtm := 1
    else if (scxt <= -1) then
    scxtm := -1
    else
        scxtm := 0;

    if(scyt >= 1) then
    scytm := 1
    else if (scyt <= -1) then
    scytm := -1
    else
        scytm := 0;

    pSclTimer.Enabled := true;
  end;
end;

procedure TForm1.sleepBtnClick(Sender: TObject);
begin
  animation := true;
  status.Text := 'sleep'
end;

procedure TForm1.timerClick(Sender: TObject);
begin
  animation := false;
  status.Text := 'timer';
end;

//TTimers
procedure TForm1.trsTimerTimer(Sender: TObject);
begin
  if (xtm = txt) and (ytm = tyt) then
  begin
     trsTimer.Enabled := false;
  end;

  transation(round(mt.x), round(mt.y));
  if (xtm > 0) and (xtm > txt) then
     xtm := txt
     else if (xtm< 0) and (xtm < txt) then
     xtm := txt
     else
         xtm := round(xtm + mt.x);

  if (ytm > 0) and (ytm > tyt) then
     ytm := tyt
     else if (ytm < 0) and (ytm < tyt) then
     ytm := tyt
     else
         ytm := round(ytm + mt.y);
end;

procedure TForm1.sdtTimerTimer(Sender: TObject);
begin
  if (st = sdtt) or (ytm = sdtt) then
  begin
     sdtTimer.Enabled := false;
  end;

  rotation(sdtmt);
  if (st > 0) and (st > sdtt) then
     st := sdtt
     else if (st < 0) and (st < sdtt) then
     st := sdtt
     else
         st := st + sdtmt;
end;

procedure TForm1.sclTimerTimer(Sender: TObject);
begin
  if (scxt = scxtm) and (scyt = scytm) then
  begin
     sclTimer.Enabled := false;
  end;

  scalation(mt.x, mt.y);
      if (scxtm > 0) and (scxtm >= scxt) then
         scxtm := scxt
         else if (scxtm < 0) and (scxtm <= scxt) then
         scxtm := scxt
         else
             scxtm := scxtm + scxm;

      if (scytm > 0) and (scytm > scyt) then
         scytm := scyt
         else if (scytm < 0) and (scytm < scyt) then
         scytm := scyt
         else
             scytm := scytm +scym;
end;

procedure TForm1.pSdtTimerTimer(Sender: TObject);
begin
  if (st = sdtt) or (ytm = sdtt) then
  begin
     pSdtTimer.Enabled := false;
  end;

  pRotation(sdtmt);
  if (st > 0) and (st > sdtt) then
     st := sdtt
     else if (st < 0) and (st < sdtt) then
     st := sdtt
     else
         st := st + sdtmt;
end;


procedure TForm1.pSclTimerTimer(Sender: TObject);
begin
  if (scxt = scxtm) and (scyt = scytm) then
  begin
     pSclTimer.Enabled := false;
  end;

  pScalation(mt.x, mt.y);
      if (scxtm > 0) and (scxtm >= scxt) then
         scxtm := scxt
         else if (scxtm < 0) and (scxtm <= scxt) then
         scxtm := scxt
         else
             scxtm := scxtm + scxm;

      if (scytm > 0) and (scytm > scyt) then
         scytm := scyt
         else if (scytm < 0) and (scytm < scyt) then
         scytm := scyt
         else
             scytm := scytm +scym;
end;

end.

