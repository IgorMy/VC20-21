function IS = funcion_sigmoide(I,alpha,tipo)

    % Imagen de salida
    IS = zeros(size(I));

    % Segun el tipo de sigmoide, actualizamos unos u otros niveles de gris
    if tipo == 1
        for i=0:255
            Ib = I == i;
            IS(Ib) = (255/2)*(1 + (1/(sin((alpha*pi)/2))) * sin(alpha*pi*((i/255)-(1/2))));
        end
    else
        for i=0:255
            Ib = I == i;
            IS(Ib) = (255/2)*(1 + (1/(tan((alpha*pi)/2))) * tan(alpha*pi*((i/255)-(1/2))));
        end
    end

    % Convertimos la imagen a uint8
    IS = uint8(IS);
end