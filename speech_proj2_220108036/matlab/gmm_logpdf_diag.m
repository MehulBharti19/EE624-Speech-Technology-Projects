function logp = gmm_logpdf_diag(X, model)
% X: N x D
% logp: N x 1

[N, D] = size(X);
K = model.K;

logComp = zeros(N, K);

for k = 1:K
    diff = X - model.mu(k,:);
    quad = sum((diff.^2) ./ model.sig2(k,:), 2);
    logdet = sum(log(model.sig2(k,:)));

    logComp(:,k) = log(model.w(k) + eps) - 0.5 * (D*log(2*pi) + logdet + quad);
end

logp = logsumexp(logComp, 2);

end