function Ib = fresas_rojas(IbR,IbV,u1,u2)

    % Eliminación de objetos pequeños
    IbRl = bwareaopen(IbR,u1);
    IbVl = bwareaopen(IbV,u2);
    
    % Definimos la matriz
    Ib = false(size(IbR));
    
    % Generación de la matriz con las dos segmentaciones
    IbRV = (IbRl | IbVl);
    
    % Matriz etiquetada
    [Ie,N] = bwlabel(IbRV);
    
    % Posiciones rojas
    R = find(IbRl==1);
    
    for i=1:N
        Ibe = Ie==i;
        S = sum(sum(ismember(find(Ibe==1),R)));
        if(S > 0)
            Ib = Ib | Ibe;
        end
    end

end