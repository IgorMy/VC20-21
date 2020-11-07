%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load("./Datos/MuestrasColoresRojoRefinadas");

%% Adicción del directorio de funciones e Imagenes
addpath('Funciones','Imagenes');

%% Selección del espacio de caracteristicas a trabajar
ec = 2; % RGB(1), Lab(2), Mejores tres(3), Mejores cuatro(4);

% Descriptores
Cadena = "[";
for j=1:3
    Cadena = Cadena + " " + nombresProblema.descriptores{DesSep{ec,1}(j)}; 
end
Cadena = Cadena+ " ]";

%% Entrenamiento
% Mahalanobis
DM = cell(1,2);
[DM{1}, DM{2}] = Mahalanobis( X(:,DesSep{ec,1}), Y);

% Entrenamiento NN
net = patternnet;
net = configure(net, X(:,DesSep{ec,1})',Y');
% net = newff(X(:,DesSep{ec,1})', Y',5);
net = train(net,X(:,DesSep{ec,1})', Y');

% KNN
k = 5;
DKNN = fitcknn(X(:,DesSep{ec,1}), Y,'NumNeighbors',k);

% SVM
DSVM = fitcsvm(X(:,DesSep{ec,1}), Y);
DSVM = compact(DSVM);

%% Prueba de funcionamiento

% Numero de imagenes
Ni = 2;

Rendimiento_total = cell(Ni);
Rendimiento = zeros(4,7);
for i=1:Ni
    
    % Carga de imagenes
    IG = imread("EvRojo"+num2str(i)+"_Gold.tif");
    I = imread("EvRojo"+num2str(i)+".tif");

    % Reducimos la imagen
    Ir = imresize(I,0.5);

    [N,M,~] = size(I);
    
    % Mahalanobis
    for h=1:4 % h es el umbral
        IbM = clasificador_mahalanobis(DM{1},DM{2},h,Ir,DesSep{ec,1});
        % Re-escalado de la imagen
        IbMR = round(imresize(IbM,[N M],'nearest'));
        % Visualización del contenido
        VisualizaColores(I,IbMR),title("Clasificador Mahalanobis - " + Cadena + " - umbral: "+DM{1}(1,size(DesSep{ec,1},2)+h));
        pause;
        [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbMR, IG);
        Rendimiento(:,h) = [Sens; Esp; Prec; FalsosPositivos];
    end
        
    % NN
    IbNN = clasificador_NN(net,Ir,DesSep{ec,1});
    % Reescalamos las imagenes
    IbNNR = round(imresize(IbNN,[N M],'nearest'));
    % Visualización del contenido
    VisualizaColores(I,IbNNR),title("Clasificador NN - "+Cadena);
    pause;
    % Medida de rendimiento
    [Sens Esp Prec FalsosPositivos] = funcion_metricas(IbNNR, IG);
    h = h + 1;
    [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbNNR, IG);
    Rendimiento(:,h) = [Sens; Esp; Prec; FalsosPositivos];
        
    % knn
    IbKNN = clasificador_KNN_SVM(DKNN,Ir,DesSep{ec,1});
    % Reescalamos las imagenes
    IbKNNR = round(imresize(IbKNN,[N M],'nearest'));
    % Visualización del contenido
    VisualizaColores(I,IbKNNR),title("Clasificador KNN - "+Cadena);
    pause;
    % Medida de rendimiento
    h = h + 1;
    [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbKNNR, IG);
    Rendimiento(:,h) = [Sens; Esp; Prec; FalsosPositivos];
        
    % SVM
    IbSVM = clasificador_KNN_SVM(DSVM,Ir,DesSep{ec,1});
    % Reescalamos las imagenes
    IbSVMR = round(imresize(IbSVM,[N M],'nearest'));
    % Visualización del contenido
    VisualizaColores(I,IbSVMR),title("Clasificador SVM - "+Cadena);
    pause
    % Medida de rendimiento
    h = h + 1;
    [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbSVMR, IG);
    Rendimiento(:,h) = [Sens; Esp; Prec; FalsosPositivos];
    Rendimiento_total{i} = Rendimiento;
end

% Cerramos todas las ventanas
close all;

% Rendimiento en la primera imagen
Rendimiento_total{1}

% Rendimiento en la segunda imagen
Rendimiento_total{2}

% Media
(Rendimiento_total{1} + Rendimiento_total{2})./2 % Se observa que el mejor clasificador es el SVM