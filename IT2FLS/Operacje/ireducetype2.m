function iset = ireducetype2(set,cut)
%
% iset = ireducetype2(set,cut)
%
% Reduce un conjunto difuso tipo-2 generalizado a
% un conjunto difuso tipo-2 por intervalos
% por medio de un corte en la funcion de membresia secundaria
%
% ********************************************************************
% * UNIVERSIDAD AUTONOMA DE BAJA CALIFORNIA, UABC.                   *
% * Facultad de Ciencias Quimicas e Ingenieria                       *
% * Ingenieria en Computacion, Unidad Tijuana                         *
% * Juan Ramon Castro Rodriguez                                      *
% ********************************************************************
%
M = [];
for i=1:size(set.X{1},1),
    index = find(set.fXU{i}(:,2)>=cut);
    M = [M ; minmax(set.fXU{i}(index,1)')];
end
iset.X{1} = set.X{1};
iset.LU{1}= M;
