function [Xagg_ob, Yagg_ob] = max_agg(X_ob_mac,Y_ob_mac)
    
        %funkcja agregacji metoda maksimow
        Xagg_ob = X_ob_mac(1,:);
        Yagg_ob = max(Y_ob_mac);
