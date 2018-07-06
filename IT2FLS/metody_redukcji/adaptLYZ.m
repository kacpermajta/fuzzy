%% adapt.m  
%% LYZ TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;
count = 0 ;
theta = hl ;

%% LYZ Algorithm for Computing Y Left

if maxflag < 0

l1 = sum(min(ysort.*lower_sort,ysort.*upper_sort))/sum(lower_sort);
l2 = sum(min(ysort.*lower_sort,ysort.*upper_sort))/sum(upper_sort);
outextreme = min(l1,l2);

end 

%% LYZ Algorithm for Computing Y Right

if maxflag > 0

r1 = sum(max(ysort.*lower_sort,ysort.*upper_sort))/sum(lower_sort);
r2 = sum(max(ysort.*lower_sort,ysort.*upper_sort))/sum(upper_sort);
outextreme = max(r1,r2);

end 



