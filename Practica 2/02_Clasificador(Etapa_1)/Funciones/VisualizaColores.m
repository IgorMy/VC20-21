function VisualizaColores(I,Ir)

    Ib = Ir == 32;
    Is = funcion_visualiza(I,Ib,[0 0 0]);
    
    Ib = Ir == 64;
    Is = funcion_visualiza(Is,Ib,[0 0 255]);
    
    Ib = Ir == 128;
    Is = funcion_visualiza(Is,Ib,[255 255 0]);
    
    Ib = Ir == 255;
    Is = funcion_visualiza(Is,Ib,[255 0 0]);
    
    subplot(1,2,1),imshow(I),title("Imagen original");
    subplot(1,2,2),imshow(Is),title("Segmentación");

end