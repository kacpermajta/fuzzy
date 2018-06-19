function varargout = Pow(varargin)
% SURF MATLAB code for Pow.fig
%      SURF, by itself, creates a new SURF or raises the existing
%      singleton*.
%
%      H = SURF returns the handle to a new SURF or the handle to
%      the existing singleton*.
%
%      SURF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SURF.M with the given input arguments.
%
%      SURF('Property','Value',...) creates a new SURF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pow

% Last Modified by GUIDE v2.5 12-Dec-2012 20:30:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pow_OpeningFcn, ...
                   'gui_OutputFcn',  @Pow_OutputFcn, ...
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


% --- Executes just before Pow is made visible.
function Pow_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
fls = readfis('test');

    set(handles.ges_siat_x,'String','20');
    set(handles.ges_siat_y,'String','20');
    rysuj(hObject,eventdata,handles);
% Update handles structure
guidata(hObject, handles);


function rysuj(hObject,eventdata,handles)
% Choose default command line output for Pow
handles.output = hObject;
fls = readfis('test2');


 %%%%%%Tworzenie g³ównego AXES 
    
 obPos = get(gcf,'Position');
 obUnits = get(gcf,'Units');
 
    axPos=[32 12 50 25];
    axCol= 0.95*[1 1 1];
    axHndl=axes( ...
        'Box','on', ...
        'Units',obUnits, ...
        'Position',axPos, ...
        'Tag','mainaxes', ...
        'Visible','on', ...
        'Color', axCol );

%%%%%Parametry figure
set(gcf,'Color',[0.73 0.83 0.96]);
 %====================================
 %%%%%Tworzenie wypelnienia glownego AXES
 %%%%%usuwanie wszystkich obecnych AXES
    axesList=findobj(gcf,'Type','axes');
    mainAxes=findobj(gcf,'Type','axes','Tag','mainaxes');
    axesList(find(axesList==mainAxes))=[];
    delete(axesList); 

    %wczytanie nazw do okienek
    set(handles.x_wej_naz,'String',fls.input(1).name);
    set(handles.y_wej_naz,'String',fls.input(2).name);
    set(handles.z_wyj_naz,'String',fls.output(1).name);
    
    %odczytanie i zapis do ges_siat
    ges_x = get(handles.ges_siat_x,'String');
    %ges_x = str2double(ges_x);
    ges_y = get(handles.ges_siat_y,'String');
    %ges_y = str2double(ges_y);
    set(handles.ges_siat_x,'String',ges_x);
    set(handles.ges_siat_y,'String',ges_y);
    
    %wartosci potrzebne do utworzenia wykresu
    rang_x = fls.input(1).range;
    rang_y = fls.input(2).range;
    rang_z = fls.output(1).range;
    
    %obliczanie skoku wykresu
    skok_x = get(handles.ges_siat_x,'String');
    skok_y = get(handles.ges_siat_y,'String');
    skok_x = str2double(skok_x);
    skok_y = str2double(skok_y);
    
    
    grid_x = rang_x(1):1/skok_x:rang_x(2)-1/skok_x;
    grid_y = rang_y(1):1/skok_y:rang_y(2)-1/skok_y;
    wart_z = rang_z(1):0.01:rang_z(2);
    [X,Y] = meshgrid(grid_x,grid_y);
    %%%%%%%Obliczenia wartosci wyjsciowych czyli Z
       %wspolrzedne okienek
        
        we1x = grid_x;
        %mid1 = mean(min(we1x),max(we1x));
        we2x = grid_y;
        %mid2 = mean(min(we2x),max(we2x));
        wy1x = grid_x;
        %mid3 = mean(min(wy1x),max(wy1x));
        %prealokacja zmiennej
        out = zeros(length(grid_y),length(grid_x));
        
        IleReg = length(fls.rule);
        for j = 1:length(grid_x)
             for k = 1:length(grid_y)   
                    for i = 1:IleReg

                        we1 = fls.rule(i).antecedent(1);
                        
                        
                                   %funkcja przynaleznosci - rys
                                   parametr = fls.input(1).mf(we1).params;
                                   [dolna,gorna] = feval('gausssymmftype2',we1x,parametr);
                                    %wartosci potrzebne do obliczen
                                    mf_dolna1(i,:) = dolna;
                                    
                                    mf_gorna1(i,:) = gorna;
                                    
                                    
                       
                        we2 = fls.rule(i).antecedent(2);
                        
                        
                              %funkcja przynaleznosci - rys          
                               parametr = fls.input(2).mf(we2).params;
                               [dolna,gorna] = feval('gausssymmftype2',we2x,parametr);
                                    
                                    %wartosci potrzebne do obliczen
                                    mf_dolna2(i,:) = dolna;
                                    
                                    mf_gorna2(i,:) = gorna;
                                    

                        wy1 = fls.rule(i).consequent(1);
                        
                        
                                   %funkcja przynaleznosci - rys          
                                   parametr = fls.output(1).mf(wy1).params;

                                   [dolna,gorna] = feval('gausssymmftype2',wy1x,parametr);
                                   mf_dolna_wyj(i,:) = dolna;
                                   mf_gorna_wyj(i,:) = gorna;

                    
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Obliczenia fls2

                                
                        %warunki wybierajace odpowiednie pliki obliczajace
                        if strcmp(fls.andMethod,'min')
                            [min_dolna(i,:), min_gorna(i,:)] = min_and(j,k,mf_dolna1(i,:),mf_gorna1(i,:),mf_dolna2(i,:),mf_gorna2(i,:));
                                if min_dolna > min_gorna
                                    temp = min_dolna;
                                    min_dolna = min_gorna;
                                    min_gorna = temp;
                                end
                            [X_ob(i,:), Y_ob(i,:)] = and_plot_bs(grid_x, min_dolna(i,:), min_gorna(i,:),mf_dolna_wyj(i,:),mf_gorna_wyj(i,:));

                            
                            %wpisanie do macierzy wynikow przed skalowaniem

                            
                            

                        elseif strcmp(fls.andMethod,'prod')
                            [prod_dolna, prod_gorna] =   prod_and(j,k,mf_dolna,mf_gorna);
                                if prod_dolna > prod_gorna
                                        temp = prod_dolna;
                                        prod_dolna = prod_gorna;
                                        prod_gorna = temp;
                                end
                            [X_ob(i,:), Y_ob(i,:)] = and_plot_bs(x, prod_dolna, prod_gorna,mf_dolna_wyj,mf_gorna_wyj);
                            
         

                    end

                    end   

                        if strcmp(fls.aggMethod,'max')
                                [Xagg_ob, Yagg_ob] = max_agg(X_ob,Y_ob);
                                x_do_wyj = Xagg_ob;
                                y_do_wyj = Yagg_ob;

                        elseif strcmp(fls.aggMethod,'prod')
                        end


                        
                        %wybor metody defuzzyfikacji
                        %pobranie wart. wyboru  DOEDYCJI
                        %tworzenie danych potrzebnych do defuzzyfikacji
                        
                        z = x_do_wyj(1:length(x_do_wyj)/2);
                        %z = z';
                        
                        y_do_wyj = y_do_wyj';
                        len_y = length(y_do_wyj);
                        %centra (srednia obliczanych wartosci) = w i rozrzut
                        %(spread) = delta
                        for i = 1:length(z)
                            w(1,i) = y_do_wyj(i);
                            w(2,i) = y_do_wyj(len_y/2+i);    
                        end
                        
                        w(2,:) = fliplr(w(2,:));
                        w = mean(w,1);
                        

                        delta = w(1,:)' - y_do_wyj(1:length(z)); 
                        
                        delta = delta';

                        defuzz_met = fls.defuzzMethod;
                        
                        switch defuzz_met
                            case 'centroid'
                            [l_out, r_out] = centroid_tr(z,w,delta);
                            out(k,j) = mean([l_out r_out]);
                            case 'œrodek sum'
                            [l_out, r_out] = cos_tr(z,w,delta);
                            out(k,j) = mean([l_out r_out]);
                        end
                    
             end
        end
                 cla;
                 surf(X,Y,out);
                 xlabel(fls.input(1).name,'FontSize',12);
                 ylabel(fls.input(2).name,'FontSize',12);
                 
                
                 rotate3d on
                 axis equal


% --- Outputs from this function are returned to the command line.
function varargout = Pow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ges_siat_x_Callback(hObject, eventdata, handles)
klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
       
       rysuj(hObject, eventdata, handles);

else
    return;
end


% --- Executes during object creation, after setting all properties.
function ges_siat_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ges_siat_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ges_siat_y_Callback(hObject, eventdata, handles)
 klaw = get(gcf, 'CurrentKey');
     
if strcmp(klaw,'return')
       
       rysuj(hObject, eventdata, handles);

else
    return;
end


% --- Executes during object creation, after setting all properties.
function ges_siat_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ges_siat_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
