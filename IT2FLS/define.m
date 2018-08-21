function varargout = define(varargin)
% DEFINE MATLAB code for define.fig
%      DEFINE, by itself, creates a new DEFINE or raises the existing
%      singleton*.
%
%      H = DEFINE returns the handle to a new DEFINE or the handle to
%      the existing singleton*.
%
%      DEFINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE.M with the given input arguments.
%
%      DEFINE('Property','Value',...) creates a new DEFINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define

% Last Modified by GUIDE v2.5 16-Aug-2018 14:32:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_OpeningFcn, ...
                   'gui_OutputFcn',  @define_OutputFcn, ...
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


% --- Executes just before define is made visible.
function define_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define (see VARARGIN)

% Choose default command line output for define
handles.output = hObject;
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

    winPos=809;
    partLength=80;
    
    fullLength=120+IleWejsc*(80+partLength);
    origPoint=winPos/2-fullLength/2;
    textBackCol=[0.729 0.831 0.957];
    partLength=80;
    numWej=1;
    WeTxt = uicontrol('Style','text', ...
                             'String','Z  =', ...
                             'BackgroundColor',textBackCol, ...
                             'Position', [origPoint 78 40 20]);
    
                  
                                 
            handles.WyInp1Box = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag','WyInp1Box', ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [origPoint+40 82 80 20]);
                                 
            WeTxt = uicontrol('Style','text', ...
                         'String',['* '  fls.input(1).name ' +'], ...
                         'BackgroundColor',textBackCol, ...
                         'Position', [origPoint+120 78 partLength 20]);
        
                                 
                                 
            handles.WyInp2Box = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag','WyInp2Box', ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [origPoint+120+partLength 82 80 20]);
                                 
            WeTxt = uicontrol('Style','text', ...
                         'String',['* '  fls.input(2).name ' +'], ...
                         'BackgroundColor',textBackCol, ...
                         'Position', [origPoint+200+partLength 78 partLength 20]);
        

           if IleWejsc>2         
            handles.WyInp3Box = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag','WyInp3Box', ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [origPoint+200+2*partLength 82 80 20]);
            WeTxt = uicontrol('Style','text', ...
                         'String',['* '  fls.input(3).name ' +'], ...
                         'BackgroundColor',textBackCol, ...
                         'Position', [origPoint+280+2*partLength 78 partLength 20]);
                     
                                 
           end
           
           if IleWejsc>3   
            handles.WyInp4Box = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag','WyInp4Box', ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [origPoint+280+3*partLength 82 80 20]);
            WeTxt = uicontrol('Style','text', ...
                         'String',['* '  fls.input(4).name ' +'], ...
                         'BackgroundColor',textBackCol, ...
                         'Position', [origPoint+360+3*partLength 78 partLength 20]);
                     
                                 
                     
                                 
           end       
            handles.WyInp0Box = uicontrol('Style','edit', ...
                                 'String','0', ...
                                    'Tag','WyInp0Box', ...
                                 'BackgroundColor', 'white', ...
                                     'Position', [origPoint+40+IleWejsc*(80+partLength) 82 80 20]);
                    




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
nazwa = handles.nazwa;
fls = readfis(nazwa);

IleWejsc = length(fls.input);
e=[str2double(handles.WyInp0Box.String) str2double(handles.WyInp1Box.String) str2double(handles.WyInp2Box.String)];
if IleWejsc>2
   e=[ e str2double(handles.WyInp3Box.String)];
end 
if IleWejsc>3
   e=[ e str2double(handles.WyInp4Box.String)];
   
end   
e=[1 e];
setappdata(0,'evalue',e);
close(define)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
