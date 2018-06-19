function varargout = Z_workspace(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Surf
%   Funkcja sluzy do wywolywania plaszczyzny sterowania typu 2 dla danych
%   zdefiniowanych w oknach powiazanych
%   
%     Argumenty:
%     varargin - nazwa obecnego fis
%
%     Funkcja zwraca:
%     varargout
%     jest to nazwa obecnego fis
%     
%     Uzywane funkcje:
%     IT2FLS
%
%     Uzywane zmienne:
%     nazwa - nazwa aktualnego fis
%     nowyFls - pomocniczy arg. do utworzenia nowego fis
%     (I)varargin - argument wejsciowy
%     (O)vargout - argument wyjsciowy
%     temp - pomocnicza wartosc 
%     hObject - aktualny obiekt
%     eventdata - nie uzywane
%     handles - struktura zawierajaca wszystkie obiekty i ich zmienne
%     Wszystkie wywolania (Callback) do listbox, textbox, popup etc.
%     ktore pomimo ze sa zapisane w tym pliku jako osobne funkcje stanowia
%     integralna czesc tej funkcji poprzez plik IT2FLS.fig
%     
%     Uwagi:
%     Plik/funkcja mocno powiazana z plikiem Surf.fig - w nim zapisana jest 
%     konfiguracja graficzna wygladu GUI a takze powiazanie wszystkich funkcji callback
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
                   'gui_OpeningFcn', @Z_workspace_OpeningFcn, ...
                   'gui_OutputFcn',  @Z_workspace_OutputFcn, ...
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


% --- Executes just before Z_workspace is made visible.
function Z_workspace_OpeningFcn(hObject, eventdata, handles, varargin)
handles = guidata(hObject);


% Choose default command line output for Z_workspace
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Z_workspace wait for user response (see UIRESUME)
% uiwait(handles.okno_z_ws);


% --- Outputs from this function are returned to the command line.
function varargout = Z_workspace_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function z_workspace_naz_Callback(hObject, eventdata, handles)
 klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
       naz = get(handles.z_workspace_naz,'String');
       okno_z_ws_CloseRequestFcn(hObject, eventdata, handles);
       IT2FLS(naz);

end



% --- Executes during object creation, after setting all properties.
function z_workspace_naz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_workspace_naz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close okno_z_ws.
function okno_z_ws_CloseRequestFcn(hObject, eventdata, handles)

delete(hObject);
delete(gcf);
