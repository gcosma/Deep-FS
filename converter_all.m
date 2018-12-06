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
%%%%%load other:
% dataPath1 = {'\ARCENE\arcene', '\DEXTER\dexter', '\DOROTHEA\dorothea', '\GISETTE\gisette', '\MADELON\madelon'}

fprintf('load %s ... \n', selection_method)
dataPath1 =['\' upper(selection_method) '\' lower(selection_method) ];
filename = [rootPath dataPath1];

load(filename)
%addpath('C:\Users\ERD204\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\DataNcode')

% data_stats(Data);%ad  DataNcode to path the

X_train=Data.train.X;
Y_train = Data.train.Y;
%a=[X_train, Y_train];
%merg with validation data
% X_train = [X_train; Data.valid.X];
% Y_train = [Y_train; Data.valid.Y];
X_valid = Data.valid.X;
Y_valid = Data.valid.Y;

% test data
X_test = Data.test.X;
Y_test = Data.test.Y;
%%
% switch lower(selection_method)
%     case 'dexter'
%       [classes, digitdata] = load_dexter();%load train dat
%     case 'arcene'
%         
%     otherwise
%         disp('Unknown dataset,')
% end
%%%%%%%%%%%%Remove fitutre vector wich is zero:

ind=[];
mmm=[];
for j=1: size(X_train,2)
    if max(X_train(:,j)) == min (X_train(:,j))
        ind=[ind, j];
%         mmm= [mmm,max(digitdata(:,j))];
        
    end
end
% digitdata2 = digitdata;
X_train(:,ind)=[];
X_valid(:,ind)=[];

X_test(:,ind)=[];

%%%%%%%%%%%%%
% save('dexter_train.mat', 'Y_train', 'X_train')

filenamSave=selection_method;
save([filenamSave '_train.mat'], 'Y_train', 'X_train')
clear Y_train X_train;

%%%%%%%%%%%%%%%2) validation dataset
% [val_classes, val_digitdata] = load_dexter_valid();% load validation data
% val_digitdata(:,ind)=[];
% 
% save('dexter_validation.mat', 'val_classes', 'val_digitdata')
% clear val_classes val_digitdata

save([filenamSave '_validation.mat'], 'Y_valid', 'X_valid')
clear Y_valid X_valid;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% % fid = fopen('C:\Users\cmp3tahera\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_train.data', 'r');
% fid = fopen('C:\Users\ERD204\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_train.data', 'r');
% 
% 
% for i=1:n
%     tline = fgetl(fid);
%     d = sscanf(tline, '%d:%d');
%     vectors(i,d(1:2:end)) = d(2:2:end);
% end
% fclose(fid);
% 
% %     fid = fopen('example_datasets/dexter_train.labels', 'r');
% % fid = fopen('C:\Users\cmp3tahera\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_train.labels', 'r');
% fid = fopen('C:\Users\ERD204\OneDrive - Nottingham Trent University\Deep_FS_MATLA_Neurocomputing\MATLAB\hub-toolbox-matlab-master\DEXTER\DEXTER\dexter_train.labels', 'r');
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
% 
% 
% 
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



