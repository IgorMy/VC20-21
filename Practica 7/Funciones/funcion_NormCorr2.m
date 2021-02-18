function NormCrossCorr = funcion_NormCorr2(I, T)

    NormCrossCorr = zeros(size(I));

    [filas_mascara, columnas_mascara] = size(T);
    
    filas_extra = (filas_mascara-1)/2;
    columnas_extra = (columnas_mascara-1)/2;
    
    for f=filas_extra+1:size(I,1)-filas_extra
        for c=columnas_extra+1:size(I,2)-columnas_extra
            
            Iroi = I(f-filas_extra:f+filas_extra,c-columnas_extra:c+columnas_extra);
            NormCrossCorr(f,c) = Funcion_CorrelacionEntreMatrices (double(Iroi), double(T));
            
        end
    end
end

function ValorCorrelacion = Funcion_CorrelacionEntreMatrices (Matriz1, Matriz2)

    M1 = mean(Matriz1(:));
    M2 = mean(Matriz2(:));

    Matriz1menosMedia = Matriz1-M1;
    Matriz2menosMedia = Matriz2-M2;
    
    
    Matriz_numerador = Matriz1menosMedia.*Matriz2menosMedia;
    numerador = sum(sum(Matriz_numerador));
    
    Matriz1c = Matriz1menosMedia.^2;
    Matriz2c = Matriz2menosMedia.^2;
    
    denominador = sqrt( sum(sum(Matriz1c)) * sum(sum(Matriz2c)) );
    
    ValorCorrelacion = numerador/denominador;
end