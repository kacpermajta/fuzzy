function [Xagg_ob, Yagg_ob] = sum_agg(X_ob_mac,Y_ob_mac)
    
        %funkcja agregacji metoda sum
        Xagg_ob = X_ob_mac(1,:);
        Yagg_ob = sum(Y_ob_mac);
