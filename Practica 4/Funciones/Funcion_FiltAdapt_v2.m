function Ifiltrada = Funcion_FiltAdapt_v2(I, NumFilVent, NumColVent, VarRuido)
    Mstd = stdfilt(double(I), ones(NumFilVent,NumColVent));
    Wmean = ( 1 / ( NumFilVent * NumColVent ) ) * ones(NumFilVent, NumColVent);
    Mmean = imfilter(I,Wmean,'symmetric');
    VarR = ones(size(I))*VarRuido;
    Ifiltrada = double(I) - ( VarR ./ ( Mstd.^2 ) ) .* (double(I) - double(Mmean));
    Ifiltrada = uint8(Ifiltrada);
end