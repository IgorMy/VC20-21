function script(Imagen1)
    
    histograma1=zeros(1,256);
    [nfilas,nColumnas,prof] = size(Imagen1);
    for i=1:nfilas
        for j=1:nColumnas
            histograma1(double(Imagen1(i,j,3))+1) = histograma1(double(Imagen1(i,j,3))+1) + 1;
        end
    end
    stem(histograma1,'.r');
    
    [histograma2,] = imhist(Imagen1(:,:,3));
    histograma2=histograma2';
    figure,stem(histograma2,'.r');
    
end