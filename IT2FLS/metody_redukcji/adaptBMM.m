%% adapt.m  
%% BMM TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

alfa=0.5;
beta=0.5;

if maxflag 
    
hl = (lower_sort+upper_sort)/2 ;

S =  alfa *(sum(ysort.*(lower_sort)))/sum(lower_sort)+ beta *(sum(ysort.*(upper_sort)))/sum(upper_sort);

count = 0 ;
theta = hl ;
   outextreme = S ;

end 


