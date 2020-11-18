function Ieq = funcion_EcualizaImagen_1(I)
    H = funcion_HistAcum(imhist(I));
    [M,N] = size(I);
    Ieq = zeros(size(I));
    
    for i=1:M
    
        for j=1:N
        
            Ieq(i,j) = max(round( (256/(M*N)) * H(I(i,j)+1) - 1),0);
        
        end
    
    end
    Ieq = uint8(Ieq);
end

function H=funcion_HistAcum(h)
    H=zeros(1,256);
    for i=1:256
        H(i) = sum(h(1:i));
    end
end