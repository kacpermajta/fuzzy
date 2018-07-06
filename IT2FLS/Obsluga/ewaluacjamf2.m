function [dolna, gorna] = ewaluacjamf2(x,parametry,nazwa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ewaluacjamf2
%   Funkcja ta generuje 2 wektory, jeden bedacy ciagiem wartosci dolnej
%   drugi gornej funkcji przynaleznosci
%   
%     Argumenty:
%     x - wektor wartosci osi odcietych
%     parametry - wektor parametrow funkcji przynaleznosci
%     nazwa - nazwa typu funkcji przynaleznosci
%
%     Funkcja zwraca:
%     dolna - wektor wartosci dolnej mf2
%     gorna - wektor wartosci gornej mf2
%     
%     Uzywane funkcje:
%     ---
%
%     Uzywane zmienne:
%     a
%     s
%     b
%     a1
%     b1
%     s1
%     a2
%     b2
%     s2
%     val 
%     iy1
%     iy2
%     ca
%     ia
%     cb
%     ib
%     sa
%     sb
%     y
%     z
%     p1
%     temp
%     
%     Uwagi:
%     W niktorych funkcjach wystepuja pewnego rodzaju nieciaglasci np. w
%     trapmftype2
%     
%     Autor:
%     Marcin Mik³as
%     rok 5
%     Kierunek: Automatyka i Robotyka
%     specjalnosc: Automatyka i Metrologia
%     Praca magisterska
%     temat: "Implementacja oprogramowania s³u¿¹cego do badan nad regulatorami rozmytymi typu 2 "
%     Promotor:
%     dr inz. Ireneusz Dominik
% 
%     Ostatnia modyfikacja:
%     14.07.2014r.
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parnum = length(parametry);
switch nazwa
    
    %mf2 trojkatna symetryczna
    case 'trisymmftype2'
        %a - 0 dla dolnej mf lewe, s - srodek, b - 0 dla gornej mf lewe;
        switch parnum 
            case 3
            parametry = sort(parametry);    
            a = parametry(1);
            b = parametry(2);
            s = parametry(3);
%             case 4,5,6
%             parametry = sort(parametry(1:3));     
%             a = parametry(1);
%             b = parametry(2);
%             s = parametry(3);
%             otherwise
%             parametry = sort(parametry(1:3));     
%             a = parametry(1);
%             b = parametry(2);
%             s = parametry(3);   
        end

        delta = abs([s-a]);
        a1 = s + delta;
        delta = abs([s-b]);
        b1 = s + delta;
        
        dolna = trimf(x, [b s b1]);
        gorna = trimf(x, [a s a1]);
        
        
        %mf2 trojkatna niesymetryczna
    case 'trimftype2'
        %a - 0 dla dolnej mf lewe, s - srodek, b - 0 dla gornej mf lewe;
        switch parnum 
            case 3;4;5;
                parametry = sort(parametry);    
                a1 = parametry(1);
                s1 = parametry(2);
                b1 = parametry(3);
                delta = s1 - a1;
                a2 = a1-delta;
                s2 = s1;
                b2 = b1+delta; 
            case 6;8;
                parametry(1:3) = sort(parametry(1:3));
                parametry(4:6) = sort(parametry(4:6));
                a1 = parametry(1);
                s1 = parametry(2);
                b1 = parametry(3);
                a2 = parametry(4);
                s2 = parametry(5);
                b2 = parametry(6);
        end

        
            
        y1 = trimf(x, [a1 s1 b1]);
        y2 = trimf(x, [a2 s2 b2]);
            for i = 1:length(x)
                if y1(i) >= y2(i)
                    gorna(i) = y1(i);
                else
                    gorna(i) = y2(i);
                end
                if y1(i) <= y2(i);
                    dolna(i) = y1(i);
                else
                    dolna(i) = y2(i);
                end
            end
        
        %tworzenie wartosci 1
        [val, iy1] = max(y1);
        [val, iy2] = max(y2);
        %gorna(iy1:iy2) =1;
        gorna(iy1:iy2) = ones(length(abs(iy1-iy2)),1);
        
    case 'tri2mftype2'
        %a - 0 dla dolnej mf lewe, s - srodek, b - 0 dla gornej mf lewe;

         switch parnum 
            case 3
                %parametry = sort(parametry);    
                a = parametry(1);
                s = parametry(2);
                b = parametry(3);
                delta = s1 - a1;
                c = 0.1;
             case 4;5;6;8;
                 %parametry = sort(parametry);
                 a = parametry(1);
                 s = parametry(2);
                 b = parametry(3);
                 c = parametry(4)/4;           
        end       
       
        
          
        dolna = trimf(x, [a s b]);
        gorna = trapmf(x, [a-c s-c s+c b+c]);
          
        
%     case 'tri3mftype2'
%         %a - 0 dla dolnej mf lewe, s - srodek, b - 0 dla gornej mf lewe;
%         a = parametry(1);
%         b = parametry(2);
%         s = parametry(3);
%         c = parametry(4);
%         
%   
%         dolna = trimf(x, [a s b]);
%         dolna = dolna - c;
%         gorna = trapmf(x, [a-c s-c s+c b+c]);        
            
            
    %mf2 gauss niesymetryczna    
    case 'gaussmftype2'
        %a - sigma pierwszej mf, sa - srodek pierwszej , b - sigma dla drugiej mf, sb - srodek drugiej;
        switch parnum 
            case 3
                a = parametry(1);
                sa = parametry(2);
                sb = sa;
                b = parametry(3);
            case 4;5;6;8;
               % parametry = sort(parametry);
                a =  parametry(1);
                sa = parametry(2);
                b =  parametry(3);
                sb = parametry(4);          
        end  
        
        
        if  a == 0 
            a = 0.3;
        end
        if  b == 0
            b = 0.1;
        end
        %sprawdzenie czy parametry sa dobrze wpisane
        if sa > sb
            [sa,sb]=swap(sa,sb);
          %  temp = sa;
           % sa = sb;
           % sb = temp;
        end
            
        %utworzenie zakresu pomiêdzy œrodkami o wartoœci 1;
        % zak = abs(sb - sa);

        gorna = ones(1,length(x));
        y1 = gaussmf(x,[a,sa]);        
        y2 = gaussmf(x,[b,sb]);        
        if sa > x(1)

        [ca,ia] = max(y1);
        gorna(1:ia) = y1(1:ia);
        end
        if sb < x(end)

        [cb,ib] = max(y2);
                gorna(ib:length(x)) = y2(ib:length(x));
        end
        %utworzenie gornej mf
       
  
        %utworzenie dolnej mf
        
        for i=1:length(x);
           if y1(i) < y2(i)
               dolna(i) = y1(i);
           else
               dolna(i) = y2(i);
           end
        end


    %mf2 gauss symetryczna    
    case 'gausssymmftype2'
        %a - sigma pierwszej mf, sa - srodek pierwszej, sb - srodek drugiej;
        a  = parametry(1);
        sa = parametry(2);
        sb = parametry(3);
        
        %sprawdzenie czy parametry sa dobrze wpisane
        if sa > sb
            temp = sa;
            sa = sb;
            sb = temp;
        end
        %utworzenie zakresu pomiêdzy œrodkami o wartoœci 1;
        % zak = abs(sb - sa);

        gorna = ones(1,length(x));

        y1 = gaussmf(x,[a,sa]);
        [ca,ia] = max(y1);
        y2 = gaussmf(x,[a,sb]);
        [cb,ib] = max(y2);
        %utworzenie gornej mf
        if y1(ia) > y2(ia)
            gorna(1:(ia-1)) = y1(1:(ia-1));
            gorna((ib+1):length(y1)) = y2((ib+1):length(y2));
        else 
            gorna(1:(ia-1)) = y2(1:(ia-1));
            gorna((ib+1):length(y1)) = y1((ib+1):length(y1));
        end
        %utworzenie dolnej mf
        mid = floor((ib+ia)/2);
        if y1(ia) > y2(ia)
            dolna(1:mid) = y2(1:mid);
            dolna((mid+1):length(y1)) = y1((mid+1):length(y1));
        else 
            dolna(1:mid) = y1(1:mid);
            dolna((mid+1):length(y1)) = y2((mid+1):length(y1));
        end
        
        
    %mf2 bell symetryczny inny kat nachylenia
    case 'gbellsym1mftype2'      

        switch parnum 
            case 3
                a1 = parametry(1);
                a2 = 1.1*a1;
                b  = parametry(2);
                s  = parametry(3);   
            case 4;5;6;7;
               % parametry = sort(parametry);
                a1 = parametry(1);
                a2 = parametry(2);
                b  = parametry(3);
                s  = parametry(4);       
            case 8
                a1 = parametry(1);
                a2 = parametry(2);
                b  = parametry(3);
                s  = parametry(4);   
        end 
        
        y1 = gbellmf(x,[a1 b s]);
%         [c1,i1]=max(y1);
        y2 = gbellmf(x,[a2 b s]);
%         [c2,i2]=max(y2);
        
        if a1>a2
            gorna = y1;
            dolna = y2;
        else
            dolna = y1;
            gorna = y2;
        end
%         %utworzenie górnej mf
%         if y1(i1-1) > y2(i1-1)
%             gorna(1:i1-1) = y1(1:i1-1);
%             gorna(i1+1:length(x)) = y2(i1+1:length(x));
%         else
%             gorna(1:i1-1) = y2(1:i1-1);
%             gorna(i1+1:length(x)) = y1(i1+1:length(x));
%         end
%             gorna(i1)=y1(i1);
%             
%         %utworzenie dolne mf
%         if y1(i1-1) > y2(i1-1)
%             dolna(1:i1-1) = y2(1:i1-1);
%             dolna(i1+1:length(x)) = y1(i1+1:length(x));
%         else
%             dolna(1:i1-1) = y1(1:i1-1);
%             dolna(i1+1:length(x)) = y2(i1+1:length(x));
%         end
%             dolna(i1)=y1(i1);
        

    %mf2 bell symetryczny taki sam kat nachylenia
    case 'gbellmftype2'
        a1 = parametry(1); % odleglosc 1
        a2 = parametry(2); % odl 2
        b  = parametry(3); %nachylenie
        s  = parametry(4);%srodek   
        
        if (a1 ==0)
            a1 = 0.1;
        end
        if (a2 == 0)
            a2 = 0.1;
        end
        if (b == 0)
            b = 0.1;
        end
        
        y1 = gbellmf(x,[a1 b s]);
%         [c1,i1]=max(y1);
        y2 = gbellmf(x,[a2 b s]);
%         [c2,i2]=max(y2);
        
        if a1>a2
            gorna = y1;
            dolna = y2;
        else
            dolna = y1;
            gorna = y2;
        end
        
    %mf2 bell symetryczny 2 takie same ramiona
    case 'gbellsym3mftype2'
        a = parametry(1); % odleglosc 1
        b = parametry(2); % odleglosc 2
        c  = parametry(3); %nachylenie
        s  = parametry(4);%srodek   
        
        y = gbellmf(x,[a c s]);
        dolna = y;
%         [c1,i1]=max(y1);
        gorna = zeros(1,length(x));
        [z,p1] = max(y);
%         n = 1;
%         m = 1;
%         for i = 1:length(x);
%             if (y(i) ~= 0) && (y(i) ~= 1)
%                 if i < p
%                 zboczel(n) = y(i);
%                 n  = n + 1;
%                 else
%                 zboczer(m) = y(i);
%                 m = m + 1;
%                 end
%             end
%         end
         
        d = length(x)*b/x(length(x));
        d = floor(d);
        
        y1 = y(d+1:length(x)); % usuniecie pierwszych elementow macierzy
        y2 = y1(1:length(y1)-d); % usuniecie ostatnich elementow macierzy
        [z,p2] = max(y2);
        gorna(1:p1-d) = y2(1:p2);
        gorna(p1+d:length(x-d)) = y2(p2:length(y2));
        gorna(p1-d:p1+d) = ones(1,2*d+1); %uzupelnienie 1
        
    %mf2 trapez o dowolnej szerokosci i nachyleniu
    case 'trapmftype2'
        
        % zrobic tak zeby zawsze jeden trap byl pod drugim
        % zrobi tak zeby nie dalo sie zrobic trojkata

        
        switch parnum 
            case 3;4;5;6;7;
                parametry=sort(parametry);
                a1 = parametry(1)/2; %f gorna
                b1 = parametry(2)/2; 
                c1  = b1+parametry(3)/2; 
                d1  = b1+parametry(3);
                a2 = parametry(1); %f dolna
                b2 = parametry(2); 
                c2  = b2+parametry(3)/2; 
                d2  = b2+parametry(3);
            case 8
               % parametry = sort(parametry);
                a1 = parametry(1); %f gorna
                b1 = parametry(2); 
                c1  = parametry(3); 
                d1  = parametry(4);
                a2 = parametry(5); %f dolna
                b2 = parametry(6); 
                c2  = parametry(7); 
                d2  = parametry(8);         
        end 
%         
%         if (a1 > b1)
%             swap(a1,b1);
%         end
%         if (a2 > b2)
%             swap(a2,b2);
%         end
%          
%         if a2 < a1 
%             a2 = a1;
%         end    
%         if b2 < b1
%             b2 = b1;
%         end
%         if c2 > c1
%             c2 = c1;
%         end
%         if d2 > d1
%             d2 = d1;
%         end
               

        
%         if nargin < 9
%             e = 0.1;
%         else
%             e = parametry(9);
%         end
        
        y1 = trapmf(x,[a1 b1 c1 d1]);
        y2 = trapmf(x,[a2 b2 c2 d2]);
        %y2 = y2*0.9;
        if y2> 0.9
            y2=0.9;
        end



        gorna = y1;
        dolna = y2;
        
    %mf2 z
    case 'zmftype2'

        switch parnum 
            case 3
                parametry=sort(parametry);
                a1 = parametry(1);
                b1 = 1.1*a1;
                a2  = parametry(2);
                b2  = parametry(3);   
            case 4
               % parametry = sort(parametry);
                a1 = parametry(1);
                b1 = parametry(2);
                a2  = parametry(3);
                b2 = parametry(4);       
            case 5;6;7;8;
                parametry=sort(parametry(2:5));
                a1 = parametry(1);
                b1 = parametry(2);
                a2 = parametry(3);
                b2 = parametry(4);  
        end      
         if a1 > b1 
             a1 = b1;
         elseif b1 < a1;
             b1 = a1;
         else
            a1 = parametry(1);
            b1 = parametry(2);
         end
         if a2 > b2
             a2 = b2;
         elseif b2 < a2
             b2 = a2;
         else
             a2 = parametry(3);
             b2 = parametry(4);
         end

         y1 = zmf(x,[a1 b1]);
         y2 = zmf(x,[a2 b2]);

         dolna = y1;
         gorna = y2;
    %mf2 s
    case 'smftype2'
        switch parnum 
            case 3
                parametry=sort(parametry);
                a1 = parametry(1);
                b1 = 1.1*a1;
                a2  = parametry(2);
                b2  = parametry(3);   
            case 4
               % parametry = sort(parametry);
%                 parametry=sort(parametry);
                a1 = parametry(1);
                b1 = parametry(2);
                a2  = parametry(3);
                b2 = parametry(4);       
            case 5;6;7;8;
                parametry=sort(parametry(2:5));
                a1 = parametry(1);
                b1 = parametry(2);
                a2 = parametry(3);
                b2 = parametry(4);  
        end   
     
         if a1 > b1 
             a1 = b1;
         elseif b1 < a1;
             b1 = a1;
         else
            a1 = parametry(1);
            b1 = parametry(2);
         end
         if a2 > b2
             a2 = b2;
         elseif b2 < a2
             b2 = a2;
         else
             a2 = parametry(3);
             b2 = parametry(4);
         end

         y1 = smf(x,[a1 b1]);
         y2 = smf(x,[a2 b2]);

         gorna = y1;
         dolna = y2;
         
    %mf2 sigma
    case 'sigmftype2'
        switch parnum 
            case 3
                parametry=sort(parametry);
                a1 = parametry(1);
                b1 = 1.1*a1;
                a2  = parametry(2);
                b2  = parametry(3);   
            case 4
               % parametry = sort(parametry);
                parametry=sort(parametry);
                a1 = parametry(1);
                b1 = parametry(2);
                a2  = parametry(3);
                b2 = parametry(4);       
            case 5;6;7;8;
                parametry=sort(parametry(2:5));
                a1 = parametry(1);
                b1 = parametry(2);
                a2 = parametry(3);
                b2 = parametry(4);  
        end   
     
         if a1 > b1 
             a1 = b1;
         elseif b1 < a1;
             b1 = a1;
         else
            a1 = parametry(1);
            b1 = parametry(2);
         end
         if a2 > b2
             a2 = b2;
         elseif b2 < a2
             b2 = a2;
         else
             a2 = parametry(3);
             b2 = parametry(4);
         end

         y1 = sigmf(x,[a1 b1]);
         y2 = sigmf(x,[a2 b2]);

         gorna = y1;
         dolna = y2; 
    

        
end
%warunki sprawdzajace czy dolna to czasem nie gorna
if mean(dolna) > mean(gorna)
    temp = gorna;
    gorna = dolna;
    dolna = temp;
end

end