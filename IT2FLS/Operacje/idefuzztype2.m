function [xcoa,xl,xr] = idefuzztype2(iset,type)
%
% [xcoa,xl,xr] = idefuzztype2(iset,type)
%
% ********************************************************************
% * UNIVERSIDAD AUTONOMA DE BAJA CALIFORNIA, UABC.                   *
% * Facultad de Ciencias Quimicas e Ingenieria                       *
% * Ingenieria en Computacion, Unidad Tijuana                         *
% * Juan Ramon Castro Rodriguez                                      *
% ********************************************************************
%
x      = iset.X{1};
h      = (iset.LU{1}(:,1)+iset.LU{1}(:,2))/2;
delta  = (iset.LU{1}(:,2)-iset.LU{1}(:,1))/2;
%
if strcmp(type, 'centroid'),
    [xl,xr]=centroid_tr(x,h,delta);
    xcoa   = (xl+xr)/2;
    return;
elseif strcmp(type, 'cos'),
    [xl,xr] =cos_tr(x,zeros(size(x)),h,delta);
    xcoa   = (xl+xr)/2;
    return;
else 
    % defuzzification type is unknown
    % We assume it is user-defined and evaluate it here
    evalStr=[type '(x, mf)'];
    out = eval(evalStr);
    return;
end
