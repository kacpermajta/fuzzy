%% adapt.m  
%% TTCC TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;
yn = sum(ysort.*hl)/sum(hl) ;   
count = 0 ;
theta = hl ;
alfa=0.5;


%%  Algorithm for Computing Y 
N=length(ysort);

for i=1:N-1;
    if  ysort(i)<=yn<=ysort(i+1)
                
        sP = i;
    break
    end
end

for i=1:N
    
    if i<=sP
        fl(i) = lower_sort(i);
        fp(i) = upper_sort(i);
    else 
        fl(i) = upper_sort(i);
        fp(i) = lower_sort(i);
    end

end


if maxflag 
    
   y1 = sum(ysort.*fl)/sum(fl) ;
   y2 = sum(ysort.*fp)/sum(fp) ;
   outextreme= alfa*y1 + (1-alfa)*y2;
end 



