function funcion_representa_histograma_por_color(I)
hold on;
stem(imhist(I(:,:,1)),'.r');
stem(imhist(I(:,:,2)),'.g');
stem(imhist(I(:,:,3)),'.b');
hold off;
legend("Rojo","Verde","Azul");

end