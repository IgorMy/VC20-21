function Ietiq = segmentacion(I,N,W1,W2)
    %% Obtención de la imagen de intensidad.
    % En este caso se selecciona el canal rojo porque se desea que se detecte
    % tambien la parte izquierda de la imagen (La marca azul de UE) y eliminar
    % la poasibilidad de que esta se pueda detectar como ruido.
    Ii = I(:,:,1);

    %% Sauavizado de la imagen
    % Al suavizar la imagen se conectan las pequeñas imperfecciones de la
    % letras y se difumina los posibles ruidos conectados a ellas.
    Ii = imfilter(Ii,fspecial('gaussian',5,1));

    %% Generación del fondo de iluminación de la imagen
    W = round(size(Ii,1)/3);
    H = (1/(W*W)*ones(W));
    Fondo = imfilter(double(Ii),H,'symmetric');

    %% Generación de la imagen con la iluminación ajustada
    % Como las zonas de interes son relativamente grandes en comparación con la
    % imágen y no poseen muchos detalles se optra por esta técnica.
    % Se le resta a la imagen de intensidad suavizada su fondo de iluminación.
    % La matriz de salida posee valores negativos, por lo que se le aplica
    % mat2gray para normalizarlos y se multiplica por el valor máximo de
    % iluminación (255). 
    %Obteniendo asi, una imagen con la iluminación corregida.
    diferencia = double(Ii)-Fondo;
    salida = uint8(255*mat2gray(diferencia));

    %% Umbralización global de la imagen
    % Al tener la imagen con la iluminación global corregda, se puede
    % umbralizar globalmente.
    Ib = salida < graythresh(salida)*255;
    
    %% Aplicación del cierre morfológico.
    % Al aplicar esta tecnica dos veces intercambiando la mascara, conseguimos
    % no solo la eliminación de ruidos pequeños. Sino arreglar las
    % imperfecciones residuales en las zonas de interes.
    Ib = ordfilt2(Ib,W2*W2,ones(W2));
    Ib = ordfilt2(Ib,1,ones(W2));

    Ib = ordfilt2(Ib,1,ones(W2));
    Ib = ordfilt2(Ib,W2*W2,ones(W2));

%% Eliminación de objetos que no esten en la linea central
    Ietiq = bwlabel(Ib);
    etiquetas = unique(Ietiq(round(size(Ietiq,1)/2),:));
    for i=0:length(unique(Ietiq))
        if ~ismember(i,etiquetas)
            Ib(Ietiq==i) = 0;
        end
    end
    
    %% Etiquetado de la imagene
    % Se obtienen las N+1 imágenes mas grandes 
    labeledImage = bwareafilt(Ib,N+1);
    Ietiq = bwlabel(labeledImage);
    for i=1:N+1
        Ietiq(Ietiq==i) = i-1;
    end
    
end