unit matrix;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math;
type t_matrix= array of array of real;
type
  TMatrix = Class
  private
  col1, col2, row1, row2: integer;
  temp: array of array of real;
  public
  constructor create();
  function add(m1: t_matrix; m2: t_matrix): t_matrix;
  function subtract(m1: t_matrix; m2: t_matrix): t_matrix;
  function multiply(m1: t_matrix; m2: t_matrix): t_matrix;
  function inverse(m1: t_matrix): t_matrix;
  function det(m1:t_matrix):float;
  function determinant(m1: t_matrix; n:integer): float;


end;


implementation


constructor TMatrix.create();
begin
   col1:=0;
   row1:=0;
   col2:=0;
   row2:=0;
end;

function TMatrix.add(m1: t_matrix; m2: t_matrix): t_matrix;
var mrpta: t_matrix; var i,j:integer;
begin
col1:=Length(m1);
row1:=Length(m1[0]);
col2:=Length(m2);
row2:=Length(m2[0]);

if(col1=col2) and (row1=row2) then
  begin
  SetLength(mrpta, col1, row1);

  for i := 0 to col1 - 1 do
  begin
    for j := 0 to row1 - 1 do
       mrpta[i][j]:=m1[i][j]+m2[i][j];
  end;
  add:=mrpta;
  end;
end;

function TMatrix.subtract(m1: t_matrix; m2: t_matrix): t_matrix;
var mrpta: t_matrix; var i,j:integer;
begin
col1:=Length(m1);
row1:=Length(m1[0]);
col2:=Length(m2);
row2:=Length(m2[0]);

if(col1=col2) and (row1=row2) then
  begin
  SetLength(mrpta, col1, row1);

  for i := 0 to col1 - 1 do
  begin
    for j := 0 to row1 - 1 do
       mrpta[i][j]:=m1[i][j]-m2[i][j];
  end;
  subtract:=mrpta;
  end;
end;

function TMatrix.multiply(m1: t_matrix; m2: t_matrix): t_matrix;
var mrpta: t_matrix; var i,j,k:integer;
begin
col1:=Length(m1);
row1:=Length(m1[0]);
col2:=Length(m2);
row2:=Length(m2[0]);

if (col2=row1) then
 begin
 SetLength(mrpta, col1, row2);
 for i := 0 to col1 - 1 do
  begin
    for j := 0 to row2 - 1 do
    begin
      mrpta[i][j] := 0;
      for k := 0 to row1 - 1 do
          mrpta[i][j] := mrpta[i][j] + m1[i][k] * m2[k][j];
      end;
  end;
 multiply:=mrpta;
 end;

end;

function TMatrix.inverse(m1: t_matrix): t_matrix;
var i,j,l,k: integer; var aux: array of real;var mrpta,tmp: t_matrix;
begin
col1:=Length(m1);
row1:=Length(m1[0]);

  SetLength(aux,col1);
  SetLength(tmp,col1,2*col1);
  SetLength(mrpta,col1,col1);

  if(col1=row1) then
  begin
  for i:=0 to col1-1 do
      for j:=0 to col1-1 do
          tmp[i][j]:=m1[i][j];

  for i:= 0 to col1-1 do
    for j:= col1 to 2*col1-1 do
	if (j - col1 = i) then
     	tmp[i][j] := 1
	else
	tmp[i][j] := 0;


  for i:=0 to col1-1 do
      for j:=i to col1-1 do
          	if(tmp[j][i] <> 0) then
                begin
                      if(i<>j) then
                      begin
                      aux:=tmp[i];
                      tmp[i]:=tmp[j];
                      tmp[j]:=aux;
                      end;
                l:=col1*2-1;
                while l>=i do
                begin
                     tmp[i][l]:= tmp[i][l]/tmp[i][i];
                     l:=l-1;
                end;
                for k:= 0 to col1-1 do
                     if(tmp[k][i] <> 0)and (k <>i) then
                      begin
                                  l:=col1*2-1;
                                  while l>=i do
                                  begin
                                  tmp[k][l]:= tmp[k][l] - tmp[k][i]*tmp[i][l];
                                  l:=l-1;
                                  end;
                      end;
               	Break;
                end;

        for i:=0 to col1-1 do
        begin
        l:=0;
                for j:=col1 to 2*col1-1 do
                 begin
                     	mrpta[i][l]:=tmp[i][j];
                        l:=l+1;
                 end;
        end;
        inverse:=mrpta;
        end;
end;

function TMatrix.det(m1:t_matrix):float;
begin
     col1:=Length(m1);
   row1:=Length(m1[0]);

  if(col1=row1) then
begin SetLength(temp,col1,col1);
det:=determinant(m1,col1);
end;
end;

function TMatrix.determinant(m1: t_matrix; n: integer): float;
var p,h,k,i,j: integer ; var dete: float;
begin
col1:=Length(m1);
row1:=Length(m1[0]);

dete:=0;
if(n=1) then
dete:=m1[0][0];
determinant:=dete;
if(n=2) then
  begin
  dete:=(m1[0][0]*m1[1][1]-m1[0][1]*m1[1][0]);
  determinant:=dete;
  end
else
begin
for p:=0 to n-1 do
    begin
    h := 0; k:= 0;
    for i:=1 to n-1 do
    begin
      for j:=0 to n-1 do
      begin
        if j=p then
            Continue;
      temp[h][k]:= m1[i][j];
      k:=k+1;
     if k=n-1 then
       begin
         h:=h+1;  k:= 0;
        end;
     end;
    end;
    dete:=dete+m1[0][p]*power(-1,p)*determinant(temp,n-1);
  end;
  determinant:=dete;
end;

end;

end.




