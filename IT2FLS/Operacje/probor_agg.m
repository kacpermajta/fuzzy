function [Xagg_ob, Yagg_ob] = probor_agg(X_ob_mac,Y_ob_mac)
    
        %funkcja agregacji metoda probor
        Xagg_ob = X_ob_mac(1,:);
        Yagg_ob = probor(Y_ob_mac);
