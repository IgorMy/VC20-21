%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Adicción de carpetas
addpath('Funciones');

%% PRIMERA PARTE: Segmentación de carreteras mediante la aplicación de la 
%                 Transformada de Hough para detectar líneas rectas.

% 1. Lee la imagen P6_1.tif (incluida en la carpeta ImagenesPractica/PrimeraParte) 
%    y genera y visualiza su imagen de intensidad I.

I = rgb2gray(imread("Imagenes/PrimeraParte/P6_1.tif"));
figure,imshow(I),title("Imagen de intensidad de P6_1")


% 2. A partir de I, genera una imagen binaria de bordes Ib. Para ello, 
%    aplica un detector de bordes verticales dado por la máscara 
%    correspondiente de Sobel; considera como umbral el 30% del valor 
%    máximo de la matriz magnitud del vector gradiente obtenida. Utiliza la
%    función implementada en la práctica de detección de bordes 
%    Funcion_Detector_Bordes para generar la magnitud del gradiente. 
%    Describe los distintos pasos metodológicos que se pueden distinguir en
%    el procedimiento de generación de Ib, explicando el significado de las
%    matrices de información involucradas.

Hx = [-1 0 1; -2 0 2; -1 0 1];
Hy = [-1 -2 -1; 0 0 0; 1 2 1];
% Hx y Hy son mascaras de Sobel que usamos para aproximar la primera 
% derivada de la imagen.

[Gx, ~, ~] = Funcion_Calcula_Gradiente (I, Hx, Hy);
% Gx y Gy son imagenes gradiente en el eje x y eje y respectivamente.
% Un vector gradiente muestra las variaciones de intensidad a lo largo de
% un eje.
% ModG es el modulo de la suma de los dos vectores gradiente anteriores.
% Con esto obtenemos los variaciones a lo largo de los ejes x e y
% simultaneamente.

umbral = max(abs(Gx(:)))*0.3;

Ib = abs(Gx) > umbral;
figure,imshow(Ib),title("Detección de borde por mascara de Sobel con umbral del 30% del maximo nivel de gris");

% 3. Aplica a Ib la Transformada de Hough para detectar líneas rectas 
%    utilizando la función de matlab hough de la siguiente forma:
%
     [H,theta,rho] = hough(Ib);
%
%    Utiliza la ayuda de matlab (help hough) para entender el 
%    funcionamiento de la función anterior y contesta:
%    - ¿Qué representan theta y rho?
%       * vector theta representa los angulos, de -90 a 89 debido a que 90 es lo
%         mismo que -90
%       * vector rho representa las distancias
%
%    - ¿Cuál es el significado de los valores almacenados en H?
%       * Cada una de las celdas de H representa una recta del tipo
%         x*cos(theta)+y*sin(theta)= rho. El contenido de cada celda es el numero de
%         puntos por los que pasa esa recta.
%
%    - ¿Cómo es la discretización que se realiza del espacio de parámetros 
%       en esta configuración por defecto?
%       * El angulo se discretiza de -90 a 89 y los puntos por los que
%       pasan las rectas en función del tamaño de la imagen
%
%    - Ayudándote de la función de Matlab find , escribe la ecuación de la 
%      recta que pasa por más puntos en la imagen binaria Ib.
[iRho, iTheta]=find(H == max(H(:)));
disp("x*cosd("+num2str(theta(iTheta))+")+y*sind("+num2str(theta(iTheta))+") = "+num2str(rho(iRho)));

% 4. Encuentra los parámetros representativos de las 5 rectas más votadas. 
%    Para ello aplica la función de matlab houghpeaks con la siguiente 
%    configuración:
    NumRectas = 5; 
    Umbral = ceil(0.3*max(H(:)));
    P = houghpeaks(H,NumRectas,'threshold', Umbral)
%    Utiliza la ayuda de matlab (help houghpeaks) para entender el 
%    funcionamiento de la función anterior y contesta:
%    - ¿Qué información contiene el parámetro de salida P?
%       P almacena las posiciónes de los picos de la transforción de Hought
%
%    - ¿Qué significado tiene la inclusión del parámetro de entrada Umbral 
%       en la función?
%        Establece el valor minimo que se debe considerar para un pico

%    - ¿Qué efecto tiene en los resultados finales fijar Umbral con un 
%       valor ceil(0.5*max(H(:)))?
%       Aumentamos el umbral, pero aun asi, detectamos una de las rectas
%       que no nos interesa
%    NumRectas = 5; 
%    Umbral = ceil(0.5*max(H(:)));
%    P = houghpeaks(H,NumRectas,'threshold', Umbral)

% 5. Muestra los segmentos de puntos de Ib que incluyen las 5 rectas 
%    detectadas. Para ello utiliza el código que se adjunta a continuación:

lines = houghlines(Ib,theta,rho,P,'FillGap',5,'MinLength',7);

figure, imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
    
    % Plot beginnings and ends of lines
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
    
    % Determine the endpoints of the longest line segment
    len = norm(lines(k).point1 - lines(k).point2);
    if ( len > max_len)
        max_len = len;
        xy_long = xy;
    end
end

% highlight the longest line segment
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');

%    Utiliza la ayuda de matlab (help houghlines) para entender el 
%    funcionamiento de la función anterior y contesta:
%
%    - ¿Qué información contiene la variable lines?
%
%       La variable lines contiene cuatro columnas que sirven para
%       representar lineas que siguen a los bordes detectados. Las dos
%       primeras columnas contienen los puntos inicial y final de la linea
%       a representar, en la tercera columna tenemos theta y en la cuarta
%       rho.

%     - ¿Qué significado tienen las opciones elegidas en la llamada de la 
%       función "'FillGap',5,'MinLength',7"?
%
%       'FillGap' — Establece la distancia entre dos segmentos de línea 
%                    asociados con la misma ubicación de transformación
%                    Hough. En este caso 5
%
%       'MinLength' — Establece la longitud mínima de la línea. En este
%       caso 7

% 6. A partir de la información obtenida en los pasos anteriores, realiza 
%    la segmentación de la carretera siguiendo los siguientes pasos:
%
%    - Sobre una imagen binaria inicializada a 1 (inicialmente "blanca") de
%      las mismas dimensiones que la imagen de intensidad original, asigna
%      un valor 0 a todos los píxeles presentes en las rectas detectadas en
%      P. Visualiza la imagen binaria resultante.

Ibb = true(size(I));
for k = 1:size(P,1)
    rho1 = rho(P(k,1));
    theta1 = theta(P(k,2));
    x = 1:size(Ibb,2);
    y = round((rho1 - x .* cosd(theta1) )./ sind(theta1)) + 1;
    for i=1:length(x)
        if y(i) >= 1 & y(i) <=size(Ibb,1)
            Ibb(y(i),x(i)) = false;
        end
    end
end
figure,imshow(Ibb),title("Representación de las rectas")

%    - Aplica un filtro de mínimos 3x3 a la imagen binaria anterior para 
%      unir los puntos de las líneas detectadas y delimitar regiones 
%      candidatas a ser la zona principal de la carretera. Visualiza la 
%      imagen binaria resultante.
Ibb = ordfilt2(Ibb,1,true(3),'symmetric');
figure,imshow(Ibb),title("Representación de las rectas con anchura de 3")

%    - Genera y visualiza la imagen binaria que representa la segmentación
%      de la carretera asumiendo que es la región que contiene al píxel
%      central de la imagen.
[N,~] = size(Ibb);
Det = false(size(I));
for i=1:N
    pos = find(Ibb(i,:)==0);
    if ~isempty(pos)
        Det(i,pos(1):pos(end)) = true;
    end
end

Det = bwlabel(Ibb);

f = round(size(Ibb,1)/2)
c = round(size(Ibb,2)/2)

Det = Det == Det(f,c);

%    - Visualiza el resultado a través de una imagen que muestre únicamente
%      los valores de intensidad de los píxeles detectados (el resto de los
%      píxeles se visualizarán en negro).
figure,imshow(Det),title("Detección");
I(not(Det)) = 0;
figure,imshow(I),title("Detección");


% 7. Aplica todos los pasos anteriores, con idéntica configuración, para 
%    segmentar las imágenes P6_2.tif y P6_3.tif, incluidas en la carpeta 
%    facilitada: ImagenesPractica/PrimeraParte.
practica_6_parte_1("P6_2.tif");
practica_6_parte_1("P6_3.tif");