%% adaptEIASC.m  

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

%% EKM2 Algorithm for Computing Y Left

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
          
    while(1)
        count=count+1;
        % Step 1.
    
        D= sum(lowerY(1:L).*upperF(1:L))+(sum(lowerY.*lowerF)-sum(lowerY(1:L).*lowerF(1:L)));
        P= sum(upperF(1:L))+(sum(lowerF)-sum(lowerF(1:L)));
        y=D/P;
        
        % Step 2. 
        for i=1:n-1;
            if  lowerY(i)<=y<=lowerY(i+1)             
                Lk = i;
                break
            end
        end
       
        % Step 3.
        if Lk == L
            
            outextreme=y;
            break
        else
            
        L=Lk;
        
        end

    end
end

%% EKM2 Algorithm for Computing Y right
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

     while(1)
        count=count+1;
        % Step 1.    
        D= sum(lowerY(1:R).*lowerF(1:R))+(sum(lowerY.*upperF)-sum(lowerY(1:R).*upperF(1:R)));
        P= sum(lowerF(1:R))+(sum(upperF)-sum(upperF(1:R)));
        yr=D/P;
        % Step 2. 
        for i=1:n-1;
            if  lowerY(i)<=yr<=lowerY(i+1)             
                Rk = i;
                break
            end
        end
       
        % Step 3.
        if Rk == R
            
            outextreme=yr;
            break
        else
            
        R=Rk;
        
        end

    end
end


