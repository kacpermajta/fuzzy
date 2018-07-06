%x=0:0.01:1;
%min_dolna = 0.4;
%min_gorna = 0.5;
%[mf_dolna_wyj, mf_gorna_wyj] = gausssymmftype2(x,[0.1 0.3 0.5]);

function [X_ob, Y_ob] = and_plot_bs(x, min_dolna, min_gorna,mf_dolna_wyj,mf_gorna_wyj)
%warunki sprawdzajace czy dolna to czasem nie gorna
    if mean(mf_dolna_wyj) > mean(mf_gorna_wyj)
        temp = mf_gorna_wyj;
        mf_gorna_wyj = mf_dolna_wyj;
        mf_dolna_wyj = temp;
    end
%bs oznacza bez skalowania
            %and ze rysujemy wykres do addMethod = and
            %zamiana funkcji dolnej w wynikowa
            %zamiana funkcji gornej w wynikowa
            
            %mf_dolna_wyj(end+1) = 0;
            for i =1:length(x)
                if mf_dolna_wyj(i) <= min_dolna
                mf_dolna_ob(i) = mf_dolna_wyj(i);
                else
                    mf_dolna_ob(i) = min_dolna;
                end
                if mf_gorna_wyj(i) <= min_gorna;
                    mf_gorna_ob(i) = mf_gorna_wyj(i);
                else
                    mf_gorna_ob(i) = min_gorna;
                end
            end
            
            %warunki sprawdzajace czy przypadkiem mf_dolna_ob nie jest
            %wiêksza niz mf_gorna_ob
            if mean(mf_dolna_ob) > mean(mf_gorna_ob)
                temp = mf_gorna_ob;
                mf_gorna_ob = mf_dolna_ob;
                mf_dolna_ob = temp;
            end
            X_ob = [x fliplr(x)];
            Y_ob = [mf_dolna_ob fliplr(mf_gorna_ob)];
            plot(x,mf_dolna_wyj,x,mf_gorna_wyj,x,mf_gorna_ob,x,mf_dolna_ob);
            hold on;
            patch(X_ob,Y_ob,'b');
            
            
            