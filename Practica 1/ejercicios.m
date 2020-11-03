%% Cargamos los directorios
addpath("Funciones");
addpath("Imagenes");

%% Practica

% Ejercicio 4

pixel_width = imfinfo("P1_1.jpg").Width;
pixel_height = imfinfo("P1_1.jpg").Height;
image_type = imfinfo("P1_1.jpg").Format;
bit_depth = imfinfo("P1_1.jpg").BitDepth;

% Ejercicio 5

Imagen1 = imread("P1_1.jpg");

% Ejercicio 6

imtool(Imagen1),imshow(Imagen1);

% Ejercicio 7

whos Imagen1 % En size observamos que es una matriz de 3 dimensiones y en Class vemos que es uint8 (0-255)

% Al comparar los datos obtenidos en el ejercicio 4 vemos que tanto la
% altura como la anchura, etc son giaules (Es la misma imagen)

max(Imagen1(:)) % 255

% Ejercicio 8

% Imagen2 = uint8((ones(size(Imagen1))*255))-Imagen1;
Imagen2 = 255-Imagen1;
imtool(Imagen2);
figure, subplot(1,2,1),imshow(Imagen1),subplot(1,2,2),imshow(Imagen2)
imwrite(Imagen2,"P1_2."+image_type);

%---------------------------------------------------------------------

R = rand()*255 - Imagen1(:,:,1);
G = rand()*255 - Imagen1(:,:,2);
B = rand()*255 - Imagen1(:,:,3);

RGB = cat(3,R,G,B);

figure, imshow(RGB);

%---------------------------------------------------------------------

% Ejercicio 9

Imagen3 = Imagen1(:,:,1);
imtool(Imagen3);
imwrite(Imagen3,"P1_3.bmp");
iminfo("P1_3.bmp")

% Ejercicio 10

Imagen4 = uint8(imadjust(Imagen3,[],[],0.5));
Imagen5 = uint8(imadjust(Imagen3,[],[],1.5));
imshow(Imagen4),figure,imshow(Imagen5);
subplot(1,2,1),imhist(Imagen4),subplot(1,2,2),imhist(Imagen5); % Observamos que la tonalidad de color en la primera imagen tira mas hacia el balnco y en la otra al negro

% Ejercicio 11

Imagen6 = imabsdiff(Imagen4,Imagen5);
imshow(Imagen6); %Observamos que las zonas de color mas oscuras son se vuelven claras y las claras en oscuras
Imagen7 = uint8(abs(Imagen4-Imagen5));
imshow(Imagen7); %Observamos que obtenemos un resultado parecido

% Ejercicio 12
script(Imagen1);

