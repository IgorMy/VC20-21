%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Addicción de carpetas
addpath('Imágenes','Funciones');

%% TERCERA PARTE: Evaluación de eficiencia de filtros gaussiano, mediana y adaptativo.

clear, clc;

% 1. A partir de la imagen "P4.tif", genera tres imágenes con ruido 
%    gaussiano de media nula y desviaciones típicas, por cada imagen 
%    generada, de 5, 10 y 35.
I = imread('P4.tif');

IR = cell(3,1);
Std = [5,10,35];
for i=1:3
    IR{i} = uint8(double(I) + randn(size(I)).*Std(i));
end
clear Std i;


% 2. Filtra cada una de las imágenes ruidosas anteriores con filtros de 
%    tipo gaussiano, de tipo mediana y adaptativo, considerando tamaños 3x3
%    y 7x7 para cada filtro. Visualiza las distintas imágenes ruidosas y 
%    filtradas.

IF = cell(7,5);
Ventanas = [3,7,3,7,3,7];
Std = [5, 5, 10, 10, 35, 35];
for i=1:6
    IF{i+1,1} = "σ: "+int2str(Std(i));
    IF{i+1,2} ="Ventana: "+int2str(Ventanas(i));
end
IF{1,3} = "Filtro gaussiano";
IF{1,4} = "Filtro de la mediana";
IF{1,5} = "Filtro adaptativo";
EfIF = IF;

% Generación de datos
for i=1:6
    for j=1:3
        if j==1 % Filtro gausiano
            ImF = imfilter(IR{ceil(i/2)},funcion_fspecial(Ventanas(i),Ventanas(i)/5));
            IF{i+1,j+2} = ImF;
            ISNR = evalua_eficiencia(I,ImF,IR{ceil(i/2)});
            EfIF{i+1,j+2} = ISNR;
        elseif j ==2 % Filtro de la mediana
            ImF = Funcion_FiltroMediana(IR{ceil(i/2)}, Ventanas(i), Ventanas(i),"zeros");
            IF{i+1,j+2} = ImF;
            ISNR = evalua_eficiencia(I,ImF,IR{ceil(i/2)});
            EfIF{i+1,j+2} = ISNR;
        else % Filtro adaptativo
            ImF = Funcion_FiltAdapt_v2(IR{ceil(i/2)}, Ventanas(i), Ventanas(i), var( double(I(:)) - double(IR{ceil(i/2)}(:)) ));
            IF{i+1,j+2} = ImF;
            ISNR = evalua_eficiencia(I,ImF,IR{ceil(i/2)});
            EfIF{i+1,j+2} = ISNR;
        end
    end
end

% Visualización de las imagenes una a una en la misma ventana visualizando
% el ISNR
for i=1:6
    for j=1:3
        if j==1 % Filtro gausiano
            hold on;
            subplot(1,2,1),imshow(IR{ceil(i/2)}),title("Imagen ruidosa σ:"+Std(i));
            subplot(1,2,2),imshow(IR{ceil(i/2)}),title(IF{1,j+2}+" Ventana: "+Ventanas(i)+" ISNR: " + EfIF{i+1,j+2});
            hold off
            pause;
        elseif j ==2 % Filtro de la mediana
            hold on;
            subplot(1,2,1),imshow(IR{ceil(i/2)}),title("Imagen ruidosa σ:"+Std(i));
            subplot(1,2,2),imshow(IR{ceil(i/2)}),title(IF{1,j+2}+" Ventana: "+Ventanas(i)+" ISNR: "+EfIF{i+1,j+2});
            hold off
            pause;
        else % Filtro adaptativo
            hold on;
            subplot(1,2,1),imshow(IR{ceil(i/2)}),title("Imagen ruidosa σ:"+Std(i));
            subplot(1,2,2),imshow(IR{ceil(i/2)}),title(IF{1,j+2}+" Ventana: "+Ventanas(i)+" ISNR: "+EfIF{i+1,j+2});
            hold off
            pause;
        end
    end
end

EfIF

% Se observa que para imagenes ruidosas con desviaciónes tipicas pequeñas,
% tanto el filtro gaussiano como el filtro de las medianas empeoran la
% imagen. En cambio el filtro adaptativo, aunque por poco, mejora la
% imagen. 

% En cambio, para imagenes ruidosas con desviaciones tipicas altas, el
% filtro gaussiano es el mas optimo


%% Aplicación filtro temporal

clear, clc;
I = imread('P4.tif');

% 5. Genera, a partir de la imagen inicial, 10 imágenes ruidosas con ruido blanco gaussiano y
%    desviación típica 35. Visualiza una de estas imágenes.
IR = cell(10,1);
for i=1:10
    IR{i} = double(I) + randn(size(I))*35;
end

figure,imshow(uint8(IR{1})),title("Imagen ruidosa nº2");

% 6. Aplica un promediado a estas imágenes y observa la imagen resultante.
If = filtro_promediado(IR); 
If = uint8(If);
figure, hold on
subplot(1,3,1),imshow(I),title("Imagen original");
subplot(1,3,2),imshow(uint8(IR{1})),title("Imagen ruidosa nº2");
subplot(1,3,3),imshow(If),title({"Filtro promedio con "+length(IR)+" imagenes","ISNR(frente a la 2º imagen ruidosa): "+evalua_eficiencia(I,If,uint8(IR{1}))});
hold off

