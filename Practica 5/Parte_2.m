%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Addicción de carpetas
addpath('Imágenes','Funciones');

%% SEGUNDA PARTE: Implementación de algoritmo de detección de bordes basado en
% primera derivada.

% 3. Implementa un detector de bordes basado en primera derivada a través 
%    de la siguiente función:
%
%    [Gx Gy ModG] = Funcion_Calcula_Gradiente (I, Hx, Hy)
%
%    Esta función deberá:
%    - Para cada píxel de la imagen de entrada I , obtener las componentes 
%      horizontal y vertical, Gx y Gy, del vector gradiente calculadas 
%      considerando las máscaras de convolución Hx y Hy respectivamente.
%    - Obtener la magnitud del vector gradiente ModG.
%    Observaciones
%    * Para obtener la imagen binaria de bordes, tan sólo hay que binarizar
%       ModG con un valor de umbralización Umbral .
%    * En la implementación de esta función, todas las operaciones deben 
%       ser realizadas considerando variables tipo double. Además, para 
%       crear falsos bordes en los contornos de la imagen, las convoluciones 
%       deben calcularse utilizando una opción de relleno adecuada.

% 4. Aplica un detector de bordes de Sobel a la imagen de intensidad I 
%    utilizando la función anterior y considerando como umbrales el 10, 25, 
%    50 y 75% del valor máximo de la matriz magnitud del vector gradiente 
%    obtenida.
%
%    - Utilizando la función de matlab mat2gray, visualiza a través de 
%      distintas imágenes las siguientes matrices: magnitud de Gx, magnitud
%      de Gy y magnitud ModG del vector gradiente. Comenta los distintos 
%      resultados obtenidos. Utiliza siempre la misma escala para representar 
%      el negro y el blanco en las imágenes, por ejemplo el mínimo y el 
%      máximo de ModG.
%    - Visualiza y comenta las distintas matrices binarias de bordes obtenidas.

I = rgb2gray(imread("P5.tif"));
Hx = [-1 0 1; -2 0 2; -1 0 1];
Hy = [-1 -2 -1; 0 0 0; 1 2 1];
[Gx,Gy,ModG] = Funcion_Calcula_Gradiente (I, Hx, Hy);

figure,
subplot(3,1,1),imshow(mat2gray(abs(Gx))),title("Gx");
subplot(3,1,2),imshow(mat2gray(abs(Gy))),title("Gy");
subplot(3,1,3),imshow(mat2gray(abs(ModG))),title("ModG");
u = ["10%","25%","50%","75%"];
maximo = max(ModG(:));
umbrales = [maximo*0.1 maximo*0.25 maximo*0.50 maximo*0.75];
figure,
for i=1:length(umbrales)
    Ib = ModG>umbrales(i);
    subplot(length(umbrales),1,i),imshow(Ib),title("Umbral: "+u(i));
end

% 5. Aplica un detector de bordes de Sobel a la imagen de intensidad 
%    suavizada Igauss utilizando la función Funcion_Calcula_Gradiente y 
%    considerando como umbrales los mismos valores utilizados en el aparado
%    anterior.
%    - Visualiza la magnitud del vector gradiente y las distintas matrices 
%      binarias de bordes obtenidas. Compara estas gráficas con las 
%      obtenidas en el apartado anterior y analiza los resultados.

clear,clc;
I = imfilter(rgb2gray(imread("P5.tif")),fspecial('gaussian',5,1));

Hx = [-1 0 1; -2 0 2; -1 0 1];
Hy = [-1 -2 -1; 0 0 0; 1 2 1];
[Gx,Gy,ModG] = Funcion_Calcula_Gradiente (I, Hx, Hy);

figure,
subplot(3,1,1),imshow(uint8(Gx)),title("Gx");
subplot(3,1,2),imshow(uint8(Gy)),title("Gy");
subplot(3,1,3),imshow(uint8(ModG)),title("ModG");
u = ["10%","25%","50%","75%"];
maximo = max(ModG(:));
umbrales = [maximo*0.1 maximo*0.25 maximo*0.50 maximo*0.75];
figure,
for i=1:length(umbrales)
    Ib = ModG>umbrales(i);
    subplot(length(umbrales),1,i),imshow(Ib),title("Umbral: "+u(i));
end

% 6. Genera una imagen binaria de bordes donde se detecten lo máximo 
%    posible las líneas blancas que delimitan la carretera y lo mínimo 
%    posible la línea horizontal correspondiente al horizonte de la imagen.
%    Para ello, elige la configuración y parametrización del detector de 
%    bordes que consideres más adecuados para conseguir el objetivo 
%    planteado.
clear,clc;
I = imfilter(rgb2gray(imread("P5.tif")),fspecial('gaussian',5,1/5));

Hx = [-1 0 1; -1 0 1; -1 0 1];
Hy = [-1 -1 -1; 0 0 0; 1 1 1];
[Gx,Gy,ModG] = Funcion_Calcula_Gradiente (I, Hx, Hy);
maximo = max(ModG(:));
umbral = maximo*0.50;
figure,imshow(abs(Gx) > 0.3*max(Gx(:))),title("umbral del 55%");

