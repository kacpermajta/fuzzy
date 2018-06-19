%% centroid_tr.m 
%%
%% [l_out,r_out]=centroid_tr(z,w,delta)
%%
%% Written by Nilesh N. Karnik - August 9,1998
%% For use with MATLAB 5.1 or higher.
%%
%% Function used to implement the centroid type-reduction method that 
%% is described in Section 9.5.1 of the book.
%% Outputs : "l_out" and "r_out" (scalars) are, respectively, the
%% left and the right end-points of the type-reduced set "Y", which 
%% itself is an interval type-1 set.
%%
%% Inputs : "z" is a N-vector, containing the value of each sampling point, 
%% and "w" and "delta" are  
%% N-vectors containing the centers and spreads of the membership degrees 
%% of each sampling point. 

function [l_out,r_out]=centroid_tr(z,w,delta)

L=length(z);
[l_out,r_out] = interval_wtdavg(z,zeros(L,1),w,delta);
