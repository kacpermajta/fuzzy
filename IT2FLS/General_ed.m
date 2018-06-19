function varargout = General_ed(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IT2FLS
%   Funkcja sluzy do edycji przekroju dla generalnej funkcji rozmytej typu
%   2
%   
%     Argumenty:
%     
%     Funkcja zwraca:
%     varargin
%     jest to nazwa obecnego fis
%     
%     Uzywane funkcje:
%     Surf
%     Wej_ed
%     Pod_reg
%     Baza_regul
%     Wszystkie wywolania (Callback) do listbox, textbox, popup etc.
%     ktore pomimo ze sa zapisane w tym pliku jako osobne funkcje stanowia
%     integralna czesc tej funkcji poprzez plik IT2FLS.fig
%     
%     Uzywane zmienne:
%     varargin
%     
%     Uwagi:
%     Plik/funkcja mocno powiazana z plikiem General_ed.fig - w nim zapisana jest 
%     konfiguracja graficzna wygladu GUI a takze powiazanie funkcji callback
%     z ta funkcja.
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
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @General_ed_OpeningFcn, ...
                   'gui_OutputFcn',  @General_ed_OutputFcn, ...
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


% --- Executes just before General_ed is made visible.
function General_ed_OpeningFcn(hObject, eventdata, handles, varargin)

handles = guidata(hObject);

if isempty(varargin)
    fls = readfis('bez_nazwy');
    handles.nazwa = 'bez_nazwy';
    nazwa = handles.nazwa;
else
    
    nazwa = char(varargin);
    fls = readfis(nazwa);
    handles.nazwa = nazwa;

end
%wczytanie z ws ilosci general slices
zslices_num = evalin('base','zslices');
%wpisanie do gandles
handles.zslices = zslices_num;

%wpisanie ilosci zslice
    set(handles.zslices_num,'String',num2str(zslices_num));
handles.output = hObject;
guidata(hObject, handles);
rysuj_linie(hObject,eventdata,handles);
     


function varargout = General_ed_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function rysuj_linie(hObject, eventdata, handles)
     cla;
     handles = guidata(hObject); 
     nazwa = handles.nazwa;
     %zslices_num = evalin('base','zslices');
     zslices_num = handles.zslices;
     fls = readfis(nazwa); 
%      klaw = get(gcf, 'CurrentKey');
     
%tworzenie trojkata
    line1 = line([0 0.5],[0 1],'Color','b','LineWidth',5);
    line2 = line([0.5 1],[1 0],'Color','b','LineWidth',5);
%wpisanie ilosci zslice
    set(handles.zslices_num,'String',num2str(zslices_num));
%pobranie ilosci zslice
    %zslices_num = str2num(get(handles.zslices_num,'String'));
    
    %tworzenie linii z slice zaleznych od zslices_num
    for i=1:zslices_num
        line([0 1],[1/zslices_num*i 1/zslices_num*i],'Color','b');
    end

    %tworzenie linii pionowych zslice
    for i=1:(zslices_num*2-1)
        line([(0.5*1/zslices_num)*i 0.5*1/zslices_num*i],[0 1],'Color','b');
    end
    
    %pogrubienie waznych linii
     for i=1:zslices_num
        line([-0.5*1/zslices_num*i+0.5 0.5*1/zslices_num*i+0.5],[1/zslices_num*(zslices_num-i) 1/zslices_num*(zslices_num-i)],'Color','g','LineWidth',3);
        line([(0.5*1/zslices_num)*i 0.5*1/zslices_num*i],[0 1/zslices_num*(i)],'Color','g','LineWidth',3);
     end
     
    for i=zslices_num+1:zslices_num*2-1
        line([(0.5*1/zslices_num)*i 0.5*1/zslices_num*i],[0 2-(1/zslices_num*(i))],'Color','g','LineWidth',3);
    end
     guidata(hObject,handles);



function zslices_num_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    nazwa = handles.nazwa;
     fls = readfis(nazwa); 
     klaw = get(gcf, 'CurrentKey');
  
if strcmp(klaw,'return')
       
       slices_num = get(handles.zslices_num,'String');


       handles.zslices = str2num(slices_num);
              assignin('base','zslices',handles.zslices);
       guidata(hObject,handles); 
       handles = guidata(hObject);
       


          
              rysuj_linie(hObject, eventdata, handles);

       set(handles.zslices_num,'String',handles.zslices);       
       guidata(hObject,handles);
else
    return;
end


% --- Executes during object creation, after setting all properties.
function zslices_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslices_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on zslices_num and none of its controls.
function zslices_num_KeyPressFcn(hObject, eventdata, handles)


