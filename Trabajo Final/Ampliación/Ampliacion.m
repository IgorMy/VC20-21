clear, clc, close all;
Im = imread("Imagenes/16.JPG");
addpath("Funciones");

%% PRIMERA FASE: Obtención de imagen de trabajo.

% 1.1. Reduce la resolución de ImagenColor para trabajar con una imagen de 120 columnas.
factor_de_reduccion = size(Im,2)/120;
Ir = imresize(Im,1/factor_de_reduccion);

% figure,
% subplot(2,1,1),imshow(Im),title("Imagen original");
% subplot(2,1,2),imshow(Ir),title("Imagen reducida con facotr de reducción: "+num2str(factor_de_reduccion));
% 

% 1.2. Genera la imagen de intensidad I de resolución reducida.
I = rgb2gray(Ir);
% figure,imshow(I),title("Imagen de intensidad de color");
% 1.3. Aplica la siguiente transformación logarítmica para reducir el rango dinámico y homogeneizar
%      los valores de distintas matrículas:

%    Ilog = 100+ 20*log(I+1);

Ilog = 100+ 20*log(double(I+1));
% figure,imshow(uint8(Ilog)),title("Imagen con transformación logarítmica");

%% SEGUNDA FASE: Detección de contornos horizontales de la placa.

% 2.1. Aplica la máscara horizontal de bordes de Prewitt para generar la magnitud de los bordes
%      verticales de Ilog .

mascara = [-1 0 1;-1 0 1; -1 0 1];
Gx = imfilter(Ilog,mascara,'symmetric');
Ibor = mat2gray(abs(Gx));
% figure,imshow(Ibor),title("Bordes de Prewitt");

% 2.2. Aplica un filtro de orden que seleccione el valor del percentil 80 de una vecindad de 3 filas y
%      24 columnas (20% del número total de columnas de la imagen en resolución reducida).

Ifilt = mat2gray(Funcion_filtro_orden_per(Ibor,3,24,80));
% figure,imshow(Ifilt),title("imagen filtrada");


% 2.3. Calcula las proyecciones verticales sobre la matriz resultante del apartado anterior, esto es, 
%      para cada fila, obtener la media de todos los valores de las columnas.
proye_ver = zeros(size(Ifilt,1),1);

for i=1:length(proye_ver)
    vec = Ifilt(i,:);
    proye_ver(i) = mean(vec);
end

% figure,plot(proye_ver),title("proyecciones verticales");

% 2.4. Genera un vector de proyecciones suavizado por media móvil central utilizando una ventana 
%      de amplitud el 10% del número total de filas. Cada valor de este nuevo vector se obtiene 
%      como la media de todos los valores del vector original que abarca la ventana centrada en el 
%      valor en cuestión. Para calcular los valores en los extremos del vector, amplía este utilizando 
%      una opción de relleno tipo “symmetric”.
ventana = round(length(proye_ver)*0.1);
if mod(ventana,2) == 0
    ventana=ventana + 1;
end

arr_amp = padarray(proye_ver,(ventana-1)/2,"symmetric");
Vector_PSuav = zeros(size(proye_ver));
for i=1:length(proye_ver)
    ini = i;
    fin = i+(ventana-1);
    Vector_PSuav(i) = mean(arr_amp(ini:fin));
end

% figure,plot(Vector_PSuav),title("pproyecciones suavizado por media móvil");

% 2.5. Encontrar la posición de las filas correspondientes a los dos máximos lo suficientemente 
%      separados como para que correspondan a distintas zonas de la imagen. Además encontrar la 
%      posición de la fila que presenta el valor mínimo entre estos dos máximos, fmin.

% Para encontrar los dos máximos, utiliza el siguiente algoritmo:
% - Primer máximo fmax1: fila de la imagen o posición del vector en la que se alcanza el 
%   máximo en las proyecciones suavizadas Vector_PSuav.
% - Segundo máximo fmax2: fila de la imagen o posición del vector en la que se alcanza el 
%   máximo del vector generado de acuerdo a la siguiente expresión:
%   [(f - fmax1)^2 * Vector_PSuav(f)]
% donde:
%   + f: distintas posiciones del vector: 1 ≤ f ≤ Número de Filas
%   + Vector_PSuav(f): valor en el vector de las proyecciones suavizadas Vector_PSuav
%     en la posición f.

fmax1 = find(Vector_PSuav == max(Vector_PSuav));

vec = ([1:length(Vector_PSuav)]' - fmax1).^2 .* Vector_PSuav([1:length(Vector_PSuav)]);

[~,fmax2] = max(vec);
if(fmax1>fmax2)
    [~,fmin] = min(Vector_PSuav(fmax2:fmax1));
    fmin = fmin-1+fmax2;
else
    [~,fmin] = min(Vector_PSuav(fmax1:fmax2));
    fmin = fmin-1+fmax1;
end


% 2.6. De los dos máximos encontrados, selecciona aquel asociado a la fila perteneciente a la placa 
%      de la matrícula, de la siguiente forma:
%
% - La fila del máximo de la placa no puede estar en los extremos de la imagen, debe tener un 
%   valor comprendido entre el 10% y 90% del número total de filas de la imagen. 
% - La fila del máximo de la placa tiene que tener un valor alto en el vector de proyecciones 
%   suavizadas Vector_PSuav. 
%   Esta condición hay que implementarla de la siguiente forma: 

%   1.- Si el segundo máximo posicionado en fmax2 no tiene una contribución significativa en 
%       Vector_PSuav, se asume que no está en la placa de la matrícula. Por tanto: seleccionar
%       fmax1:
%
%   Si Vector_PSuav (fmax2) <= 0.6 * Vector_PSuav (fmax1) -> seleccionar fmax1
%   
%   2.- En caso contrario, seleccionar aquel máximo cuya fila presente un perfil horizontal de 
%       I, evaluado en la zona central de la imagen (desde la columna 
%       round(0.25*NumColumnas) hasta la columna round(0.75*NumColumnas)), con el 
%       cociente mayor entre dos valores, máximo y mínimo, de referencia.
%
%       El valor mínimo de referencia se obtendrá como la media del 25% de los valores más 
%       bajos del perfil. El valor máximo será la media del 75% de los valores más altos.
%
%       Es decir, se asume que el perfil de la placa matrícula en I presenta valores altos (zona del 
%       fondo de la placa) y bajos (caracteres) al mismo tiempo.

fcmin = round(0.1*length(Vector_PSuav));
fcmax = round(0.9*length(Vector_PSuav));
% Suponemos que uno de los dos siempre estara en la linea central
    
if(fmax1 < fcmin || fmax1 > fcmax)
    fila_matricula = fmax2;
else
    if (fmax2 < fcmin || fmax2 > fcmax)
        fila_matricula = fmax1;
    else
        if(Vector_PSuav (fmax2) <= 0.6*Vector_PSuav (fmax1))
            fila_matricula = fmax1;
        else
            cini = round(0.25*size(Ifilt,2));
            cfin = round(0.75*size(Ifilt,2));
            PCfmax1 = Ifilt(fmax1,cini:cfin);
            
            or = sort(PCfmax1,'descend');
            nf = round(0.75*length(or));
            
            dividendo = sum(or(1:nf));
            
            or = sort(PCfmax1);
            nf = round(0.25*length(or));
            divisor = sum(or(1:nf));
            
            con1 = dividendo/divisor;
            
            PCfmax2 = Ifilt(fmax2,cini:cfin);
            
            or = sort(PCfmax2,'descend');
            nf = round(0.75*length(or));
            
            dividendo = sum(or(1:nf));
            
            or = sort(PCfmax2);
            nf = round(0.25*length(or));
            divisor = sum(or(1:nf));
            
            con2 = dividendo/divisor;
            
            if(con1 > con2)
                fila_matricula = fmax1;
            else
                fila_matricula = fmax2;
            end
        end
    end
end

% 2.7. Elimina la contribución del máximo descartado del vector de proyecciones suavizadas 
%      Vector_PSuav. Para ello, asigna el valor mínimo del vector Vector_PSuav, a todas 
%      aquellas posiciones que van desde fmin (fila del mínimo entre los máximos, ver apartado 2.5) 
%      hasta el principio o hasta el final del vector, dependiendo de si la fila del máximo descartado 
%      es inferior o superior, respectivamente, a la fila del máximo seleccionado.

%      Las proyecciones resultantes permiten localizar la placa de la matrícula: es la zona donde 
%      existen contribuciones altas en los perfiles.

if fmin < fila_matricula
    Vector_PSuav(1:fmin) = min(Vector_PSuav);
else
    Vector_PSuav(fmin:end) = min(Vector_PSuav);
end

% figure,plot(Vector_PSuav),title("pproyecciones suavizado por media móvil");

% 2.8. Encuentra las filas que delimitan el contorno horizontal de la placa considerando que son la
%      primera y última fila de la imagen que presentan un valor significativo en las proyecciones del 
%      apartado anterior. Este valor significativo o umbral será fijado como el 60% del valor 
%      máximo. Una forma de implementar este concepto es poner a cero todos los valores que 
%      tienen un valor superior al umbral seleccionado y encontrar las posiciones de los máximos 
%      resultantes a la izquierda y derecha del máximo principal.
umbral = Vector_PSuav(max(fila_matricula)) * 0.4;
Copia_Vector_PSuav = Vector_PSuav;
Vb = Vector_PSuav >= umbral;
Copia_Vector_PSuav(Vb) = 0;
[~,fila_min_placa] = max(Copia_Vector_PSuav(1:fila_matricula));
Copia_Vector_PSuav(1:fila_matricula) = 0;
[~,fila_max_placa] = max(Copia_Vector_PSuav);
% Busqueda de los puntos de minimos

% 2.9. Delimita la imagen I (ver apartado 1.2) al rango que abarca las dos filas encontradas
%      fila_min_placa, fila_max_placa. Esta imagen reducida Ired será la que se analice en
%      la tercera fase del algoritmo para delimitar los contornos verticales de la placa.
Ired = I(fila_min_placa:fila_max_placa,:);
Ilogred = Ilog(fila_min_placa:fila_max_placa,:);
% imshow(Ired);

%% TERCERA FASE: Detección de contornos verticales de la placa.

% 3.1. Aplica la máscara horizontal de bordes de Prewitt para generar la magnitud de los bordes 
%      verticales de Ired.

mascara = [-1 0 1;-1 0 1; -1 0 1];
Gx = imfilter(Ilogred,mascara,'replicate');
Ibor = mat2gray(abs(Gx));
%imshow(Ibor)

% 3.2. Aplica una apertura morfológica con vecindad vertical a la matriz generada en el apartado 
%      anterior. De esta forma, se realzan las contribuciones de bordes verticales que se detectan en 
%      placa, tanto en los caracteres que la integran como al comienzo y final de la misma. 
%
%      La vecindad vertical será establecida con número de columnas igual a 1 y número de filas 
%      igual a la mitad del número de filas de la imagen de entrada. 
%
%      Para ello, utiliza la función de Matlab imopen (lo que hace es la aplicación sucesiva de un 
%      Filtro de Mínimos, para reducir ruido con una contribución no vertical externo a la placa, y 
%      Filtro de Máximos, para reestablecer las contribuciones verticales atenuadas por la aplicación 
%      del filtro anterior).
mascara = ones(round(size(Ibor,1)/2),1);
Imor = imopen(Ibor,mascara);
%imshow(mat2gray(Imor));

% 3.3. Calcula las proyecciones horizontales sobre la matriz resultante del apartado anterior, esto es, 
%      para cada columna, obtener la media de todos los valores de las filas.

proye_ver = zeros(size(Imor,2),1);

for i=1:length(proye_ver)
    vec = Imor(:,i);
    proye_ver(i) = mean(vec);
end
% figure,plot(proye_ver),title("proyecciones horizontales");

% 3.4. Genera un vector de proyecciones suavizado por media móvil central utilizando una ventana 
%      de amplitud 3. Cada valor de este nuevo vector se obtiene como la media del valor original en 
%      cuestión, el de la izquierda y el de la derecha (valores que abarca la ventana de amplitud 3 
%      centrada en el valor en cuestión). Para calcular los valores en los extremos del vector, amplía 
%      este utilizando una opción de relleno tipo “symmetric”.

arr_amp = padarray(proye_ver,1,"symmetric");
Vector_PSuav = zeros(size(proye_ver));
for i=1:length(proye_ver)
    ini = i;
    fin = i+2;
    Vector_PSuav(i) = mean(arr_amp(ini:fin));
end

% figure,plot(Vector_PSuav),title("pproyecciones suavizado por media móvil");

% 3.5. Encuentra la posición de las columnas cuya contribución en las proyecciones suavizadas 
%      anteriores es significativa. Se considerarán contribuciones significativas aquellas cuya 
%      contribución tiene un valor superior al valor medio de las constribuciones (valor medio 
%      medido descartando el 10% de los valores más bajos).

ordenada = sort(Vector_PSuav,'ascend');
descartar = round(length(ordenada)*0.1);

umbral = mean(ordenada(descartar:end));

Interes = Vector_PSuav > umbral;

% 3.6. Valida estas columnas para que pertenezcan a la placa de la siguiente forma: 
%       - Determina las proyecciones horizontales de la componente azul de la imagen en color de 
%         resolución reducida, delimitada por las dos filas de la placa de la matrícula, 
%         fila_min_placa, fila_max_placa. - Ordénalas de menor a mayor y selecciona el valor del percentil 20 como valor de 
%         referencia. 
%       - Selecciona, del conjunto de columnas encontradas en el apartado 3.5, aquellas que 
%         presentan una proyección horizontal mayor que este valor. 

%   Este proceso de validación se realiza en la componente azul para asegurar la detección de 
%   la parte azul del logotipo de la Unión Europea. Por el cual, se descartan el 20% de las 
%   columnas con perfiles verticales más oscuros (el comienzo y final de la placa se 
%   caracterizan por tener perfiles verticales claros).

B = Ir(fila_min_placa:fila_max_placa,:,3);
%imshow(B);

proye_ver = mean(double(B))';

ordenada = sort(proye_ver,'ascend');
perc = prctile(ordenada,20);

Ib = proye_ver > perc;
Interes = Interes & Ib;
Picos = Vector_PSuav;
Picos(not(Interes)) = 0;
% plot(Picos);

% 3.7. Encuentra la posición de las columnas que delimitan la placa asumiendo que son la primera y 
%      última columna que satisfacen las condiciones impuestas en los apartados 3.5 y 3.6. Sean 
%      estas columnas columna_min_placa, columna_max_placa.

[~,columnas] = findpeaks(Picos);

columna_min_placa = columnas(1);
columna_max_placa = columnas(end);

Irecfin = Ir(fila_min_placa:fila_max_placa,columna_min_placa:columna_max_placa);
%  imshow(Irecfin);
%  figure,
%  subplot(2,1,1),imshow(Ir),title("Imagen reducida");
%  subplot(2,1,2),imshow(Irecfin),title("Matricula");

%% CUARTA FASE: Segmentación de la placa de la matrícula.

% 4.1. Encuentra una posición de las filas y columnas que delimitan la placa en la resolución original 
%      de la imagen (las obtenidas en las fases anteriores fila_min_placa, fila_max_placa, 
%      columna_min_placa, columna_max_placa, están en resolución reducida).

fila_min = floor(factor_de_reduccion*fila_min_placa);
fila_max = ceil(factor_de_reduccion*fila_max_placa);
col_min = floor(factor_de_reduccion*columna_min_placa);
col_max = ceil(factor_de_reduccion*columna_max_placa);

% figure,
% subplot(2,1,1),imshow(Im),title("Imágene original");
% subplot(2,1,2),imshow(Im(fila_min:fila_max,col_min:col_max,:)),title("Matrícula");

% 4.2. Para facilitar las etapas posteriores de segmentación y reconocimiento de caracteres, reduce 
%      el rango de columnas en una cincuenteava parte del número total de columnas por la izquierda 
%      y por la derecha.

factor_reduccion_2 = round(size(Im,2))/50;

% 4.3. Reduce la imagen en color original ImagenColor al rango de filas y columnas encontrado. 
%      Esta imagen ImagenColorReducida será la que devuelva la función.

Matricula = imresize(Im(fila_min:fila_max,col_min:col_max,:),factor_reduccion_2);
figure,
subplot(2,1,1),imshow(Im),title("Imágen original");
subplot(2,1,2),imshow(Matricula),title("Matricula");
