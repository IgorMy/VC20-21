% funcion que recibe dos matrices que compara dos matrices y devuelve si
% son dos matrices iguales o diferentes

function compara_matrices(A,B)
% Echo por mi
% if(A==B)
%     disp("Son iguales");
% else
%     disp("Son distintas");
% end

Error =  double(A) - double(B);

m = max(Error(:));
M = min(Error(:));

if(M == m && M == 0)
    disp("Son iguales");
else
    disp("Son distintas");
end


end