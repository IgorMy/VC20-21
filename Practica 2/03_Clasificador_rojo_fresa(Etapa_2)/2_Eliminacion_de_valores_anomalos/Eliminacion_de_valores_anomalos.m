%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load('Datos/MuestrasColoresRojo');

%% Adicción del directorio de funciones
addpath("Funciones");

%% Eliminación de valores anómalos en la clase de interés (ser píxel de color rojo
% fresa): eliminar del conjunto de datos todas las muestras de píxeles rojo fresa cuya
% componente roja sea inferior a 0.95.

Ib = Y == 1;

R_f = X(Ib,:);

Ib = Ib == 0;

Resto = X(Ib,:);

Ib =R_f(:,1) > 0.95;

R_f_fin = R_f(Ib,:);

Y = [ones(size(R_f_fin,1),1);zeros(size(Resto(:,1),1),1)];

X = [R_f_fin;Resto];

% Representación de los tres primeros espacios de ccas
for i=1:3
    Cadena = "[";
    for j=1:3
        Cadena = Cadena + " " + nombresProblema.descriptores{DesSep{i,1}(j)}; 
    end
    Cadena = Cadena + " ] - Separabilidad: " + DesSep{i,2};
    funcion_representa_datos(X,Y,DesSep{i,1},nombresProblema,Cadena);

end

save('./Datos/MuestrasColoresRojoRefinadas.mat','X','Y','DesSep', 'nombresProblema');