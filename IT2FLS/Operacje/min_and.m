function [min_dolna, min_gorna]= min_and(n_lin1x,n_lin2x, mf_dolna1, mf_gorna1,mf_dolna2,mf_gorna2);


n_lin1x = round(n_lin1x);
n_lin2x = round(n_lin2x);
min1_d = mf_dolna1(n_lin1x);
min1_g = mf_gorna1(n_lin1x);
min2_d = mf_dolna2(n_lin2x);
min2_g = mf_gorna2(n_lin2x);
[min_dolna,n1] = min([min1_d min2_d]);
[min_gorna,n2] = min([min1_g min2_g]);
% if n1 == 1
%     n_min_dolna = n_lin1x;
% else
%     n_min_dolna = n_lin2x;
%     
% end
% 
% if n2 == 1
%     n_min_gorna = n_lin1x;
%     
% else
%     n_min_gorna = n_lin2x;
% end