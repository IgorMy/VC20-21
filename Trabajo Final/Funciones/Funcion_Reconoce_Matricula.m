function Cadena = Funcion_Reconoce_Matricula (Nombre, Numero_Objetos)

    %% SEGUNDA FASE DE DESARROLLO: Reconocimiento de Caracteres.
    
    %% Carga de plantillas
    load('Imágenes/00_Plantillas/Plantillas.mat');

    %% Lectura de la imagen
    I = imread("Imágenes/03_Todas/"+Nombre);

    %% Segmentación de la imagen
    Ietiq = segmentacion(I,Numero_Objetos,99,5);

    %% Caracteres
    Caracteres = '0123456789ABCDFGHKLNRSTXYZ';

    %% Correlación
    Cadena = "";
    Angulos = 6;
    Simbolos = 26;
    B = cell(7,1); % Variable para almacenar bounding box de cada caracter
    for i=1:Numero_Objetos
        Simbolo = Ietiq == i;
        Correlacion = zeros(Simbolos,Angulos);

        measurements = regionprops(Simbolo, 'BoundingBox', 'centroid');
        BB = round(measurements.BoundingBox);
        Simbolo = Simbolo(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3));
        B{i} = measurements;
        for j=1:Simbolos
            for h=1:Angulos
                Matriz2 = eval("Objeto"+num2str(j,'%02.f')+"Angulo"+num2str(h,'%02.f') );
                [Nt,Mt] = size(Matriz2);
                Matriz1 =  imresize(Simbolo,[Nt,Mt]);

                Correlacion(j,h) = Funcion_CorrelacionEntreMatrices (Matriz1, Matriz2);

            end
        end

        [f,~] = find(Correlacion == max(Correlacion(:)));
        Cadena = Cadena + Caracteres(f);
    end

    %% Representación
    figure,imshow(I);
    for k = 1 : Numero_Objetos
      rectangle('Position', B{k}.BoundingBox,'EdgeColor','r')
      hold on;
      plot(B{k}.Centroid(1),B{k}.Centroid(2),'*r');
      hold off;
    end
    title(Cadena);

end