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

nombreClases{1} = 'Resto';
nombreClases{2} = 'Rojo Fresa';

simbolosClases{1} = '.k';
simbolosClases{2} = '.r';

nombresProblema.clases = nombreClases;
nombresProblema.simbolos = simbolosClases;

%% Representación de datos
% RGB
funcion_representa_datos(X,Y,[1 2 3],nombresProblema,"RGB");

% HS
funcion_representa_datos(X,Y,[4 5],nombresProblema,"HS");

% UV
funcion_representa_datos(X,Y,[8 9],nombresProblema,"UV");

% ab
funcion_representa_datos(X,Y,[11 12],nombresProblema,"ab");

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

% Representación de 3 dimensiones
    Cadena = "[";
    for j=1:3
        Cadena = Cadena + " " + nombresProblema.descriptores{DSCal{1,1}(j)}; 
    end
    Cadena = Cadena + " ] - Separabilidad: " + DSCal{1,2};
    funcion_representa_datos(X,Y,DSCal{1,1},nombresProblema,Cadena);

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
DesSep(4,1) = {DSCal{2,1}}; % Escogemos el espacio de 4 descriptores
DesSep(4,2) = {DSCal{2,2}};

%% Guardamos los datos

save('./Datos/MuestrasColoresRojo.mat','X','Y','DesSep', 'nombresProblema')