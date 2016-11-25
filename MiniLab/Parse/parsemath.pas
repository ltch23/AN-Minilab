unit ParseMath;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, math, fpexprpars, Dialogs,Newton,Senl,MI,Ms;

type arr= array of array of real;
type
  TParseMath = Class

  Private
      FParser: TFPExpressionParser;
      identifier: array of TFPExprIdentifierDef;
      Procedure AddFunctions();


  Public

      Expression: string;
      function NewValue( Variable:string; Value: Double ): Double;
      procedure AddVariable( Variable: string; Value: Double );
      procedure AddString( Variable: string; Value: string );

      function Evaluate(): Double;
      constructor create();
      destructor destroy;

  end;

implementation


constructor TParseMath.create;
begin
   FParser:= TFPExpressionParser.Create( nil );
   FParser.Builtins := [ bcMath ];
   AddFunctions();
   //FParser.Identifiers.AddFloatVariable( 'x', 0);
end;

destructor TParseMath.destroy;
begin
    FParser.Destroy;
end;

function TParseMath.NewValue( Variable: string; Value: Double ): Double;
var i: Variant;
begin
    FParser.IdentifierByName(Variable).AsFloat:= Value;

end;

function TParseMath.Evaluate(): Double;
begin
     FParser.Expression:= Expression;

     Result:= FParser.Evaluate.ResFloat;
end;


function IsNumber(AValue: TExprFloat): Boolean;
begin
  result := not (IsNaN(AValue) or IsInfinite(AValue) or IsInfinite(-AValue));
end;

Procedure ExprTan( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and ((frac(x - 0.5) / pi) <> 0.0) then
      Result.resFloat := tan(x)

   else
     Result.resFloat := NaN;
end;

Procedure ExprNewton( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
  f: string;
  TheNewton: TNewton;
begin
   f:= Args[ 0 ].ResString;
   x:= ArgToFloat( Args[ 1 ] );

   TheNewton:= TNewton.Create;
   TheNewton.InitialPoint:= x;
   TheNewton.Expression:= f;
   Result.ResFloat := TheNewton.Execute;

   TheNewton.Destroy;

end;

Procedure ExprBiseccion( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b: float;
  f: string;
  senl: TSenl;
begin
   f:= Args[ 0 ].ResString;
   a:= ArgToFloat( Args[ 1 ] );
   b:= ArgToFloat( Args[ 2 ] );

   Result.ResFloat := senl.biseccion(f,a,b);
end;

Procedure ExprFalsaPosicion( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b: float;
  f: string;
  senl: TSenl;
begin
   f:= Args[ 0 ].ResString;
   a:= ArgToFloat( Args[ 1 ] );
   b:= ArgToFloat( Args[ 2 ] );

   Result.ResFloat := senl.falsa_posicion(f,a,b);
end;

Procedure ExprSecante( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: float;
  f: string;
  senl: TSenl;
begin
   f:= Args[ 0 ].ResString;
   x:= ArgToFloat( Args[ 1 ] );

   Result.ResFloat := senl.secante(f,x);
end;

Procedure ExprSin( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := sin(x)

end;

Procedure ExprCos( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
   x := ArgToFloat( Args[ 0 ] );
   Result.resFloat := cos(x)

end;

Procedure ExprLn( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x)

   else
     Result.resFloat := NaN;

end;

Procedure ExprLog( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := ln(x) / ln(10)

   else
     Result.resFloat := NaN;

end;

Procedure ExprSQRT( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x: Double;
begin
    x := ArgToFloat( Args[ 0 ] );
   if IsNumber(x) and (x > 0) then
      Result.resFloat := sqrt(x)

   else
     Result.resFloat := NaN;

end;

Procedure ExprPower( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  x,y: float;

begin
    x := ArgToFloat( Args[ 0 ] );
    y := ArgToFloat( Args[ 1 ] );


     Result.resFloat := power(x,y);

end;

Procedure ExprIntegral( var Result: TFPExpressionResult; Const Args: TExprParameterArray);
var
  a,b,n,o,ia: float;
  op: integer;
  f: String;
  mi: TMI;
begin
   f:= Args[ 0 ].ResString;
   a := ArgToFloat( Args[ 1 ] );
   b := ArgToFloat( Args[ 2 ] );
   n := ArgToFloat( Args[ 3 ] );
   o:= ArgToFloat( Args[ 4 ] );
   ia:= ArgToFloat( Args[ 5 ] );
   op:=trunc(o);

   Case op of

   0: if(ia=0) then Result.resFloat :=mi.trapecio(f,a,b,Trunc(n))
      else  Result.resFloat :=mi.trapecioA(f,a,b,Trunc(n));
   1: if(ia=0) then Result.resFloat :=mi.simpson_simple(f,a,b,Trunc(n))
      else  Result.resFloat :=mi.simpson_simpleA(f,a,b,Trunc(n));
   2: if(ia=0) then Result.resFloat :=mi.simpson_38_simple(f,a,b,3)
      else  Result.resFloat :=mi.simpson_38_simpleA(f,a,b,3);
   3: if(ia=0) then Result.resFloat :=mi.simpson_38_compuesto(f,a,b,3)
      else  Result.resFloat :=mi.simpson_38_compuestoA(f,a,b,3);
   4: if(ia=0) then Result.resFloat :=mi.simpson_compuesto(f,a,b,Trunc(n))
      else  Result.resFloat :=mi.simpson_compuestoA(f,a,b,Trunc(n));
   else exit;

   end;

end;


Procedure TParseMath.AddFunctions();
begin
   with FParser.Identifiers do begin
       AddFunction('tan', 'F', 'F', @ExprTan);
       AddFunction('sin', 'F', 'F', @ExprSin);
       AddFunction('sen', 'F', 'F', @ExprSin);
       AddFunction('cos', 'F', 'F', @ExprCos);
       AddFunction('ln', 'F', 'F', @ExprLn);
       AddFunction('log', 'F', 'F', @ExprLog);
       AddFunction('sqrt', 'F', 'F', @ExprSQRT);
       AddFunction('power', 'F', 'FF', @ExprPower);

       AddFunction('Biseccion', 'S', 'SFF', @ExprBiseccion );
       AddFunction('FalsaPosicion', 'S', 'SF', @ExprFalsaPosicion );
       AddFunction('Secante', 'S', 'SF', @ExprSecante );
       AddFunction('Newton', 'S', 'SF', @ExprNewton );

       AddFunction('Integral', 'S', 'SFFFFF', @ExprIntegral );



   end

end;

procedure TParseMath.AddVariable( Variable: string; Value: Double );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;
   identifier[ Len - 1 ]:= FParser.Identifiers.AddFloatVariable( Variable, Value);

end;

procedure TParseMath.AddString( Variable: string; Value: string );
var Len: Integer;
begin
   Len:= length( identifier ) + 1;
   SetLength( identifier, Len ) ;

   identifier[ Len - 1 ]:= FParser.Identifiers.AddStringVariable( Variable, Value);
end;

end.

