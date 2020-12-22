%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Addicción de carpetas
addpath('Imágenes','Funciones','Imágenes generadas');

%% SEGUNDA PARTE: Implementación de filtros gaussiano, mediana y adaptativo.

I = imread("P4.tif");
load("imagenes_ruidosas.mat");

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

IrG_FG = imfilter(IrG,Mascara);

FM_Rg_F = IrG_FG(round(size(IrG_FG,1)/2),:);
FM_Rg = IrG(round(size(IrG,1)/2),:);

figure, hold on
subplot(2,2,1),imshow(IrG),title("Imagen con ruido gaussiano");
subplot(2,2,2),imshow(IrG_FG),title("Filtro Gaussiano: W("+W+") σ("+Std+") ISNR: " + evalua_eficiencia(I,IrG_FG,IrG));
subplot(2,2,3),plot(FM_Rg),xlabel("Fila "+ceil(size(IrG,1))),ylabel("g");
subplot(2,2,4),plot(FM_Rg_F),xlabel("Fila "+ceil(size(IrG_FG,1))),ylabel("g");
hold off;

clear W Std Mascara FM_Rg_F FM_Rg IrG_FG

% b. Un filtro de la mediana considerando un entorno de vecindad de 5 x 5. 
%    Para ello, implementa la función (ver observación):
%
%    Ifiltrada = Funcion_FiltroMediana(I, NumFilVent, NumColVent)
%
%    Comprueba que se obtiene la misma imagen de salida que genera la función de Matlab medfilt2.

IrSP_FM_Mat = medfilt2(IrSP,[3 3]);
IrSP_FM = Funcion_FiltroMediana(IrSP, 3, 3,"zeros");

f1 = IrSP_FM_Mat(ceil(size(IrSP_FM_Mat,1)/2),:);
f2 = IrSP_FM(ceil(size(IrSP_FM,1)/2),:);
f3 = IrSP(ceil(size(IrSP,1)/2),:);

figure,hold on;
subplot(2,3,1),imshow(IrSP),title("Imagen con ruido Sal y Pimienta");
subplot(2,3,2),imshow(IrSP_FM_Mat),title("medfilt2 ISNR: " + evalua_eficiencia(I,IrSP_FM_Mat,IrSP));
subplot(2,3,3),imshow(IrSP_FM),title("Funcion FiltroMediana ISNR: " + evalua_eficiencia(I,IrSP_FM,IrSP));
subplot(2,3,4),plot(f3),xlabel("Fila "+ceil(size(IrSP,1))),ylabel("g");
subplot(2,3,5),plot(f1),xlabel("Fila "+ceil(size(IrSP_FM_Mat,1))),ylabel("g");
subplot(2,3,6),plot(f2),xlabel("Fila "+ceil(size(IrSP_FM,1))),ylabel("g");
hold off;

clear f1 f2 f3 IrSP_FM_Mat IrSP_FM


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


% Diferencia temporal
tic
    Ifv1 = Funcion_FiltAdapt_v1(IrG, NumFilVent, NumColVent, VarRuidoG);
t1 = toc;

tic
    Ifv2 = Funcion_FiltAdapt_v2(IrG, NumFilVent, NumColVent, VarRuidoG);
t2 = toc;

figure,hold on
subplot(1,3,1),imshow(IrG),title("Imagen con Ruido Gausiano");
subplot(1,3,2),imshow(Ifv1),title("Filtro adaptativo v1: "+t1);
subplot(1,3,3),imshow(Ifv2),title("Filtro adaptativo v1: "+t2);
hold off;

clear t1 t2 Ifv1 Ifv2

IrG_FA = Funcion_FiltAdapt_v2(IrG, NumFilVent, NumColVent, VarRuidoG);
IrSP_FA = Funcion_FiltAdapt_v2(IrSP, NumFilVent, NumColVent, VarRuidoSP);

% Comparación
f1 = IrG(ceil(size(IrG,1)/2),:);
f2 = IrG_FA(ceil(size(IrG_FA,1)/2),:);
f3 = IrSP(ceil(size(IrSP,1)/2),:);
f4 = IrSP_FA(ceil(size(IrSP_FA,1)/2),:);

figure, hold on;
subplot(2,4,1), imshow(IrG), title("Imagen con ruido gaussiano");
subplot(2,4,2), imshow(IrG_FA), title("IrG Filtro adaptativo, ISNR: "+evalua_eficiencia(I,IrG_FA,IrG));
subplot(2,4,3), imshow(IrSP), title("Imagen con ruido Sal y Pimienta");
subplot(2,4,4), imshow(IrSP_FA), title("IrSP Filtro adaptativo, ISNR: "+evalua_eficiencia(I,IrSP_FA,IrSP));
subplot(2,4,5), plot(f1),xlabel("Fila "+ceil(size(IrG,1))),ylabel("g");
subplot(2,4,6), plot(f2),xlabel("Fila "+ceil(size(IrG_FA,1))),ylabel("g");
subplot(2,4,7), plot(f3),xlabel("Fila "+ceil(size(IrSP,1))),ylabel("g");
subplot(2,4,8), plot(f4),xlabel("Fila "+ceil(size(IrSP_FA,1))),ylabel("g");
hold off