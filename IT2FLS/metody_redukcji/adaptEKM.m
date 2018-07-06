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
N=size(lowerF);
l=round(N/2.4);
a= sum(lowerY(1:l).*upperF(1:l)) + sum(lowerY(l+1:end).*lowerF(l+1:end));
b= sum(upperF(1:l)) + sum(lowerF(l+1:end));
y=a/b;

while(1)
    
    % Step 2.
    lussu = 0;
    for i=1:N-1;
        if y>=lowerY(i) && y<=lowerY(i+1)
            lussu = i;
            break
        end
    end
    
    % Step 3.
    if lussu==l
        outextreme = y;
        break
    else
        
        % Step 4.
        s=sign(lussu-l);
        aussu=a+s*(sum(lowerY(min(l,lussu)+1:max(l,lussu)).*(upperF(min(l,lussu)+1:max(l,lussu))-lowerF(min(l,lussu)+1:max(l,lussu)))));
        bussu=b+s*(sum(upperF(min(l,lussu)+1:max(l,lussu))-lowerF(min(l,lussu)+1:max(l,lussu))));
        yussu=aussu/bussu;
        % Step 5.
        y=yussu;
        a=aussu;
        b=bussu;
        l=lussu;
    end
end

end

%% EIASC Algorithm for Computing Y right
if maxflag > 0
    
    % Sort Y matrix
    upperY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;
N=size(lowerF);
    % Step 1.
r=round(N/1.7);
a= sum(upperY(1:r).*lowerF(1:r)) + sum(upperY(r+1:end).*upperF(r+1:end));
b= sum(lowerF(1:r)) + sum(upperF(r+1:end));
y=a/b;

while(1)
    
    % Step 2.
    russu = 0;
    for i=1:N-1;
        if y>=upperY(i) && y<=upperY(i+1)
            russu = i;
            break
        end
    end
    
    % Step 3.
    if russu==r
        outextreme = y;
       
        break
    else
        
        % Step 4.
        s=sign(russu-r);
        aussu=a-s*(sum(upperY(min(r,russu)+1:max(r,russu)).*(upperF(min(r,russu)+1:max(r,russu))-lowerF(min(r,russu)+1:max(r,russu)))));
        bussu=b-s*(sum(upperF(min(r,russu)+1:max(r,russu))-lowerF(min(r,russu)+1:max(r,russu))));
        yussu=aussu/bussu;
        % Step 5.
        y=yussu;
        a=aussu;
        b=bussu;
        r=russu;
    end
end
end
