function IAM=expansion_histograma(I,qmin,qmax,pmin,pmax)
    
    % Imagen de salida
    IAM = zeros(size(I));
    
    % Recorremos los valores de gris de la imagen modificandolos
    for i=pmin:pmax
        Ib = I==i;
        IAM(Ib) = qmin + ( (qmax - qmin) / (pmax-pmin) * ( i - pmin ) );
    end
    
    % Convertimos la imagen en uint8
    IAM = uint8(IAM);
end