%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Carga de datos
load("./Datos/MuestrasColoresRojoRefinadas");

%% Adicción del directorio de funciones e Imagenes
addpath('Funciones','Imagenes');

%% Entrenamiento Mahalanobis

DM = cell(4,2); % 1º columna {Centro, u1,u2,u3,u4} , 2º columna {Matriz covarianzas}

for i=1:size(DesSep,1)
    [DM{i,1}, DM{i,2}] = Mahalanobis( X(:,DesSep{i,1}), Y);
end

%% Entrenamiento NN

DRN = cell(4,1);

for i=1:size(DesSep,1)
    DRN{i} = newff(X(:,DesSep{i,1})', Y',5);
    DRN{i} = train(DRN{i},X(:,DesSep{i,1})', Y');
end
close all;

%% Enttrenamiento kNN y SVM

%KNN
k = 5;
DKNN = cell(4,1);
for i=1:size(DesSep,1)
    DKNN{i} = fitcknn(X(:,DesSep{i,1}), Y,'NumNeighbors',k);
end

% SVM
DSVM = cell(4,1);
for i=1:size(DesSep,1)
    DSVM{i} = fitcsvm(X(:,DesSep{i,1}), Y);
    DSVM{i} = compact(DSVM{i});
end

%% Prueba de funcionamiento

% Numero de imagenes
Ni = 2;

Rendimiento = cell(2,4);
for i=1:Ni
    
    % Carga de imagenes
    IG = imread("EvRojo"+num2str(i)+"_Gold.tif");
    I = imread("EvRojo"+num2str(i)+".tif");

    % Reducimos la imagen
    Ir = imresize(I,0.5);

    [N,M,~] = size(I);

    % Aplicamos tecnicas de clasificación
    
    % Espacio CCAS
    for j=1:size(DesSep,1)
        R_t = zeros(4,7);
        % Mahalanobis
        for h=1:4
            IbM = clasificador_mahalanobis(DM{j,1},DM{j,2},h,Ir,DesSep{j,1});
            % Re-escalado de la imagen
            IbMR = round(imresize(IbM,[N M],'nearest'));
            % Visualización del contenido
            VisualizaColores(I,IbMR),title("Clasificador Mahalanobis");
            pause;
            [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbMR, IG);
            R_t(:,h) = [Sens; Esp; Prec; FalsosPositivos];
        end
        
        % NN
        IbNN = clasificador_NN(DRN{j},Ir,DesSep{j,1});
        % Reescalamos las imagenes
        IbNNR = round(imresize(IbNN,[N M],'nearest'));
        % Visualización del contenido
        VisualizaColores(I,IbNNR),title("Clasificador NN");
        pause;
        % Medida de rendimiento
        [Sens Esp Prec FalsosPositivos] = funcion_metricas(IbNNR, IG);
        h = h + 1;
        [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbNNR, IG);
        R_t(:,h) = [Sens; Esp; Prec; FalsosPositivos];
        % knn
        IbKNN = clasificador_KNN_SVM(DKNN{j},Ir,DesSep{j,1});
        % Reescalamos las imagenes
        IbKNNR = round(imresize(IbKNN,[N M],'nearest'));
        % Visualización del contenido
        VisualizaColores(I,IbKNNR),title("Clasificador KNN");
        pause;
        % Medida de rendimiento
        h = h + 1;
        [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbKNNR, IG);
        R_t(:,h) = [Sens; Esp; Prec; FalsosPositivos];
        
        % SVM
        IbSVM = clasificador_KNN_SVM(DSVM{j},Ir,DesSep{j,1});
        % Reescalamos las imagenes
        IbSVMR = round(imresize(IbSVM,[N M],'nearest'));
        % Visualización del contenido
        VisualizaColores(I,IbSVMR),title("Clasificador SVM");
        pause
        % Medida de rendimiento
        h = h + 1;
        [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbSVMR, IG);
        R_t(:,h) = [Sens; Esp; Prec; FalsosPositivos];
        Rendimiento{i,j} = R_t;
    end
end

% Para cerrar todas las ventanas
close all;

% Visualizamos la salida media
Rs = zeros(4,7);
for i=1:2
    for j=1:4
        Rs =Rs + Rendimiento{i,j}; 
    end
end
Rs = Rs./8;
Rs
% Se observan mejores resultado en general en Mahalanobis con el 2º umbral
% (Distancia Mahalanobis seleccionada para excluir el 3% de los puntos rojo
%  fresa más alejado del centroide de la nube de puntos. )
