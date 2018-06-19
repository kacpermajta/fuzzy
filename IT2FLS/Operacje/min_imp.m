function [Ximp_ob,Yimp_ob]= min_imp(X_mac_ob,Y_mac_ob);

Ximp_ob = X_mac_ob(1,:);
Yimp_ob = min(Y_mac_ob);
    