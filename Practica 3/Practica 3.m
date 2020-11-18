%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Addicción de carpetas
addpath('Imágenes','Funciones');

%% 1. Primera parte

% 1. Utilizando como entrada la imagen P3.tif facilitada, obtener distintas
% imágenes de salida resultados de la aplicación de las siguientes 
% transformaciones locales de manipulación de contraste:
%  - Amplitud de Contraste.
%  - Funciones Cuadrada y Cúbica.
%  - Funciones Raíz Cuadrada y Raíz Cúbica.
%  - Funciones Sigmoide (con α = 0.85 ).

% 2. Para cada una de las imágenes generadas, medir el brillo y contraste y visualizar su histograma.

% 3. Realizar un breve informe de conclusiones.

%------------------------------------------------------------------------------------

% Carga de la imagen
I = imread('P3.tif');

% Visualizamos el histograma y vemos la zona que queremos ampliar
imhist(I);
rango = [0,85];
extension = [0,250];

% Obtenemos la primera imagen (Amplitud de Contraste)
IAC = funcion_amplitud_contraste(I,rango,extension); 

% Obtenemos la segunda imagen (Cuadratica)
I2 = funcion_h_cuadratica(I);

% Obtenemos la tercera imagen (Cubica)
I3 = funcion_h_cubica(I);

% Obtenemos la cuarta imagen (Sigmoide - VI)
IS_VI = funcion_sigmoide(I,0.85,1);

% Obtenemos la cuarta imagen (Sigmoide - VE)
IS_VE = funcion_sigmoide(I,0.85,2);



% Calculo de los brillos y contrastes
IB = funcion_calcula_brillo_histograma(I);
IC = funcion_calcula_contraste_histograma(I);

IAC_B = funcion_calcula_brillo_histograma(IAC);
IAC_C = funcion_calcula_contraste_histograma(IAC);

I2_B = funcion_calcula_brillo_histograma(I2);
I2_C = funcion_calcula_contraste_histograma(I2);

I3_B = funcion_calcula_brillo_histograma(I3);
I3_C = funcion_calcula_contraste_histograma(I3);

IS_VI_B = funcion_calcula_brillo_histograma(IS_VI);
IS_VI_C = funcion_calcula_contraste_histograma(IS_VI);

IS_VE_B = funcion_calcula_brillo_histograma(IS_VE);
IS_VE_C = funcion_calcula_contraste_histograma(IS_VE);



% Visualización de las imagenes y sus histogramas
figure, hold on;
subplot(2,6,1),imshow(I),title("Imagen original");
subplot(2,6,2),imshow(IAC),title("Amplitud de Contraste");;
subplot(2,6,3),imshow(I2),title("Funciones Cuadrada");;
subplot(2,6,4),imshow(I3),title("Funciones Cubica");;
subplot(2,6,5),imshow(IS_VI),title("Funciones Sigmoide VI");;
subplot(2,6,6),imshow(IS_VE),title("Funciones Sigmoide VE");;
subplot(2,6,7),imhist(I),title("B: "+IB+"   C:"+IC);
subplot(2,6,8),imhist(IAC),title("B: "+IAC_B+"   C:"+IAC_C);
subplot(2,6,9),imhist(I2),title("B: "+I2_B+"   C:"+I2_C);
subplot(2,6,10),imhist(I3),title("B: "+I3_B+"   C:"+I3_C);
subplot(2,6,11),imhist(IS_VI),title("B: "+IS_VI_B+"   C:"+IS_VI_C);
subplot(2,6,12),imhist(IS_VE),title("B: "+IS_VE_B+"   C:"+IS_VE_C);

% Se observa que la mayoria de los pixeles de la imagen tienen niveles
% bajos de gris. Usando la función de amplitud de contraste, podemos
% extender este rango mejorando el contraste.

% Por otro lado la funcón cuadrada empeora notablemente la imagen al no
% conseguir realzar lo suficiente los valores claros

% En cambio, la función cubica consigue realzar mucho los valores claros
% aumentando significativamente el contraste y el brillo

% Por ultimo, la función sigmoide no consigue realzar el histograma

%% 2. Segunda parte
clear, clc;
I = imread('P3.tif');
IB = funcion_calcula_brillo_histograma(I);
IC = funcion_calcula_contraste_histograma(I);

% 4. Implementar la siguiente función matlab para calcular el histograma acumulado H de una
% imagen a partir de su histograma h: H = funcion_HistAcum (h) .

H = funcion_HistAcum(imhist(I));

figure, hold on
subplot(1,2,1),imhist(I),title("histograma");
subplot(1,2,2),bar(H),title("histograma acumulado");
hold off;

% 5. Implementar la siguiente función matlab para ecualizar de forma uniforme una imagen:
% Ieq = funcion_EcualizaImagen(I), donde I es la imagen de entrada e Ieq la
% imagen de salida ecualizada. Esta función puede implementarse según diferentes
% criterios:
%  - Implementación basada en el recorrido píxel a píxel de la imagen y calcular la función
%    de transformación para cada píxel para generar la imagen de salida.
%  - Realizar el cálculo de la función de transformación para cada nivel de gris posible y,
%    recorriendo la imagen píxel a píxel, aplicarla para generar la imagen de salida.
%  - Realizar el cálculo de la función de transformación para cada nivel de gris posible y,
%    haciendo un barrido en los 256 posibles niveles de gris, aplicarla para generar la
%    imagen de salida.

    Ieq_1 = funcion_EcualizaImagen_1(I);
    Ieq_2 = funcion_EcualizaImagen_2(I);
    Ieq = funcion_EcualizaImagen(I);

    % Comparación
    figure,hold on
    subplot(2,3,1),imshow(Ieq_1),title("Piexel a pixel");
    subplot(2,3,2),imshow(Ieq_2),title("Calculo previo de g");
    subplot(2,3,3),imshow(Ieq),title("Directamente");
    subplot(2,3,4),imhist(Ieq_1);
    subplot(2,3,5),imhist(Ieq_2);
    subplot(2,3,6),imhist(Ieq);
    hold off;
    
    % Datos de la imagen de salida
    IeqB = funcion_calcula_brillo_histograma(Ieq);
    IeqC = funcion_calcula_contraste_histograma(Ieq);
    figure,hold on
    subplot(2,2,1),imshow(I),title("Imagen original");
    subplot(2,2,2),imshow(Ieq),title("Imagen equalizada");
    subplot(2,2,3),imhist(I),title("B: "+IB+"  C: "+IC);
    subplot(2,2,4),imhist(Ieq),title("B: "+IeqB+"  C: "+IeqC);
    hold off
    
% 6. Aplicar las funciones anteriores para ecualizar la imagen P3.tif y mediante la 
%    instrucción tic … toc medir su tiempo computacional.
tic
    Ieq_1 = funcion_EcualizaImagen_1(I);
T1 = toc;
tic
    Ieq_2 = funcion_EcualizaImagen_2(I);
T2 = toc;
tic
    Ieq = funcion_EcualizaImagen(I);
T3 = toc;
figure,hold on;
    subplot(1,3,1),imshow(Ieq_1),title("Piexel a pixel: "+T1);
    subplot(1,3,2),imshow(Ieq_2),title("Calculo previo de g: "+T2);
    subplot(1,3,3),imshow(Ieq),title("Directamente: "+T3);
hold off;
% 7. Realizar una ecualización uniforme zonal a la imagen P3.tif. Para ello, se ha de 
%    dividir la imagen en 9 subimágenes de las mismas dimensiones y aplicar la función 
%    del apartado anterior a cada una de ellas.

    Ieq9Z = funcion_EcualizaImagen_9Zonas(I);

    % Datos de la imagen de salida
    Ieq9ZB = funcion_calcula_brillo_histograma(Ieq9Z);
    Ieq9ZC = funcion_calcula_contraste_histograma(Ieq9Z);
    figure,hold on
    subplot(2,2,1),imshow(I),title("Imagen original");
    subplot(2,2,2),imshow(Ieq9Z),title("Imagen equalizada");
    subplot(2,2,3),imhist(I),title("B: "+IB+"  C: "+IC);
    subplot(2,2,4),imhist(Ieq9Z),title("B: "+Ieq9ZB+"  C: "+Ieq9ZC);
    hold off

% 8. Implementar la siguiente función matlab para ecualizar de forma local, a nivel de píxel, una imagen:
%    
%    Ieq_local = funcion_EcualizacionLocal(I, NumFilVent, NumColVent, OpcionRelleno),
%    
%    donde I es la imagen de entrada, NumFilVent y NumColVent son el número de filas y 
%    columnas de la ventana de vecindad considerada, e Ieq_local es la imagen de salida 
%    ecualizada. En la implementación de la función considerar que las ventanas de vecindad 
%    tienen un número impar de filas y columnas. Además, el parámetro OpcionRelleno 
%    permitirá aplicar “symmetric”, “replicate” o “zeros” como opciones de relleno a todos 
%    aquellos píxeles que no existen en la imagen, pero puedan incluirse en el entorno de 
%    vecindad de los píxeles del o cercanos al contorno de la imagen.

    NumFilVent = 21;
    NumColVent = 21;
    OpcionRelleno = 'symmetric';
    
    Ieq_local = funcion_EcualizacionLocal(I, NumFilVent, NumColVent, OpcionRelleno);

    % Datos de la imagen de salida
    Ieq_localB = funcion_calcula_brillo_histograma(Ieq_local);
    Ieq_localC = funcion_calcula_contraste_histograma(Ieq_local);
    figure,hold on
    subplot(2,2,1),imshow(I),title("Imagen original");
    subplot(2,2,2),imshow(Ieq_local),title("Equalización local ["+NumFilVent+","+NumColVent+"] "+OpcionRelleno);
    subplot(2,2,3),imhist(I),title("B: "+IB+"  C: "+IC);
    subplot(2,2,4),imhist(Ieq_local),title("B: "+Ieq_localB+"  C: "+Ieq_localC);
    hold off
    
% 9. Aplicar esta función para ecualizar la imagen P3.tif considerando el siguiente tamaño de ventana de vecindad:
%    - NumFilVent = 1/3 del número de filas de la imagen ; NumColVent = 1/3 del número de columnas de la imagen.

    [NF,NC] = size(I);

    NumFilVent =  round(NF/3);
    if mod(NumFilVent,2) == 0
        NumFilVent = NumFilVent + 1;
    end
    
    NumColVent = round(NC/3);
    if mod(NumColVent,2) == 0
        NumColVent = NumColVent + 1;
    end
    
    OpcionRelleno = 'symmetric';
    
    Ieq_local = funcion_EcualizacionLocal(I, NumFilVent, NumColVent, OpcionRelleno);

    % Datos de la imagen de salida
    Ieq_localB = funcion_calcula_brillo_histograma(Ieq_local);
    Ieq_localC = funcion_calcula_contraste_histograma(Ieq_local);
    figure,hold on
    subplot(2,2,1),imshow(I),title("Imagen original");
    subplot(2,2,2),imshow(Ieq_local),title("Equalización local ["+NumFilVent+","+NumColVent+"] "+OpcionRelleno);
    subplot(2,2,3),imhist(I),title("B: "+IB+"  C: "+IC);
    subplot(2,2,4),imhist(Ieq_local),title("B: "+Ieq_localB+"  C: "+Ieq_localC);
    hold off

% 10. Implementar una nueva versión de la función funcion_EcualizacionLocal en la que no se 
%     calcula una ecualización individual y específica para cada píxel. 
%     En esta nueva versión, la ecualización se deberá calcular por ventanas 5x5.

    OpcionRelleno = 'symmetric';
    NumFilVent = 21;
    NumColVent = 21;
    Ieq5 = funcion_EcualizacionLocal55(I, NumFilVent, NumColVent, OpcionRelleno);

    % Datos de la imagen de salida
    IeB = funcion_calcula_brillo_histograma(Ieq5);
    IeC = funcion_calcula_contraste_histograma(Ieq5);
    figure,hold on
    subplot(2,2,1),imshow(I),title("Imagen original");
    subplot(2,2,2),imshow(Ieq5),title("Equalización local 5x5 ["+NumFilVent+","+NumColVent+"] "+OpcionRelleno);
    subplot(2,2,3),imhist(I),title("B: "+IB+"  C: "+IC);
    subplot(2,2,4),imhist(Ieq5),title("B: "+IeB+"  C: "+IeC);
    hold off

% 11. Compara la eficiencia computacional de las dos versiones de la función.
    OpcionRelleno = 'symmetric';
    NumFilVent = 21;
    NumColVent = 21;

tic
    Ieq_local = funcion_EcualizacionLocal(I, NumFilVent, NumColVent, OpcionRelleno);
T1 = toc;

tic
    Ieq5 = funcion_EcualizacionLocal55(I, NumFilVent, NumColVent, OpcionRelleno);
T2 = toc;

    IeB = funcion_calcula_brillo_histograma(Ieq_local);
    IeC = funcion_calcula_contraste_histograma(Ieq_local);
    Ie5B = funcion_calcula_brillo_histograma(Ieq5);
    Ie5C = funcion_calcula_contraste_histograma(Ieq5);

figure, hold on;
subplot(2,2,1),imshow(Ieq_local),title("Pixel a pixel: "+T1);
subplot(2,2,2),imshow(Ieq5),title("5x5: "+T2);
subplot(2,2,3),imhist(Ieq_local),title("B: "+IeB+"  C: "+IeC);
subplot(2,2,4),imhist(Ieq5),title("B: "+Ie5B+"  C: "+Ie5C);
hold off;

% 12. Para cada una de las imágenes generadas en esta segunda parte de la práctica, 
%     medir el brillo y contraste y visualizar su histograma. Realizar un breve informe 
%     de conclusiones.

% Se observa que las imagenes que ofrecen el mejor contraste son las que se
% obtienen a partir de la ecualización de la imagen total y la de 9 zonas.
% Ademas, de los 3 metodos para ecualizar la imagen ,el mas rapido es el
% 2º, calcular previamente g' y aplicarselo a cada pixel.

%Por contrario, el resto de las funciones alteran significativamente el
%brillo de la imagen, pero no llegan a modificar en gran medida el
%contraste. 

% Ademas, cabe destacar, que la ecualización local por bloque 5x5 tarda menos y
% ofrece un mejor contraste frente a la de pixel a pixel.


