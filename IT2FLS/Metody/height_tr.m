%% height_tr.m 

%% Function used to implement the height type-reduction method that 
%% is described in Section 9.5.3 of the book.

%% Outputs : "l_out" and "r_out" (scalars) are, respectively, the
%% left and the right end-points of the type-reduced set "Y", which 
%% itself is an interval type-1 set.

%% Inputs : "h" is an M-vector, containing the height of each consequent set, 
%% and "w" and "delta" are  
%% M-vectors containing the centers and spreads of the firing degrees 
%% of each rule. 

function [l_out,r_out]=height_tr(h,w,delta)
L=length(h);
[l_out,r_out] = interval_wtdavg(h,zeros(1,L),w,delta);
