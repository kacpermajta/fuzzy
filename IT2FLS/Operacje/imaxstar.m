function set = imaxstar(A,R,stnorm)
% Composicion max-star de dos relaciones difusas tipo-2 por intervalos
%
% set = imaxstar(A,R,stnorm)
%
% ********************************************************************
% * UNIVERSIDAD AUTONOMA DE BAJA CALIFORNIA, UABC.                   *
% * Facultad de Ciencias Quimicas e Ingenieria                       *
% * Ingenieria en Computacion, Unidad Tijuana                         *
% * Juan Ramon Castro Rodriguez                                      *
% ********************************************************************
%
AL = A.LU{1}(:,1)';
AU = A.LU{1}(:,2)';
ALoRL = maxstar(AL,R.LU{1}{1},stnorm);
AUoRU = maxstar(AU,R.LU{1}{2},stnorm);
set.X{1}  = R.X{2};
set.LU{1} = [ALoRL' AUoRU'];
