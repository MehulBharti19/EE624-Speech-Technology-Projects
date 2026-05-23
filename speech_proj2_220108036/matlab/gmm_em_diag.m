function model = gmm_em_diag(X, K, opts)
% X: N x D
% K: number of mixtures

if nargin < 3
    opts = struct();
end

if ~isfield(opts, 'maxIter'); opts.maxIter = 100; end
if ~isfield(opts, 'tol');     opts.tol = 1e-4;   end
if ~isfield(opts, 'reg');     opts.reg = 1e-6;   end
if ~isfield(opts, 'verbose'); opts.verbose = false; end

[N, D] = size(X);
assert(N >= K, 'Not enough frames to initialize %d mixtures.', K);

rng(1); % fixed seed for reproducibility
perm = randperm(N);

mu   = X(perm(1:K), :);
sig2 = repmat(var(X, 0, 1) + opts.reg, K, 1);
w    = ones(1, K) / K;

prevLL = -inf;

for iter = 1:opts.maxIter

    % E-step
    logComp = zeros(N, K);

    for k = 1:K
        diff = X - mu(k,:);
        quad = sum((diff.^2) ./ sig2(k,:), 2);
        logdet = sum(log(sig2(k,:)));
        logComp(:,k) = log(w(k) + eps) - 0.5 * (D*log(2*pi) + logdet + quad);
    end

    logNorm = logsumexp(logComp, 2);
    ll = sum(logNorm);

    resp = exp(logComp - logNorm);  % N x K
    Nk = sum(resp, 1) + eps;

    % M-step
    w = Nk / N;

    for k = 1:K
        rk = resp(:,k);
        mu(k,:) = (rk' * X) / Nk(k);

        diff = X - mu(k,:);
        sig2(k,:) = (rk' * (diff.^2)) / Nk(k) + opts.reg;
    end

    if opts.verbose
        fprintf('  iter %d, LL = %.4f\n', iter, ll);
    end

    if abs(ll - prevLL) < opts.tol * (abs(prevLL) + eps)
        break;
    end

    prevLL = ll;
end

model.w = w;
model.mu = mu;
model.sig2 = sig2;
model.K = K;
model.D = D;
model.ll = ll;
model.iter = iter;

end