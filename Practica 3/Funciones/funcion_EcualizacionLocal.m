function Ieq_local = funcion_EcualizacionLocal(I, NumFilVent, NumColVent, OpcionRelleno)

    % Datos de la imagen
    [M,N] = size(I);

    % Calculo para la ampliación
    Famp = (NumFilVent - 1)/2;
    Camp = (NumColVent - 1)/2;

    % Ampliación de la imagen
    Iamp = padarray(I,[Famp Camp],OpcionRelleno);
    [Ma,Na] = size(Iamp);
    
    % Imagen de salida
    Ieq_local = zeros(size(I));
    
    for i=1:M
        for j=1:N
            fini = i;
            ffin = NumFilVent+1*(i-1);
            cini = j;
            cfin = NumColVent+1*(j-1);
            Zona = Iamp(fini:ffin,cini:cfin);
            Zeq = funcion_EcualizaImagen(Zona);
            Ieq_local(i,j) = Zeq(Famp+1,Camp+1);
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