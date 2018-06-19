%% md_height_tr.m 

%% Function used to implement the modified height type-reduction method 
%% that is described in Section 9.5.4 of the book.

%% Outputs : "l_out" and "r_out" (scalars) are, respectively, the
%% left and the right end-points of the type-reduced set "Y", which 
%% itself is an interval type-1 set.

%% Inputs : "h" is an M-vector, containing the height of each consequent set, 
%% and "w" and "delta" are  
%% M-vectors containing the centers and spreads of the firing degrees 
%% of each rule. 
%% sp is an M-vector containing the spread of each consequent set. 

function [l_out,r_out]=md_height_tr(h,w,delta,sp)

L=length(h);
w=w./(sp.^2);
delta=delta./(sp.^2);
[l_out,r_out] = interval_wtdavg(h,zeros(1,L),w,delta);
