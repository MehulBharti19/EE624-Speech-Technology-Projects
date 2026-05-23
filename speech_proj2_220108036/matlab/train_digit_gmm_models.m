function models = train_digit_gmm_models(trainListFile, numMix)

[files,labels]=readFileList(trainListFile);

models=cell(10,1);   % <-- use cell instead of struct array

opts.maxIter=100;
opts.tol=1e-4;
opts.reg=1e-6;
opts.verbose=false;

for digit=0:9

 idx=find(labels==digit);

 pooledFrames=[];

 for i=1:length(idx)

   fname=strtrim(files{idx(i)});
   %disp(fname)
   feat39=extract39mfcc(char(fname));

   pooledFrames=[pooledFrames; feat39']; 

 end

 fprintf('Training digit %d on %d frames from %d files...\n',...
 digit,size(pooledFrames,1),length(idx));

 model=gmm_em_diag(pooledFrames,numMix,opts);

 model.digit=digit;

 models{digit+1}=model;   % store in cell

end

end