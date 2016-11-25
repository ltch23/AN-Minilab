unit Ng;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,math;
type a= array of Real;
type m= array of array of Real;


type
TNg = class

  public
   function newton_generalizado(av: array of string ; a1: array of string ; a2:a): string;

end;


implementation
uses ParseMath,matrix;

function TNg.newton_generalizado(av: array of string ; a1: array of string ; a2:a): string;
var m_eval,m_e_aux,m_j,m_X_last,m_X,tmp,tmp2: m;
var m_fun: array of TParseMath;
var m_variables: array of string;
var rpta: a;
var i,j,k,l,n,c1,c2,r1,r2,c,tam: integer;
var h,e,er: float;
var m_matrix: TMatrix;
var str:String;

begin
tam:=Length(av);

SetLength(m_eval,tam,1);
SetLength(m_e_aux,tam,tam);
SetLength(m_j,tam,tam);
SetLength(rpta,tam);
SetLength(m_variables,tam);
SetLength(m_fun,tam);
SetLength(m_X,tam,1);
SetLength(m_X_last,tam,1);

e:=0.0001;
er:=e;
h:=e/1000;
n:=1;
c:=2;


for i:=0 to tam -1 do
    begin
     m_variables[i]:=av[i];
     m_fun[i]:= TParseMath.create();
     m_fun[i].Expression:=a1[i];
     m_X[i][0]:=a2[i];
     end;

for j:=0 to tam-1 do
    for i:=0  to tam-1 do
     m_fun[j].AddVariable(m_variables[i],m_X[i][0]);

for i:=0 to tam-1 do
m_eval[i][0]:=m_fun[i].Evaluate();

for i:=0 to tam-1 do
    for j:=0 to tam-1 do
    begin
    m_fun[i].NewValue(m_variables[j],m_X[j][0]+m_X[j][0]*h);
    m_e_aux[i][j]:=m_fun[i].Evaluate();
    m_fun[i].NewValue(m_variables[j],m_X[j][0]);
    end;

for i:=0 to tam-1 do
    for j:=0 to tam-1 do
    m_j[i][j]:=(m_e_aux[i][j]-m_eval[i][0])/(h*m_X[j][0]);

m_matrix := TMatrix.Create();
m_j:=m_matrix.inverse(m_j);

tmp:=m_matrix.multiply(m_j,m_eval);
tmp2:=m_matrix.subtract(m_X,tmp);

for i:=0 to tam-1 do
m_X_last[i][0]:=m_X[i][0];

for i:=0 to tam-1 do
m_X[i][0]:=tmp2[i][0];

n:=n+tam;

while er >=e do
begin

for j:=0 to tam-1 do
    for i:=0  to tam-1 do
     m_fun[j].NewValue(m_variables[i],m_X[i][0]);

for i:=0 to tam-1 do
m_eval[i][0]:=m_fun[i].Evaluate();

for i:=0 to tam-1 do
    for j:=0 to tam-1 do
    begin
    m_fun[i].NewValue(m_variables[j],m_X[j][0]+m_X[j][0]*h);
    m_e_aux[i][j]:=m_fun[i].Evaluate();
    m_fun[i].NewValue(m_variables[j],m_X[j][0]);
    end;

for i:=0 to tam-1 do
    for j:=0 to tam-1 do
    m_j[i][j]:=(m_e_aux[i][j]-m_eval[i][0])/(h*m_X[j][0]);

m_matrix := TMatrix.Create();
m_j:=m_matrix.inverse(m_j);

tmp:=m_matrix.multiply(m_j,m_eval);
tmp2:=m_matrix.subtract(m_X,tmp);

er:=0;
for i:=0 to tam-1 do
    er:=er+power(m_X_last[i][0]- m_X[i][0],2);
er:=power(er,1/2);

for i:=0 to tam-1 do
m_X_last[i][0]:=m_X[i][0];

for i:=0 to tam-1 do
m_X[i][0]:=tmp2[i][0];

n:=n+tam;
c:=c+1;
end;


str:=' ';
for i:=0 to tam -1 do begin
rpta[i]:=m_X[i][0];
str:=str+FloatToStr(rpta[i])+' ';
end;


newton_generalizado:=str;

end;



end.

