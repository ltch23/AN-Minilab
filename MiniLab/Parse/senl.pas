unit Senl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math;
type
TSenl = Class
private
error: float;

public
function biseccion(_funcion: String;_a: float; _b: float): float;
function falsa_posicion(_funcion: String;_a: float; _b: float): float;
function newton(_funcion: String;_x:float): float;
function secante(_funcion: String;_x:float): float;
function add(n1:float;n2:float;n3:float):float;
//constructor create();
//destructor destroy;

end;

implementation

 uses ParseMath;
{constructor TSenl.create()
begin
error:=0;
end;}

function TSenl.add(n1:float;n2:float;n3:float):float;
begin
add:=n1+n2+n3;
end;

function TSenl.biseccion(_funcion: String;_a: float; _b: float): float;
var a,b,xn,e,er,z,fa,fb,fxn,aux :float; var s:integer; var fun: TParseMath;
begin

a:=_a;  b:=_b;  e:=0.00001;   er:=e; s:=1; xn:=(a+b)/2;

fun:= TParseMath.create();
fun.Expression:= _funcion;
fun.AddVariable('x', a );

try
fa:=fun.Evaluate();
fun.NewValue('x',b);
fb:=fun.Evaluate();
fun.NewValue('x',xn);
fxn:=fun.Evaluate();

if (fa*fb>=0.0) and (fa*fb<>infinity) then
begin
 //ShowMessage('Bolzano');
 exit;
end;

finally
//if (fxn=infinity) then ShowMessage(' error fxn ' +FloatToStr(fxn))
//else if (fa=infinity) then ShowMessage(' error fa ' +FloatToStr(fa));
end;
if (fxn=infinity) or (fa=infinity) then exit;
if (fa*fxn)<0 then s:=-1  else s:=1;

while (er >= e) and (fa*fxn<>0.0) do
begin
   if s = -1  then b:=xn
   else  a:=xn;
   z:=xn;
   xn:=(a+b)/2;

   try
     fun.NewValue('x',a);
     fa:=fun.Evaluate();
     fun.NewValue('x',xn);
     fxn:=fun.Evaluate();
   finally
   //if (fxn=infinity) then ShowMessage(' error fxn '+FloatToStr(fxn))
   //else if (fa=infinity) then ShowMessage(' error fa '+FloatToStr(fa));
   end;
   if (fxn=infinity) or (fa=infinity)  then exit;
   if (fa*fxn)<0 then s:=-1  else s:=1;

   er:=(xn-z);
   if er<0 then er:=er*-1;
   end;
fun.destroy;
biseccion:=xn;
end;

function TSenl.falsa_posicion(_funcion: String;_a: float; _b: float): float;
var a,b,xn,e,er,z,fa,fb,fxn :double; var i,s:integer; var fun1: TParseMath;
begin

a:=_a;  b:=_b; e:=0.00001; er:=e; s:=1;

fun1:= TParseMath.create();
fun1.AddVariable('x', a );
fun1.Expression:= _funcion;

try
  fa:=fun1.Evaluate();
  fun1.NewValue('x',b);          fb:=fun1.Evaluate();
  fun1.NewValue('x',xn);         fxn:=fun1.Evaluate();
  xn:=a-((fa*(b-a))/(fb-fa));
  if (fa*fb>=0.0)and (fa*fb<>infinity) then begin
  //ShowMessage('Bolzano') ;
  exit; end;
  finally
  //if (fa=infinity) then ShowMessage(' error fa '+FloatToStr(fa))
  //else if (fb=infinity) then ShowMessage(' error fb '+FloatToStr(fb))
  //else if fb-fa=0 then ShowMessage(' error fb-fa '+FloatToStr(fb-fa));
  end;
  if (fa=infinity) or (fb=infinity)  then exit;

  if (fa*fxn)< 0 then s:=-1 else s:=1;

while (er >= e) do
begin
    if s = -1  then b:=xn  else  a:=xn;
    z:=xn;
    try
    fun1.NewValue('x',a);          fa:=fun1.Evaluate();
    fun1.NewValue('x',b);          fb:=fun1.Evaluate();
    fun1.NewValue('x',xn);         fxn:=fun1.Evaluate();
    xn:=a-((fa*(b-a))/(fb-fa));
    finally
        //if (fa=infinity) then ShowMessage(' error fa '+FloatToStr(fa))
        //else if (fb=infinity) then ShowMessage(' error fb '+FloatToStr(fb))
        //else if fb-fa=0 then ShowMessage(' error fb-fa '+FloatToStr(fb-fa));
    end;
    if (fa=infinity) or (fb=infinity)  then exit;

    if (fa*fxn)<0 then s:=-1  else s:=1;
    er:=(xn-z);
   if er<0 then er:=er*-1;
end;
fun1.destroy;
falsa_posicion:=xn;
end;


function TSenl.newton(_funcion: String;_x:float): float;
begin
end;

function TSenl.secante(_funcion: String;_x:float): float;
var xn,xn1,fxn,fxnh,e,er,h,aux : float; var fun2 : TParseMath;
begin
     xn:=_x; e:=0.00001;  er:=e; h:=e/10;

     fun2 := TParseMath.Create();
     fun2.Expression := _funcion;

     //   PRIMERA
     try
     fun2.AddVariable('x', xn); fxn:= fun2.Evaluate();
     fun2.NewValue('x',(xn+h) ); fxnh:= fun2.Evaluate();

     finally      //if (fxn=0)or(fxn=infinity) then ShowMessage('error fxn '+ FloatToStr(fxn))
                  //else if (fxnh=0) or (fxnh=infinity) then ShowMessage('eror fxnh '+FloatToStr(fxnh))
                  //else if fxnh-fxn=0 then ShowMessage('eror fxnh-fxn '+FloatToStr(fxnh-fxn));
     end;
     if (fxn=0)or(fxnh=0) or (fxn=infinity)or (fxnh=infinity) or (fxnh-fxn=0)then exit;

     xn1:=xn-((h*fxn)/(fxnh-fxn));
     er:=xn-xn1;
     if er<0 then er:=er*-1;
     xn:=xn1;

     while er >= e do
     begin
     try
     fun2.NewValue('x', xn); fxn:= fun2.Evaluate();
     fun2.NewValue('x',(xn+h) ); fxnh:= fun2.Evaluate();
     finally      //if (fxn=0)or(fxn=infinity) then ShowMessage('error fxn '+ FloatToStr(fxn))
                  //else if (fxnh=0) or (fxnh=infinity) then ShowMessage('eror fxnh '+FloatToStr(fxnh))
                  //else if fxnh-fxn=0 then ShowMessage('eror fxnh-fxn '+FloatToStr(fxnh-fxn));
     end;
     if (fxn=0)or(fxnh=0) or (fxn=infinity)or (fxnh=infinity) or (fxnh-fxn=0)then exit;
     xn1:=xn-((h*fxn)/(fxnh-fxn));
     er:=xn-xn1;
     if er<0 then er:=er*-1;
     xn:=xn1;
     end;
     fun2.destroy;
     secante:=xn;

end;

end.

