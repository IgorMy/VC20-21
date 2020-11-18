function C = funcion_calcula_contraste_histograma(I)
    [M,N] = size(I);
    h = imhist(I);
    B = mean2(I);
    C = 0;
    for i=1:256
        C = C + ((( (i-1)-B )^2)*h(i));
    end
    C = sqrt(C/(M*N));
end