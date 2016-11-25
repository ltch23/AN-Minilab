unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, uCmdBox, TAGraph, TARadialSeries, TASeries,
  TAFuncSeries, Forms, Controls, Graphics, Dialogs, ComCtrls, Grids, ValEdit,
  ExtCtrls, ShellCtrls, EditBtn, Menus, ParseMath, StdCtrls, SpkToolbar,
  spkt_Tab, spkt_Pane, spkt_Buttons, spkt_Checkboxes, Ms,TAChartUtils,Ng;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Plotchar: TChart;
    CmdBox: TCmdBox;
    dEdit: TDirectoryEdit;
    lblCommandHistory: TLabel;
    lblCommandHistory1: TLabel;
    lblFileManager: TLabel;
    pgcRight: TPageControl;
    Ejex: TConstantLine;
    Ejey: TConstantLine;
    Funcion: TFuncSeries;
    Plotear: TLineSeries;
    pnlArvhivos: TPanel;
    pnlCommand: TPanel;
    pnlPlot: TPanel;
    slvFiles: TShellListView;
    stvDirectories: TShellTreeView;
    spkcheckSeePlot: TSpkCheckbox;
    SpkLargeButton1: TSpkLargeButton;
    SpkLargeButton2: TSpkLargeButton;
    SpkLargeButton3: TSpkLargeButton;
    SpkLargeButton4: TSpkLargeButton;
    SpkLargeButton5: TSpkLargeButton;
    SpkPane1: TSpkPane;
    SpkPane2: TSpkPane;
    SpkPane3: TSpkPane;
    spkRdoPlotIn: TSpkRadioButton;
    spkRdoPlotEx: TSpkRadioButton;
    SpkTab1: TSpkTab;
    SpkToolbar1: TSpkToolbar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    StatusBar1: TStatusBar;
    tbtnClosePlot: TToolButton;
    tshcomandos: TTabSheet;
    tshVariables: TTabSheet;
    tBarPlot: TToolBar;
    tvwHistory: TTreeView;
    ValueListEditor1: TValueListEditor;
    procedure CmdBoxInput(ACmdBox: TCmdBox; Input: string);
    procedure dEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncionCalculate(const AX: Double; out AY: Double);
    procedure spkcheckSeePlotClick(Sender: TObject);
    procedure tbtnClosePlotClick(Sender: TObject);
    procedure getValues(finalLine:string);
    procedure getValues2(finalLine:string);

  private
    { private declarations }
    ListVar: TStringList;
    Parse: TParseMath;
    ms: TMs;
    ng:TNg;

    a,b,x0,y0,n,op: Double;
    fx: String;
    nn,tam: integer;


    procedure StartCommand();


  public
    function f( x: Double ): Double;

    { public declarations }
  end;

var
  frmMain: TfrmMain;
  i: Integer;
  Max, Min, h, NewX, Newy: Real;
  matrix: array of array of Real;
  auxStr,strv,str1,str2: string; //var j,pos: integer;
  arr2: array of Real;
  arrv,arr1: array of String;

implementation

{$R *.lfm}

{ TfrmMain }




procedure TfrmMain.dEditChange(Sender: TObject);
begin
  if DirectoryExists(dEdit.Text) then
  stvDirectories.Root:= dEdit.Text;
end;

procedure TfrmMain.StartCommand();
begin
   CmdBox.StartRead( clBlack, clWhite,  'MiniLab-->', clBlack, clWhite);
end;

procedure TfrmMain.CmdBoxInput(ACmdBox: TCmdBox; Input: string);
var FinalLine: string;

  procedure AddVariable( EndVarNamePos: integer );
  var PosVar: Integer;
    const NewVar= -1;
  begin

    PosVar:= ListVar.IndexOfName( trim( Copy( FinalLine, 1, EndVarNamePos  ) ) );

    with ValueListEditor1 do
    case PosVar of
         NewVar: begin
                  ListVar.Add(  FinalLine );
                  Parse.AddVariable( ListVar.Names[ ListVar.Count - 1 ], StrToFloat( ListVar.ValueFromIndex[ ListVar.Count - 1 ]) );
                  Cells[ 0, RowCount - 1 ]:= ListVar.Names[ ListVar.Count - 1 ];
                  Cells[ 1, RowCount - 1 ]:= ListVar.ValueFromIndex[ ListVar.Count - 1 ];
                  RowCount:= RowCount + 1;

         end else begin
              ListVar.Delete( PosVar );
              ListVar.Insert( PosVar,  FinalLine );
              Cells[ 0, PosVar + 1 ]:= ListVar.Names[ PosVar ] ;
              Cells[ 1, PosVar + 1 ]:= ListVar.ValueFromIndex[ PosVar ];
              Parse.NewValue( ListVar.Names[ PosVar ], StrToFloat( ListVar.ValueFromIndex[ PosVar ] ) ) ;

          end;

    end;


  end;

  procedure Execute();
  begin
      Parse.Expression:= Input ;
      CmdBox.TextColors(clBlack,clWhite);
      CmdBox.Writeln( LineEnding +  FloatToStr( Parse.Evaluate() )  + LineEnding);
  end;


begin
  Input:= Trim(Input);
  case input of
       'help': ShowMessage( 'help ');
       'exit': Application.Terminate;
       'clear': begin CmdBox.Clear; StartCommand() end;
       'clearhistory': CmdBox.ClearHistory;

        else begin
             FinalLine:=  StringReplace ( Input, ' ', '', [ rfReplaceAll ] );
             if Pos( '=', FinalLine ) > 0 then
                AddVariable( Pos( '=', FinalLine ) - 1 )

             else if(pos('graficar',FinalLine) >0) then
              begin
                 fx:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
                 delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
                 a:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
                 delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
                 b:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));

                { Plotear.Clear;
                with Funcion do begin
                  Active:= False;
                  Extent.XMax:= b;
                  Extent.XMin:= a ;
                  Extent.UseXMax:= true;
                  Extent.UseXMin:= true;
                  Active:= True;
                end;}

                Funcion.Active:= False;
                  Plotear.Clear;
                  Max:=  b;
                  Min:=  a;
                  h:= (Max - Min) /( 10 * Max );
                  Plotear.Marks.Style:= smsValue;
                  Plotear.ShowPoints:= true;
                  NewX:= Min;

                  while NewX < Max do begin
                     Plotear.AddXY( NewX, f( NewX ) );
                     NewX:= NewX + h;
                  end;

                end

              else if(pos('edo',FinalLine) >0) then
              begin

              getValues(FinalLine);
              nn:=trunc(n);
                  Case trunc(op) of
                  0: matrix:= ms.euler(fx,a,b,x0,y0,Trunc(n));
                  1: matrix:= ms.heun(fx,a,b,x0,y0,Trunc(n));
                  2: matrix:= ms.RK3(fx,a,b,x0,y0,Trunc(n));
                  3: matrix:= ms.RK4(fx,a,b,x0,y0,Trunc(n));
                  else exit;
                  end;

                  Funcion.Active:= False;
                  Plotear.Clear;

                  Max:=  matrix[nn][0];
                  Min:=  matrix[1][0];

                  Plotear.Marks.Style:= smsValue;
                  Plotear.ShowPoints:= true;

                  for i:=0 to nn do begin
                  Plotear.AddXY(matrix[i][0],matrix[i][1]);
                  end;
                  CmdBox.TextColors(clBlack,clWhite);
                  CmdBox.Writeln( LineEnding + FloatToStr(matrix[i][1]) +'     '+ LineEnding);


              end

              else if (pos('newtongeneralizado(',FinalLine) >0) then
              begin
                  getValues2(FinalLine);
                  CmdBox.TextColors(clBlack,clWhite);
                  CmdBox.Writeln( LineEnding + ng.newton_generalizado(arrv,arr1,arr2)  +'     '+ LineEnding);
              end

              else
                  Execute;
              end;

  end;
  StartCommand()
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  CmdBox.StartRead( clBlack, clWhite,  'MiniLab-->', clBlack, clWhite);

  with ValueListEditor1 do begin
    Cells[ 0, 0]:= 'Nombre';
    Cells[1, 0]:= 'Valor';
    Clear;

  end;

  ListVar:= TStringList.Create;
  Parse:= TParseMath.create();
  Parse.AddVariable('x',0.0);

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ListVar.Destroy;
  Parse.Destroy;
end;

procedure TfrmMain.FuncionCalculate(const AX: Double; out AY: Double);
begin
  AY := f( AX )
end;

procedure TfrmMain.spkcheckSeePlotClick(Sender: TObject);
begin
  pnlPlot.Visible:= not pnlPlot.Visible;
end;

procedure TfrmMain.tbtnClosePlotClick(Sender: TObject);
begin
  spkcheckSeePlot.Checked:= False;
  pnlPlot.Visible:= False;
end;

function TfrmMain.f( x: Double ): Double;
begin
     parse.Expression:= fx;
     Parse.NewValue('x' , x );
     Result:= Parse.Evaluate();
end;

procedure TfrmMain.getValues(finalLine:string);
begin
    fx:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
     delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
     a:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
     delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
     b:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
     delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
     x0:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
     delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
     y0:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
     delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
     n:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
     delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
     op:=StrToFloat(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));

end;


procedure TfrmMain.getValues2(FinalLine:string);
begin

strv:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
str1:=(copy(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-1-pos('(',FinalLine)));
delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
str2:=(copy(FinalLine,pos('(',FinalLine)+1, pos(')',FinalLine)-1-pos('(',FinalLine)));

auxStr:=strv;
tam:=0;
while (pos(' ',auxStr)>0) do begin
tam:=tam+1;
delete(auxStr,pos(' ',auxStr), 1);
end;

SetLength(arrv,tam+1);
SetLength(arr1,tam+1);
SetLength(arr2,tam+1);

for i:=0 to tam-1 do begin
    arrv[i]:= (copy(strv,pos('[',strv)+1, pos(' ',strv)-1-pos('[',strv)));
    delete(strv,pos('[',strv)+1, pos(' ',strv)-pos('[',strv));
end;
arrv[tam]:=(copy(strv,pos('[',strv)+1, pos(']',strv)-1-pos('[',strv)));

for i:=0 to tam-1 do begin
    arr1[i]:= (copy(str1,pos('[',str1)+1, pos(' ',str1)-1-pos('[',str1)));
    delete(str1,pos('[',str1)+1, pos(' ',str1)-pos('[',str1));
end;
arr1[tam]:=(copy(str1,pos('[',str1)+1, pos(']',str1)-1-pos('[',str1)));


for i:=0 to tam-1 do begin
    arr2[i]:= StrToFloat(copy(str2,pos('[',str2)+1, pos(' ',str2)-1-pos('[',str2)));
    delete(str2,pos('[',str2)+1, pos(' ',str2)-pos('[',str2));
end;
arr2[tam]:=StrToFLoat(copy(str2,pos('[',str2)+1, pos(']',str2)-1-pos('[',str2)));
end;


end.

