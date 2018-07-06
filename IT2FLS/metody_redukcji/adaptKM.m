%% adaptKM.m  

function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%% sort
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;
S = sum(ysort.*hl)/sum(hl) ;   % starting point

eps = 1e-3 ;   %%% small quantity to avoid floating point equality problems

count = 0 ;
theta = hl ;


%% KM Algorithm for Computing Y Left

if maxflag < 0
     % Sort Y matrix
        lowerY = ysort;
        lowerF = lower_sort;
        upperF = upper_sort;

    % b) Initialize fn by setting and computing

    isZero=(sum(hl)==0);
    nRules=length(lowerY);
    
    if isZero
        yn=0;
    else
        yn = S;
    end
    while(1)
        % c) Find switch point k (1 <= k <= N ? 1) such that yk <= y <= yk+1
        sPointLeft = 0;
        for i=1:nRules-1;
            if  lowerY(i)<=yn<=lowerY(i+1)
                
                sPointLeft = i;
                break
            end
        end
        % d) Compute
       
        for i=1:nRules
            if i<=sPointLeft
                fn(i) = lowerF(i);
            elseif i>sPointLeft
                fn(i) = upperF(i);
            end

        end
        if(sum(fn)==0)
            ynPrime=0;
        else
            ynPrime = sum(lowerY.*fn)/sum(fn);
        end
        % e) if yn==ynPrime stop else go to c)
        if(abs(yn-ynPrime)<eps)
            
            outextreme = ynPrime;
            
            break;
        else
            yn=ynPrime;
        end
    end
end

%% KM Algorithm for Computing Y Right

if maxflag > 0
    
     % Sort Y matrix
        UpperY = ysort;
        lowerF = lower_sort;
        upperF = upper_sort;

    % b) Initialize fn by setting and computing

    isZero=(sum(hl)==0);
    nRules=length(UpperY);
    
    if isZero
        yn=0;
    else
        yn = S;
    end
    % c) Find switch point k (1 <= k <= N ? 1) such that yk <= y <= yk+1
    while(1)
        sPointRight = 0;
        for i=1:nRules-1;
            if  UpperY(i)<=yn<=UpperY(i+1)
                
                sPointRight = i;
                break
            end
        end
        for i=1:nRules
            if i<=sPointRight
                fn(i) = upperF(i);
            elseif i>sPointRight
                fn(i) = lowerF(i);
            end
        end
        if(sum(fn)==0)
            ynPrime=0;
        else
            ynPrime = sum(UpperY.*fn)/sum(fn);
        end
        % e) if yn==ynPrime stop else go to c)
        if(abs(yn-ynPrime)<eps)
            
            outextreme = ynPrime;
            
            break;
        else
            yn=ynPrime;
        end
    end
end