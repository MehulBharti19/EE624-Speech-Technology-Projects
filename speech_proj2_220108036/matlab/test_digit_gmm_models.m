function [confMat, yTrue, yPred, scores] = test_digit_gmm_models(models, testListFile)

[files, labels] = readFileList(testListFile);

N = numel(files);
yTrue = labels(:);
yPred = zeros(N,1);
scores = zeros(N,10);

for i = 1:N
    feat39 = extract39mfcc(files{i});
    X = feat39';   % T x 39

    for digit = 0:9
        logp = gmm_logpdf_diag(X, models{digit+1});
        scores(i, digit+1) = mean(logp);  % length-normalized score
    end

    [~, bestIdx] = max(scores(i,:));
    yPred(i) = bestIdx - 1;

    %fprintf('File: %s | True: %d | Predicted: %d\n', ...
        %files{i}, yTrue(i), yPred(i));
end

% Confusion matrix
confMat = zeros(10,10);
for i = 1:N
    confMat(yTrue(i)+1, yPred(i)+1) = confMat(yTrue(i)+1, yPred(i)+1) + 1;
end

accuracy = sum(yTrue == yPred) / N * 100;
fprintf('\nOverall accuracy = %.2f%%\n', accuracy);

end