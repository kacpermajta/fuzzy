function [max_dolna, max_gorna]= max_or(n_lin1x,n_lin2x, mf_dolna1, mf_gorna1,mf_dolna2,mf_gorna2);

max1_d = mf_dolna1(n_lin1x);
max1_g = mf_gorna1(n_lin1x);
max2_d = mf_dolna2(n_lin2x);
max2_g = mf_gorna2(n_lin2x);
max_dolna = max([max1_d max2_d]);
max_gorna = max([max1_g max2_g]);