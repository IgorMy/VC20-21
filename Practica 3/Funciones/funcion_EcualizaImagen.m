function Ieq = funcion_EcualizaImagen(I)
    H = funcion_HistAcum(imhist(I));
    [M,N] = size(I);
    Ieq = zeros(size(I));
    for i=0:255
        Ib = I == i;
        g = (256/(M*N)) * H(i+1) - 1;
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