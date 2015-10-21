i=1;
syms u k;
%periodo=input('Periodo:');
%const=input('Constante:');
%n_cant=input('N:');
n=[1:1:n_cant];
bn=[1:1:n_cant]; %Lo declaro para saber cuantas bn va a haber
L=periodo/2;
w=2*pi/periodo;
x=linspace(0,periodo);
y=(x<=(L)).*const;
fb=0;%Con este sumo todas las bn*sin(nwx)
hold on;
while i<=n_cant
    subplot(2,1,1);
    p=@(u)(u<=L).*const.*sin(i.*u.*w); 
    %Al final habia que declarar todo lo que va en la integral como una
    %funcion simbolica o function handler que es lo del @
    %Y ademas cada n la calcule separada dentro del while, la n seria la i
    bn(i)=((integral(p,0,periodo))./L); %Guardo cada bn
    fb=fb+bn(i).*sin(i.*w.*x);%Para graficar la aproximacion
    i=i+1;
end
plot((n.*w),bn,'.');
hold off;
subplot(2,1,2);
hold on;
plot(x,y,'b');%La fx para comparar con la aprox en azul
t=@(u)(u<=L).*const;%La fx declarada con el @ para poder integrar a0
a0=integral(t,0,periodo)./periodo;
plot(x,fb+a0,'r');%En rojo la aprox.
ylim([-1 const+1]);
grid;
hold off;