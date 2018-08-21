function varargout = Baza_regul(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Baza_regul
%   Funkcja sluzy do wywolywania okna tworzenia regul
%   
%     Argumenty:
%     (I)varargin - argument wejsciowy
%     (O)vargout - argument wyjsciowy
%
%     Funkcja zwraca:
%     varargout
%     jest to nazwa obecnego fis
%     
%     Uzywane funkcje:
%     IT2FLS
%     + funkcje wbudowane w program Matlab
%
%     Uzywane zmienne:
%     nazwa - nazwa aktualnego fis
%     IleWejsc
%     IleWyjsc
%     Col
%     mfLt
%     listbox1
%     listbox2
%     num
%     zas_Num
%     Id_wej
%     Id_wyj
%     str1
%     str2
%     str3
%     temp_val
%     temp_str
%     baz_Reg_str
%     old_baz_reg_str
%     (I)varargin - argument wejsciowy
%     (O)vargout - argument wyjsciowy
%     fls - zmienna w ktorej zapisany jest aktualny fis
%     klaw - arg. w ktorym zapisywany jest aktualnie wcisniety klawisz
%     plik - nazwa zapisywanego pliku
%     sciezka - sciezka dostepu do arg. plik
%     hObject - aktualny obiekt
%     eventdata - nie uzywane
%     handles - struktura zawierajaca wszystkie obiekty i ich zmienne
%     Wszystkie wywolania (Callback) do listbox, textbox, popup etc.
%     ktore pomimo ze sa zapisane w tym pliku jako osobne funkcje stanowia
%     integralna czesc tej funkcji poprzez plik IT2FLS.fig
%     
%     Uwagi:
%     Plik/funkcja mocno powiazana z plikiem Baza_regul.fig - w nim zapisana jest 
%     konfiguracja graficzna wygladu GUI a takze powiazanie wszystkich funkcji callback
%     z ta funkcja.
%     
%     Autor:
%     Marcin Mik³as
%     rok 4
%     specjalnosc: Automatyka i Robotyka
%     Praca in¿ynierska
%     temat: "Praktyczna implementacja regulatora rozmytego typu 2 w oprogramowaniu Matlab"
%     Promotor:
%     dr inz. Ireneusz Dominik
% 
%     Ostatnia modyfikacja:
%     03.01.2013r.
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Baza_regul_OpeningFcn, ...
                   'gui_OutputFcn',  @Baza_regul_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Baza_regul is made visible.
function Baza_regul_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Baza_regul (see VARARGIN)

% Choose default command line output for Wej_ed
handles.output = hObject;
%structure = findobj(IT2FLS); 

if isempty(varargin)
    fls = readfis('bez_nazwy');
    handles.nazwa = 'bez_nazwy';
    nazwa = handles.nazwa;
else
    nazwa = char(varargin);
    fls = readfis(nazwa);
    handles.nazwa = nazwa;

end

    
    IleWejsc = length(fls.input);
    IleWyjsc = length(fls.output);
    Col = [0.99 1 0.7];
    
    %napisy nad okienkami
        WeTxt = uicontrol('Style','text', ...
                             'String','Jezeli ... ', ...
                             'BackgroundColor',Col, ...
                             'Position', [0 180 100 20]);
        WeTxt = uicontrol('Style','text', ...
                           'String','... wtedy ... ', ...
                           'BackgroundColor',Col, ...
                           'Position', [450 180 100 20]);
                       
                       
     %przycisk dodawania zasady
        DodBut = uicontrol('Style','pushbutton', ...
                           'String','Dodaj regule', ...
                           'BackgroundColor', Col, ...
                           'Position', [130 10 80 30], ...
                           'Callback', @dodzasfcn);
%      %przycisk edycji zasady
%         EdBut = uicontrol('Style','pushbutton', ...
%                            'String','Edytuj regule', ...
%                            'BackgroundColor', Col, ...
%                            'Position', [230 10 80 30], ...
%                            'Callback', @edzasfcn);

     %przycisk usuniecia zasady
        UsBut = uicontrol('Style','pushbutton', ...
                          'String','Usuñ regule', ...
                          'BackgroundColor', Col, ...
                          'Position', [230 10 80 30], ...
                          'Callback', @uszasfcn);
                      
      %update handles w gui
        guidata(hObject, handles);
                      

                
      
    %petle tworzaca odpowiednia ilosc tabel wejsc i wyjsc pozwalajacych na
    %edycje
    %ustawienia dla elementow
    
    
    %pierwotne handles okienek wejsc
    WeLiBox1 =0;
    WeLiBox2 =0;
    WeLiBox3 =0;
    WeLiBox4 =0;
    WyLiBox1 =0;
    WyLiBox2 =0;
    
    
    

    
    for i = 1:IleWejsc
        

        %przygotowanie tekstu do listboxa
        mfLt = length(fls.input(i).mf);
             for j = 1:mfLt
                 if j == 1
                     lbTxt = cellstr('');
                 end
                 lbTxt = fls.input(i).mf(j).name;
                 lbTxt = cellstr(lbTxt);
                 switch i 
                     case 1
                 listboxTxt1(j) = lbTxt;
                 listboxTxt1 = listboxTxt1';
                     case 2
                 listboxTxt2(j) = lbTxt;
                 listboxTxt2 = listboxTxt2';
                     case 3
                 listboxTxt3(j) = lbTxt;
                 listboxTxt3 = listboxTxt3';
                     case 4
                 listboxTxt4(j) = lbTxt;
                 listboxTxt4 = listboxTxt4';
                 end
             end
%             switch i
%                 case 1
%                             listboxTxt1(j+1) = cellstr('nic');
%                 case 2
%                            %  listboxTxt1(j+1) = cellstr('nic');
%                              listboxTxt2(j+1) = cellstr('nic');
%                 case 3
%                             % listboxTxt1(j+1) = cellstr('nic');
%                             % listboxTxt2(j+1) = cellstr('nic');
%                              listboxTxt3(j+1) = cellstr('nic');
%                 case 4
%                              %listboxTxt1(j+1) = cellstr('nic');
%                              %listboxTxt2(j+1) = cellstr('nic');
%                              %listboxTxt3(j+1) = cellstr('nic');
%                              listboxTxt4(j+1) = cellstr('nic');         
%             end
        
        %listbox
        num = num2str(i);
        nazwa = ['WeLiBox' num];
        listbox = ['listboxTxt' num];
        WeLiBox1 = uicontrol('Style','Listbox', ...
                                'Min', 1, ...
                                'Max', 1, ...
                                'Tag',nazwa, ...
                                'String',listboxTxt1, ...
                                'Value',1,...
                                'Position', [0 50 80 100]);
        if i >= 2
                            WeLiBox2 = uicontrol('Style','Listbox', ...
                                'Min', 1, ...
                                'Max', 1, ...
                                'Tag',nazwa, ...
                                'String',listboxTxt2, ...
                                'Value',1,...
                                'Position', [90 50 80 100]);
        end
            %warunkowe dodanie 3 okna - 3 wysjcie
         if i >= 3
                   
            WeLiBox3 = uicontrol('Style','Listbox', ...
                                'Min', 1, ...
                                'Max', 1, ...
                                'Tag',nazwa, ...
                                'String',listboxTxt3, ...
                                'Value',1,...
                                'Position', [180 50 80 100]);                     
        end
        %warunkowe dodanie 4 okna - 4 wysjcie
        if i == 4
          
            WeLiBox4 = uicontrol('Style','Listbox', ...
                                'Min', 1, ...
                                'Max', 1, ...
                                'Tag',nazwa, ...
                                'String',listboxTxt4, ...
                                'Value',1,...
                                'Position', [270 50 80 100]);                     
        end 
       
        %txt
        WeTxt(i) = uicontrol('Style','text', ...
                             'String',[ fls.input(i).name ' jest...'], ...
                             'BackgroundColor',[0.99 1 0.7], ...
                             'Position', [90*(i-1) 150 80 20]);
        %update handles w gui
     
       
    end
    handles.WeLiBox1 = WeLiBox1;
    handles.WeLiBox2 = WeLiBox2;
    handles.WeLiBox3 = WeLiBox3;
    handles.WeLiBox4 = WeLiBox4;
    guidata(hObject,handles);
    handles = guidata(gcf);
    
    
    if strcmp(fls.type, 'mamdani')  %KVM
    %pocz¹tek wyjsc mamdani
        for i = 1:IleWyjsc
              %przygotowanie tekstu do listboxa
            mfLt = length(fls.output(i).mf);

                 for j = 1:mfLt
                     lbTxt = fls.output(i).mf(j).name;
                     lbTxt = cellstr(lbTxt);
                     listboxTxt(j) = lbTxt;
                 end
%          listboxTxt(j+1) = cellstr('nic');
%          if IleWyjsc == 2
%              listboxTxt(j+1) = cellstr('nic');
%          end
             listboxTxt = listboxTxt';


            %listbox
            num = num2str(i);
            nazwa = ['WyLiBox' num];
            WyLiBox(i) = uicontrol('Style','Listbox', ...
                                    'Min', 1, ...
                                    'Max', 1, ...
                                    'Tag',nazwa, ...
                                    'String',listboxTxt, ...
                                    'Position', [450-90*(i-1) 50 80 100]);
            %txt
            WyTxt(i) = uicontrol('Style','text', ...
                                 'String',fls.output(i).name, ...
                                 'BackgroundColor',[0.99 1 0.7], ...
                                     'Position', [450-90*(i-1) 150 80 20]);


        end

                %update handles w gui
        handles.WyLiBox1 = WyLiBox(1);
        if IleWyjsc ==2
        handles.WyLiBox2 = WyLiBox(2);
        end
        guidata(hObject,handles);
        handles = guidata(gcf);
        %koniec wyjsc mamdani
        
    else                            %KVM- pocz¹tek wyjsc sugeno
        
        

        
        for i = 1:IleWyjsc
            num = num2str(i);
            nazwa0 = ['WyLiBox' num];
            nazwa1 = ['WyInp1Box' num];
            nazwa2 = ['WyInp2Box' num];
            nazwa3 = ['WyInp3Box' num];
            nazwa4 = ['WyInp4Box' num];
            nazwa5 = ['WyInp0Box' num];
            WyLiBox(i) = uicontrol('Style','pushbutton', ...
                                 'String','Wiecej', ...
                                    'Tag',nazwa0, ...
                                 'BackgroundColor', [0.7 0.7 0.7], ...
                                     'Position', [450-90*(i-1) (99-IleWejsc*21) 80 20], ...
                                 'Callback', @sugeno_edit_callback);
                    
                                 
            WyInp1Box(i) = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag',nazwa1, ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [450-90*(i-1) 125 80 20]);
                    
            WyInp2Box(i) = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag',nazwa2, ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [450-90*(i-1) 104 80 20]);
           if IleWejsc>2         
            WyInp3Box(i) = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag',nazwa3, ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [450-90*(i-1) 83 80 20]);
           end
           
           if IleWejsc>3   
            WyInp4Box(i) = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag',nazwa4, ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [450-90*(i-1) 62 80 20]);
             end       
            WyInp0Box(i) = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag',nazwa5, ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [454-90*(i-1) (125-21*IleWejsc) 76 20]);
                    
            
            

            
            WyTxt(i) = uicontrol('Style','text', ...
                                 'String',fls.output(i).name, ...
                                 'BackgroundColor',[0.99 1 0.7], ...
                                     'Position', [450-90*(i-1) 150 80 20]);
                    
        end
            
        handles.WyLiBox1 = WyLiBox(1);
        handles.WyInp0Box1 = WyInp0Box(1);
        handles.WyInp1Box1 = WyInp1Box(1);
        handles.WyInp2Box1 = WyInp2Box(1);
        if IleWejsc >2
            handles.WyInp3Box1 = WyInp3Box(1);
            if IleWejsc >3
                handles.WyInp4Box1 = WyInp4Box(1);
            end
        end
        
        set(handles.WyLiBox1,'visible','on');
        if IleWyjsc ==2
            
            
        handles.WyLiBox2 = WyLiBox(2);
        
        handles.WyInp0Box2 = WyInp0Box(2);
        handles.WyInp1Box2 = WyInp1Box(2);
        handles.WyInp2Box2 = WyInp2Box(2);
        if IleWejsc >2
            handles.WyInp3Box2 = WyInp3Box(2);
            if IleWejsc >3
                handles.WyInp4Box2 = WyInp4Box(2);
            end
        end

        
        end
        guidata(hObject,handles);
        handles = guidata(gcf);
        
        %koniec wyjsc sugeno KVM
    end
        
        
    
    handles.fls = fls;

          %kasowanie aktualnego stanu listbox1
      set(handles.listbox1,'String','');   
      %wczytanie stanu bazy z pliku fls
      %zebranie id kazdego z wynikow wybranych w bazie regul
      if numel(fls.rule) >= 1
           zas_Num = length(fls.rule);

            for i = 1:zas_Num
                    Id_wej(i,:) = fls.rule(i).antecedent;
                    Id_wyj(i,:) = fls.rule(i).consequent;
                    Conn(i) = fls.rule(i).connection;
              
                for j = 1:IleWejsc
                    set(handles.listbox1,'Value',Id_wej(i,j));
                end
                for j = 1:IleWyjsc
                    set(handles.listbox1,'Value',Id_wyj(i,j));
                end
                
            end
            
           
            for i = 1:zas_Num
                temp_str = get(handles.WeLiBox1,'String');
                    if Id_wej(i,1) == 0
%                         str1 = 'nic';
                    else
                        str1 = temp_str{Id_wej(i,1)};
                    end
                if IleWejsc >= 2    
                temp_str = get(handles.WeLiBox2,'String');
                    if Id_wej(i,2) == 0
%                         str2 = 'nic';
                    else
                        str2 = temp_str{Id_wej(i,2)}; 
                    end
                end
                %jezeli jest 3 wejscie
                if IleWejsc >= 3    
                temp_str = get(handles.WeLiBox3,'String');
                    if Id_wej(i,3) == 0
%                         str3 = 'nic';
                    else
                        str3 = temp_str{Id_wej(i,3)};
                    end
                end
                %jezeli jest 4 wejscie    
                if IleWejsc == 4
                temp_str = get(handles.WeLiBox4,'String');
                    if Id_wej(i,4) == 0
%                         str4 = 'nic';
                    else
                        str4 = temp_str{Id_wej(i,4)};
                    end
                end
                %wyjscia
                
                if strcmp(fls.type, 'mamdani')
                    
                        temp_str = get(handles.WyLiBox1,'String');
                        str5 = temp_str{Id_wyj(i,1)};
                    if IleWyjsc == 2
                        temp_str = get(handles.WyLiBox2,'String');
                        str6 = temp_str{Id_wyj(i,2)};
                    end
                else
    regNo=i+1;
    temp_par=fls.output(1).mf(regNo).params;
    str5= [num2str(temp_par(5))];

    if IleWejsc > 3
        str5= ['(' num2str(temp_par(4)) ') * ' fls.input(4).name ' + ' str5];

    end
    if IleWejsc > 2
        str5= ['(' num2str(temp_par(3)) ') * ' fls.input(3).name ' + ' str5];

    end


    if IleWejsc > 1
        str5= ['(' num2str(temp_par(2)) ') * ' fls.input(2).name ' + ' str5];

    end

    str5= ['(' num2str(temp_par(1)) ') * ' fls.input(1).name ' + ' str5];









    if IleWyjsc == 2
        temp_par=fls.output(2).mf(regNo).params;
        str6= [num2str(temp_par(5))];
        if IleWejsc > 3
            str6= ['(' num2str(temp_par(4)) ') * ' fls.input(4).name ' + ' str6];
        end


        if IleWejsc > 2
            str6= ['(' num2str(temp_par(3)) ') * ' fls.input(3).name ' + ' str6];
        end


        if IleWejsc > 1
            str6= ['(' num2str(temp_par(2)) ') * ' fls.input(2).name ' + ' str6];
        end
        str6= ['(' num2str(temp_par(1)) ') * ' fls.input(1).name ' + ' str6];



    end

                    
                end
%generacja stringow  do listbox1
            


                if strcmp(str1,'nic')
                               str_part1 = [];
                               %str_part1_con = [];
               else
                               str_part1 = ([ fls.input(1).name ' jest ' str1]);
%                              if Conn == 1
%                                  str_part1_con = '" lub "';
%                              elseif Conn == 2
%                                  str_part1_con = '" i "';
%                              end
                              
               end
              if IleWejsc < 2 || strcmp(str2,'nic')
                               str_part2 = [];
                               str_part1_con = [];
              else
                               str_part2 = ([fls.input(2).name ' jest ' str2]);
                             if Conn(i) == 1
                                 str_part1_con = '" i "';
                             elseif Conn(i) == 2
                                 str_part1_con = '" lub "';
                             end
              end           
  
              if IleWejsc < 3 || strcmp(str3,'nic')
                               str_part3 = [];
                               str_part2_con = [];
              else
                               str_part3 = ([fls.input(3).name ' jest ' str3]);
                             if Conn(i) == 1
                                 str_part2_con = '" i "';
                             elseif Conn(i) == 2
                                 str_part2_con = '" lub "';
                             end
              end
                             
              if IleWejsc < 4 || strcmp(str4,'nic')
                               str_part4 = [];
                               str_part3_con = [];
              else
                               str_part4 = ([fls.input(4).name ' " jest " ' str4]);
                              if Conn(i) == 1
                                 str_part3_con = '" i "';
                             elseif Conn(i) == 2
                                 str_part3_con = '" lub "';
                             end

              end
              
              if strcmp(str5,'nic')
                               str_part5 = [];
              else
                               str_part5 = ([ fls.output(1).name ' " jest " ' str5 ' "']);
              end
              
              if IleWyjsc ==2 
                               if strcmp(str6,'nic')
                                   str_part6 = [];
                               else
                               str_part6 = ([fls.output(2).name ' jest ' str6]);
                               end
                               
              else             
                               str_part6 = ([]);
              end
                            

                   baz_reg_txt = (['Jezeli " ' str_part1 str_part1_con str_part2 str_part2_con str_part3 str_part3_con str_part4 ' " wtedy " ',  str_part5 str_part6]);
                    
                  % baz_reg_txt = textwrap(handles.listbox1,baz_reg_txt);
                    
                    %%ZROBIC £ATWIEJ BEZ KONIECZNOSCI ROZPATRZANIA WSZYSTKICH WARUNKOW

% 
%                if ~strcmp(str3,'nic') && ~strcmp(str1,'nic') && ~strcmp(str2,'nic')
%                     baz_reg_txt = (['Jezeli " ' fls.input(1).name ' jest ' str1 ' " i " ' fls.input(2).name ' jest ' str2 ' " wtedy " ' fls.output(1).name ' " jest " ' str3 ' "']);
%                 elseif strcmp(str1,'nic') && ~strcmp(str2,'nic') && ~strcmp(str3,'nic')
%                     baz_reg_txt = (['Jezeli " ' fls.input(2).name ' " jest " ' str2 ' " wtedy " ' fls.output(1).name ' " jest " ' str3 ' "']);           
%                 elseif ~strcmp(str1,'nic') && strcmp(str2,'nic') && ~strcmp(str3,'nic')
%                     baz_reg_txt = (['Jezeli " ' fls.input(1).name ' " jest " ' str1 ' " wtedy " ' fls.output(1).name ' " jest " ' str3 ' "']);   
%                 elseif strcmp(str3,'nic') 
%                     return;
%                 elseif ~strcmp(str3,'nic') && strcmp(str1,'nic') && strcmp(str2,'nic')
%                     return;
%                end
                
              baz_reg_str(i) = cellstr(baz_reg_txt);
              
%                 baz_reg_i = length(get(handles.listbox1,'String'));
% 
%                 %stara baza zeby nowej nei wymazywalo
%                 old_baz_reg_str = get(handles.listbox1,'String');
%                 baz_reg_str(1:baz_reg_i)= cellstr(old_baz_reg_str);
%                 baz_reg_str(baz_reg_i+1)= cellstr(baz_reg_txt);
                set(handles.listbox1,'Value',length(baz_reg_str));
                set(handles.listbox1,'String',baz_reg_str);
            end
      end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Baza_regul wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes when selected object is changed in uipanel1.
%  function uipanel1(hObject, eventdata, handles)
% switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
%     case 'radiobutton1'
%      Conn = 1; 
%     case 'radiobutton2'
%      Conn = 0;
%   end  
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


    function dodzasfcn(hObject, eventdata, handles)
        
      handles = guidata(hObject);
      handles2 = get(handles.uipanel1);
      nazwa = handles.nazwa;
      fls = readfis(nazwa);

      IleWejsc = length(fls.input);
      IleWyjsc = length(fls.output);
      
      for i=1:IleWyjsc
        if ~isfield(fls.output(i),'mf')
            fls.output(i).mf=[];
        end
      end
      
      handles = guidata(hObject);
%dodanie warunku wyboru polaczenia
if handles2.SelectedObject==handles.radiobutton1
   Conn = 1;
else
    Conn = 2;
end

      %pobranie wartosci z okna wejsc

               lb1_dl = length(get(handles.listbox1,'String'));  
               if IleWejsc >= 1
               
               
                   %wybranie aktualnie kliknietego
                   temp_val1 = get(handles.WeLiBox1,'Value');


                   temp_str = get(handles.WeLiBox1,'String');
                   str1 = temp_str{temp_val1};

                                  %str1 == nic => temp_val61 == 0
                 %  if strcmp( str1,'nic')

                 %       temp_val1 = 0;
                 % end
                    dodaj_ok = 1;
               end
               %wybranie aktualnie kliknietego - input2
               if IleWejsc >= 2

                   temp_val2 = get(handles.WeLiBox2,'Value');


                   temp_str = get(handles.WeLiBox2,'String');
                   str2 = temp_str{temp_val2};

                                  %str2 == nic => temp_val2 == 0
                   if strcmp(str2,'nic')
                       temp_val2 = 0;
                   end
                  %sprawdzenie czy conajmniej jedno wejscie jest inne niz 0                   
                   ile_nic = sum(eq([temp_val1 temp_val2],0));
                  if ile_nic < 2
                      dodaj_ok = 1;
                  else
                      dodaj_ok = 0;
                  end              
               end
               
               %wybranie aktualnie kliknietego - input3
               if IleWejsc >= 3
               
                   temp_val3 = get(handles.WeLiBox3,'Value');


                   temp_str = get(handles.WeLiBox3,'String');
                   str3 = temp_str{temp_val3};

                                  %str3 == nic => temp_val3 == 0
                   if strcmp(str3,'nic')
                       temp_val3 = 0;
                   end
                   %sprawdzenie czy conajmniej jedno wejscie jest inne niz 0                  
                   ile_nic = sum(eq([temp_val1 temp_val2 temp_val3],0));
                  if ile_nic < 3
                      dodaj_ok = 1;
                  else
                      dodaj_ok = 0;
                  end
               end    
               
               if IleWejsc == 4

                   temp_val4 = get(handles.WeLiBox4,'Value');


                   temp_str = get(handles.WeLiBox4,'String');
                   str4 = temp_str{temp_val4};

                                  %str4 == nic => temp_val4 == 0
                   if strcmp(str4,'nic')
                       temp_val4 = 0;
                   end
                  %sprawdzenie czy conajmniej jedno wejscie jest inne niz 0
                  
                   ile_nic = sum(eq([temp_val1 temp_val2 temp_val3 temp_val4],0));
                  if ile_nic < 4
                      dodaj_ok = 1;
                  else
                      dodaj_ok = 0;
                  end
                  
               end               
               

               

      %pobranie wartosci z okna wyjsc
                if strcmp(fls.type, 'mamdani')
                

                    %wybranie aktualnie kliknietego
                    temp_val5 = get(handles.WyLiBox1,'Value');


                    temp_str = get(handles.WyLiBox1,'String');
                    str5 = temp_str{temp_val5};
                     %str5 == nic => temp_val6 == 0
                   if strcmp( str5,'nic')
                       temp_val5 = 0;
                   end            

                    if IleWyjsc == 2

                       temp_val6 = get(handles.WyLiBox2,'Value');


                       temp_str = get(handles.WyLiBox2,'String');
                       str6 = temp_str{temp_val6};

                       %str6 == nic => temp_val6 == 0
                       if strcmp( str6,'nic')
                           temp_val6 = 0;
                       end
                       %sprawdzenie czy conajmniej jedno wejscie jest inne niz 0                   
                           ile_nic = sum(eq([temp_val5 temp_val6],0));
                          if ile_nic < 2
                              dodaj_ok = 1;
                          else
                              dodaj_ok = 0;
                          end                
                    end
                else         %             %          %        %KVM sugeno rule generation
                    regNo=length(fls.rule)+1;

                    temp_val5=regNo+1;


                    temp_str=handles.WyInp0Box1.String;
                    mfMatr1=str2double(temp_str);
                    str5= [temp_str];


                    if IleWejsc > 3
                        temp_str=handles.WyInp4Box1.String;

                        mfMatr1 = [str2double(temp_str) mfMatr1];
                        str5= ['(' temp_str ') * ' fls.input(4).name ' + ' str5];
                    else
                        mfMatr1 = [0 mfMatr1];
                    end


                    if IleWejsc > 2
                        temp_str=handles.WyInp3Box1.String;

                        mfMatr1 = [str2double(temp_str) mfMatr1];
                        str5= ['(' temp_str ') * ' fls.input(3).name ' + ' str5];
                    else
                        mfMatr1 = [0 mfMatr1];
                    end


                    if IleWejsc > 1
                        temp_str=handles.WyInp2Box1.String;

                        mfMatr1 = [ str2double(temp_str) mfMatr1];
                        str5= ['(' temp_str ') * ' fls.input(2).name ' + ' str5];
                    else
                        mfMatr1 = [0 mfMatr1];
                    end

                    temp_str=handles.WyInp1Box1.String;

                    mfMatr1 = [ str2double(temp_str) mfMatr1];
                    str5= ['(' temp_str ') * ' fls.input(1).name ' + ' str5];







                    nazwamf=['mf' num2str(regNo)];
                    fls = addmf(fls,'output',1,nazwamf,'linear',mfMatr1);

        if IleWyjsc == 2
            temp_val6=regNo+1;
            temp_str=handles.WyInp0Box2.String;

            mfMatr2=str2double(temp_str);
            str6= [temp_str];

            if IleWejsc > 3
                temp_str=handles.WyInp4Box2.String;

                mfMatr2 = [str2double(temp_str) mfMatr2];
                str6= ['(' temp_str ') * ' fls.input(4).name ' + ' str6];
            else
            mfMatr2 = [0 mfMatr2];

            end


            if IleWejsc > 2
                temp_str=handles.WyInp3Box2.String;
                mfMatr2 = [str2double(temp_str) mfMatr2];
                str6= ['(' temp_str ') * ' fls.input(3).name ' + ' str6];
            else
            mfMatr2 = [0 mfMatr2];

            end


            if IleWejsc > 1
                temp_str=handles.WyInp2Box2.String;

                mfMatr2 = [ str2double(temp_str) mfMatr2];
                str6= ['(' temp_str ') * ' fls.input(2).name ' + ' str6];
            else
            mfMatr2 = [0 mfMatr2];
            end

            temp_str=handles.WyInp1Box2.String;
            mfMatr2 = [ str2double(temp_str) mfMatr2];
            str6= ['(' temp_str ') * ' fls.input(1).name ' + ' str6];







            nazwamf=['mf' num2str(regNo)];
            fls = addmf(fls,'output',2,nazwamf,'linear',mfMatr2);
        end
                    
                end
       
        
      %generacja stringow  do listbox1 pod warunkiem dodaj_ok (odpowiednia
      %ilosc wejsc/wyjsc bez wartosci "nic"
if dodaj_ok

               if strcmp(str1,'nic')
                               str_part1 = [];
                               %str_part1_con = [];
               else
                               str_part1 = ([ fls.input(1).name ' jest ' str1]);
                               temp_antecedent = [temp_val1];
%                              if Conn == 1
%                                  str_part1_con = '" lub "';
%                              elseif Conn == 2
%                                  str_part1_con = '" i "';
%                              end
                              
               end

               
              if IleWejsc < 2 || strcmp(str2,'nic')
                               str_part2 = [];
                               str_part1_con = [];
              else
                               str_part2 = ([fls.input(2).name ' jest ' str2]);
                               temp_antecedent = [temp_val1 temp_val2];
                             if Conn == 1
                                 str_part1_con = '" i "';
                             elseif Conn == 2
                                 str_part1_con = '" lub "';
                             end
              end 

               if IleWejsc < 3 || strcmp(str3,'nic')
                               str_part3 = [];
                               str_part2_con = [];
              else
                               str_part3 = ([fls.input(3).name ' jest ' str3]);
                               temp_antecedent = [temp_val1 temp_val2 temp_val3];   
                             if Conn == 1
                                 str_part2_con = '" i "';
                             elseif Conn == 2
                                 str_part2_con = '" lub "';
                             end
              end
                             
              if IleWejsc < 4 || strcmp(str4,'nic')
                               str_part4 = [];
                               str_part3_con = [];
                               
              else
                               str_part4 = ([fls.input(4).name ' " jest " ' str4]);
                               temp_antecedent = [temp_val1 temp_val2 temp_val3 temp_val4];   
                             if Conn == 1
                                 str_part3_con = '" i "';
                             elseif Conn == 2
                                 str_part3_con = '" lub "';
                             end                               

              end
              
              if strcmp(str5,'nic')
                               str_part5 = [];
              else
                               str_part5 = ([ fls.output(1).name ' " jest " ' str5 ' "']);
                               temp_consequent = [temp_val5];
              end
              
              if IleWyjsc == 2 
                            if  strcmp(str6,'nic')
                                    str_part6 = [];   
                            else
                               str_part6 = ([fls.output(2).name ' jest ' str6]);
                               temp_consequent = [temp_val5 temp_val6];
                            end

              else             
                               str_part6 = [];
              end
                            

                   baz_reg_txt = (['Jezeli " ' str_part1 str_part1_con str_part2 str_part2_con str_part3 str_part3_con str_part4 ' " wtedy " '  str_part5 str_part6]);
                    
       %dopisywanie do biezacej bazy
%        %jezeli wybrane jest nic to wtedy uzyta jest tylko jedna regula
%        if ~strcmp(str3,'nic') && ~strcmp(str1,'nic') && ~strcmp(str2,'nic')
%                       fls.rule(lb1_dl+1).antecedent = [temp_val1 temp_val2];
%                       fls.rule(lb1_dl+1).consequent(1) = temp_val;
%        baz_reg_txt = (['Jezeli " ' fls.input(1).name ' jest ' str1 ' " i " ' fls.input(2).name ' jest ' str2 ' " wtedy " ' fls.output(1).name ' " jest " ' str3 ' "']);
%        elseif strcmp(str1,'nic') && ~strcmp(str2,'nic') && ~strcmp(str3,'nic')
%                       fls.rule(lb1_dl+1).antecedent = [0 temp_val2];
%                       fls.rule(lb1_dl+1).consequent(1) = temp_val;
%        baz_reg_txt = (['Jezeli " ' fls.input(2).name ' " jest " ' str2 ' " wtedy " ' fls.output(1).name ' " jest " ' str3 ' "']);           
%        elseif ~strcmp(str1,'nic') && strcmp(str2,'nic') && ~strcmp(str3,'nic')
%                       fls.rule(lb1_dl+1).antecedent = [temp_val1 0];          
%                       fls.rule(lb1_dl+1).consequent(1) = temp_val;
%        baz_reg_txt = (['Jezeli " ' fls.input(1).name ' " jest " ' str1 ' " wtedy " ' fls.output(1).name ' " jest " ' str3 ' "']);   
%        elseif strcmp(str3,'nic') 
%            return;
%        elseif ~strcmp(str3,'nic') && strcmp(str1,'nic') && strcmp(str2,'nic')
%            return;
%        end
       fls.rule(lb1_dl+1).antecedent = temp_antecedent;
       fls.rule(lb1_dl+1).consequent = temp_consequent;
       fls.rule(lb1_dl+1).weight = 1;
       fls.rule(lb1_dl+1).connection = Conn;
       writefis(fls,nazwa);
       readfis(nazwa);
       baz_reg_i = lb1_dl;
       %stara baza zeby nowej nei wymazywalo
       old_baz_reg_str = get(handles.listbox1,'String');
       baz_reg_str(1:baz_reg_i)= cellstr(old_baz_reg_str);
       baz_reg_str(baz_reg_i+1)=cellstr(baz_reg_txt);
       set(handles.listbox1,'Value',length(baz_reg_str));
       set(handles.listbox1,'String',baz_reg_str);
       
       
       
       guidata(hObject, handles);
end
       
    
function edzasfcn(hObject, eventdata, handles)
        
        handles = guidata(hObject);
      nazwa = handles.nazwa;
      fls = readfis(nazwa);
      IleWejsc = length(fls.input);
      IleWyjsc = length(fls.output);
      handles = guidata(hObject);

      
function uszasfcn(hObject, eventdata, handles)
        handles = guidata(hObject);
      nazwa = handles.nazwa;
      fls = readfis(nazwa);
      IleWejsc = length(fls.input);
      IleWyjsc = length(fls.output);
      IleReg = length(fls.rule);
      handles = guidata(hObject);
      
      wybrana_reg_num = get(handles.listbox1,'Value');
%       if wybrana_num == length(get(handles.listbox1,'Value'));
%           wybrana_num = get(handles.listbox1,'Value-1');
%       end
      baz_reg_str = get(handles.listbox1,'String');
%       if wybrana_num < length(fls.rule) && wybrana_num > 1
%         %listbox_str(wybrana_num:end-1) = listbox_str(wybrana_num+1:end);
         baz_reg_str(wybrana_reg_num) = [];
%       elseif wybrana_num == length(fls.rule)
%          listbox_str(end) = []; 
%       elseif wybrana_num == 1
%         listbox_str(wybrana_num:end-1) = listbox_str(wybrana_num+1:end);
%         listbox_str(end) = [];
%       end
      %wpisanie wyedytowanego stringa
      if strcmp(fls.type, 'sugeno')  
          for i= wybrana_reg_num+1:IleReg
            fls.rule(i).consequent=fls.rule(i).consequent-1;   
          end

          for i= 1:IleWyjsc
              fls.output(i).mf(wybrana_reg_num+1)=[];
              %wybrana_reg_num

          end
      end
      set(handles.listbox1,'Value',length(baz_reg_str));
      set(handles.listbox1,'String',baz_reg_str);

%       if wybrana_num < length(fls.rule) && wybrana_num > 1
%       fls.rule(wybrana_num:length(fls.rule)-1) = fls.rule(wybrana_num+1:length(fls.rule));
        fls.rule(wybrana_reg_num) = [];
        
        
%       else
%       fls.rule(end) = []; 
%       end
    writefis(fls,nazwa);
    
    guidata(hObject, handles);
      


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%WYGENEROWANE PRZEZ GUIDE
% --- Outputs from this function are returned to the command line.
function varargout = Baza_regul_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)




% --- Executes on key press with focus on listbox1 and none of its controls.
function listbox1_KeyPressFcn(hObject, eventdata, handles)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
nazwa = handles.nazwa;
fls = readfis(nazwa);
writefis(fls,nazwa);
delete(gcf);


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


function sugeno_edit_callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
nazwa = handles.nazwa;
fls = readfis(nazwa);

if strcmp(fls.type, 'sugeno')
    IleWejsc=length(fls.input);

    definicja= define(nazwa);
    
    waitfor(definicja);

    e = getappdata(0,'evalue');
    setappdata(0,'evalue',0);
    if e(1)~=0
        
        if strcmp(hObject.Tag,  'WyLiBox1')

            handles.WyInp0Box1.String = e(2);
            handles.WyInp1Box1.String = e(3);
            handles.WyInp2Box1.String = e(4);
            if IleWejsc >2
                handles.WyInp3Box1.String = e(5);
                if IleWejsc >3
                    handles.WyInp4Box1.String = e(6);
                end
            end


         else




            handles.WyInp0Box2.String = e(2);
            handles.WyInp1Box2.String = e(3);
            handles.WyInp2Box2.String = e(4);
            if IleWejsc >2
                handles.WyInp3Box2.String = e(5);
                if IleWejsc >3
                    handles.WyInp4Box2.String = e(6);
                end
            end
        end
    end
    
end

% --- Executes on button press in pushbutton1.
function WyLiBox1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function WyLiBox2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


