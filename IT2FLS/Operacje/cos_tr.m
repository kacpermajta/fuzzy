%% cos_tr.m 
%%
%% [l_out,r_out]=cos_tr(z,s,w,delta);
%%
%% Written by Nilesh N. Karnik - August 9,1998
%% For use with MATLAB 5.1 or higher.
%%
%% Function used to implement the center-of-sets type-reduction method 
%% that is described in Section 9.5.5 of the book.
%%
%% Outputs : "l_out" and "r_out" (scalars) are, respectively, the
%% left and the right end-points of the type-reduced set "Y", which 
%% itself is an interval type-1 set.
%%
%% Inputs : "z" and "s" are M-vectors, containing the center and spread of 
%% the center-of-sets of each consequent set, 
%% and "w" and "delta" are  
%% M-vectors containing the centers and spreads of the firing degrees 
%% of each rule. 

function [l_out,r_out]=cos_tr(z,s,w,delta)
disp('Cos');
[l_out,r_out] = interval_wtdavg(z,s,w,delta);
return;
