function [agg_L, agg_R] = sug_agg(Z_imp,wart_d,wart_g)
    
        %funkcja agregacji metoda sum w sugeno
        
        mian_g=sum(wart_g);
        mian_d=sum(wart_d);
        liczn_g=0;
        liczn_d=0;
        
        for i=1:length(Z_imp)
            liczn_g=liczn_g+wart_g(i)*Z_imp(i);
            liczn_d=liczn_d+wart_d(i)*Z_imp(i);
        end

        
        agg_L = liczn_d/mian_d;
        agg_R = liczn_g/mian_g;