    %% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Adicción de carpetas
addpath('Funciones');

%% SEGUNDA PARTE: Segmentación de señales de tráfico mediante la aplicación de la Transformada de Hough para detectar circunferencias.

% Segmentación de señales de limitación de velocidad:

% 8. A partir de la imagen en color Signal1_1.tif (incluida en la carpeta ImagenesPractica/SegundaParte),
%    genera y visualiza una imagen binaria Ib de puntos "rojos" de la imagen en color, candidatos a pertenecer 
%    al contorno de la región que se pretende segmentar (interior de la señal de tráfico). Para ello, utiliza 
%    un método de umbralización global, tomando como umbrales de referencia para cada componente de color los siguientes:
%
%    factor = 0.35;
%    UmbralRojo = factor*(Rmin+Rmax);
%    UmbralVerde = factor*(Gmax+Gmin);
%    UmbralAzul = factor*(Bmax+Bmin);
% 
%    donde Rmin, Rmax, Gmin, Gmax, Bmin y Bmax, son los valores de intensidad mínimo y máximo en las componentes roja (R),
%    verde (G) y azul (B) de la imagen en color que está siendo analizada.

I = imread('Imagenes/SegundaParte/Signal1_1.tif');
figure,imshow(I),title("Imagen RGB");
R = double(I(:,:,1));Rmin=min(R(:));Rmax = max(R(:));
G = double(I(:,:,2));Gmin=min(G(:));Gmax = max(G(:));
B = double(I(:,:,3));Bmin=min(B(:));Bmax = max(B(:));

factor = 0.35;
UmbralRojo = factor*(Rmin+Rmax);
UmbralVerde = factor*(Gmax+Gmin);
UmbralAzul = factor*(Bmax+Bmin);

Ib = (R > UmbralRojo) & (G < UmbralVerde) & (B < UmbralAzul);
figure,imshow(Ib),title("Detección");


figure,
imshow(I)
hold on;
[p1,p2] = find(Ib == 1);
plot(p2,p1,'*r')
hold off;
title("Visualización de la detección sobre la imagen original");

% 9. Aplica a Ib la Transformada de Hough para detectar contornos circulares utilizando la función facilitada circle_hough 
%    de la siguiente forma:
%
     radii = 5:2:35; % Radios posibles de las circunferencias buscadas.
%
%    Todas las imágenes tienen la misma resolución. Conocimiento a priori:
%    los objetos circulares buscados tienen sus radios limitados en ese rango.
%
     H = circle_hough(Ib, radii, 'same');
%
%    Opción 'same': los centros de las circunferencias buscadas deben ser puntos de la imagen, 
%    no se permiten circunferencias cuyos centros se sitúan fuera de la imagen.
%
%    - Interpreta las dimensiones de la matriz de salida H. 
%      ¿Cuál es el significado de los valores almacenados en dicha matriz?
%       Las dimensiones de H son iguales a las dimensiones de la imagen
%       binaria por 16 tamaños de radio. En cada celda se almacena el
%       numero de puntos de la imagen binaria que se encuentran en el
%       circulo que tiene como centro la posicion de la celda, la capa 
%       nos sirve de indice en el vector radios. 
%
%    - Ayudándote de la función de Matlab find , escribe la ecuación de la 
%      circunferencia que pasa por más puntos en la imagen binaria Ib, 
%      especificando su radio y las coordenadas (x,y) de su centro. 
%      ¿Cuántos puntos de Ib contiene esta circunferencia?
    [f,c] = find(H==max(H(:)));
    if(length(f) > 1)
        f = f(1);
        c = c(1);
    end
    if c > size(I,2)
        radio = radii(ceil(c/size(I,2)))
        c = c - size(I,2)*floor(c/size(I,2));
        Numero_de_puntos = H(f,c,ceil(c/size(I,2)))
    else
        radio = radii(1)
        Numero_de_puntos = H(f,c,1)
    end
    centro = [f,c]
    disp("(x-"+num2str(c)+")^2 + (y-"+num2str(f)+")^2 = "+num2str(radio)+"^2");
    figure,imshow(I),hold on;
    ang=0:0.01:2*pi; 
    fp=radio*cos(ang);
    cp=radio*sin(ang);
    plot(c+cp,f+fp,'.r');
    hold off
    title("Detección de forma circular")
    
% 10. Encuentra los parámetros representativos de la circunferencia más 
%     votada aplicando la función facilitada circle_houghpeaks con la siguiente configuración:
P = circle_houghpeaks(H, radii,'npeaks',1)

%     ¿Qué información contiene el parámetro de salida P?
%     contiene el centro de la circunferencia, el radio y el numero de
%     puntos por los que pasa la circunferencia

% 11. A partir de la información contenida en P, genera una imagen binaria, Ib_circunf, 
%     de las mismas dimensiones que las matrices que componen la imagen original que 
%     especifique los píxeles correspondientes a la circunferencia detectada. 
%     Para ello, utiliza la función facilitada circlepoints:

[x,y] = circlepoints(P(3)); % genera las coordenadas (x,y) que pertenecen a la 
% circunferencia de radio r y centro en el origen del sistema de coordenadas (0,0).
Ib_circunf = false(size(Ib));
for i=1:length(x)
    Ib_circunf(y(i)+P(2),x(i)+P(1)) = true;
end
figure,imshow(Ib_circunf),title("Detección y binarización de forma circular")

% 12. Genera y visualiza la imagen binaria que representa la segmentación 
%     de la señal de tráfico, Ib_circulo. Utiliza para ello la función de matlab imfill:

Ib_circulo = imfill(Ib_circunf,'holes');

% Visualiza el resultado a través de una imagen que muestre los píxeles detectados de la misma 
% forma que aparecen en la imagen de color de entrada (el resto de los píxeles se visualizarán en negro).
figure,imshow(uint8(cat(3,R.*double(Ib_circulo),G.*double(Ib_circulo),B.*double(Ib_circulo)))),title("Visualización de la detección");

% 13. Aplica todos los pasos anteriores, con idéntica configuración, para segmentar las señales de limitación de velocidad presentes 
%     en las imágenes Signal1_2.tif , Signal1_3.tif , Signal1_4.tif , Signal2_1.tif , Signal2_2.tif , Signal3_1.tif y Signal3_2.tif, 
%     facilitadas en la carpeta ImagenesPractica/SegundaParte.
practica_6_parte_2("Signal1_2.tif")
practica_6_parte_2("Signal1_3.tif")
practica_6_parte_2("Signal1_4.tif")
practica_6_parte_2("Signal2_1.tif")
practica_6_parte_2("Signal2_2.tif")
practica_6_parte_2("Signal3_1.tif")
practica_6_parte_2("Signal3_2.tif")

%% Segmentación de señales de obligación (señales circulares de fondo azul):

% 14. Genera y visualiza la imagen binaria que representa la segmentación de la señal de tráfico 
%     presente en las imágenes "Signal4_1.tif y Signal4_2.tif" facilitadas en la carpeta ImagenesPractica/SegundaParte. 
%     Visualiza el resultado a través de una imagen que muestre los píxeles detectados de la misma forma que aparecen 
%     en la imagen de color de entrada (el resto de los píxeles se visualizarán en negro).

practica_6_parte_2_azul("Signal4_1.tif")
practica_6_parte_2_azul("Signal4_2.tif")

