function B = funcion_calcula_brillo_histograma(I)

    h = imhist(I);
    B = 0;
    N = 0;
    
    for i=1:256
        B = B + (h(i)*(i-1));
        N = N + h(i);
    end

    B = B/N;
    
end