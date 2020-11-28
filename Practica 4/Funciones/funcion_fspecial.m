function M = funcion_fspecial(W,Std)

M = zeros(W);
m = (W-1)/2;
for i=1:W
    for j=1:W
        x = i - (m+1);
        y = j - (m+1);
        M(i,j) = exp((-1/2)*((x^2+y^2)/Std^2));
    end
end
M = M ./sum(M(:));

end