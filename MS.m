


function varargout = MS(varargin)

global fx;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MS_OpeningFcn, ...
                   'gui_OutputFcn',  @MS_OutputFcn, ...
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
function MS_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);
axes(handles.axes1);
plot(0,0);
axes(handles.axes2);
plot(0,0);


function varargout = MS_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
global fx;
set(handles.pushbutton1,'Enable','off');
set(handles.pushbutton1,'ForegroundColor', [0.5 0.5 0.5]);
set(handles.pushbutton1,'String','Creando Serie de Fourier..');
popup_sel_index = get(handles.popupmenu1, 'Value');
periodo = handles.periodo;
calculo(popup_sel_index,handles,hObject);
f=fx;
axes(handles.axes1);
hold on;
plot(linspace(0,periodo,300),f);
title('Funciones en el tiempo');
legend('show','Funcion real','Serie de Fourier','Location', 'Best');

set(handles.pushbutton1,'String','Crear Serie de Fourier');
set(handles.pushbutton1,'Enable','on');
set(handles.pushbutton1,'ForegroundColor', 'black');


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Func. onda cuadrada', 'Func. onda de sierra','Func. onda triangular'});



function edit2_Callback(hObject, eventdata, handles)
periodo=str2double(get(hObject,'String'));
if periodo<=0 || isnan(periodo)
    periodo=1;
    set(hObject,'String',num2str(periodo));
end
handles.periodo = periodo;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
constante=str2double(get(hObject,'String'));
if isnan(constante)
    constante=1;
    set(hObject,'String',num2str(constante));
end
handles.constante = constante;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
cant_n=floor(str2double(get(hObject,'String')));
if cant_n>50
    cant_n=50;
end
if cant_n<1 || isnan(cant_n)
    cant_n=1;
end
set(hObject,'String',num2str(cant_n));
handles.cant_n =cant_n;
guidata(hObject,handles);

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function calculo(funcion,handles,hObject)
global fx;
axes(handles.axes1);
cla;
i=1;
syms u k qq aa bb nn;
n_cant = handles.cant_n;
periodo= handles.periodo;
const= handles.constante;
n=[1:1:n_cant];
an=[1:1:n_cant];
bn=[1:1:n_cant];
L=periodo/2;
w=2*pi/periodo;
x=linspace(0,periodo,300);
FN=0;
FAN(aa,nn,qq)=(aa.*cos(nn.*qq.*w));
FBN(bb,nn,qq)=(bb.*sin(nn.*qq.*w));
f_error=0;
while i<=n_cant
    switch funcion
        case 1
            AN=@(u)(u<=L).*const.*cos(i.*u.*w);
            BN=@(u)(u<=L).*const.*sin(i.*u.*w);
            A0=@(u)(u<=L).*const;
            y=(x<=(L)).*const;          
         case 2
            AN=@(u) u.*const.*cos(i.*u.*w);
            BN=@(u) u.*const.*sin(i.*u.*w);
            A0=@(u) u.*const;
            y=x.*const;           
         case 3             
            AN=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const.*cos(i.*u.*w);
            BN=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const.*sin(i.*u.*w);
            A0=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const;
            y=((x>=L).*(-1).*(x-periodo)+(x<L).*x).*const;            
    end    
    if funcion==3
        an(i)=((integral(AN,0,periodo))./L);
        bn(i)=0;
    else
        an(i)=0;
        bn(i)=((integral(BN,0,periodo))./L);
    end
    FN=FN+FAN(an(i),i,qq)+FBN(bn(i),i,qq);
    if i==1
        a0=integral(A0,0,periodo)./periodo;
        FA0=abs(integral(A0,0,periodo));  
        FN=FN+a0;
    end

    switch funcion
        case 1
            fn1(qq)=abs(const-(FN));
            fn2(qq)=abs(0-(FN));    
        case 2
            fn1(qq)=abs(qq.*const-(FN));
            fn2(qq)=fn1;
        case 3
            fn1(qq)=abs(qq.*const-(FN));
            fn2(qq)=abs(FN+(qq-periodo).*const);
    end
    g1=matlabFunction(fn1);
    Fn1=integral(g1,0,L);
    g1=matlabFunction(fn2); 
    Fn2=integral(g1,L,periodo);
    errorA=Fn2+Fn1;
    errorR=100*(errorA./FA0);
    if errorR<= 5 &&f_error == 0
        set(handles.text8,'String', num2str(i));
        f_error=1;
    end
    i=i+1;
end
plot(x,y,'r');
fx= subs(FN,qq,x);
set(handles.text5,'String',strcat('%',num2str(errorR)));
axes(handles.axes2);
cla;
hold on;
plot(0,a0,'g+')
plot(n, an,'b-o');
plot(n, bn,'r-*');
title('Coeficientes');
xlabel('N');
ylabel('An, Bn');
legend('show','A0','An','Bn','Location', 'Best');
while f_error==0
    switch funcion
        case 1
            AN=@(u)(u<=L).*const.*cos(i.*u.*w);
            BN=@(u)(u<=L).*const.*sin(i.*u.*w);
         case 2
            AN=@(u) u.*const.*cos(i.*u.*w);
            BN=@(u) u.*const.*sin(i.*u.*w);
         case 3             
            AN=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const.*cos(i.*u.*w);
            BN=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const.*sin(i.*u.*w);            
    end
    
    if funcion==3
        an(i)=((integral(AN,0,periodo))./L);
        bn(i)=0;
    else
        an(i)=0;
        bn(i)=((integral(BN,0,periodo))./L);
    end
    FN=FN+FAN(an(i),i,qq)+FBN(bn(i),i,qq);
    switch funcion
        case 1
            fn1(qq)=abs(const-(FN));
            fn2(qq)=abs(0-(FN));
        case 2
            fn1(qq)=abs(qq.*const-(FN));
            fn2(qq)=fn1;
        case 3
            fn1(qq)=abs(qq.*const-(FN));
            fn2(qq)=abs(FN+(qq-periodo).*const);
    end
    g1=matlabFunction(fn1);
    Fn1=integral(g1,0,L);
    g1=matlabFunction(fn2); 
    Fn2=integral(g1,L,periodo);
    errorA=Fn2+Fn1;
    errorR=100*(errorA./FA0);
    if errorR<= 5 &&f_error == 0
        set(handles.text8,'String', num2str(i));
        f_error=1;
    end
    i=i+1;
end



