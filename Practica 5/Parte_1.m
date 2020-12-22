%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Addicción de carpetas
addpath('Imágenes','Funciones');

%% PRIMERA PARTE: Generación de imágenes. Análisis de perfiles de intensidad.

% 1. A partir de la lectura de la imagen “P5.tif”, genera y visualiza las 
%    siguientes imágenes:
%    - Imagen de intensidad I.
%    - Imagen de intensidad suavizada Igauss: es la imagen resultado de 
%      aplicar a I un filtro gaussiano 5x5.

I = imread("P5.tif");
Ii = rgb2gray(I);
Is = imfilter(Ii,fspecial('gaussian',5,1));
figure;
subplot(2,1,1),imshow(Ii),title("Imagen de intensidad")
subplot(2,1,2),imshow(Is),title("Imagen de intensidad suavizada")


% 2. Para cada una de las imágenes anteriores, representa, en un mismo 
%    gráfico, los perfiles de intensidad correspondientes a las siguientes 
%    líneas horizontales: round(0.25xN), round(0.5xN) y round(0.75xN), 
%    siendo N el número de filas de la imagen. Analiza las distintas 
%    distribuciones observadas.

%    Observación:
%     Utiliza la instrucción axis de matlab, para realizar ambas 
%     representaciones en la misma escala.

[N, M] = size(Ii);
lineas = [round(0.25*N),round(0.5*N),round(0.75*N)];
for i=1:length(lineas)
    figure;
    
    subplot(2,2,1), 
    hold on
    imshow(Ii),title("Imagen de intensidad");
    line([0,M],[lineas(i),lineas(i)],'Color','red')
    hold off
    
    subplot(2,2,2),plot(Ii(lineas(i),:)),axis([0,M,0,255]),xlabel("Fila: "+int2str(lineas(i))),ylabel("g");
    
    subplot(2,2,3);
    hold on;
    imshow(Is),title("Imagen suavizada");
    line([0,M],[lineas(i),lineas(i)],'Color','red')
    hold off
    
    subplot(2,2,4),plot(Is(lineas(i),:)),axis([0,M,0,255]),xlabel("Fila: "+int2str(lineas(i))),ylabel("g");
end


