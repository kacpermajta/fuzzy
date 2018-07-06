%% adaptEODS.m  

function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%% sort
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;

hl = (lower_sort+upper_sort)/2 ;

count = 0 ;
theta = hl ;


%% EODS Algorithm for Computing Y Left

if maxflag < 0
    
    % Sort Y matrix
    lowerY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;

    % Step 1.
    N=length(lowerY);
    m=2;
    n=N-1;
    Sl=(lowerY(m)-lowerY(1))*upperF(1);
    Sr=(lowerY(N)-lowerY(n))*lowerF(N);
    Fl=lowerF(N);
    Fr=upperF(1);


    while(1)
        count= count+1;
         % Step 2.
        if m==n
            %Step 4.
            if Sl<=Sr
                
                Fr=Fr+upperF(m);
            else
                
                Fl=Fl+lowerF(m);
            end
            % Step 5.
            yl=lowerY(m)+((Sr-Sl)/(Fr+Fl));
            outextreme=yl;
            break
        else
            % Step 3.
            if Sl>Sr
                Fl=Fl+lowerF(n);
                n=n-1;
                Sr=Sr+Fl*(lowerY(n+1)-lowerY(n));
            else
                Fr=Fr+upperF(m);
                m=m+1;
                Sl=Sl+Fr*(lowerY(m)-lowerY(m-1));
            end
        end
    end
end

%% EODS Algorithm for Computing Y right

if maxflag > 0
    
    % Sort Y matrix
    upperY = ysort;
    lowerF = lower_sort;
    upperF = upper_sort;

    % Step 1.
    N=length(upperY);
    m=2;
    n=N-1;
    Sl=(upperY(m)-upperY(1))*lowerF(1);
    Sr=(upperY(N)-upperY(n))*upperF(N);
    Fl=lowerF(1);
    Fr=upperF(N);


    while(1)
        count= count+1;
         % Step 2.
        if m==n
            %Step 4.
            if Sl<=Sr
                
                Fl=Fl+lowerF(m);
            else
                
                Fr=Fr+upperF(m);
            end
            % Step 5.
            yr=upperY(m)+((Sr-Sl)/(Fr+Fl));
            outextreme=yr;
            break
        else
            % Step 3.
            if Sl>Sr
                Fr=Fr+upperF(n);
                n=n-1;
                Sr=Sr+Fr*(upperY(n+1)-upperY(n));
            else
                Fl=Fl+lowerF(m);
                m=m+1;
                Sl=Sl+Fl*(upperY(m)-upperY(m-1));
            end
        end
        
    end
end