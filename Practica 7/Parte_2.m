%% Limpieza inicial
restoredefaultpath,clear, clc, close all;

%% Adicción de carpetas
addpath('Funciones');

%% SEGUNDA PARTE: Ilustración de la correlación normalizada como descriptor de similitud.

% 6. Localiza y visualiza el punto de las imágenes disponibles en 
%    ImagenesPractica/SegundaParte que tiene la mayor semejanza con cada 
%    una de las plantillas facilitadas en la carpeta ImagenesPractica/SegundaParte/Plantillas. 
%    Las plantillas han sido extraídas de la imagen *_Plantillas.tif. 
%    Para ello, aplica la correlación normalizada sobre las imágenes de 
%    intensidad correspondientes a la imagen y las plantillas. Utilizando 
%    la función de matlab line, muestra la región que mejor se ajusta con 
%    la plantilla (template matching) sobre la imagen original. 
%    ¿Qué conclusiones sacas?

Plantilla = "AlejandroB.tif";
Plantilla = "AlejandroH.tif";
Plantilla = "Carlos.tif";
Plantilla = "Cesar.tif";
Plantilla = "Daniel.tif";
Plantilla = "Fran.tif";
Plantilla = "Ihar.tif";
Plantilla = "Ivan.tif";
Plantilla = "Jesus.tif";
Plantilla = "Jose.tif";
Plantilla = "Manuel.tif";
Plantilla = "Victor.tif";

I = imread("Imagenes/SegundaParte/2.bmp");
T = imread("Imagenes/SegundaParte/plantillas/"+Plantilla);
%figure;
%subplot(1,2,1),imshow(I),title("Imagen ("+num2str(size(I))+") px");
%subplot(1,2,2),imshow(T),title("Plantilla ("+num2str(size(T))+") px");
[NI,MI,~]=size(I);
[NT,MT,~]=size(T);
ncc = normxcorr2(rgb2gray(T),rgb2gray(I));  
[Nncc,Mncc]=size(ncc);
ncc=ncc(1+floor(NT/2):Nncc-floor(NT/2),1+floor(MT/2):Mncc-floor(MT/2));

[f,c] = find(ncc == max(ncc(:)));
figure;
imshow(I)
ext_f = (size(T,1)-1)/2 + 0.5;
ext_c = (size(T,2)-1)/2 + 0.5;
line([c-ext_c c+ext_c c+ext_c c-ext_c c-ext_c],[f-ext_f f-ext_f f+ext_f f+ext_f f-ext_f],'color','r');

% Se observa que la tecninca es muy especifica, por lo que si ocurren
% cambios en la imagen como por ejemplo, el cambio de la dirección de la
% cara, el sistema falla.
% No es un sistema optimo para reconocimiento de caras.