function IAM=funcion_amplitud_contraste(I,rango,extension)
    
    IAM = zeros(size(I));

    for i=0:255
        Ib = I == i;
        
        if i < rango(1)
            qmin = 1;
            qmax = extension(1)-1;
            pmin = 1;
            pmax = rango(1)-1;
        else
            if i >= rango(1) && i <= rango(2)
                qmin = extension(1);
                qmax = extension(2);
                pmin = rango(1);
                pmax = rango(2);
            else
                if i > rango(2)
                    qmin = rango(2)+1;
                    qmax = 255;
                    pmin = extension(2)+1;
                    pmax = 255;
                end
            end
        end
        
        IAM(Ib) = qmin + ( (qmax - qmin) / (pmax-pmin) * ( i - pmin ) );
    end
    
    IAM = uint8(IAM);
    
end