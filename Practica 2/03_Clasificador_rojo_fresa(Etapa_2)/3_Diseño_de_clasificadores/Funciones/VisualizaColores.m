function VisualizaColores(I,Ir)

    Ib = Ir == 1;
    Is = funcion_visualiza(I,Ib,[255 0 0]);
    subplot(1,2,1),imshow(I),title("Imagen original");
    subplot(1,2,2),imshow(Is),title("Segmentación");
end