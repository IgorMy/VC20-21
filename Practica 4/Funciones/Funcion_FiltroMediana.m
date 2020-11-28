function Ifiltrada = Funcion_FiltroMediana(I, NumFilVent, NumColVent,OpcionRelleno)

    % Datos de la imagen
    [M,N] = size(I);

    % Calculo para la ampliación
    Famp = (NumFilVent - 1)/2;
    Camp = (NumColVent - 1)/2;

    % Ampliación de la imagen
    if strcmp(OpcionRelleno,'zeros')
        Iamp = zeros(2*Famp+M,2*Camp+N);
        Iamp(Famp+1:M+Famp,Camp+1:N+Camp) = I;
        Iamp = uint8(Iamp);
    else
        Iamp = padarray(I,[Famp Camp],OpcionRelleno);
    end
    
    % Imagen de salida
    Ifiltrada = zeros(size(I));
    
    for i=1:M
        for j=1:N
            fini = i;
            ffin = NumFilVent+1*(i-1);
            cini = j;
            cfin = NumColVent+1*(j-1);
            Zona = Iamp(fini:ffin,cini:cfin);
            mediana = median(Zona(:));
            Ifiltrada(i,j) = mediana;
        end
    end
    Ifiltrada = uint8(Ifiltrada);
end