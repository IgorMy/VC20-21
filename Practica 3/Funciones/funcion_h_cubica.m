function I2=funcion_h_cubica(I)

    % imagen de salida
    I2 = zeros(size(I));
    
    % recorremos los valores de gris
    for i=0:255
        Ib = I == i;
        I2(Ib) = (i^3)/255;
    end

    % convertimos la imagen a uint8
    I2 = uint8(I2);
    
end