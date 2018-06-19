function iset = itnormtype2(isetA,isetB,stnorm)
%
% T-norm de dos conjuntos difusos tipo-2 por intervalos
%
% itnormtype2(isetA,isetB,stnorm)
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
%
XB     = isetB.X{1};
LowerB = isetB.LU{1}(:,1);
UpperB = isetB.LU{1}(:,2);
%
LowerTAB = feval(stnorm,LowerA,LowerB);
UpperTAB = feval(stnorm,UpperA,UpperB);
%
if size(XA,1) > size(XB,1)
    iset.X{1} = XA;
else
    iset.X{1} = XB;
end
%
iset.LU{1}= [LowerTAB UpperTAB];
