function [outextreme,count,theta] = adapt(ypoint,lower,upper,maxflag)

%% sort
[ysort,lower_sort,upper_sort] = trimvec(ypoint,lower,upper,1) ;
%% WM
hl = (lower_sort+upper_sort)/2 ;

count = 0 ;
theta = hl ;

lowerY = ysort;
upperY = ysort;
lowerF = lower_sort;
upperF = upper_sort;

upperyl=min(sum(lowerY.*(lowerF))/sum(lowerF),sum(lowerY.*(upperF))/sum(upperF));

loweryr=max(sum(upperY.*(lowerF))/sum(lowerF),sum(upperY.*(upperF))/sum(upperF));

loweryl=upperyl-(sum(upperF-lowerF)/(sum(upperF)*sum(lowerF)))*sum(lowerF.*(lowerY-lowerY(1)))*sum(upperF.*(lowerY(end)-lowerY))/(sum(lowerF.*(lowerY-lowerY(1)))+sum(upperF.*(lowerY(end)-lowerY)));

upperyr=loweryr+(sum(upperF-lowerF)/(sum(upperF)*sum(lowerF)))*sum(upperF.*(upperY-upperY(1)))*sum(lowerF.*(upperY(end)-upperY))/(sum(upperF.*(upperY-upperY(1)))+sum(lowerF.*(upperY(end)-upperY)));



if maxflag < 0
    outextreme=(loweryl+upperyl)/2;
end
if maxflag > 0
    outextreme=(loweryr+upperyr)/2;
end

