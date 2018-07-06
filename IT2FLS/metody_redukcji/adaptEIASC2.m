%% adaptEIASC2.m  

function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%% sort
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;

count = 0 ;
theta = hl ;

y1=sum(ysort.*lower_sort)/sum(lower_sort);
y2=sum(ysort.*upper_sort)/sum(upper_sort);
ymin= min(y1,y2);
ymax= max(y1,y2);
n= length(ysort);

%% EIASC2 Algorithm for Computing Y Left

if maxflag < 0
    
    % Sort Y matrix
    lowerY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;
    
    for i=1:n-1;
        if  lowerY(i)<=ymin<=lowerY(i+1)             
            L = i;
            break
        end
    end


    % Step 1.
    
    D= sum(lowerY(1:L).*upperF(1:L))+(sum(lowerY.*lowerF)-sum(lowerY(1:L).*lowerF(1:L)));
    P= sum(upperF(1:L))+(sum(lowerF)-sum(lowerF(1:L)));
    
    ymin=D/P;

    while(1)
        count=count+1;
        % Step 2.
        a=upperF(L)-lowerF(L);
        D=D-a*lowerY(L);
        P=P-a;        
        yl=D/P;

        % Step 3.
        if yl<=ymin
            
            L=L-1;
            ymin=yl;  
            
        else
            outextreme=yl;
            break
        end

    end
end

%% EIASC2 Algorithm for Computing Y right
if maxflag > 0
    
    % Sort Y matrix
    lowerY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;
    
    for i=1:n-1;
        if  lowerY(i)<=ymax<=lowerY(i+1)             
            R = i;
            break
        end
    end

    % Step 1.
    
    D= sum(lowerY(1:R).*lowerF(1:R))+(sum(lowerY.*upperF)-sum(lowerY(1:R).*upperF(1:R)));
    P= sum(lowerF(1:R))+(sum(upperF)-sum(upperF(1:R)));
    
    ymax=D/P;

    while(1)
        count=count+1;
        % Step 2.
        a=upperF(R)-lowerF(R);
        D=D-a*lowerY(R);
        P=P-a;        
        yr=D/P;

        % Step 3.
        if yr>=ymax
            
            R=R+1;
            ymax=yr;  
            
        else
            outextreme=yr;
            break
        end

    end
end

