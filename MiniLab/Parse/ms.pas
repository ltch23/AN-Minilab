unit Ms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;
type
m= array of array of real;

type
TMs=Class

public
    function euler(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float;  _n:integer): m;
    function heun(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float; _n:integer): m;
    function RK3(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float; _n:integer): m;
    function RK4(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float; _n:integer): m;

end;

implementation
uses ParseMath;

function TMs.euler(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float;  _n:integer): m;
var fun: TParseMath;
var xi,xf,x0,y0,h: float; var n,i:integer;
var matrix: array of array of real;
var str: string;
begin
fun:=TParseMath.create();
fun.Expression:=_funcion;
fun.AddVariable('x',0);
fun.AddVariable('y',0);

xi:=_xi;  xf:=_xf;  x0:=_x0;   y0:=_y0;    n:=_n;
SetLength(matrix,n+2,2);
//SetLength(str,n+1);
str:='';

matrix[0][0]:=x0;
matrix[0][1]:=y0;
h:=(xf-xi)/n;

for i:=1 to n do
  matrix[i][0]:= matrix[i-1][0]+h;

if(matrix[n][0]>xf) then
matrix[n][0]:= xf

else if(matrix[n][0]<>xf) then begin
     n:=n+1;
     matrix[n][0]:=xf;
end;

for i:=1 to n do begin
    fun.NewValue('x',matrix[i-1][0]);
    fun.NewValue('y',matrix[i-1][1]);
    matrix[i][1]:= matrix[i-1][1]+h*fun.Evaluate();
end;

euler:=matrix;
end;

function TMs.heun(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float; _n:integer): m;
var fun: TParseMath;
var xi,xf,x0,y0,h,aux: float; var n,i:integer;
var matrix: array of array of real;
var str: string;
begin
fun:=TParseMath.create();
fun.Expression:=_funcion;
fun.AddVariable('x',0);
fun.AddVariable('y',0);

xi:=_xi;  xf:=_xf;  x0:=_x0;   y0:=_y0;    n:=_n;
SetLength(matrix,n+1,3);
//SetLength(str,n+1);
str:='';

matrix[0][0]:=x0;
matrix[0][2]:=y0;
h:=(xf-xi)/n;

fun.NewValue('x',matrix[0][0]);
fun.NewValue('y',matrix[0][2]);
matrix[0][1]:= matrix[0][2]+h*fun.Evaluate();

for i:=1 to n do
  matrix[i][0]:= matrix[i-1][0]+h;

{if(matrix[n][0]>xf) then
matrix[n][0]:= xf;}

for i:=1 to n do begin

    fun.NewValue('x',matrix[i-1][0]);
    fun.NewValue('y',matrix[i-1][2]);
    matrix[i][1]:= matrix[i-1][2]+h*fun.Evaluate();

    fun.NewValue('x',matrix[i][0]);
    fun.NewValue('y',matrix[i][1]);
    aux:=fun.Evaluate();

    fun.NewValue('x',matrix[i-1][0]);
    fun.NewValue('y',matrix[i-1][2]);
    matrix[i][2]:= matrix[i-1][2]+h*(fun.Evaluate()+aux)/2;

end;

heun:=matrix;
end;



function TMs.RK3(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float; _n:integer): m;
var fun: TParseMath;
var xi,xf,x0,y0,h,k1,k2,k3: float; var n,i:integer;
var matrix: array of array of real;
var str: string;
begin
fun:=TParseMath.create();
fun.Expression:=_funcion;
fun.AddVariable('x',0);
fun.AddVariable('y',0);

xi:=_xi;  xf:=_xf;  x0:=_x0;   y0:=_y0;    n:=_n;
SetLength(matrix,n+1,2);
str:='';

matrix[0][0]:=x0;
matrix[0][1]:=y0;
h:=(xf-xi)/n;

for i:=1 to n do
  matrix[i][0]:= matrix[i-1][0]+h;

{if(matrix[n][0]>xf) then
matrix[n][0]:= xf ;}

for i:=1 to n do begin

    fun.NewValue('x',matrix[i-1][0]);    fun.NewValue('y',matrix[i-1][1]);
    k1:=h*fun.Evaluate();
    fun.NewValue('x',matrix[i-1][0]+h/2);fun.NewValue('y',matrix[i-1][1]+k1/2);
    k2:=h*fun.Evaluate();
    fun.NewValue('x',matrix[i-1][0]+h);fun.NewValue('y',matrix[i-1][1]-k1+2*k2);
    k3:=h*fun.Evaluate();
    matrix[i][1]:= matrix[i-1][1]+(k1+4*k2+k3)*(1/6);
end;


RK3:=matrix;
end;

function TMs.RK4(_funcion: String ; _xi:float; _xf:float ; _x0:float; _y0:float;  _n:integer): m;
var fun: TParseMath;
var xi,xf,x0,y0,h,k1,k2,k3,k4: float; var n,i:integer;
var matrix: array of array of real;
var str: string;
begin
fun:=TParseMath.create();
fun.Expression:=_funcion;
fun.AddVariable('x',0);
fun.AddVariable('y',0);

xi:=_xi;  xf:=_xf;  x0:=_x0;   y0:=_y0;    n:=_n;
SetLength(matrix,n+1,2);
str:='';

matrix[0][0]:=x0;
matrix[0][1]:=y0;
h:=(xf-xi)/n;

for i:=1 to n do
  matrix[i][0]:= matrix[i-1][0]+h;

{if(matrix[n][0]>xf) then
matrix[n][0]:= xf  ;}


for i:=1 to n do begin

    fun.NewValue('x',matrix[i-1][0]);    fun.NewValue('y',matrix[i-1][1]);
    k1:=h*fun.Evaluate();
    fun.NewValue('x',matrix[i-1][0]+h/2);fun.NewValue('y',matrix[i-1][1]+k1/2);
    k2:=h*fun.Evaluate();
    fun.NewValue('x',matrix[i-1][0]+h/2);fun.NewValue('y',matrix[i-1][1]+k2/2);
    k3:=h*fun.Evaluate();
    fun.NewValue('x',matrix[i-1][0]+h);fun.NewValue('y',matrix[i-1][1]+k3);
    k4:=h*fun.Evaluate();

    matrix[i][1]:= matrix[i-1][1]+(k1+2*k2+2*k3+k4)*(1/6);
end;

RK4:=matrix;
end;




end.

