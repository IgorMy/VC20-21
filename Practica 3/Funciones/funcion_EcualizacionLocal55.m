function Ieq_local = funcion_EcualizacionLocal55(I, NumFilVent, NumColVent, OpcionRelleno)

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
    [Ma,Na] = size(Iamp);
    
    % Imagen de salida
    Ieq_local = zeros(size(I));

    for i=1:ceil(M/5)
        for j=1:ceil(N/5)
            fini = (i-1)*(5)+1;
            ffin = fini+4+Famp*2;
            if ffin > Ma
                ffin = Ma
            end
            
            cini = (j-1)*(5)+1;
            cfin = cini+4+Camp*2;
            if cfin > Na
                cfin = Na;
            end
            
            Zona = Iamp(fini:ffin,cini:cfin);
            Zeq = funcion_EcualizaImagen(Zona);
            
            ampf = 5;
            ampc = 5;
            
            fini = 5*(i-1)+1;
            ffin = fini+4;
            if ffin > M
                ampf = ampf - (ffin - M);
                ffin = M;
            end
            
            cini = 5*(j-1)+1;
            cfin = cini+4;
            if cfin > N
                ampc = ampc - (cfin - N);
                cfin = N;
            end
            
            Ieq_local(fini:ffin,cini:cfin) = Zeq(Famp+1:Famp+ampf,Camp+1:Camp+ampc);
        end
    end
    Ieq_local = uint8(Ieq_local);
end

function Ieq = funcion_EcualizaImagen(I)
    H = funcion_HistAcum(imhist(I));
    [M,N] = size(I);
    Ieq = zeros(size(I));
    for i=0:255
        Ib = I == i;
        g = (255/(M*N)) * H(i+1) - 1;
        Ieq(Ib) = max(round(g),0);
    end
    Ieq = uint8(Ieq);
end

function H=funcion_HistAcum(h)
    H=zeros(1,256);
    for i=1:256
        H(i) = sum(h(1:i));
    end
end