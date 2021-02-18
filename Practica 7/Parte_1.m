%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Adicción de carpetas
addpath('Funciones');

%% PRIMERA PARTE: Implementación de correlación bidimensional normalizada.

% 1. Lee y visualiza las imágenes de intensidad Imagen.tif y Plantilla.tif 
%    (incluidas en la carpeta ImagenesPractica/PrimeraParte). Esta primera 
%    parte de la práctica tiene como objetivo localizar la plantilla 
%    facilitada en la imagen, aplicando para ello la correlación 
%    bidimensional normalizada.

I = imread("Imagenes/PrimeraParte/Imagen.tif");
T = imread("Imagenes/PrimeraParte/Plantilla.tif");
figure;
subplot(1,2,1),imshow(I),title("Imagen ("+num2str(size(I))+") px");
subplot(1,2,2),imshow(T),title("Plantilla ("+num2str(size(T))+") px");

% 2. Implementa una función que mida para cada píxel de la imagen de entrada
%    I la similitud entre los valores de su entorno de vecindad y la 
%    plantilla proporcionada T. El grado de similitud se cuantificará a 
%    través de la correlación cruzada normalizada.
%
%        NormCrossCorr = funcion_NormCorr2(I, T)
%
%    Esta función deberá, para cada píxel (i,j) de la imagen de entrada I:
%
%    2.1. Generar la matriz IROI de valores de su entorno de vecindad. 
%         Este entorno tendrá las mismas dimensiones que la plantilla y 
%         estará centrado en el píxel en cuestión (se asumirá que el número
%         de filas y columnas de T es impar). Por tanto, IROI y T son 
%         matrices de igual dimensión.
%
%    2.2. Calcular la correlación cruzada normalizada entre IROI y T:
%
%         𝐶𝐶𝑁= (Σ𝑥Σy { [𝐼𝑅𝑂𝐼(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝐼𝑅𝑂𝐼)]
%         [𝑇(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝑇)] }𝑦) / (𝑠𝑞𝑟𝑡{ [Σ𝑥Σ[𝐼𝑅𝑂𝐼(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝐼𝑅𝑂𝐼)]2𝑦 ] [Σ𝑥Σ[𝑇(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝑇)]2𝑦 ]})
%
%    2.3. Asignar el valor calculado al pixel correspondiente de la matriz 
%         NormCrossCorr de salida:
%
%         𝑁𝑜𝑟𝑚𝐶𝑟𝑜𝑠𝑠𝐶𝑜𝑟𝑟 (𝑖,𝑗)=𝐶𝐶𝑁
%
%   Observaciones:
%   - El resultado de la correlación normalizada para cada píxel es un valor
%     real entre -1 y 1. Para poder visualizar la matriz de salida NormCrossCorr 
%     hay que transformar linealmente sus valores al intervalo 0-255 (números enteros)
%     o al intervalo 0-1 (números reales), de tal forma que los puntos más claros
%     de la imagen resultado representan las zonas de la imagen donde ha habido
%     mayor semejanza con la plantilla T.
%
%   - La matriz de salida NormCrossCorr debe tener las mismas dimensiones que la 
%     imagen de entrada I.
%
%   - No calcular el valor de la correlación para los píxeles del contorno 
%     de la imagen para los que no se puede establecer un entorno de vecindad
%     IROI completo por no existir valores. En estos puntos, asignar ceros 
%     en la matriz de salida.
%
%   - El valor de la correlación entre la plantilla y la vecindad de cada 
%     punto de la imagen debe calcularse implementando la siguiente función:
%
%   ValorCorrelacion = Funcion_CorrelacionEntreMatrices (Matriz1, Matriz2)
%   
%   𝑉𝑎𝑙𝑜𝑟𝐶𝑜𝑟𝑟𝑒𝑙𝑎𝑐𝑖𝑜𝑛== (Σ𝑥Σy{
%   [𝑀𝑎𝑡𝑟𝑖𝑧1(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝑀𝑎𝑡𝑟𝑖𝑧1)] [𝑀𝑎𝑡𝑟𝑖𝑧2(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝑀𝑎𝑡𝑟𝑖𝑧2)] })/ (𝑠𝑞𝑟𝑡{ [Σ𝑥Σ[𝑀𝑎𝑡𝑟𝑖𝑧1(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝑀𝑎𝑡𝑟𝑖𝑧1)]2𝑦 ] [Σ𝑥Σ[𝑀𝑎𝑡𝑟𝑖𝑧2(𝑥,𝑦)−𝑚𝑒𝑎𝑛(𝑀𝑎𝑡𝑟𝑖𝑧2)]2𝑦 ]})
%
%   Esta función calcula la correlación normalizada entre dos matrices 
%   bidimensionales de igual dimensión (debe asumirse).

NormCrossCorr = funcion_NormCorr2(I, T);

% 3. Aplica la función funcion_NormCorr2 para localizar el punto de la imagen 
%    Imagen.tif que tiene la mayor semejanza con la plantilla dada por Plantilla.tif. 
%    Visualiza este punto sobre la imagen original. Utilizando la función de 
%    matlab line, muestra también la región de la imagen que se corresponde 
%    con la plantilla.
[f,c] = find(NormCrossCorr == max(NormCrossCorr(:)));
figure;
imshow(I)
ext_f = (size(T,1)-1)/2 + 0.5;
ext_c = (size(T,2)-1)/2 + 0.5;
line([f-ext_f f-ext_f f+ext_f f+ext_f f-ext_f],[c-ext_c c+ext_c c+ext_c c-ext_c c-ext_c],'color','r');

% 4. Repetir el apartado anterior utilizando la función de matlab 
%    normxcorr2, aplicada con la siguiente configuración:
%
%    [NI MI]=size(I); % Filas y columnas de la imagen
%    [NT MT]=size(T); % Filas y columnas de la plantilla
%
%    ncc = normxcorr2(T,I); % Normalized cross correlation
%    [Nncc Mncc]=size(ncc);
%     Observar las dimensiones de ncc. Hay que ajustar su tamaño para hacer 
%     coincidir la información de sus puntos con los píxeles de la imagen I
%    ncc=ncc(1+floor(NT/2):Nncc-floor(NT/2),1+floor(MT/2):Mncc-floor(MT/2));

[NI MI]=size(I);
[NT MT]=size(T);
ncc = normxcorr2(T,I);  
[Nncc Mncc]=size(ncc);
ncc=ncc(1+floor(NT/2):Nncc-floor(NT/2),1+floor(MT/2):Mncc-floor(MT/2));

[f,c] = find(ncc == max(ncc(:)));
figure;
imshow(I)
ext_f = (size(T,1)-1)/2 + 0.5;
ext_c = (size(T,2)-1)/2 + 0.5;
line([f-ext_f f-ext_f f+ext_f f+ext_f f-ext_f],[c-ext_c c+ext_c c+ext_c c-ext_c c-ext_c],'color','r');

% 5. Comparar los valores de correlación obtenidos mediante ambas funciones
%    (función implementada funcion_NormCorr2 y función de matlab normxcorr2),
%    considerando únicamente los valores de correlación calculados con un 
%    solapamiento total entre los valores de I y T (ver código de ayuda a 
%    continuación). ¿Cuál es el orden de magnitud de la máxima diferencia 
%    que se produce?

% Antes de comparar, debemos poner Cero los contornos de ncc donde no ha habido solapamiento total.
[NI MI]=size(I); % Filas y columnas de la imagen
[NT MT]=size(T); % Filas y columnas de la plantilla
ncc(1:floor(NT/2),:)=0; ncc(NI-floor(NT/2)+1:NI,:)=0;
ncc(:,1:floor(MT/2))=0; ncc(:,MI-floor(MT/2)+1:MI)=0;

Diferencia_en_valor_absoluto = sum(sum(abs(ncc - NormCrossCorr)))
