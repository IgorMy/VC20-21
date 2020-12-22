function error = calcula_error_cuadratico_medio(I,IR)
    [M,N] = size(I);
    I = double(I);
    IR = double(IR);
    error = sum((I(:) - IR(:)).^2) / (M * N);
end