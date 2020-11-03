%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Adicción del directorio de las imágenes y funciones
addpath("Imagenes");
addpath("Funciones");

%% Obtención de los datos
% Número de imágenes
N = 3;

% Variables de salida
CodifValoresColores = [];
ValoresColores = [];
ValoresColoresNormalizados = [];

% Codificación de datos de interes
CC = [32; 64; 128; 255];

% Bucle de obtención de muestras de color
for i=1:N
    
    % Lectura de imagen
    I = imread(["Color"+i+".jpeg"]);
   
    % Lectura de la imagen de muestras
    Im = imread(["Color"+i+"_MuestraColores.tif"]);
    
    % Obtención de las muestras de color
    [VC VCN] = calcula_atributos(I);
    
    % Almacenamiento de los datos de interés
    for j=1:length(CC)
        Ib = Im == CC(j);
        ValoresColores = [ValoresColores; VC{1}(Ib) VC{2}(Ib) VC{3}(Ib) VC{4}(Ib) VC{5}(Ib) VC{6}(Ib) VC{7}(Ib) VC{8}(Ib) VC{9}(Ib) VC{10}(Ib) VC{11}(Ib) VC{12}(Ib)];
        ValoresColoresNormalizados = [ValoresColoresNormalizados; VCN{1}(Ib) VCN{2}(Ib) VCN{3}(Ib) VCN{4}(Ib) VCN{5}(Ib) VCN{6}(Ib) VCN{7}(Ib) VCN{8}(Ib) VCN{9}(Ib) VCN{10}(Ib) VCN{11}(Ib) VCN{12}(Ib)];
        Nfilas = length(VC{1}(Ib));
        CodifValoresColores = [CodifValoresColores;ones(Nfilas,1).*CC(j)];
    end
    
end

%% Características de los datos

nombreDescriptores = { 'R', 'G', 'B', 'H', 'S', 'I', 'Y', 'U', 'V', 'L', 'a', 'b'};

nombreClases{1} = 'Lona';
nombreClases{2} = 'Verde hoja';
nombreClases{3} = 'Verde fresa';
nombreClases{4} = 'Rojo Ffesa';

simbolosClases{1} = '.k';
simbolosClases{2} = '.b';
simbolosClases{3} = '.g';
simbolosClases{4} = '.r';

nombresProblema = [];
nombresProblema.descriptores = nombreDescriptores;
nombresProblema.clases = nombreClases;
nombresProblema.simbolos = simbolosClases;

%% Representación de los datos sin normalizar
% RGB
funcion_representa_datos(ValoresColores,CodifValoresColores,[1 2 3],nombresProblema,"RGB");

% HS
funcion_representa_datos(ValoresColores,CodifValoresColores,[4 5],nombresProblema,"HS");

% UV
funcion_representa_datos(ValoresColores,CodifValoresColores,[8 9],nombresProblema,"UV");

% ab
funcion_representa_datos(ValoresColores,CodifValoresColores,[11 12],nombresProblema,"ab");

% En HS se observa que la componente H, tiene rojo tanto al principio como
% al final, seria muy recomendable desplazarlo.

%% Corrección de la componente H

for i=1:size(ValoresColores,1)
    if ValoresColores(i,4) <= 0.5
        hr = 1 - 2 * ValoresColores(i,4);
        ValoresColores(i,4) = hr;
    else
        hr = 2 * (ValoresColores(i,4)-0.5);
        ValoresColores(i,4) = hr;
    end
end

%% Segunda representación del espacio HS
funcion_representa_datos(ValoresColores,CodifValoresColores,[4 5],nombresProblema,"HS");

%% Conversión de los datos
% Debido a que a continuación solo se usara la variable 
% ValoresColoresNormalizados, Se obviara el almacenamiento de la variable
% ValoresColores y se renombraran las variables para su mejor uso a
% continuación.

X = ValoresColoresNormalizados;
Y = CodifValoresColores;

% Guardamos los datos obtenidos
save('./Datos/MuestrasColores','X','Y','nombresProblema');