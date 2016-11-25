unit PIL;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

type
  TPil= Class

    public
      var matrix: array of array of real;
      function f(_X:string;_Y:string):string;
      procedure detectar(X:string;Y:string);
  end;

implementation

uses ParseMath;


procedure TPil.detectar(X:string;Y:string);
begin

if(pos('[',X) >0) then
    begin
    while  pos(']',X) >0) do begin

    matrix[][]:=StrToFloat(copy(X,pos('(',X)+1, pos(';',X)-1-pos('(',X)));
    delete(FinalLine,pos('(',FinalLine)+1, pos(';',FinalLine)-pos('(',FinalLine));
    matrix[][]:=StrToFloat(copy(X,pos('(',X)+1, pos(';',X)-1-pos('(',X)));

     end;
end;

function TPil.f(_X:string;_Y:string):string;
var i,j: integer; var den,num,value: float; var PIL: array of String; var P:String;
begin
SetLength(matrix,tam,2);
SetLength(PIL,tam);
//value:=StrToFloat(Edit1.Text);
//llenando matriz de stringgrild

for i:=0 to tam-1 do
begin
     matrix[i][0]:=StrToFloat(StringGrid4.Cells[0,i]);
     matrix[i][1]:=StrToFloat(StringGrid4.Cells[1,i]);
end;

for i:=0 to tam-1 do
begin
den:=1; num:=1;
  for j:=0 to tam-1 do
  begin
     if(j<>i) then
         begin
         PIL[i]:=PIL[i]+'(x-'+FloatToStr(Matrix[j][0])+')*';
         den:=den*(Matrix[i][0]-Matrix[j][0]);
         end;
    end;
  delete(PIL[i],Length(PIL[i]),1);
PIL[i]:='((('+PIL[i]+')/'+FloatToStr(den)+')*'+FloatToStr(matrix[i][1])+')';
end;

for i:=0 to tam-2 do
P:=P+PIL[i]+'+';
P:=P+PIL[i+1];

f:='P(x)= '+P;

//fun:=TParseMath.create();
//fun.Expression:=P;
//fun.AddVariable('x',0);


end;

end.

