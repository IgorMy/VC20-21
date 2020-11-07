 %% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load("./Datos/MuestrasColoresVerde");
 
%% Adicción del directorio de funciones e Imagenes
addpath('Funciones','Imagenes');

%% Enttrenamiento kNN 

%KNN
k = 5;
DKNN = fitcknn(X(:,D), Y,'NumNeighbors',k);

%% Prueba de funcionamiento

% Numero de imagenes
Ni = 2;

Rendimiento = cell(1,2);
for i=1:Ni
    
    % Carga de imagenes
    IG = imread("EvRojo"+num2str(i)+"_Gold.tif");
    I = imread("EvRojo"+num2str(i)+".tif");

    % Reducimos la imagen
    Ir = imresize(I,0.5);

    [N,M,~] = size(I);

    % Aplicamos la tecnica de clasificación
    IbKNN = clasificador_KNN_SVM(DKNN,Ir,D);
    % Reescalamos las imagenes
    IbKNNR = round(imresize(IbKNN,[N M],'nearest'));
    % Visualización del contenido
    VisualizaColores(I,IbKNNR),title("Clasificador KNN - " + Cadena);
    pause;
    % Medida de rendimiento
    [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbKNNR, IG);
    Rendimiento{1,i} = [Sens; Esp; Prec; FalsosPositivos];
end

% Rendimiento en la primera imagen
Rendimiento{1}

% Rendimiento en la segunda imagen
Rendimiento{2}

% Media
(Rendimiento{1} + Rendimiento{2})./2
