


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
tic
popup_sel_index = get(handles.popupmenu1, 'Value');
periodo = handles.periodo;
calculo(popup_sel_index,handles,hObject);
f=fx;
axes(handles.axes1);
hold on;
plot([0:0.01:periodo],f);
toc
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

set(hObject, 'String', {'f(x)= 1', 'f(x)= x','f(x)=x periodo'});



function edit2_Callback(hObject, eventdata, handles)
periodo=str2double(get(hObject,'String'));
handles.periodo = periodo;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
constante=str2double(get(hObject,'String'));
handles.constante = constante;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
cant_n=str2double(get(hObject,'String'));
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
bn=[1:1:n_cant]; %Lo declaro para saber cuantas bn va a haber
L=periodo/2;
w=2*pi/periodo;
x=[0:0.01:periodo];

%fa=0;
%fb=0;%Con este sumo todas las bn*sin(nwx)
%hold on;
FN=0;
FAN(aa,nn,qq)=(aa.*cos(nn.*qq.*w));
FBN(bb,nn,qq)=(bb.*sin(nn.*qq.*w));
while i<=n_cant
    switch funcion
        case 1
            AN=@(u)(u<=L).*const.*cos(i.*u.*w);
            BN=@(u)(u<=L).*const.*sin(i.*u.*w);
            A0=@(u)(u<=L).*const;
            y=(x<=(L)).*const;
            plot(x,y,'r');

            
         case 2
            AN=@(u) u.*const.*cos(i.*u.*w);
            BN=@(u) u.*const.*sin(i.*u.*w);
            A0=@(u) u.*const;
            y=x.*const;
            plot(x,y,'r');
         case 3             
            AN=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const.*cos(i.*u.*w);
            BN=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const.*sin(i.*u.*w);
            A0=@(u)((u>=L).*(-1).*(u-periodo)+(u<L).*u).*const;
            y=((x>=L).*(-1).*(x-periodo)+(x<L).*x).*const;
            plot(x,y,'r');
     end
    
    %Al final habia que declarar todo lo que va en la integral como una
    %funcion simbolica o function handler que es lo del @
    %Y ademas cada n la calcule separada dentro del while, la n seria la i
    if funcion==3
        an(i)=((integral(AN,0,periodo))./L);
        bn(i)=0;
    else
        an(i)=0;
        bn(i)=((integral(BN,0,periodo))./L); %Guardo cada bn
    end
    %fa=fa+an(i).*cos(i.*w.*x);
    %fb=fb+bn(i).*sin(i.*w.*x);
    FN=FN+FAN(an(i),i,qq)+FBN(bn(i),i,qq);
    %fn=@(u) fn+an(i).*cos(i.*w.*u)+bn(i).*sin(i.*w.*u);
    i=i+1;
end
a0=integral(A0,0,periodo)./periodo;
FA0=abs(integral(A0,0,periodo));
%fx= fb+a0+fa;
fx= a0+subs(FN,qq,x);
FN=FN+a0;
switch funcion
    case 1
        fn1(qq)=abs(const-(FN));
        fn2(qq)=abs(0-(FN));
        set(handles.text8,'String', '27');
    case 2
        fn1(qq)=abs(qq.*const-(FN));
        fn2(qq)=fn1;
        set(handles.text8,'String', '14');
    case 3
        fn1(qq)=abs(qq.*const-(FN));
        fn2(qq)=abs(FN+(qq-periodo).*const);
        set(handles.text8,'String', '3');
end
g1=matlabFunction(fn1);
fn1=integral(g1,0,L);
g1=matlabFunction(fn2);
fn2=integral(g1,L,periodo);
errorA=fn2+fn1;
errorR=100*(errorA./FA0);
set(handles.text5,'String',strcat('%',num2str(errorR)));
axes(handles.axes2);
cla;
hold on;
plot(n, an,'b-o');
plot(n, bn,'r-*');
title('Coeficientes');
xlabel('N');
ylabel('An, Bn');
legend('show','An','Bn','Location', 'Best');




