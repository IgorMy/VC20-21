%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load("Datos/MuestrasColores.mat");

%% Adicción de carpeta de funciones
addpath("Funciones");

%% Recodificación
Ib = Y == 128;
Y(Ib) = 1;
Ib = Ib == 0;
Y(Ib) = 0;


%% Seleccionar el conjuntos de 3 descriptores que proporcione mayor separabilidad.
[D S] = funcion_selecciona_vector_ccas(X,Y,3);

%% Guardamos los datos

save('./Datos/MuestrasColoresVerde.mat','X','Y','D','S', 'nombresProblema');