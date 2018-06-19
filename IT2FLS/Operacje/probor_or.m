function [probor_dolna, probor_gorna]= probor_or(n_lin1x,n_lin2x, mf_dolna1, mf_gorna1,mf_dolna2,mf_gorna2)

probor1_d = mf_dolna1(round(n_lin1x));
probor1_g = mf_gorna1(round(n_lin1x));
probor2_d = mf_dolna2(n_lin2x);
probor2_g = mf_gorna2(n_lin2x);
probor_dolna = probor([probor1_d ; probor2_d]);
probor_gorna = probor([probor1_g ; probor2_g]);