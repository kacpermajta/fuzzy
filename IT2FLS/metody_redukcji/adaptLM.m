%% adapt.m  
%% LM TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;
count = 0 ;
theta = hl ;

%% LM Algorithm for Computing Y Left

if maxflag < 0

outextreme = sum(ysort.*(lower_sort))/sum(lower_sort);

end 

%% LM Algorithm for Computing Y Right

if maxflag > 0

outextreme = sum(ysort.*(upper_sort))/sum(upper_sort);

end 