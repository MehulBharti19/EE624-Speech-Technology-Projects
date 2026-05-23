function y = logsumexp(A, dim)

if nargin < 2
    dim = 1;
end

maxA = max(A, [], dim);
y = maxA + log(sum(exp(A - maxA), dim) + eps);

end