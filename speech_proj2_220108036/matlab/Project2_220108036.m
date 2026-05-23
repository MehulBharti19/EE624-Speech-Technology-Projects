clc;
clear;
close all;

addpath(genpath(pwd));

trainList='../lists/train_list.txt';
testList='../lists/test_list.txt';

numMix=16;
fprintf(' GMM ISOLATED DIGIT RECOGNITION\n');

%39-D MFCC
fprintf('\nChecking MFCC feature dimensions...\n');

F=extract39mfcc('../Data/Digits/220108036_0_1.wav');

fprintf('Feature matrix size: %d x %d\n',size(F,1),size(F,2));
fprintf('Static MFCC   : %d coefficients\n',13);
fprintf('Delta MFCC    : %d coefficients\n',13);
fprintf('Delta-Delta   : %d coefficients\n',13);
fprintf('Total features: %d dimensions\n',size(F,1));

fprintf('\nTraining 10 GMM models (%d mixtures each)\n',numMix);

models=train_digit_gmm_models(trainList,numMix);

fprintf('\n------------- GMM MODEL SUMMARY -------------\n');

for d=0:9

 m=models{d+1};

 fprintf('\nDigit %d model\n',d);
 fprintf('Mixtures          : %d\n',m.K);
 fprintf('Feature dimension : %d\n',m.D);
 fprintf('Final log-like    : %.4f\n',m.ll);

end


fprintf('\nTesting using Maximum Likelihood Rule...\n');

[confMat,yTrue,yPred,scores]=test_digit_gmm_models(models,testList);


fprintf('\n---------- TEST FILE SCORES ----------\n');

for i=1:length(yTrue)

 fprintf('\nTest sample %d\n',i);
 fprintf('True digit      : %d\n',yTrue(i));
 fprintf('Predicted digit : %d\n',yPred(i));

 fprintf('Likelihood scores:\n');

 for d=0:9
   fprintf('Digit %d model : %.4f\n',d,scores(i,d+1));
 end

end


fprintf('\n========= CONFUSION MATRIX =========\n');
disp(confMat)

acc=sum(yTrue==yPred)/length(yTrue)*100;

fprintf('Recognition Accuracy = %.2f %%\n',acc);

plot_confusion_matrix(confMat,0:9,...
sprintf('Digit Recognition Confusion Matrix (%d mixtures)',numMix));