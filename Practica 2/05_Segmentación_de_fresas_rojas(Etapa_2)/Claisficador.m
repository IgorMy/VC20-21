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

%% Enttrenamiento Verde fresa

% Mahalanobis
DMV = cell(1,2);
[DMV{1}, DMV{2}] = Mahalanobis( Xv(:,D), Yv);

% Entrenamiento NN
netV = patternnet;
netV = configure(netV, Xv(:,D)',Yv');
% net = newff(X(:,DesSep{ec,1})', Y',5);
netV = train(netV,Xv(:,D)', Yv');

% KNN
k = 5;
DKNNV = fitcknn(Xv(:,D), Yv,'NumNeighbors',k);

% SVM
DSVMV = fitcsvm(Xv(:,D), Yv);
DSVMV = compact(DSVMV);

%% Entrenamiento rojo fresa

ec = 1; % RGB(1), Lab(2), Mejores tres(3), Mejores cuatro(4);

% Mahalanobis
DMR = cell(1,2);
[DMR{1}, DMR{2}] = Mahalanobis( X(:,DesSep{ec,1}), Y);

% Entrenamiento NN
netR = patternnet;
netR = configure(netR, X(:,DesSep{ec,1})',Y');
% net = newff(X(:,DesSep{ec,1})', Y',5);
netR = train(netR,X(:,DesSep{ec,1})', Y');

% KNN
k = 5;
DKNNR = fitcknn(X(:,DesSep{ec,1}), Y,'NumNeighbors',k);

% SVM
DSVMR = fitcsvm(X(:,DesSep{ec,1}), Y);
DSVMR = compact(DSVMR);


%% Prueba de funcionamiento

% Numero de imagenes
Ni = 3;

RendimientoUnion = cell(Ni);
RendimientoRojo = cell(Ni);
RendimientoVerde = cell(Ni);
for i=1:Ni
    
    % Carga de imagenes
    IG = imread("SegFresas"+num2str(i)+"_Gold.tif");
    I = imread("SegFresas"+num2str(i)+".tif");

    % Reducimos la imagen
    Ir = imresize(I,0.5);

    % Tamaño de la imagen
    [N,M,~] = size(I);

    %% Clasificador Rojo fresa
    % Mahalanobis
    % umbral = 1;
    % IbR = clasificador_mahalanobis(DMR{1},DMR{2},umbral,Ir,DesSep{ec,1});
    
    % NN
    %IbR = clasificador_NN(netR,Ir,DesSep{ec,1});
    
    % KNN
    IbR = clasificador_KNN_SVM(DKNNR,Ir,DesSep{ec,1});
    
    % SVM
    %IbR = clasificador_KNN_SVM(DSVMR,Ir,DesSep{ec,1});
    
    % Reescalamos las imagenes
    IbRR = round(imresize(IbR,[N M],'nearest'));
    
    %% Clasificador Verde fresa
    % Mahalanobis
    % umbral = 1;
    % IbV = clasificador_mahalanobis(DMV{1},DMV{2},umbral,Ir,D);
    
    % NN
    %IbV = clasificador_NN(netV,Ir,D);
    
    % KNN
    IbV = clasificador_KNN_SVM(DKNNV,Ir,D);
    
    % SVM
    %IbV = clasificador_KNN_SVM(DSVMV,Ir,D);
    
    % Reescalamos las imagenes
    IbVR = round(imresize(IbV,[N M],'nearest'));
    
    %% Visualizamos la imagen
    VisualizaColores2(I,IbRR,IbVR);
    
    %% Segmentación
    % Segmentacion de fresa roja
    Ib = fresas_rojas(IbRR, IbVR,60,60);
    figure,hold on;
    subplot(1,2,1),imshow(IG),title("Original");
    subplot(1,2,2),imshow(Ib),title("Generada");
    hold off;
    
    %Medida de rendimiento
    [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(Ib, IG);
    RendimientoUnion{i} = [Sens; Esp; Prec; FalsosPositivos];
    
    [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbRR, IG);
    RendimientoRojo{i} = [Sens; Esp; Prec; FalsosPositivos];
    
    [Sens, Esp, Prec, FalsosPositivos] = funcion_metricas(IbVR, IG);
    RendimientoVerde{i} = [Sens; Esp; Prec; FalsosPositivos];
    
end

Rendimiento_total = zeros(4,3);
% Calculo de rendimiento
for i=1:Ni
    Rendimiento_total(:,1) = Rendimiento_total(:,1) + RendimientoUnion{i};
    Rendimiento_total(:,2) = Rendimiento_total(:,2) + RendimientoRojo{i};
    Rendimiento_total(:,3) = Rendimiento_total(:,3) + RendimientoVerde{i};
end

Rendimiento_total = Rendimiento_total./Ni;

disp("    Union     Rojo F    Verde F");
disp(Rendimiento_total);
