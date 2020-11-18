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

nombreClases{1} = 'Resto';
nombreClases{2} = 'Verde Fresa';

simbolosClases{1} = '.k';
simbolosClases{2} = '.g';

nombresProblema.clases = nombreClases;
nombresProblema.simbolos = simbolosClases;

%% Seleccionar el conjuntos de 3 descriptores que proporcione mayor separabilidad.
[D S] = funcion_selecciona_vector_ccas(X,Y,3);

% Para optimizar
load("Datos/DS.mat");

%% Representacion del espacio
Cadena = "[";
for j=1:3
    Cadena = Cadena + " " + nombresProblema.descriptores{D(j)}; 
end
Cadena = Cadena + " ] - Separabilidad: " + S;

funcion_representa_datos(X,Y,D,nombresProblema,Cadena);

%% Guardamos los datos

save('./Datos/MuestrasColoresVerde.mat','X','Y','D','S', 'nombresProblema');