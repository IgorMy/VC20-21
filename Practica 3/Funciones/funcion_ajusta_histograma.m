function Ih = funcion_ajusta_histograma(I,C)
    
    % Canales de color de la imagen
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    
    % Region de interes de la imagen original
    RoIo = (R + G + B) >= 150;
    
    
    % Canales de color de C
    RC = C(:,:,1);
    GC = C(:,:,2);
    BC = C(:,:,3);
    
    % Region de interes de la imagen original
    RoIC = (RC + GC + BC) >= 150;
    
    
    % Para cada uno de los canales obtenemos T
    [~,T1] = histeq(RC(RoIC),imhist(R(RoIo)));
    [~,T2] = histeq(GC(RoIC),imhist(G(RoIo)));
    [~,T3] = histeq(BC(RoIC),imhist(B(RoIo)));
    
    % Desnormalizamos
    T1 = round(T1*255);
    T2 = round(T2*255);
    T3 = round(T3*255);
    
    % Salida
    Rs = RC;
    Gs = GC;
    Bs = BC;
    
    % Transformación de grises
    for i=0:255
        Ib1 = RC == i;
        Ib2 = GC == i;
        Ib3 = BC == i;
        if(i + i + i) > 150
            Rs(Ib1) = T1(i+1);
            Gs(Ib2) = T2(i+1);
            Bs(Ib3) = T3(i+1);
        end
    end
    
    Ih = uint8(cat(3,Rs,Gs,Bs));
end