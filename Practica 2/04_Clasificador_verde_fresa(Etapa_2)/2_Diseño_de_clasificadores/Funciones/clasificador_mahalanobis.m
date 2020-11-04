function Ib = clasificador_mahalanobis(DM,mCov,u,Ir,espacioCcas)
    % Obtenemos los atributos de la imagen
    [~,atributos] = calcula_atributos_h_ajustada(Ir);
    
    % Obtenemos el numero de filas y de columnas de la imagen
    [nf, nc, ~ ] = size(Ir);
    
    % Creamos la Ib de salida
    Ib = false(nf,nc);
    centro = DM(1,1:size(espacioCcas,2));
    umbral = DM(1,size(espacioCcas,2)+u);
    
    % Recorremos todos los pixeles de la imagen
    for i=1:nf
        for j=1:nc
            % Generamos el vector fila X
            X = [];
            
            for h=1:size(espacioCcas,2)
                X = [X atributos{espacioCcas(1,h)}(i,j)];
            end
            d = sqrt( ( X-centro)*pinv(mCov) * (X - centro)');
            if d < umbral
                Ib(i,j) = true;
            end
        end
    end
end