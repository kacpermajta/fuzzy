function [ X_ob, Y_ob ] = prod_plot_bs( x, min_dolna, min_gorna, mf_dolna_wyj, mf_gorna_wyj )
%PROD_PLOT_BS Summary of this function goes here
%   Detailed explanation goes here

mf_dolna_wyj = mf_dolna_wyj * min_dolna;
mf_gorna_wyj = mf_gorna_wyj * min_gorna;


X_ob = [x fliplr(x)];
Y_ob = [mf_dolna_wyj fliplr(mf_gorna_wyj)];
end

