unit PIL;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils;

type
  TPil= Class

    public
      function f(m1:array of real ;m2:array of real):string;
  end;

implementation

uses ParseMath;




function TPil.f(m1:array of real ;m2:array of real):string;
var i,j,tam: integer;
begin
Length(m1);


for i:=0 to tam-1 do
begin
den:=1; num:=1;
  for j:=0 to tam-1 do
  begin
     if(j<>i) then
         begin
         PIL[i]:=PIL[i]+'(x-'+FloatToStr(m1[j])+')*';
         den:=den*m1[i]-m1[j];
         end;
    end;
  delete(PIL[i],Length(PIL[i]),1);
PIL[i]:='((('+PIL[i]+')/'+FloatToStr(den)+')*'+FloatToStr(m2[i])+')';
end;

for i:=0 to tam-2 do
P:=P+PIL[i]+'+';
P:=P+PIL[i+1];

f:='P(x)= '+P;

end;

end.

