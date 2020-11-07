%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Adicción del directorio de las imágenes
addpath("Imagenes");

%% Paso 0: Utiliza la función de matlab roipoly para generar, a partir de la imagen facilitada 
% P1b.jpg, una nueva imagen que contenga únicamente la información central contenida en el
% cuadro. Sobre esta nueva imagen hay que implementar el resto de operaciones descritas a 
% continuación.

% Leemos la imagen
I = imread("P1b.jpg");

% Obtenemos la Ib de la zona de interes
Ib = roipoly(I);

% Obtenemos la imagen de interes
[row,col] = find(Ib==1);
Ii = I(min(row):max(row),min(col):max(col));

% Visualizamos la imagen
imshow(Ii);

%% Operaciones individuales: manipulación de brillo y contraste.

% 1. Determinar el brillo y el contraste de la nueva imagen generada.

% Brillo
% Forma manual
[M N] = size(Ii);
brillo = sum(Ii(:)) / (M*N);

% Usando mean
brillo = mean(Ii(:));

% Contraste
% Forma manual
Ic = double(Ii - brillo).^2;
contraste = sqrt( sum(Ic(:))/(M*N) );

% 2. Genere nuevas imágenes de mayor y menor brillo que la original y mida, para cada 
% imagen generada, el nuevo valor de brillo.

IBmayor = imadjust(Ii,[],[],1,5);
IBmenor = imadjust(Ii,[],[],0,5);

% representación
figure,hold on;
subplot(1,3,1),imshow(Ii),title("Imagen original");
subplot(1,3,2),imshow(IBmayor),title("Imagen con mas brillo");
subplot(1,3,3),imshow(IBmenor),title("Imagen con menos brillo");

% Calculamos los nuevos brillos
Bmayor = mean(IBmayor(:));
Bmenor= mean(IBmenor(:));

%  3. Genere nuevas imágenes de mayor y menor contraste que la original y mida, para cada 
%  imagen generada, el nuevo valor de contraste.
ICmayor = imcontrast(Ii,1.5);

% representación
figure,hold on;
subplot(1,3,1),imshow(Ii),title("Imagen original");
subplot(1,3,2),imshow(ICmayor),title("Imagen con mas contraste");
subplot(1,3,3),imshow(ICmenor),title("Imagen con menos contraste");

B = mean(ICmayor(:));
Ic = double(ICmayor - B).^2;
CICmayor= sqrt( sum(ICmayor(:))/(M*N) );

B = mean(ICmenor(:));
Ic = double(ICmenor - B).^2;
CICmenor= sqrt( sum(ICmenor(:))/(M*N) );

