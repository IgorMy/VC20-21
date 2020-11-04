function [espacioCcas, JespacioCcas]=funcion_selecciona_vector_ccas(X,Y,tam)

        comb = combnk(1:size(X,2),tam);
        numComb = size(comb,1);

        outputs = Y';
        valoresJ = zeros(numComb,1);
        for i=1:numComb
            columnasOI = comb(i,:);
            inputs = X(:,columnasOI)';
            valoresJ(i) = indiceJ(inputs,outputs);
        end
        [valoresJord,indices] = sort (valoresJ,'descend');

        espacioCcas = comb(indices(1),:);
        JespacioCcas = valoresJord(1);
        
end