function VisualizaColores(I,Ir)

    Ib = Ir == 1;
    Is = funcion_visualiza(I,Ib,[0 0 255]);
    figure,hold on;
    subplot(1,2,1),imshow(I),title("Imagen original");
    subplot(1,2,2),imshow(Is),title("Segmentación");
    hold off;
end