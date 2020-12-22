%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Addicción de carpetas
addpath('Imágenes','Funciones');

%% TERCERA PARTE: Detección de bordes mediante la función edge de Maltab

Iint = rgb2gray(imread("P5.tif"));
Is = imfilter(Iint,fspecial('gaussian',5,1/5));

% 7. Aplica sobre la imagen de intensidad I y sobre la imagen de intensidad
%    suavizada Igauss, un detector de Sobel, con un umbral de valor umbral
%    y con un umbral de valor 0.4*umbral. El valor umbral es el que utiliza
%    la función edge en su configuración por defecto cuando se aplica sobre
%    la imagen de intensidad I:
%
%    [Isobel,umbral]=edge(I,'sobel','nothinning');
%
%    Visualiza las cuatro imágenes de bordes obtenidas y comenta los 
%    resultados. Aplica la función edge sin la opción 'nothinning' para 
%    ilustrar el efecto de realizar un adelgazamiento de los bordes 
%    detectados.

[I1,u1]=edge(Iint,'sobel','nothinning');
[I2,u2]=edge(Is,'sobel','nothinning');
[I3,u3]=edge(Iint,'sobel','nothinning',u1*0.4);
[I4,u4]=edge(Is,'sobel','nothinning',u2*0.4);

figure,
subplot(2,2,1),imshow(I1),title("edge sobre imagen de intensidad, umbral: "+num2str(u1));
subplot(2,2,2),imshow(I2),title("edge sobre imagen suavizada, umbral: "+num2str(u2));
subplot(2,2,3),imshow(I3),title("edge sobre imagen de intensidad, umbral: "+num2str(u3));
subplot(2,2,4),imshow(I4),title("edge sobre imagen suavizada, umbral: "+num2str(u4));

[I1,u1]=edge(Iint,'sobel');
[I2,u2]=edge(Is,'sobel');
[I3,u3]=edge(Iint,'sobel',u1*0.4);
[I4,u4]=edge(Is,'sobel',u2*0.4);

us1 = u1;

figure,
subplot(2,2,1),imshow(I1),title("edge sobre imagen de intensidad, umbral: "+num2str(u1));
subplot(2,2,2),imshow(I2),title("edge sobre imagen suavizada, umbral: "+num2str(u2));
subplot(2,2,3),imshow(I3),title("edge sobre imagen de intensidad, umbral: "+num2str(u3));
subplot(2,2,4),imshow(I4),title("edge sobre imagen suavizada, umbral: "+num2str(u4));

% 8. Aplica sobre la imagen de intensidad I un detector de Canny con 
%    umbrales superior e inferior: umbral y 0.4*umbral.


[I1,u1]=edge(Iint,'Canny');
[I2,u2]=edge(Is,'Canny');
[I3,u3]=edge(Iint,'Canny',us1*5 ,us1*0.4);
[I4,u4]=edge(Is,'Canny',u2*0.4);

figure,
subplot(2,2,1),imshow(I1),title("edge sobre imagen de intensidad, umbral: "+num2str(u1));
subplot(2,2,2),imshow(I2),title("edge sobre imagen suavizada, umbral: "+num2str(u2));
subplot(2,2,3),imshow(I3),title("edge sobre imagen de intensidad, umbral: "+num2str(u3));
subplot(2,2,4),imshow(I4),title("edge sobre imagen suavizada, umbral: "+num2str(u4));

% 9. Aplica sobre la imagen de intensidad I un detector de bordes Laplaciona de la Gaussiana.
[I1,u1]=edge(Iint,'log');
[I2,u2]=edge(Is,'log');
[I3,u3]=edge(Iint,'log',u1*5);
[I4,u4]=edge(Is,'log',u2*0.4);

figure,
subplot(2,2,1),imshow(I1),title("edge sobre imagen de intensidad, umbral: "+num2str(u1));
subplot(2,2,2),imshow(I2),title("edge sobre imagen suavizada, umbral: "+num2str(u2));
subplot(2,2,3),imshow(I3),title("edge sobre imagen de intensidad, umbral: "+num2str(u3));
subplot(2,2,4),imshow(I4),title("edge sobre imagen suavizada, umbral: "+num2str(u4));