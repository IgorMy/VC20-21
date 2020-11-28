%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Addicción de carpetas
addpath('Imágenes','Funciones');

%% PRIMERA PARTE: Simulación de ruidos.

% 1. Lee la imagen “P4.tif”, que es una imagen en escala de gris.
I = imread('P4.tif');


% 2. Corrompe la imagen anterior con ruido de tipo de sal y pimienta y de 
% tipo gaussiano para generar, tal y como se describe a continuación:

% a. Sal y pimienta, con p = 0.9 y q = 0.95 (ver ecuación). La imagen 
% corrompida con este ruido (imagen A) se puede calcular de la siguiente manera:
%
%          | I(i,j)     x < p    |
% A(i,j) = | 0        p <=x <=q  | siendo I la imagen original sin 
%          | 255     q < x <= 1  | corromper, x una 
%
% variable aleatoria uniforme de rango (0,1), q-p el porcentaje de píxeles 
% con ruido de tipo pimienta y 1-q el porcentaje de píxeles con ruido de 
% tipo sal.

% Datos problema
p = 0.9;
q = 0.95;
Mascara_ruido = rand(size(I));
IrSP = I;

% Pimienta
Ib = Mascara_ruido >= p & Mascara_ruido <= q;
IrSP(Ib) = 0;

% Sal
Ib = Mascara_ruido > q ;
IrSP(Ib) = 255;

% Visualización
figure, hold on
subplot(1,2,1),imshow(I),title("Imagen original");
subplot(1,2,2),imshow(IrSP),title("Imagen con ruido Sal y Pimienta");
hold off;

clear p q Mascara_ruido Ib

% b. Gaussiano de media nula y desviación típica 10.

Mascara_ruido =0 + 10*randn(size(I));
IrG = double(I) + Mascara_ruido;
IrG = uint8(IrG);

% Visualización
figure, hold on
subplot(1,2,1),imshow(I),title("Imagen original");
subplot(1,2,2),imshow(IrG),title("Imagen con ruido Gaussiano");
hold off;

clear Mascara_ruido

% 3. Visualiza las imágenes ruidosas A y B. Representa en un mismo gráfico la variación de los
% niveles de gris a lo largo de la línea horizontal central para la imagen original, para la
% imagen A con ruido de tipo sal y pimienta, y para la imagen B con ruido gaussiano. Para
% ello emplea la función plot (hold on para mantener la misma gráfica). Observa las
% distintas distribuciones del ruido.

FM_Rsp = IrSP(round(size(IrSP,1)/2),:); 
FM_Rg = IrG(round(size(IrG,1)/2),:); 

figure, hold on
subplot(2,2,1),imshow(IrSP),title('Imagen con ruido sal y pimienta');
subplot(2,2,2),imshow(IrG),title('Imagen con ruido Gaussiano');
subplot(2,2,3),plot(FM_Rsp),xlabel("Fila "+round(size(IrSP,1))),ylabel("g"),title("Distribución de ruido Sal y Pimienta");
subplot(2,2,4),plot(FM_Rg),xlabel("Fila "+round(size(IrG,1))),ylabel("g"),title("Distribución de ruido Gaussiano");
hold off;


%% SEGUNDA PARTE: Implementación de filtros gaussiano, mediana y adaptativo.

% Aplica los siguientes filtros, visualiza las imágenes filtradas y discuta 
% los resultados obtenidos:

% a. Un filtro gaussiano con W = 5 σ, siendo σ la desviación típica del 
% filtro y W el tamaño del filtro (considera un valor W=5). Para ello:
% - Crea la máscara del filtro gaussiano, implementada en Código Matlab 
% (ver documentación teórica - Tema 3) y utilizando función fspecial. 
% Comprueba que se obtienen los mismos resultados.
% - Utiliza la función imfilter para realizar la convolución.

W = 5;
Std = W/5;
Mascara = funcion_fspecial(W,Std);

IrG_Filtro_Gaussiano = imfilter(IrG,Mascara);

FM_Rg_F = IrG_Filtro_Gaussiano(ceil(size(IrG,1)/2),:); 
figure, hold on
subplot(2,2,1),imshow(IrG),title("Gaussiano");
subplot(2,2,2),imshow(IrG_Filtro_Gaussiano),title("Filtro Gaussiano: W("+W+") σ("+Std+")");
subplot(2,2,3),plot(FM_Rg),xlabel("Fila "+ceil(size(IrSP,1))),ylabel("g");
subplot(2,2,4),plot(FM_Rg_F),xlabel("Fila "+ceil(size(IrG_Filtro_Gaussiano,1))),ylabel("g");
hold off;

clear W Std Mascara 

% b. Un filtro de la mediana considerando un entorno de vecindad de 5 x 5. 
%    Para ello, implementa la función (ver observación):
%
%    Ifiltrada = Funcion_FiltroMediana(I, NumFilVent, NumColVent)
%
%    Comprueba que se obtiene la misma imagen de salida que genera la función de Matlab medfilt2.

IrSP_Filt_Med_Mat = medfilt2(IrSP,[5 5]);
IrSP_Filt_Med = Funcion_FiltroMediana(IrSP, 5, 5,"zeros");

f1 = IrSP_Filt_Med_Mat(ceil(size(IrSP_Filt_Med_Mat,1)/2),:);
f2 = IrSP_Filt_Med(ceil(size(IrSP_Filt_Med,1)/2),:);

figure,hold on;
subplot(2,2,1),imshow(IrSP_Filt_Med_Mat),title("medfilt2");
subplot(2,2,2),imshow(IrSP_Filt_Med),title("Funcion FiltroMediana");
subplot(2,2,3),plot(f1),xlabel("Fila "+ceil(size(IrSP_Filt_Med_Mat,1))),ylabel("g");
subplot(2,2,4),plot(f2),xlabel("Fila "+ceil(size(IrSP_Filt_Med,1))),ylabel("g");
hold off;



% c. Un filtro adaptativo que actúe en un entorno de vecindad 5x5. 
%    Para ello, implementa la función (ver observación):
% 
%    Ifiltrada = Funcion_FiltAdapt (I, NumFilVent, NumColVent, VarRuido)
%
%    Observación: En las funciones anteriores, I es la imagen de entrada, 
%    NumFilVent y NumColVent son el número de filas y columnas de la 
%    ventana de vecindad considerada, e Ifiltrada es la imagen de salida 
%    filtrada. En el caso de la función Funcion_FiltAdapt, VarRuido es la 
%    varianza del ruido presente en la imagen; para hacerla más eficiente, 
%    utilizar en su implementación las funciones imfilter y stdfilt. 
%    Por otra parte, se ha de considerar que las ventanas de vecindad 
%    tienen un número impar de filas y columnas. Además, se debe contemplar
%    la asignación de un valor adecuado a todos aquellos puntos del entorno
%    de vecindad que no existen en la imagen (para ello, puede utilizarse 
%    la función de matlab padarray).

NumFilVent = 5;
NumColVent = 5;
VarRuidoG = var(double(IrG(:))-double(I(:)));
VarRuidoSP = var(double(IrSP(:))-double(I(:)));

IfiltradaGv1 = Funcion_FiltAdapt_v1(IrG, NumFilVent, NumColVent, VarRuidoG);

figure,hold on
subplot(1,2,1),imshow(IrG),title(VarRuidoG);
subplot(1,2,2),imshow(IfiltradaGv1),title(var(double(IfiltradaGv1(:))-double(I(:))));
hold off;

IfiltradaSPv1 = Funcion_FiltAdapt_v1(IrSP, NumFilVent, NumColVent, VarRuidoSP);
figure,hold on
subplot(1,2,1),imshow(IrSP),title(VarRuidoSP);
subplot(1,2,2),imshow(IfiltradaSPv1),title(var(double(IfiltradaSPv1(:))-double(I(:))));
hold off;

IfiltradaGv1 = Funcion_FiltAdapt_v1(IrG, NumFilVent, NumColVent, VarRuidoG);
IfiltradaGv2 = Funcion_FiltAdapt_v2(IrG, NumFilVent, NumColVent, VarRuidoG);
figure,hold on
subplot(1,2,1),imshow(IfiltradaGv1),title(var(double(IfiltradaGv1(:))-double(I(:))));
subplot(1,2,2),imshow(IfiltradaGv2),title(var(double(IfiltradaGv2(:))-double(I(:))));
hold off;

%% TERCERA PARTE: Evaluación de eficiencia de filtros gaussiano, mediana y adaptativo.

clear, clc;

% 1. A partir de la imagen "P4.tif", genera tres imágenes con ruido 
%    gaussiano de media nula y desviaciones típicas, por cada imagen 
%    generada, de 5, 10 y 35.
I = imread('P4.tif');

IR = cell(3,1);
Std = [5,10,35];
for i=1:3
    IR{i} = uint8(double(I) + randn(size(I)).*Std(i));
end
clear Std i;


% 2. Filtra cada una de las imágenes ruidosas anteriores con filtros de 
%    tipo gaussiano, de tipo mediana y adaptativo, considerando tamaños 3x3
%    y 7x7 para cada filtro. Visualiza las distintas imágenes ruidosas y 
%    filtradas.

IF = cell(7,5);
Ventanas = [3,7,3,7,3,7];
Std = [5, 5, 10, 10, 35, 35];
for i=1:6
    IF{i+1,1} = "σ: "+int2str(Std(i));
    IF{i+1,2} ="Ventana: "+int2str(Ventanas(i));
end
IF{1,3} = "Filtro gaussiano";
IF{1,4} = "Filtro de la mediana";
IF{1,5} = "Filtro adaptativo";
EfIF = IF;


% Con imagenes en un figure y espera
for i=1:6
    for j=1:3
        if j==1 % Filtro gausiano
            ImF = imfilter(IR{ceil(i/2)},funcion_fspecial(Ventanas(i),Ventanas(i)/5));
            IF{i+1,j+2} = ImF;
            ISNR = evalua_eficiencia(I,ImF,IR{ceil(i/2)});
            EfIF{i+1,j+2} = ISNR;
            hold on;
            subplot(1,2,1),imshow(IR{ceil(i/2)}),title("Imagen ruidosa σ:"+Std(i));
            subplot(1,2,2),imshow(IR{ceil(i/2)}),title(IF{1,j+2}+" Ventana: "+Ventanas(i)+" ISNR: "+ISNR);
            hold off
            %pause;
        elseif j ==2 % Filtro de la mediana
            ImF = Funcion_FiltroMediana(IR{ceil(i/2)}, Ventanas(i), Ventanas(i),"zeros");
            IF{i+1,j+2} = ImF;
            ISNR = evalua_eficiencia(I,ImF,IR{ceil(i/2)});
            EfIF{i+1,j+2} = ISNR;
            hold on;
            subplot(1,2,1),imshow(IR{ceil(i/2)}),title("Imagen ruidosa σ:"+Std(i));
            subplot(1,2,2),imshow(IR{ceil(i/2)}),title(IF{1,j+2}+" Ventana: "+Ventanas(i)+" ISNR: "+ISNR);
            hold off
            %pause;
        else % Filtro adaptativo
            ImF = Funcion_FiltAdapt_v1(IR{ceil(i/2)}, Ventanas(i), Ventanas(i), var( double(I(:)) - double(IR{ceil(i/2)}(:)) ));
            IF{i+1,j+2} = ImF;
            ISNR = evalua_eficiencia(I,ImF,IR{ceil(i/2)});
            EfIF{i+1,j+2} = ISNR;;
            hold on;
            subplot(1,2,1),imshow(IR{ceil(i/2)}),title("Imagen ruidosa σ:"+Std(i));
            subplot(1,2,2),imshow(IR{ceil(i/2)}),title(IF{1,j+2}+" Ventana: "+Ventanas(i)+" ISNR: "+ISNR);
            hold off
            %pause;
        end
    end
end

% cerrar todas las ventanas
close all;

% Se observa que para imagenes ruidosas con desviaciónes tipicas pequeñas,
% tanto el filtro gaussiano como el filtro de las medianas empeoran la
% imagen. En cambio el filtro adaptativo, aunque por poco, mejora la
% imagen. 

% En cambio, para imagenes ruidosas con desviaciones tipicas altas, el
% filtro gaussiano es el mas optimo
