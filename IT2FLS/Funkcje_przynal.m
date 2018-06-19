function varargout = Funkcje_przynal(varargin)
% FUNKCJE_PRZYNAL MATLAB code for Funkcje_przynal.fig
%      FUNKCJE_PRZYNAL, by itself, creates a new FUNKCJE_PRZYNAL or raises the existing
%      singleton*.
%
%      H = FUNKCJE_PRZYNAL returns the handle to a new FUNKCJE_PRZYNAL or the handle to
%      the existing singleton*.
%
%      FUNKCJE_PRZYNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FUNKCJE_PRZYNAL.M with the given input arguments.
%
%      FUNKCJE_PRZYNAL('Property','Value',...) creates a new FUNKCJE_PRZYNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Funkcje_przynal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Funkcje_przynal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Funkcje_przynal

% Last Modified by GUIDE v2.5 12-Oct-2012 14:33:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Funkcje_przynal_OpeningFcn, ...
                   'gui_OutputFcn',  @Funkcje_przynal_OutputFcn, ...
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


% --- Executes just before Funkcje_przynal is made visible.
function Funkcje_przynal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Funkcje_przynal (see VARARGIN)

% Choose default command line output for Funkcje_przynal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Funkcje_przynal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Funkcje_przynal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
