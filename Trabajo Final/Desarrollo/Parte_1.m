%% Limpieza inicial
clear, clc, close all;

%% PRIMERA FASE DE DESARROLLO: Segmentación de Caracteres.

%% Lectura de imagen
I = imread("Imágenes/01_Training/Training_03.jpg");
figure,imshow(I),title("Imagen RGB");

%% Obtención de la imagen de intensidad.
% En este caso se selecciona el canal rojo porque se desea que se detecte
% tambien la parte izquierda de la imagen (La marca azul de UE) y eliminar
% la poasibilidad de que esta se pueda detectar como ruido.
Ii = I(:,:,1);
figure,imshow(Ii),title("Imagen de intensidad");

%% Sauavizado de la imagen
% Al suavizar la imagen se conectan las pequeñas imperfecciones de la
% letras y se difumina los posibles ruidos conectados a ellas.
Ii = imfilter(Ii,fspecial('gaussian',10,1));
figure,imshow(Ii),title("Imagen de intensidad suavizada");

%% Numero de objetos a detectar
N = 7;

%% Generación del fondo de iluminación de la imagen
W = round(size(Ii,1)/3);
H = (1/(W*W)*ones(W));
Fondo = imfilter(double(Ii),H,'replicate');

%% Generación de la imagen con la iluminación ajustada
% Como las zonas de interes son relativamente grandes en comparación con la
% imágen y no poseen muchos detalles se optra por esta técnica.
% Se le resta a la imagen de intensidad suavizada su fondo de iluminación.
% La matriz de salida posee valores negativos, por lo que se le aplica
% mat2gray para normalizarlos y se multiplica por el valor máximo de
% iluminación (255). 
%Obteniendo asi, una imagen con la iluminación corregida.
diferencia = double(Ii)-Fondo;
salida = uint8(255*mat2gray(diferencia));

% Visualización de la imágen con la iluminación ajustada
figure,imshow(salida),title("Imagen de intensidad suavizada con la iluminación global corregida");

%% Umbralización global de la imagen
% Al tener la imagen con la iluminación global corregda, se puede
% umbralizar globalmente.
Ib = salida < graythresh(salida)*255;
figure,imshow(Ib),title("Detección de la imágen");

%% Aplicación del cierre morfológico.
% Al aplicar esta tecnica dos veces intercambiando la mascara, conseguimos
% no solo la eliminación de ruidos pequeños. Sino arreglar las
% imperfecciones residuales en las zonas de interes.
W = 7;
Ib = ordfilt2(Ib,W*W,ones(W));
Ib = ordfilt2(Ib,1,ones(W));

Ib = ordfilt2(Ib,1,ones(W));
Ib = ordfilt2(Ib,W*W,ones(W));

figure,imshow(Ib),title("Aplicación del cierre morfológico");

%% Eliminación de objetos que no esten en la linea central
Ietiq = bwlabel(Ib);
etiquetas = unique(Ietiq(round(size(Ietiq,1)/2),:));
for i=0:length(unique(Ietiq))
    if ~ismember(i,etiquetas)
        Ib(Ietiq==i) = 0;
    end
end
figure,imshow(Ib),title("Bordes eliminados")

%% Etiquetado de la imagene
% Se obtienen las N+1 imágenes mas grandes 
labeledImage = bwareafilt(Ib,N+1);
Ietiq = bwlabel(labeledImage);
Vis = false(size(Ietiq));
for i=1:N+1
    if i > 1
        Vis(Ietiq==i) = true;
    end
    Ietiq(Ietiq==i) = i-1;
end
figure,imshow(Vis),title("Detección final de la imagen");
measurements = regionprops(Vis, 'BoundingBox', 'Area');
for k = 1 : N
  thisBB = measurements(k).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 )
end

