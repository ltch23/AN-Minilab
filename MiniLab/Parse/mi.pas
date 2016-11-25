unit MI;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math;

type
  TMI = Class

  private

  public
    function trapecio(_funcion: String ; _a:float; _b:float; _n:integer):float;
    function trapecioA(_funcion: String ; _a:float; _b:float; _n:integer):float;

    function simpson_simple( _funcion: String ; _a:float; _b:float; _n:integer):float;
    function simpson_simpleA( _funcion: String ; _a:float; _b:float; _n:integer):float;

    function simpson_compuesto( _funcion: String ; _a:float; _b:float; _n:integer):float;
    function simpson_compuestoA( _funcion: String ; _a:float; _b:float; _n:integer):float;

    function simpson_38_simple( _funcion: String ; _a:float; _b:float; _n:integer):float;
    function simpson_38_simpleA( _funcion: String ; _a:float; _b:float; _n:integer):float;

    function simpson_38_compuesto( _funcion: String ; _a:float; _b:float; _n:integer):float;
    function simpson_38_compuestoA( _funcion: String ; _a:float; _b:float; _n:integer):float;

  end;

implementation

uses ParseMath;

function TMI.trapecio(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);

fb:=fun.Evaluate();

rpta:=(fa+fb)/2;
//rpta2:=(abs(fa)+abs(fb))/2;

for i:=1 to n-1 do begin
  fun.NewValue('x',a+i*h);
  rpta:=rpta+fun.Evaluate();
  //rpta2:=rpta2+abs(fun.Evaluate());
  end;
rpta:=rpta*h;
//rpta2:=rpta2*h;
trapecio:=rpta;
end;
function TMI.trapecioA(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);

fb:=fun.Evaluate();

rpta2:=(abs(fa)+abs(fb))/2;

for i:=1 to n-1 do begin
  fun.NewValue('x',a+i*h);
  rpta2:=rpta2+abs(fun.Evaluate());
  end;

rpta2:=rpta2*h;
trapecioA:=rpta2;
end;


function TMI.simpson_simple(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0;
n:=_n;
h:=(b-a)/6;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta:=(fa+fb);
//rpta2:=(abs(fa)+abs(fb))/2;

  fun.NewValue('x',(a+b)/2);
  rpta:=rpta+4*fun.Evaluate();
  //rpta2:=rpta2+abs(fun.Evaluate());
rpta:=rpta*h;
//rpta2:=rpta2*h;
simpson_simple:=rpta;
end;

function TMI.simpson_simpleA(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0;
n:=_n;
h:=(b-a)/6;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta2:=(abs(fa)+abs(fb))/2;

  fun.NewValue('x',(a+b)/2);
  rpta2:=rpta2+4*abs(fun.Evaluate());
rpta2:=rpta2*h;
simpson_simpleA:=rpta2;
end;



function TMI.simpson_compuesto(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx,aux,aux2 :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;
rpta:=0;
aux:=0; aux2:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta:=(fa+fb);
//rpta2:=(abs(fa)+abs(fb))/2;


i:=1;
while(i<=(n/2)-1) do begin
  fun.NewValue('x',a+i*h);
  aux:=aux+fun.Evaluate();
  i:=i+1;
  //rpta2:=rpta2+abs(fun.Evaluate());
  end;

i:=1;
while (i<=(n/2)) do begin
  fun.NewValue('x',(a+i*h)-1);
  aux2:=aux2+fun.Evaluate();
  i:=i+1;
  //rpta2:=rpta2+abs(fun.Evaluate());
  end;

rpta:=rpta+(2*aux)+(4*aux2);
rpta:=rpta*(h/3);
//rpta2:=rpta2*h;
simpson_compuesto:=rpta;
end;
function TMI.simpson_compuestoA(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx,aux,aux2 :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;
rpta:=0;
aux:=0; aux2:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta2:=(abs(fa)+abs(fb))/2;


i:=1;
while(i<=(n/2)-1) do begin
  fun.NewValue('x',a+i*h);
  aux:=aux+abs(fun.Evaluate());

  i:=i+1;
  end;

i:=1;
while (i<=(n/2)) do begin
  fun.NewValue('x',(a+i*h)-1);
  aux2:=aux2+abs(fun.Evaluate());
  i:=i+1;
end;

rpta:=rpta+(2*aux)+(4*aux2);
rpta:=rpta*(h/3);
//rpta2:=rpta2*h;
simpson_compuestoA:=rpta;
end;

function TMI.simpson_38_simple(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta:=(fa+fb);
//rpta2:=(abs(fa)+abs(fb))/2;

fun.NewValue('x',(2*a+b)/3);
rpta:=rpta+3*fun.Evaluate();

fun.NewValue('x',(a+2*b)/3);
rpta:=rpta+3*fun.Evaluate();

rpta:=rpta*((3*h)/8);
//rpta2:=rpta2*h;
simpson_38_simple:=rpta;
end;
function TMI.simpson_38_simpleA(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta:=abs(fa)+abs(fb);

fun.NewValue('x',(2*a+b)/3);
rpta:=rpta+3*abs(fun.Evaluate());

fun.NewValue('x',(a+2*b)/3);
rpta:=rpta+3*abs(fun.Evaluate());

rpta:=rpta*((3*h)/8);
simpson_38_simpleA:=rpta;
end;

function TMI.simpson_38_compuesto(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx,aux,aux2,aux3 :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0; aux:=0; aux2:=0; aux3:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta:=(fa+fb);
//rpta2:=(abs(fa)+abs(fb))/2;


i:=1;
while(i<=n-2) do begin
  fun.NewValue('x',a+i*h);
  aux:=aux+fun.Evaluate();
  i:=i+3;
  //rpta2:=rpta2+abs(fun.Evaluate());
  end;

i:=1;
while (i<=n-1) do begin
  fun.NewValue('x',a+i*h);
  aux2:=aux2+fun.Evaluate();
  i:=i+3;
  //rpta2:=rpta2+abs(fun.Evaluate());
  end;

i:=1;
while (i<=n-3) do begin
  fun.NewValue('x',a+i*h);
  aux3:=aux3+fun.Evaluate();
  i:=i+3;
  //rpta2:=rpta2+abs(fun.Evaluate());
  end;

rpta:=rpta+(3*aux)+(3*aux2)+(2*aux3);
rpta:=rpta*((3*h)/8);
//rpta2:=rpta2*h;
simpson_38_compuesto:=rpta;

end;
function TMI.simpson_38_compuestoA(_funcion: String ; _a:float; _b:float; _n:integer): float;
var i,j,n:integer; var a,b,fa,fb,h,rpta,rpta2,dfx,aux,aux2,aux3 :float; var fun: TParseMath;
begin

a:=_a;
b:=_b;        rpta:=0; aux:=0; aux2:=0; aux3:=0;
n:=_n;
h:=(b-a)/n;
fun:=TParseMath.create();
fun.Expression:=_funcion;

fun.AddVariable('x',a);
fa:=fun.Evaluate();

fun.NewValue('x',b);
fb:=fun.Evaluate();

rpta:=abs(fa)+abs(fb);


i:=1;
while(i<=n-2) do begin
  fun.NewValue('x',a+i*h);
  aux:=aux+abs(fun.Evaluate());
  i:=i+3;
  end;

i:=1;
while (i<=n-1) do begin
  fun.NewValue('x',a+i*h);
  aux2:=aux2+abs(fun.Evaluate());
  i:=i+3;
  end;

i:=1;
while (i<=n-3) do begin
  fun.NewValue('x',a+i*h);
  aux3:=aux3+abs(fun.Evaluate());
  i:=i+3;
  end;

rpta:=rpta+(3*aux)+(3*aux2)+(2*aux3);
rpta:=rpta*((3*h)/8);
//rpta2:=rpta2*h;
simpson_38_compuestoA:=rpta;

end;



end.

