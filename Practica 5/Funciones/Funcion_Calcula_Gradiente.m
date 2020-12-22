function [Gx, Gy, ModG] = Funcion_Calcula_Gradiente (I, Hx, Hy)
    I = double(I);
    Gx = imfilter(I,Hx);
    Gy = imfilter(I,Hy);
    ModG = (Gx.^2 + Gy.^2).^(1/2);
end