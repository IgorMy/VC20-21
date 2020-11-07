function Ib=clasificador_NN(net,Ir,espacioCcas)
    % Obtenemos los atributos de la imagen
    [~,atributos] = calcula_atributos_h_ajustada(Ir);
    
    [N,M,~] = size(Ir);
    
    % Generamos los datos
    input=[];
    for j=1:M
        input_temp=[];
        for i=1:size(espacioCcas,2)
            input_temp = [input_temp atributos{1,espacioCcas(i)}(:,j)];
        end
        input = [input;input_temp];
    end
    
    % Generamos la respuesta
    R = sim(net,input');
    
    % Generamos la Ib
    ind = 1;
    for j=1:M
      Ib(:,j) = R(ind:ind+N-1);  
      ind = ind + N;
    end
end