%% adapt.m  
%% C-J TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;
count = 0 ;
theta = hl ;


%%  Algorithm for Computing Y 


if maxflag 
    
    N=length(ysort);        
    f=zeros(2*N);
    y=zeros(2*N);
    
    for i=1:2*N;
        if  i <= N
            f(i)= lower_sort(i); 
            y(i)= ysort(i);
        else
            
            f(i)= upper_sort(2*N-i+1);
            y(i)= ysort(2*N-i+1);
        end
    end
    
    d=zeros(2*N-1);
    p=zeros(2*N-1);
    
    for i=1:(2*N-1);
        d(i)=(y(i)+y(i+1))*(y(i)*f(i+1) - y(i+1)*f(i));
        p(i)=y(i)*f(i+1)-y(i+1)*f(i);
    end
    
    outextreme= sum(d)/(3*sum(p));

end 