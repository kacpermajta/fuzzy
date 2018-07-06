%% adaptEIASC.m  

function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%% sort
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;

count = 0 ;
theta = hl ;


%% EIASC Algorithm for Computing Y Left

if maxflag < 0
    
    % Sort Y matrix
    lowerY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;

    % Step 1.
    
    a= sum(lowerY.*lowerF);
    b= sum(lowerF);
    L=0;


    while(1)
        count=count+1;
        % Step 2.
        L=L+1;
        a=a+lowerY(L)*(upperF(L)-lowerF(L));
        b=b+upperF(L)-lowerF(L);
        yl=a/b;

        % Step 3.
        if yl<=lowerY(L+1)
            
            outextreme=yl;
            break

        end

    end
end

%% EIASC Algorithm for Computing Y right
if maxflag > 0
    
    % Sort Y matrix
    upperY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;

    % Step 1.
    N=length(upperF);
    a = sum(upperY.*upperF);
    b = sum(upperF);
    R = N;

    while(1)
        count=count+1;
        % Step 2.
        a=a+upperY(R)*(upperF(R)-lowerF(R));
        b=b-upperF(R)+lowerF(R);
        yr=a/b;
        R=R-1;
        % Step 3.
        if yr>=upperY(R)
           
           outextreme=yr;
        break
       end

    end
end

