function h = funcion_imhist_v2(I)

    h=double(zeros(256,1));

    for i=0:255
        h(i+1) = sum(sum(I == i));
    end

end