function Ieq = funcion_EcualizaImagen_2(I)
    [M,N] = size(I);
    H = funcion_HistAcum(imhist(I));
    g = double(zeros(1,256));
    for i=1:256
       g(i) = (256/(M*N)) * H(i) - 1;
    end
    Ieq = zeros(size(I));
    
    for i=1:M
        for j=1:N
        
            Ieq(i,j) = max(round(g(I(i,j)+1)),0);
        
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