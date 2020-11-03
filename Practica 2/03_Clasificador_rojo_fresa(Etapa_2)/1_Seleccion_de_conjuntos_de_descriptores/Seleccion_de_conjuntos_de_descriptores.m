%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load("Datos/MuestrasColores.mat");

%% Adicción de carpeta de funciones
addpath("Funciones");

%% Recodificación
Ib = Y == 255;
Y(Ib) = 1;
Ib = Ib == 0;
Y(Ib) = 0;

%% Cuantificacón de la separabilidad de los espacio RGB, HSI, YUV, Lab mediante CSM

separabilidad = [];

for i=1:4
    if i == 1
        h = 1;
    else
        h=(i-1)*3;
    end  
    separabilidad =[separabilidad; indiceJ(X(:,h:i*3)',Y')];
end

disp("    RGB       HSI       YUV       Lab");
disp(separabilidad');

% Observamos que la separabilidad en general no es muy buena

%% Seleccionar los conjuntos de 3, 4, 5 y 6 descriptores que proporcionan mayor separabilidad.
DSCal = cell(4,2);
for i=3:6
    [D S] = funcion_selecciona_vector_ccas(X,Y,i);
    DSCal(i-2,1) = {D};
    DSCal(i-2,2) = {S};
end

%% Este paso terminará con la siguiente selección de vectores 
% característica que se utilizarán en la siguiente etapa de clasificación:
% - R G B
% - L a b
% - Mejor combinación de 3 descriptores.
% - La combinación que se considere más adecuada de más descriptores 
%   (4, 5 o 6) atendiendo a los datos de separabilidad.

DesSep = cell(4,2);
DesSep(1,1) = {[1 2 3]};
DesSep(1,2) = {separabilidad(1)};
DesSep(2,1) = {[10 11 12]};
DesSep(2,2) = {separabilidad(4)};
DesSep(3,1) = {DSCal{1,1}};
DesSep(3,2) = {DSCal{1,2}};
DesSep(4,1) = {DSCal{2,1}}; % Escogemos una selección de 4 descriptores porque no varia mucho respecto a 5 o 6
DesSep(4,2) = {DSCal{2,2}};

%% Guardamos los datos

save('./Datos/MuestrasColoresRojo.mat','X','Y','DesSep', 'nombresProblema')