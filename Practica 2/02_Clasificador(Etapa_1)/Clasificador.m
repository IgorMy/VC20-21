%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load("Datos/MuestrasColores.mat");

%% Adicción del directorio de imágenes y funciones
addpath("Imagenes","Funciones")

%% Calculo de Medias y Desviaciónes tipicas

% Codificación de valores de interés
CC = unique(Y);

% Inicialización de matrices a rellenar
MEAN = [];
STD = [];

for i=1:length(CC)
    R = X(Y==CC(i),:);
    MEAN = [MEAN;CC(i) mean(R)];
    STD = [STD;CC(i) std(R)];
end

%% Aplicación del clasificador

% Numero de imagenes
N = 11;

for i=1:N
    
    % Lectura de la imagen
    I = imread("imagen"+num2str(i,'%02.0f')+".jpeg");

    % Obtención de los colores
    Matriz = double(I)./255;

    % Clasificamos los colores
    Ir = Clasificador_RGB(Matriz,MEAN,STD,2,[2,3,4]); % RGB
    
    % Mostramos el contenido
    VisualizaColores(I,Ir);
    
    pause;
end

