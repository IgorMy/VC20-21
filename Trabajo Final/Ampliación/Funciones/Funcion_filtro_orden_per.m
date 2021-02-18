function Ifilt = Funcion_filtro_orden_per(I,fil,col,per)
    [M N] = size(I);
    Ifilt = zeros(size(I));
    
    nf = floor(fil/2);
    nc = floor(col/2);
    Iamp = padarray(I,[nf,nc]);
    
    for i=1:M
        for j=1:N
            ventana = Iamp(i:i+2*nf,j:j+2*nc);
            Ifilt(i,j) = prctile(ventana(:),per);
        end
    end
end