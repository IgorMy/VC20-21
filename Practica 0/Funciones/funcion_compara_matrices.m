function varLogica = funcion_compara_matrices(m1,m2)
    varLogica = false;
    if( size(m1) == size(m2) )
        m3 = m1 - m2;
        if(max(m3(:)) == 0 && min(m3(:)) == 0 )
            varLogica = true;
        end
    else
        disp("Las matrices no tienen las mismas dimensiones");
    end
end