function ISNR=evalua_eficiencia(I,IF,IR)
    
    I = double(I);
    IF = double(IF);
    IR = double(IR);
    
    numerador = sum( (I(:) - IR(:)).^2 );
    denominador = sum( (I(:) - IF(:)).^2 );
    
    ISNR = 10*log10(numerador/denominador);
    
end