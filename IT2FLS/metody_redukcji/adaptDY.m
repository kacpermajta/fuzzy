%% adapt.m  
%% DY TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;
count = 0 ;
theta = hl ;

fn= [lower_sort, upper_sort];

%% DY Algorithm for Computing Y 

if maxflag 

S = (sum(ysort.*lower_sort)+sum(ysort.*upper_sort))/(sum(lower_sort)+sum(upper_sort));

outextreme = S;

end 




