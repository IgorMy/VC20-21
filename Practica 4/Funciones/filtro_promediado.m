function If = filtro_promediado(IR)
    N = length(IR);
    If = zeros(size(IR{1}));
    for i=1:N
        If = If + IR{i};
    end
    If = If./N;
end