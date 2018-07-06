%% adapt.m  
%% IASC TR
%%
function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%%
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;
    
hl = (lower_sort+upper_sort)/2 ;

count = 0 ;
theta = hl ;
    
%% IASC Algorithm for Computing Y Left

if maxflag < 0
    
    % Sort Y matrix
    lowerY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;

    % Step 1.
    N=size(lowerF);
    a= sum(lowerY.*lowerF);
    b= sum(lowerF);
    yl=lowerY(N);
    l=0;


    while(1)
        % Step 2.
        l=l+1;
        a=a+lowerY(l)*(upperF(l)-lowerF(l));
        b=b+upperF(l)-lowerF(l);
        c=a/b;

        % Step 3.
        if c>=yl
           count=l-1;
            outextreme =yl;
        break
        else
            yl=c;
       end

    end
end

%% IASC Algorithm for Computing Y right

if maxflag > 0
    
    % Sort Y matrix
    upperY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;


    % Step 1.
    
    a= sum(upperY.*upperF);
    b= sum(upperF);
    yr=upperY(1);
    r=0;


    while(1)
        % Step 2.
        r=r+1;
        a=a-upperY(r)*(upperF(r)-lowerF(r));
        b=b-upperF(r)+lowerF(r);
        c=a/b;

        % Step 3.
        if c<=yr
           count=r-1;
           outextreme = yr ;
        break
        else
            yr=c;
       end

    end
end

