function Iseg = funcion_umbralizacion_local_media(I, W1, W2, Constante)
    % Conversión de Imagen a Double %
    I = double(I);

    W = W1;
    mascara_medias = 1/(W*W) * ones(W);
    Medias = imfilter(I, mascara_medias, 'symmetric');
    matrizUmbrales = Medias - Constante;
    Iseg = double(I < matrizUmbrales);
    
%     W = W2;
%     Desv = stdfilt(I, ones(W));
% 
%     % 4 Cuadrantes %
%     [N,M] = size(Desv);
% 
%     FC = floor(N/2);
%     CC = floor(M/2);
% 
%     Desv11 = mat2gray(Desv(1:FC, 1:CC));
%     Desv12 = mat2gray(Desv(1:FC, CC+1:M));
%     Desv21 = mat2gray(Desv(FC+1:N, 1:CC));
%     Desv22 = mat2gray(Desv(FC+1:N,CC+1:M));
% 
%     g_otsu11 = graythresh(Desv11);
%     g_otsu12 = graythresh(Desv12);
%     g_otsu21 = graythresh(Desv21);
%     g_otsu22 = graythresh(Desv22);
% 
%     MascaraBinaria = [Desv11>g_otsu11 Desv12>g_otsu12 ; Desv21>g_otsu21 Desv22>g_otsu22];
% 
%     Io = Iseg .* MascaraBinaria;
end