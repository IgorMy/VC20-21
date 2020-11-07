function VisualizaColores2(I,Ir1,Ir2)

    Ib1 = Ir1 == 1;
    Ib2 = Ir2 == 1;
    
    Is = funcion_visualiza(I,Ib1,[255 0 0]);
    Is = funcion_visualiza(Is,Ib2,[255 255 0]);
    figure,hold on;
    subplot(1,2,1),imshow(I),title("Imagen original");
    subplot(1,2,2),imshow(Is),title("Segmentación");
    hold off;
end