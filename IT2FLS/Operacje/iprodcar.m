function AxB = iprodcar(A,B,stnorm)
%
% Producto cartesiano de dos conjuntos difusos tipo-2 por intervalos
%
% AxB = iprodcar(A,B)
%
% ********************************************************************
% * UNIVERSIDAD AUTONOMA DE BAJA CALIFORNIA, UABC.                   *
% * Facultad de Ciencias Quimicas e Ingenieria                       *
% * Ingenieria en Computacion, Unidad Tijuana                         *
% * Juan Ramon Castro Rodriguez                                      *
% ********************************************************************
%
AxBL = prodcar(A.LU{1}(:,1)',B.LU{1}(:,1)',stnorm);
AxBU = prodcar(A.LU{1}(:,2)',B.LU{1}(:,2)',stnorm);
AxB.X{1} = A.X{1};
AxB.X{2} = B.X{1};
AxB.LU{1}= {AxBL,AxBU};
