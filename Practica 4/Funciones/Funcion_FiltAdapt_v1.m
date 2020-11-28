function Ifiltrada = Funcion_FiltAdapt_v1(I, NumFilVent, NumColVent, VarRuido)
    % Datos de la imagen
    [M,N] = size(I);

    % Calculo para la ampliación
    Famp = (NumFilVent - 1)/2;
    Camp = (NumColVent - 1)/2;

    Iamp = padarray(I,[Famp Camp],'symmetric');
    
    % Imagen de salida
    Ifiltrada = zeros(size(I));
    
    for i=1:M
        for j=1:N
            fini = i;
            ffin = NumFilVent+1*(i-1);
            cini = j;
            cfin = NumColVent+1*(j-1);
            Zona = Iamp(fini:ffin,cini:cfin);
            
            VarLocal = var(double(Zona(:)));
            media = mean(double(Zona(:)));
            
            Ifiltrada(i,j) = double(I(i,j)) - (double(VarRuido)/double(VarLocal)) * (double(I(i,j)) - double(media));
        end
    end
    Ifiltrada = uint8(Ifiltrada);
end