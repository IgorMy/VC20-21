 %% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load("./Datos/MuestrasColoresVerde");
Xv = X;
Yv = Y;
Dv = D;
Sv = S;
nombresProblemaV = nombresProblema;
load("./Datos/MuestrasColoresRojoRefinadas");

%% Adicción del directorio de funciones e Imagenes
addpath('Funciones','Imagenes');

%% Enttrenamiento kNN Verde fresa

%KNN
k = 5;
DKNN = fitcknn(Xv(:,D), Yv,'NumNeighbors',k);

%% Entrenamiento rojo fresa (Usaremos SVM porque es la que mejor resultados nos dio)

ec = 1; % RGB(1), Lab(2), Mejores tres(3), Mejores cuatro(4);

% Descriptores
Cadena = "[";
for j=1:3
    Cadena = Cadena + " " + nombresProblema.descriptores{DesSep{ec,1}(j)}; 
end
Cadena = Cadena+ " ]";

% SVM
DSVM = fitcsvm(X(:,DesSep{ec,1}), Y);
DSVM = compact(DSVM);

%% Prueba de funcionamiento

% Numero de imagenes
Ni = 3;

Rendimiento = cell(1,2);
for i=1:Ni
    
    % Carga de imagenes
    IG = imread("SegFresas"+num2str(i)+"_Gold.tif");
    I = imread("SegFresas"+num2str(i)+".tif");

    % Reducimos la imagen
    Ir = imresize(I,0.5);

    [N,M,~] = size(I);

    % Aplicamos la tecnica de clasificación rojo fresa
    IbR = clasificador_KNN_SVM(DSVM,Ir,DesSep{ec,1});
    % Reescalamos las imagenes
    IbRR = round(imresize(IbR,[N M],'nearest'));
    
    % Aplicamos la tecnica de clasificación 
    IbV = clasificador_KNN_SVM(DKNN,Ir,D);
    % Reescalamos las imagenes
    IbVR = round(imresize(IbV,[N M],'nearest'));
    
    % Visualizamos la imagen
    VisualizaColores2(I,IbRR,IbVR);
    pause;
    
    % Segmentacion de fresa roja
    
    
    % Medida de rendimiento
    %[Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbKNNR, IG);
    %Rendimiento{1,i} = [Sens; Esp; Prec; FalsosPositivos];
end
