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
options = {'MNIST', 'arcene', 'dexter', 'dorothea', 'gisette', 'madelon'}

[ methodID ] = readInput( options );

selection_method = options{methodID}; % Selected
switch lower(selection_method)
    case 'mnist'% put the MNIST data in the current folder which contine this m-file
        fprintf(1,'Converting Raw files into Matlab format \n');
        converter;
        makebatches;
        fprintf(1,'Pretraining a Deep Boltzmann Machine. \n');
        
    otherwise
        % put the root path to the data: {'arcene', 'dexter', 'dorothea', 'gisette', 'madelon'}
        rootPath =     'C:\Users\ERD204\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\DataNcode\Data';
        
        converter_all;
        
        fprintf(1,['Loading ' selection_method ' ...'])
        batchsize = 10
        
        makebatches_all;
        fprintf(1,'Pretraining a Deep Boltzmann Machine. \n');
        
end
%%%%%%%%%%%%%%%%%
[numcases numdims numbatches]=size(batchdata);
numdims0=numdims;
tic

%%%%%% Training 1st layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numhid=500; maxepoch=2

fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid);
restart=1;
rbm% initial trainig of thre first RBM on the all the input features
%%%%%%%%%%%%%% feature selection: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555
Ne=100
rbm_test17b% remove a grope of pixels (Ne pixels) which has the minimum ek^
indix_selected_feature =[1:numdims0];
indix_selected_feature (ind_re)=[];
fprintf('number of Selected feature is:')
Nu_F=length(indix_selected_feature)%number of selected features
%%%%%%%% continue the trainig of DBM with the selected features
maxepoch=2;
epoch=epoch+1;
rbm% train with reduced data

%%%%%% Training 2st layer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
numpen = 1000;
maxepoch=2;
fprintf(1,'\nPretraining Layer 2 with RBM: %d-%d \n',numhid,numpen);
restart=1;
%%%%%%%%
switch lower(selection_method)
    case 'mnist'
        makebatches
        
    otherwise
        makebatches_all;
        
end
%%%%%%
rbm_l2


%%%%%% Training two-layer Boltzmann machine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
numhid = 500;
numpen = 1000;
maxepoch=3; %To get results in the paper I used maxepoch=500, which took over 2 days or so.

fprintf(1,'Learning a Deep Bolztamnn Machine. \n');
restart=1;

switch lower(selection_method)
    case 'mnist'
        makebatches
        
    otherwise
        makebatches_all;
        
end

% makebatches;
dbm_mf

%%%%%% Fine-tuning two-layer Boltzmann machine  for classification %%%%%%%%%%%%%%%%%
maxepoch=5;

switch lower(selection_method)
    case 'mnist'
        makebatches
        
        
    otherwise
        makebatches_all
end

% makebatches;
backprop

err_fin=[ err_II; err_III(1); err_III(2)]%[ dbm_mf out of 60000; backprob1 out of 10000; backprob2 out of 60000] ]

toc

%%%function:
function [ methodID ] = readInput( list )
%READINPUT

fprintf('Please, select a dataset from the list, i.e. 1:\n');
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
