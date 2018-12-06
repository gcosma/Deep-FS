%%
%This code first select features using Deep-FS [1] for different data sets.Then
%it trains a DBM [2] on the selected features.
%%
clc
clear all
close all


randn('state',100);
rand('state',100);
warning off

%%%%load data
options = {'Run DeepFS, Deep feature selection method.', 'Run DeepFS and then run DBM (Deep Boltzmann Machin) on the selected features.'}
[ methodID ] = readInput( options );
selection_method = options{methodID}; % Selected
fprintf(1,'Converting Raw files into Matlab format \n');
converter;
makebatches;
fprintf(1,'Pretraining a Deep Boltzmann Machine. \n');

%%%%%%%%%%%%%%%%%
[numcases numdims numbatches]=size(batchdata);
numdims0 = numdims;
tic

%%%%%% Training 1st layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numhid=500; maxepoch=10

fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid);
restart=1;
rbm% initial trainig of thre first RBM on the all the input features
%%%%%%%%%%%%%% DeepFS feature selection: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555
% Ne=10
Ne=50
rbm_test17b2% remove a grope of pixels (Ne=10 pixels) which has the minimum ek^
index_selected_feature =[1:numdims0];
index_selected_feature (ind_re)=[];
fprintf('Number of Selected feature is:')
Nu_F=length(index_selected_feature)%number of selected features
fprintf('The index of selected features are in the variable: indix_selected_feature.\n')
%%%%%%%% continue the trainig of DBM with the selected features
if methodID== 2%selection_method == 'Run DeepFS and then run DBM (Deep Boltzmann Machin) on the selected features.'
    maxepoch=10;
    epoch=epoch+1;
    rbm% train with reduced data
    %%%%%% Training the 2nd layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all
    numpen = 1000;
    maxepoch=2;
    fprintf(1,'\nPretraining Layer 2 with RBM: %d-%d \n',numhid,numpen);
    restart=1;
    makebatches
    rbm_l2
    
    %%%%%% Training two-layer Boltzmann machine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    close all
    numhid = 500;
    numpen = 1000;
    maxepoch=3; %To get results in the paper I used maxepoch=500, which took over 2 days or so.
    
    fprintf(1,'Learning a Deep Bolztamnn Machine. \n');
    restart=1;
    makebatches
    dbm_mf

    %%%%%% Fine-tuning two-layer Boltzmann machine  for classification %%%%%%%%%%%%%%%%%
    maxepoch=1;
    makebatches
    backprop
    Nu_F=20000-length(ind_re)%number of selected features
    err_fin=[ err_II; err_III(1); err_III(2)]%[ dbm_mf out of 60000; backprob1 out of 10000; backprob2 out of 60000] ]
    toc
    fprintf('number of Selected feature is:')
    Nu_F=length(index_selected_feature)%number of selected features
end% option

%%%function fo getting input
function [ methodID ] = readInput( list )
%READINPUT

fprintf('Please, select one option (1 or 2):\n\n');
for i=1:length(list)
    fprintf('[%d] %s \n',i,list{i});
end
methodID = input('> ');

end

%Refrences:

% [1]A. Taherkhani, G. Cosma, and T. M. McGinnity, “Deep-FS: A feature selection algorithm for Deep Boltzmann Machines,”
% Neurocomputing, vol. 0, pp. 1–16, 2018.
%[2] Learning Deep Boltzmann Machines, Ruslan Salakhutdinovh, http://www.cs.toronto.edu/~rsalakhu/DBM.html
% Aboozar Taherkhani extend the code provided by Ruslan Salakhutdinov to
% select features.


%The prenciple of the feature selection method is described in:
% A. Taherkhani, G. Cosma, and T. M. McGinnity, “Deep-FS: A feature selection algorithm for Deep Boltzmann Machines,” Neurocomputing, vol. 0, pp. 1–16, 2018.
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.
