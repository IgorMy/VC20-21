function [datos mCovInteres] = Mahalanobis(X,Y)
       
      % Seleccionamos los datos de interes
      Ib = Y ==1;
      XoI = X(Ib,:);
      
      % Obtenemos los datos de estudio
      valoresClases = unique(Y);
      numClases = length(valoresClases);
      [numDatos, numAtributos] = size(X);

      % Obtenemos el centro de la nube de puntos
      centro = mean(XoI);
      
      % Obtenemos la matriz de covarianzas
      mCov = zeros(numAtributos,numAtributos,numClases);
      for i=1:numClases
            FoI = Y == valoresClases(i);
            XClase = X(FoI,:);
            M(i,:) = mean(XClase);
            mCov(:,:,i) = cov(XClase,1);
      end
      
      % Separamos las matrices de covarianzas para un mejor uso
      mCovResto = mCov(:,:,1);
      mCovInteres = mCov(:,:,2);
      
      % Calculamos las distancias mahalanobis 
      distancias_interes = [];
      distancias_resto=[];
      
      mCov1 = mCov(:,:,1);
      mCov2 = mCov(:,:,2);
    
      numDatosClase1 = sum(Y==valoresClases(1));
      numDatosClase2 = sum(Y==valoresClases(2));
      mCov = (numDatosClase1*mCov1 + numDatosClase2*mCov2) / (numDatosClase1 + numDatosClase2); 
      
      for i=1:numDatos
            if Y(i) == 0
                   distancias_resto = [distancias_resto; sqrt( ( X(i,:)-centro)*pinv(mCovInteres) * (X(i,:) - centro)')];
            else
                  distancias_interes = [distancias_interes; sqrt( ( X(i,:)-centro)*pinv(mCovInteres) * (X(i,:) - centro)') ];
            end
      end
      
      % Umbral maximo
      d1 = max(distancias_interes);
      
      % Excluimos el 3% de los puntos mas alejados
      d_i_o = sort(distancias_interes,'descend');
      indice = round(size(d_i_o,1)*3/100);
      d2 = d_i_o(indice);
      
      % Distancia minima de los puntos
      d3 = min(distancias_resto); % Le resamos una distancia muy pequeña para no incluir ese punto 
      
      %  Distancia que permite error de 0.05%
      d_r_o = sort(distancias_resto);
      indice = round(size(d_i_o,1)*0.05/100);
      d4 = d_r_o(indice);
      
      datos =[centro, d1, d2, d3, d4];
      
end