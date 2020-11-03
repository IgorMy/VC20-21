function [VC VCN]=calcula_atributos(I)

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
    I = (Id(:,:,1) + Id(:,:,2) + Id(:,:,3))/3;
    Y = 0.299*Id(:,:,1) + 0.587*Id(:,:,2) + 0.114*Id(:,:,3);
    U = 0.492*(Id(:,:,3)- Y);
    V = 0.877*(Id(:,:,1) - Y);
    L = Lab(:,:,1);
    a = Lab(:,:,2);
    b = Lab(:,:,3);
    
    % Obtención de las componentes normalizadas
    Rn = Idn(:,:,1); 
    Gn = Idn(:,:,2);
    Bn = Idn(:,:,3);
    Hn = HSV(:,:,1);
    Sn = HSV(:,:,2);
    In = (Idn(:,:,1) + Idn(:,:,2) + Idn(:,:,3))/3;
    Yn = 0.299*Idn(:,:,1) + 0.587*Idn(:,:,2) + 0.114*Idn(:,:,3);
    Un = 0.492*(Idn(:,:,3)- Y);
    Vn = 0.877*(Idn(:,:,1) - Y);
    Ln = mat2gray(Lab(:,:,1),[0 100]);
    an = mat2gray(Lab(:,:,2),[-128 127]);
    bn = mat2gray(Lab(:,:,3),[-128 127]);
    
    VC = {R,G,B,H,S,I,Y,U,V,L,a,b};
    VCN = {Rn,Gn,Bn,Hn,Sn,In,Yn,Un,Vn,Ln,an,bn};
end