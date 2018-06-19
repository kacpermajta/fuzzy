function iset = inottype2(isetA)
%
% Negacion de un conjunto difuso tipo-2 por intervalos
%
% iset = inottype2(isetA)
%
% ********************************************************************
% * UNIVERSIDAD AUTONOMA DE BAJA CALIFORNIA, UABC.                   *
% * Facultad de Ciencias Quimicas e Ingenieria                       *
% * Ingenieria en Computacion, Unidad Tijuana                         *
% * Juan Ramon Castro Rodriguez                                      *
% ********************************************************************
%
XA     = isetA.X{1};
LowerA = isetA.LU{1}(:,1);
UpperA = isetA.LU{1}(:,2);

LowerNotA = 1-UpperA;
UpperNotA = 1-LowerA;

iset.X{1} = XA;
iset.LU{1}= [LowerNotA UpperNotA];
