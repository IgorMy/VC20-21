function R = funcion_visualiza(I,Ib,Color)

if( (size(I,1)== size(Ib,1))&&(size(I,2) == size(Ib,2)))
    
    if(size(Color,2)==3)
        if(min(Color) >= 0 && max(Color) <= 255)
            
            if(size(I,3)==1)
                I= cat(3,I,I,I);
            end
            R = I(:,:,1);
            R(logical(Ib)) = Color(1);
            G = I(:,:,2);
            G(logical(Ib)) = Color(2);
            B = I(:,:,3);
            B(logical(Ib)) = Color(3);
            R = cat(3,R,G,B);
            
        else
            disp("Los elementos del color tienen que estar comprendidos entre 0 y 255");
        end
    else
        disp("Color tiene que ser un vector de 1 x 3")
    end
   
else
    disp("Las matrices I y Ib son diferentes");
end

end
