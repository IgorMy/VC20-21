function Is = imfilter(I,mascara)
    
    % Tamaño de la mascara
    [Nm,Mm] = size(mascara);
    
    % Tamaño de la imagen
    [N,M] = size(I);
    
    % Mascara cuadrada
    if Nm ~= Mm 
        if Nm > Mm
            mascara(:,Mm+1:Nm) = 0;
            Mm=Nm;
        else
            mascara(Nm+1:Mm,:) = 0;
            Nm=Mm;
        end
    end
    
    % Ampliación
    amp = (Nm-1)/2;

    % Ampliación de la imagen
    I = double(I);
    Iamp = padarray(I,[amp amp],'replicate');
    
    % Imagen de salida
    Is = double(zeros(N,M));
    
    % Recorremos la matriz
    for i=1+amp:N+amp
        for j=1+amp:M+amp
            Mt = Iamp(i-amp:i+amp,j-amp:j+amp);
            Pixel = sum(sum((Mt.*mascara)./(Nm*Mm)));
            Is(i-amp,j-amp) = Pixel;
        end
    end
    
    % Convertimos a uint8
    Is = uint8(Is);
    
end