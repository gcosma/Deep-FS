% first run demo_pixel.m until loading
clc
clear all
close all

randn('state',100);
rand('state',100);
warning off


fprintf(1,'Converting Raw files into Matlab format \n');
converter; 

fprintf(1,'Pretraining a Deep Boltzmann Machine. \n');
makebatches; 
[numcases numdims numbatches]=size(batchdata);
tic
%%%%%% Training 1st layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% numhid=500; maxepoch=100;
numhid=500; maxepoch=10

fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid);
restart=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training data
trainMNIST =zeros(60000,784);
trainTargets =zeros(size(trainMNIST,1),10);
% trainMNIST = [];
% trainTargets = [];
% trainTargets = [];
for i= 1:size(batchdata,1)
    for j=1:size(batchdata,3)
%         trainMNIST = [trainMNIST;batchdata(i, :, j)];
%         trainTargets = [trainTargets; batchtargets(i,:,j)];
       trainMNIST((i-1)*600+j,:) =batchdata(i, :, j);
       trainTargets((i-1)*600+j,:) =batchtargets (i,:,j);
    end
end
% save('trainMNIST.mat', 'trainMNIST')
% save('trainTargets.mat','trainTargets')
testMNIST =zeros(10000,784);
testTargets =zeros(size(testMNIST,1),10);
for i= 1:size(testbatchdata,1)
    for j=1:size(testbatchdata,3)
       testMNIST((i-1)*100+j,:) =testbatchdata(i, :, j);
       testTargets((i-1)*100+j,:) =testbatchtargets (i,:,j);
    end
end
% save('testMNIST.mat','testMNIST')
% save('testTargets.mat','testTargets')