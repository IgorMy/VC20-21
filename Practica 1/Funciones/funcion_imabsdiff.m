%funcion que hace imabsdiff(A,B)

function c = funcion_imabsdiff(A,B)

    c = uint8(abs(double(A)-double(B)));

end