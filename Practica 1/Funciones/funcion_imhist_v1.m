function h = funcion_imhist_v1(I)

    h=double(zeros(256,1));
    [nfilas,nColumnas] = size(I);
    for i=1:nfilas
        for j=1:nColumnas
            h(double(I(i,j))+1) = h(double(I(i,j))+1) + 1;
        end
    end

end