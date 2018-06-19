function varargout = Dodawanie_funkcji(varargin)
% DODAWANIE_FUNKCJI MATLAB code for Dodawanie_funkcji.fig
%      DODAWANIE_FUNKCJI, by itself, creates a new DODAWANIE_FUNKCJI or raises the existing
%      singleton*.
%
%      H = DODAWANIE_FUNKCJI returns the handle to a new DODAWANIE_FUNKCJI or the handle to
%      the existing singleton*.
%
%      DODAWANIE_FUNKCJI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DODAWANIE_FUNKCJI.M with the given input arguments.
%
%      DODAWANIE_FUNKCJI('Property','Value',...) creates a new DODAWANIE_FUNKCJI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Dodawanie_funkcji_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Dodawanie_funkcji_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Dodawanie_funkcji

% Last Modified by GUIDE v2.5 15-Mar-2014 14:30:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Dodawanie_funkcji_OpeningFcn, ...
                   'gui_OutputFcn',  @Dodawanie_funkcji_OutputFcn, ...
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


% --- Executes just before Dodawanie_funkcji is made visible.
function Dodawanie_funkcji_OpeningFcn(hObject, eventdata, handles, varargin)

if isempty(varargin)
    
    cd(setflspath());
    fls = readfis('bez_nazwy');
    handles.nazwa = 'bez_nazwy';
    nazwa = handles.nazwa;
else
    
    nazwa = char(varargin)
    fls = readfis(nazwa);
    handles.nazwa = nazwa;

end

set(handles.obecny_folder,'String',setflspath);

handles.output = hObject;

guidata(hObject, handles);

% UIWAIT makes Dodawanie_funkcji wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Dodawanie_funkcji_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function tresc_func_Callback(hObject, eventdata, handles)
% hObject    handle to tresc_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tresc_func as text
%        str2double(get(hObject,'String')) returns contents of tresc_func as a double


% --- Executes during object creation, after setting all properties.
function tresc_func_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tresc_func (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nazwa_metody_Callback(hObject, eventdata, handles)
% hObject    handle to nazwa_metody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nazwa_metody as text
%        str2double(get(hObject,'String')) returns contents of nazwa_metody as a double


% --- Executes during object creation, after setting all properties.
function nazwa_metody_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nazwa_metody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function centre_Callback(hObject, eventdata, handles)
% hObject    handle to centre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of centre as text
%        str2double(get(hObject,'String')) returns contents of centre as a double


% --- Executes during object creation, after setting all properties.
function centre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to centre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spread_Callback(hObject, eventdata, handles)
% hObject    handle to spread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spread as text
%        str2double(get(hObject,'String')) returns contents of spread as a double


% --- Executes during object creation, after setting all properties.
function spread_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_Callback(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta as text
%        str2double(get(hObject,'String')) returns contents of delta as a double


% --- Executes during object creation, after setting all properties.
function delta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in anuluj_push.
function anuluj_push_Callback(hObject, eventdata, handles)
selection = questdlg('Czy na pewno chcesz wyjsc?','Close Request Function','Tak','Nie','Anuluj');
    switch selection
        case 'Tak'
            delete(gcf);
        case 'Nie'
            return;
    end


% --- Executes on button press in dodaj_funkcje_push.
function dodaj_funkcje_push_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    nazwa = handles.nazwa;
     fls = readfis(nazwa);
     obecny_folder = pwd;
    % savefile = [get(handles.nazwa_metody) '.m'];
    tresc = ['function ' '[l_out,r_out]='...
              get(handles.nazwa_metody,'String') '(' 'z,w,delta' ')      ' sprintf('\n')  sprintf('\n')...
              get(handles.tresc_func,'String')  sprintf('\n') ...
              '[l_out,r_out] = interval_wtdavg(' get(handles.centre,'String') ','...
              get(handles.spread,'String') ',' get(handles.height,'String') ','...
              get(handles.delta,'String') ');']
%     assignin('base','tresc',string(tresc));
%     [plik,sciezka] = uiputfile('*.m','Zapisz jako');
%     save(plik,'tresc')
%     if isequal(plik,0) || isequal(sciezka,0)
%        disp('Anulowano')
%     else
%        disp(['Wybrano ', fullfile(plik, sciezka)])
%     end%%
nazwa_metody = [get(handles.nazwa_metody,'String') '.m'];

%assignin('base','tresc',0);
%[plik,sciezka] = uiputfile('*.m','Zapisz jako');
%save(plik,'tresc')
cd(get(handles.obecny_folder,'String'))
out_fid = fopen(nazwa_metody, 'w');
fprintf(out_fid, '%s', tresc);
fclose(out_fid);
cd(obecny_folder);
helpdlg(['Funkcja ' nazwa_metody ' zostala dodana'] ,'Point Selection');
close(Dodawanie_funkcji);
%[status,message,messageid]=movefile('C:\Program Files\MATLAB\R2011a\bin\nowa_metoda2.m,','C:Users\Marcin\Documents\MGR\II\Praca magisterska\Toolbox\Operacje')




function obecny_folder_Callback(hObject, eventdata, handles)
% hObject    handle to obecny_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of obecny_folder as text
%        str2double(get(hObject,'String')) returns contents of obecny_folder as a double


% --- Executes during object creation, after setting all properties.
function obecny_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to obecny_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on obecny_folder and none of its controls.
function obecny_folder_KeyPressFcn(hObject, eventdata, handles)




% --- Executes on button press in obecny_push.
function obecny_push_Callback(hObject, eventdata, handles)
nowy_folder = uigetdir('Wybierz folder');
    if isequal(nowy_folder,0)
       return;
    else
        set(handles.obecny_folder,'String',nowy_folder);
    end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over obecny_push.
function obecny_push_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to obecny_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
