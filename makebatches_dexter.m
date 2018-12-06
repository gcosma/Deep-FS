% Version 1.000
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

%%%%%%%%%%%%%%%load dexter: 1) training dataset
% [classes, digitdata] = load_dexter();%load train dat
load('dexter_train.mat')% classes, digitdata
maxV=max(max(digitdata));
digitdata = digitdata/maxV;

targets = tocategorical(classes);

totnum=size(digitdata,1);
fprintf(1, 'Size of the training dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
% batchsize = 100
[batchtargets, batchdata] = puInBatch(targets, digitdata, batchsize);
clear digitdata targets classes;

%%%%%%%%%%%%%%%2) validation dataset
% [classes, digitdata] = load_dexter_valid();% load validation data
load('dexter_validation.mat'); classes=val_classes; digitdata = val_digitdata;
maxV=max(max(digitdata));
digitdata = digitdata/maxV;

targets = tocategorical(classes);

totnum=size(digitdata,1);
fprintf(1, 'Size of the validation dataset= %5d \n', totnum);
[testbatchtargets, testbatchdata] = puInBatch(targets, digitdata, batchsize);
clear digitdata classes val_digitdata val_classes;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Reset random seeds
rand('state',sum(100*clock));
randn('state',sum(100*clock));

% function [classes, vectors] = load_dexter()
% %     fprintf('\nNO PARAMETERS GIVEN! Loading & evaluating DEXTER data set.\n\n');
% fprintf('\n Loading DEXTER data set.\n\n');
% fprintf('DEXTER is a text classification problem in a bag-of-word\n');
% fprintf('representation. This is a two-class classification problem\n');
% fprintf('with sparse continuous input variables.\n');
% fprintf('This dataset is one of five datasets of the NIPS 2003 feature\n');
% fprintf('selection challenge.\n\n');
% 
% fprintf('http://archive.ics.uci.edu/ml/datasets/Dexter\n\n');
% 
% n = 300;
% dim = 20000;
% 
% vectors = zeros(n, dim);
% classes = zeros(n, 1);
% 
% 
% %     fid = fopen('example_datasets/dexter_train.data', 'r');
% fid = fopen('C:\Users\cmp3tahera\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_train.data', 'r');
% 
% for i=1:n
%     tline = fgetl(fid);
%     d = sscanf(tline, '%d:%d');
%     vectors(i,d(1:2:end)) = d(2:2:end);
% end
% fclose(fid);
% 
% %     fid = fopen('example_datasets/dexter_train.labels', 'r');
% fid = fopen('C:\Users\cmp3tahera\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_train.labels', 'r');
% 
% for i=1:n
%     tline = fgetl(fid);
%     d = sscanf(tline, '%d');
%     classes(i) = d(1);
% end
% fclose(fid);
% 
% %     D = cosine_distance(vectors);
% 
% end

function [targets] = tocategorical(classes)
targets = [];
for i=1: length(classes)
    if classes(i) == -1
        targets = [targets;[1 0]];
    elseif classes(i) == 1
        targets = [targets; [0 1]];
    end
end
end

function [batchtargets, batchdata] = puInBatch(targets, digitdata, batchsize)
%get the tardet, data and batch size and put in in batches with the size of
%batchsize
totnum=size(digitdata,1);
randomorder=randperm(totnum);

% batchsize = 100;
numbatches=totnum/batchsize;
numdims  =  size(digitdata,2);
batchdata = zeros(batchsize, numdims, numbatches);
batchtargets = zeros(batchsize,size(targets, 2), numbatches);

for b=1:numbatches
    batchdata(:,:,b) = digitdata(randomorder(1+(b-1)*batchsize:b*batchsize), :);
    batchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end
% clear digitdata targets;
end

% function [classes, vectors] = load_dexter_valid()
% %     fprintf('\nNO PARAMETERS GIVEN! Loading & evaluating DEXTER data set.\n\n');
% fprintf('\n Loading DEXTER data set.\n\n');
% fprintf('DEXTER is a text classification problem in a bag-of-word\n');
% fprintf('representation. This is a two-class classification problem\n');
% fprintf('with sparse continuous input variables.\n');
% fprintf('This dataset is one of five datasets of the NIPS 2003 feature\n');
% fprintf('selection challenge.\n\n');
% 
% fprintf('http://archive.ics.uci.edu/ml/datasets/Dexter\n\n');
% 
% n = 300;
% dim = 20000;
% 
% vectors = zeros(n, dim);
% classes = zeros(n, 1);
% 
% 
% %     fid = fopen('example_datasets/dexter_train.data', 'r');
% %     fid = fopen('C:\Users\cmp3tahera\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_train.data', 'r');
% %vlidation dat:
% fid = fopen('C:\Users\cmp3tahera\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_valid.data', 'r');
% 
% for i=1:n
%     tline = fgetl(fid);
%     d = sscanf(tline, '%d:%d');
%     vectors(i,d(1:2:end)) = d(2:2:end);
% end
% fclose(fid);
% 
% %     fid = fopen('example_datasets/dexter_train.labels', 'r');
% fid = fopen('C:\Users\cmp3tahera\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\dexter_valid.labels', 'r');
% 
% for i=1:n
%     tline = fgetl(fid);
%     d = sscanf(tline, '%d');
%     classes(i) = d(1);
% end
% fclose(fid);
% 
% %     D = cosine_distance(vectors);
% 
% end



