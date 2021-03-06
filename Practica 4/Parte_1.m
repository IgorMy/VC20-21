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

errorSP = calcula_error_cuadratico_medio(I,IrSP);

% Visualización
figure, hold on
subplot(1,2,1),imshow(I),title("Imagen original");
subplot(1,2,2),imshow(IrSP),title("Imagen con ruido Sal y Pimienta, ECM: "+ int2str(errorSP));
hold off;

clear p q Mascara_ruido Ib

% b. Gaussiano de media nula y desviación típica 10.

Mascara_ruido =0 + 10*randn(size(I));
IrG = double(I) + Mascara_ruido;
IrG = uint8(IrG);

errorG = calcula_error_cuadratico_medio(I,IrG);

% Visualización
figure, hold on
subplot(1,2,1),imshow(I),title("Imagen original");
subplot(1,2,2),imshow(IrG),title("Imagen con ruido Gaussiano ECM: "+int2str(errorG));
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
subplot(2,2,1),imshow(IrSP),title("Imagen con ruido sal y pimienta ECM: "+ int2str(errorSP));
subplot(2,2,2),imshow(IrG),title("Imagen con ruido Gaussiano ECM: "+ int2str(errorG));
subplot(2,2,3),plot(FM_Rsp),xlabel("Fila "+round(size(IrSP,1))),ylabel("g"),title("Distribución de ruido Sal y Pimienta");
subplot(2,2,4),plot(FM_Rg),xlabel("Fila "+round(size(IrG,1))),ylabel("g"),title("Distribución de ruido Gaussiano");
hold off;

save("Imágenes generadas/imagenes_ruidosas.mat","IrG","IrSP");
