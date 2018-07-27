function varargout = Dodawanie_wejsc(varargin)
% DODAWANIE_WEJSC MATLAB code for Dodawanie_wejsc.fig
%      DODAWANIE_WEJSC, by itself, creates a new DODAWANIE_WEJSC or raises the existing
%      singleton*.
%
%      H = DODAWANIE_WEJSC returns the handle to a new DODAWANIE_WEJSC or the handle to
%      the existing singleton*.
%
%      DODAWANIE_WEJSC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DODAWANIE_WEJSC.M with the given input arguments.
%
%      DODAWANIE_WEJSC('Property','Value',...) creates a new DODAWANIE_WEJSC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Dodawanie_wejsc_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Dodawanie_wejsc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Dodawanie_wejsc

% Last Modified by GUIDE v2.5 06-Jul-2018 18:29:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Dodawanie_wejsc_OpeningFcn, ...
                   'gui_OutputFcn',  @Dodawanie_wejsc_OutputFcn, ...
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


% --- Executes just before Dodawanie_wejsc is made visible.
function Dodawanie_wejsc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Dodawanie_wejsc (see VARARGIN)




if isempty(varargin)
    fls = readfis('bez_nazwy');
    handles.nazwa = 'bez_nazwy';
    nazwa = handles.nazwa;

else
    
   nazwa = char(varargin);
   fls = readfis(nazwa);
    handles.nazwa = nazwa;

 end

handles.output = hObject;
    

    

IleWejsc = length(fls.input);
IleWyjsc = length(fls.output);

for i = 1:IleWejsc
       wejsciaList(i) = cellstr(fls.input(i).name);
end

for i = 1:IleWyjsc
       wyjsciaList(i) = cellstr(fls.output(i).name);
end


 set(handles.wej_list,'String',wejsciaList); 
 set(handles.wyj_list,'String',wyjsciaList);
 
 
    check_inout(hObject, eventdata, handles);
    guidata(hObject,handles);
    handles = guidata(gcf);
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Dodawanie_wejsc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Dodawanie_wejsc_OutputFcn(hObject, eventdata, handles) 


varargout{1} = handles.output;


% --- Executes on selection change in wej_list.
function wej_list_Callback(hObject, eventdata, handles)
% hObject    handle to wej_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wej_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wej_list


% --- Executes during object creation, after setting all properties.
function wej_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wej_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in wyj_list.
function wyj_list_Callback(hObject, eventdata, handles)
% hObject    handle to wyj_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wyj_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wyj_list


% --- Executes during object creation, after setting all properties.
function wyj_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wyj_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% dodawanie wejscia 
function dod_wej_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    fls = readfis(handles.nazwa); %odczytanie fis
    fls=dodajzmiennatypu2(fls,'input',['wejscie',num2str(length(fls.input)+1)],[0 1]); %dodawanie jednego wejscia wiecej

    writefis(fls,fls.name); % zapis

    dodany_string = ['wejscie ', num2str(length(fls.input))]; %string dodanego wejscia
    wejsciaList = get(handles.wej_list,'String'); 
    wejsciaList(length(wejsciaList)+1) = cellstr(dodany_string);
    set(handles.wej_list,'String',wejsciaList); 
    writefis(fls,handles.nazwa);
    check_inout(hObject, eventdata, handles);


% --- Executes on button press in usun_wej.
function usun_wej_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    fls = readfis(handles.nazwa); %odczytanie fis
    str = get(handles.wej_list,'String');
    val = get(handles.wej_list,'Value');%odczyt które wejscie jest wybrane - numer
    %str = str{val}; %wybrany string - niekoniecznie przydatne
    if val == length(fls.input)
        fls.input = fls.input(1:end-1);
        set(handles.wej_list,'Value',val-1);
    else
        fls.input = fls.input([1:val-1 val+1:end]);
    end
      
    
    %tworzenie nowej listy
    for i = 1:length(fls.input)
        wejsciaList(i) = cellstr(fls.input(i).name);
    end
    set(handles.wej_list,'String',wejsciaList); 
    
        %usuwanie w regulach wartosci antecedent
    if ~isempty(fls.rule)
       if val == 1
            fls.rule.antecedent = fls.rule.antecedent(:,[2 length(fls.rule.antecedent)]);
       elseif val == length(fls.rule.antecedent)+1
            fls.rule.antecedent = fls.rule.antecedent(:,[1 length(fls.rule.antecedent)]);
       else
            fls.rule.antecedent = fls.rule.antecedent(:,[1:val-1 val+1:length(fls.rule.antecedent)+1]);
       end
    end
    
    writefis(fls,handles.nazwa);
    check_inout(hObject, eventdata, handles);

% --- Executes on button press in dod_wyj.
function dod_wyj_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    fls = readfis(handles.nazwa); %odczytanie fis
    fls=dodajzmiennatypu2(fls,'output',['wyjscie',num2str(length(fls.output)+1)],[0 1]); %dodawanie jednego wejscia wiecej
    writefis(fls,fls.name); % zapis

    dodany_string = ['wyjscie ', num2str(length(fls.output))]; %string dodanego wejscia
    wyjsciaList= get(handles.wyj_list,'String'); 
    wyjsciaList(length(wyjsciaList)+1) = cellstr(dodany_string);
    set(handles.wyj_list,'String',wyjsciaList); 
    check_inout(hObject, eventdata, handles);


% --- Executes on button press in usun_wyj.
function usun_wyj_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    fls = readfis(handles.nazwa); %odczytanie fis
    str = get(handles.wyj_list,'String');
    val = get(handles.wyj_list,'Value');%odczyt które wejscie jest wybrane - numer
    %str = str{val}; %wybrany string - niekoniecznie przydatne
    if val == length(fls.output)
        fls.output = fls.output(1:val-1);
                set(handles.wej_list,'Value',val-1);
    else 
        fls.output = fls.output([1:val-1 val+1:end]);
    end

    %tworzenie nowej listy
    for i = 1:length(fls.output)
        wyjsciaList(i) = cellstr(fls.output(i).name);
    end
    set(handles.wyj_list,'String',wyjsciaList); 
    writefis(fls,handles.nazwa);
    check_inout(hObject, eventdata, handles);


% --- Executes on button press in zapisz.
function zapisz_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    fls = readfis(handles.nazwa); %odczytanie fis
    close;
IT2FLS(handles.nazwa);

function check_inout(hObject, eventdata, handles)

    fls = readfis(handles.nazwa); %odczytanie fis
        
    if length(fls.output) == 1
        set(handles.usun_wyj,'Enable','off');
    else
        set(handles.usun_wyj,'Enable','on');      
    end
    
    if length(fls.output) >= 2
        set(handles.dod_wyj,'Enable','off');
    else
        set(handles.dod_wyj,'Enable','on');      
    end 
    
    if length(fls.input) == 1
        set(handles.usun_wej,'Enable','off');
    else
        set(handles.usun_wej,'Enable','on');      
    end    
       
    if length(fls.input) >= 4
        set(handles.dod_wej,'Enable','off');
    else
        set(handles.dod_wej,'Enable','on');      
    end    
