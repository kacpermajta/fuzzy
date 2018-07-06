%% adapt.m  
%% Nie Tan TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

if maxflag 
    
hl = (lower_sort+upper_sort)/2 ;
S = sum(ysort.*(lower_sort+upper_sort))/sum(lower_sort+upper_sort) ;   

count = 0 ;
theta = hl ;
   outextreme = S ;

end 


