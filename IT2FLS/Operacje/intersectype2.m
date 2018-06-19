function AiB=intersectype2(A,B,stnorm)
%
% Interseccion de dos conjuntos difusos tipo-2 generalizados
%
% AiB=intersectype2(A,B,stnorm)
%
% ********************************************************************
% * UNIVERSIDAD AUTONOMA DE BAJA CALIFORNIA, UABC.                   *
% * Facultad de Ciencias Quimicas e Ingenieria                       *
% * Ingenieria en Computacion, Unidad Tijuana                         *
% * Juan Ramon Castro Rodriguez                                      *
% ********************************************************************
%
AiB.X = A.X;
for i=1:size(A.fXU,1),
    for j=1:size(A.fXU,2),
        AiB.fXU{i,j} = meet2(A.fXU{i,j},B.fXU{i,j},stnorm);
    end
end
