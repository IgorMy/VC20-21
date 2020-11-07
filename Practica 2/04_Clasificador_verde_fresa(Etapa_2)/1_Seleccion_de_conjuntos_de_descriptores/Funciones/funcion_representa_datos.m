function funcion_representa_datos(X,Y,espacioCcas, nombresProblema,titulo)

    codifClases = unique(Y);
    numClases = length(codifClases);

    figure, hold on
    if length(espacioCcas) == 2
        for i=1:numClases
            datosClase = X(Y==codifClases(i),espacioCcas);
            plot(datosClase(:,1), datosClase(:,2),nombresProblema.simbolos{i})
        end
        xlabel(nombresProblema.descriptores{espacioCcas(1)})
        ylabel(nombresProblema.descriptores{espacioCcas(2)})
    else
        for i=1:numClases
            datosClase = X(Y==codifClases(i),espacioCcas);
            plot3(datosClase(:,1), datosClase(:,2),datosClase(:,3),nombresProblema.simbolos{i})
        end
        xlabel(nombresProblema.descriptores{espacioCcas(1)})
        ylabel(nombresProblema.descriptores{espacioCcas(2)})
        zlabel(nombresProblema.descriptores{espacioCcas(3)})
    end
    legend(nombresProblema.clases);
    title(titulo);
    
end