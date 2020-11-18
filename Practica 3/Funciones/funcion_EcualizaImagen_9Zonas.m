function Ieq = funcion_EcualizaImagen_9Zonas(I)
    [M,N] = size(I);
    TamZona = [round(M/3), round(N/3)];
    Ieq = zeros(size(I));
    for i=1:3
        for j=1:3
            fini = TamZona(1)*(i-1) + 1;
            ffin = TamZona(1)*i;
            cini = TamZona(2)*(j-1) + 1;
            cfin = TamZona(2)*j;
            Zona = I( fini:ffin,cini:cfin );
            
            Zeq = funcion_EcualizaImagen(Zona);
            
            Ieq(fini:ffin,cini:cfin) = Zeq;
            
        end
    end
    
    Ieq = uint8(Ieq);
    
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