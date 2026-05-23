function compare_dtw_pair(refFile, testFile)

refFeat  = extract39mfcc(refFile);
testFeat = extract39mfcc(testFile);

[dist, ix, iy, D] = mydtw(refFeat, testFeat);

fprintf('\nReference: %s\n', refFile);
fprintf('Test: %s\n', testFile);
fprintf('DTW Distance = %.4f\n', dist);

figure;
imagesc(D);
colorbar;
title('DTW Cost Matrix');
xlabel('Test Frames');
ylabel('Reference Frames');

figure;
plot(ix, iy, 'LineWidth', 2);
xlabel('Reference Frame Index');
ylabel('Test Frame Index');
title('DTW Warping Path (Alignment Curve)');
grid on;

end