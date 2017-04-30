function [ S ] = getSimilarityMatrix( data, s )
[n, ~] = size(data);
S = zeros(n,n);

for i = 1:n
    x_i = data(i,:);
    for j = 1:n
        x_j = data(j,:);
        num = norm(x_i - x_j)^2;
        den = 2 * s^2;
        S(i,j) = exp(-(num/den));
    end
end


end

