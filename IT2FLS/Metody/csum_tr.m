%% csum_tr.m 

%% Function used to implement the center-of-sums type-reduction method 
%% that is described in Section 9.5.2 of the book.

%% Outputs : "l_out" and "r_out" (scalars) are, respectively, the
%% left and the right end-points of the type-reduced set "Y", which 
%% itself is an interval type-1 set.

%% Inputs : "z" is a N-vector, containing the value of each sampling point, 
%% and "w" and "delta" are  
%% N-vectors containing the centers and spreads of the membership degrees 
%% of each sampling point, which are obtained after taking the sum of all 
%% upper (and lower) membership degrees for each point and then get 
%% the center and spread.

function [l_out,r_out]=csum_tr(z,w,delta)

L=length(z);
[l_out,r_out] = interval_wtdavg(z,zeros(1,L),w,delta);
