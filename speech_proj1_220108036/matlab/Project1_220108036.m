clc;
clear;
close all;

refFile  = '../data/Vowels/220108036_a_1.wav';
testFile = '../data/Vowels/220108036_a_5.wav';


F = extract39mfcc(refFile);

baseMFCC   = F(1:13,:);
deltaMFCC  = F(14:26,:);
delta2MFCC = F(27:39,:);


fprintf('PROJECT 1 : DTW BASED VOWEL RECOGNITION\n');

fprintf('\nMFCC FEATURE DETAILS\n');
fprintf('Base MFCC Dimensions        : %d x %d\n',size(baseMFCC,1),size(baseMFCC,2));
fprintf('Delta MFCC Dimensions       : %d x %d\n',size(deltaMFCC,1),size(deltaMFCC,2));
fprintf('Delta-Delta MFCC Dimensions : %d x %d\n',size(delta2MFCC,1),size(delta2MFCC,2));
fprintf('Total Feature Dimension     : %d\n',size(F,1));

figure;
imagesc(baseMFCC);
axis xy;
colorbar;
title('13 Base MFCC Coefficients');
xlabel('Frame Index');
ylabel('Coefficient Index');

savefig('Base_MFCC.fig');

figure;
imagesc(deltaMFCC);
axis xy;
colorbar;
title('Delta MFCC');
xlabel('Frame Index');
ylabel('Coefficient Index');

savefig('Delta_MFCC.fig');

figure;
imagesc(delta2MFCC);
axis xy;
colorbar;
title('Delta-Delta MFCC');
xlabel('Frame Index');
ylabel('Coefficient Index');

savefig('DeltaDelta_MFCC.fig');

refFeat  = extract39mfcc(refFile);
testFeat = extract39mfcc(testFile);

[dist, ix, iy, D] = mydtw(refFeat, testFeat);

fprintf('\nDTW COMPARISON\n');
fprintf('----------------------\n');
fprintf('Reference File : %s\n', refFile);
fprintf('Test File      : %s\n', testFile);
fprintf('DTW Distance   : %.4f\n', dist);

figure;
imagesc(D);
axis xy;
colorbar;
title('DTW Cost Matrix');
xlabel('Test Frame Index');
ylabel('Reference Frame Index');

savefig('DTW_Cost_Matrix.fig');


figure;
plot(ix, iy, 'LineWidth', 2);
grid on;
xlabel('Reference Frame Index');
ylabel('Test Frame Index');
title('DTW Warping Path (Alignment Curve)');

savefig('DTW_Warping_Path.fig');

figure;
hold on;

for i = 2:25

    currentFile = sprintf('../data/Vowels/220108036_a_%d.wav', i);

    if exist(currentFile,'file') ~= 2
        continue;
    end

    currentFeat = extract39mfcc(currentFile);

    [~, px, py] = mydtw(refFeat, currentFeat);

    plot(px, py, 'LineWidth', 1.2);

end

grid on;
xlabel('Reference Frame Index');
ylabel('Test Frame Index');
title('DTW Alignment: Reference a vs All 24 a Tests');

hold off;

savefig('All_a_Alignment.fig');


figure;
hold on;

vowels = {'a','e','i','o','u'};
colors = {'b','r','g','m','k'};

for v = 1:length(vowels)

    vowel = vowels{v};

    for i = 2:25

        currentFile = sprintf('../data/Vowels/220108036_%s_%d.wav', vowel, i);

        if exist(currentFile,'file') ~= 2
            continue;
        end

        currentFeat = extract39mfcc(currentFile);

        [~, px, py] = mydtw(refFeat, currentFeat);

        plot(px, py, 'Color', colors{v}, 'LineWidth', 1.1);

    end
end

% Legend handles
h(1)=plot(NaN,NaN,'b','LineWidth',2);
h(2)=plot(NaN,NaN,'r','LineWidth',2);
h(3)=plot(NaN,NaN,'g','LineWidth',2);
h(4)=plot(NaN,NaN,'m','LineWidth',2);
h(5)=plot(NaN,NaN,'k','LineWidth',2);

legend(h, {'a','e','i','o','u'});

grid on;
xlabel('Reference Frame Index');
ylabel('Test Frame Index');
title('DTW Alignment: Reference a vs All Vowels');

hold off;

savefig('All_Vowels_Alignment.fig');

fprintf('ALL PROJECT 1 VISUALIZATIONS GENERATED\n');