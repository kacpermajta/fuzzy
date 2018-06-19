function [prod_dolna, prod_gorna]= prod_and(n_lin1x,n_lin2x, mf_dolna1, mf_gorna1,mf_dolna2,mf_gorna2)


n_lin1x = round(n_lin1x);
n_lin2x = round(n_lin2x);
prod1_d = mf_dolna1(n_lin1x);
prod1_g = mf_gorna1(n_lin1x);
prod2_d = mf_dolna2(n_lin2x);
prod2_g = mf_gorna2(n_lin2x);
[prod_dolna] = prod([prod1_d prod2_d],2);
[prod_gorna] = prod([prod1_g prod2_g],2);