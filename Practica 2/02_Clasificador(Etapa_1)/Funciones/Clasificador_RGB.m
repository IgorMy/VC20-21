function Ir=Clasificador_RGB(Matriz,MEAN,STD,factor,espacioCcas) % debe recibir la matriz en double normalizada
   
    % Generación de la matriz de salida en negro
    Ir = zeros(size(Matriz,1:2));
    
    % Obtención de las variables de control
    m255menor = MEAN(4,espacioCcas) - factor * STD(4,espacioCcas);
    m255mayor = MEAN(4,espacioCcas) + factor * STD(4,espacioCcas);
    
    m128menor = MEAN(3,espacioCcas) - factor * STD(3,espacioCcas);
    m128mayor = MEAN(3,espacioCcas) + factor * STD(3,espacioCcas);
    
    m64menor = MEAN(2,espacioCcas) - factor * STD(2,espacioCcas);
    m64mayor = MEAN(2,espacioCcas) + factor * STD(2,espacioCcas);
    
    m32menor = MEAN(1,espacioCcas) - factor * STD(1,espacioCcas);
    m32mayor = MEAN(1,espacioCcas) + factor * STD(1,espacioCcas);
    
    % Descomposición de la Matriz
    R = Matriz(:,:,1);
    G = Matriz(:,:,2);
    B = Matriz(:,:,3);
    
    % Obtención de la matriz binaria por comparación y actualización
    % 32
    Ib = ( m32menor(1) < R & R <= m32mayor(1)) &  ( m32menor(2) < G & G <= m32mayor(2)) & ( m32menor(3) < B & B <= m32mayor(3));
    Ir(Ib) = 32;
    
    % 64
    Ib = ( m64menor(1) < R & R <= m64mayor(1)) &  ( m64menor(2) < G & G <= m64mayor(2)) & ( m64menor(3) < B & B <= m64mayor(3));
    Ir(Ib) = 64;
    
    % 128
    Ib = ( m128menor(1) < R & R <= m128mayor(1)) &  ( m128menor(2) < G & G <= m128mayor(2)) & ( m128menor(3) < B & B <= m128mayor(3));
    Ir(Ib) = 128;
    
    % 255
    Ib = ( m255menor(1) < R & R < m255mayor(1)) &  ( m255menor(2) < G & G <= m255mayor(2)) & ( m255menor(3) < B & B <= m255mayor(3));
    Ir(Ib) = 255;
end