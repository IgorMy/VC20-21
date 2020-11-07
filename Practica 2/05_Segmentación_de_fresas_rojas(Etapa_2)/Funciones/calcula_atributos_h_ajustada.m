function [VC VCN]=calcula_atributos_h_ajustada(I)

    % Imagen en double
    Id = double(I);
    
    % Imagen en double normalizada
    Idn = mat2gray(Id,[0 255]);
    
    % Obtencion de la Imagen en HSV normalizada 
    HSV = rgb2hsv(I); 
    
    % Obtención de la Imagen en Lab
    Lab = rgb2lab(I);
    
    % Obtención de las componentes sin normalizar
    R = Id(:,:,1); 
    G = Id(:,:,2);
    B = Id(:,:,3);
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    I_HSI = (R + G +B)./3;
    Y = 0.299*Idn(:,:,1) + 0.587*Idn(:,:,2) + 0.114*Idn(:,:,3);
    U = 0.492*(Idn(:,:,3)- Y);
    V = 0.877*(Idn(:,:,1) - Y);
    L = Lab(:,:,1);
    a = Lab(:,:,2);
    b = Lab(:,:,3);
    
    % Obtención de las componentes normalizadas
    Rn = Idn(:,:,1); 
    Gn = Idn(:,:,2);
    Bn = Idn(:,:,3);
    Hn = HSV(:,:,1);
    Sn = HSV(:,:,2);
    In = (Rn + Gn + Bn)./3;
    Yn = Y;
    Un = mat2gray(U, [-0.436 0.436]);
    Vn = mat2gray(V, [-0.615 0.615]);
    Ln = mat2gray(L,[0 100]);
    an = mat2gray(a,[-128 127]);
    bn = mat2gray(b,[-128 127]);
    
    % Corregimos H
    for i=1:size(H,1)
        for j=1:size(H,2)
            if H(i,j) <= 0.5
                H(i,j) = 1 - 2 * H(i,j);
            else
               H(i,j) = 2 * (H(i,j) - 0.5);
            end
            Hn(i,j) = H(i,j);
        end
    end
    VC = {R,G,B,H,S,I_HSI,Y,U,V,L,a,b};
    VCN = {Rn,Gn,Bn,Hn,Sn,In,Yn,Un,Vn,Ln,an,bn};
end