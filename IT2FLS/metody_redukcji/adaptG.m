%% adapt.m  
%% Gorzalczany TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;
count = 0 ;
theta = hl ;


%% G Algorithm for Computing Y 


if maxflag 

    S= hl .* (1 - lower_sort + upper_sort);         
       
    [f,k]=max(S);

    outextreme = ysort(k);

end 



