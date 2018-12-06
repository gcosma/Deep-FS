
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

% This program trains Restricted Boltzmann Machine in which
% visible, binary, stochastic pixels are connected to
% hidden, binary, stochastic feature detectors using symmetrically
% weighted connections. Learning is done with 1-step Contrastive Divergence.
% The program assumes that the following variables are set externally:
% maxepoch  -- maximum number of epochs
% numhid    -- number of hidden units
% batchdata -- the data that is divided into batches (numcases numdims numbatches)
% restart   -- set to 1 if learning starts from beginning


% clc
% clear all
% close all
% load('test')
%
%
fprintf(1, ' start to removed pixels by rbm_test14 \n')
tic
% Ne=10

[numcases numdims numbatches]=size(batchdata);

%%%%%%%%%%%%%%%%%%PVH0 for rbm_test14
pvh0

%%%%%%%%%%%%%%%%%%

% save fullmnistvh vishid visbiases hidbiases %epoch
%%  remove diferent pixels
err2_rec=[];
% errsum_rec=[];
% related to Removing extra pix
batchdata0=batchdata;
visbiases0=visbiases;
vishid0=vishid;
ind_re=[];
ind_r=[1:numdims];%indeix of refrence


%%%
batchdata1=batchdata0;
vishid1=vishid0;
visbiases1=visbiases0;

%learning
vishidinc0=vishidinc;
visbiasinc0=visbiasinc;

il=1;
ilo=-(Ne-1);
Nse=0;
count_r=0;%conter for removed pixle
numdims_o=numdims;
% while il+Nse < numdims
checker=0
F_t=ones(1,numdims_o);%0 for not tested,nt, and 1 for tested,t.
ipix_a=[1:Ne];

while checker < numdims_o
    checker=checker+Ne;
    
    il=il+Nse;
    ilo=ilo+Ne;
    
    %ipix_a=[il : min(il+9,numdims)];
    F_t(ipix_a)=0;%set the tested item to 1
    
    ipixo_a=[ilo : min(ilo+(Ne-1),numdims_o)];%[1: Ne]
    
    poshidprobs = zeros(numcases,numhid);
    %     errsum=0;
    errsum_analog=zeros(1,numdims);
    
    for batch = 1:numbatches,
        visbias = repmat(visbiases,numcases,1);
        hidbias = repmat(2*hidbiases,numcases,1);
        %%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data = batchdata(:,:,batch);
        data_analog=data;
        data = data > rand(numcases,numdims);
        
        data(:,ipix_a)=0;
        %%%%
        poshidprobs = 1./(1 + exp(-data*(2*vishid) - hidbias));
        %%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        poshidstates = poshidprobs > rand(numcases,numhid);
        negdata = 1./(1 + exp(-poshidstates*vishid' - visbias));
        negdata_analog=negdata;
        negdata = negdata > rand(numcases,numdims);
        %%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %           err= sum(sum( (data0-negdata).^2 ));
        %         err= sum(sum( (data-negdata).^2 ));
        err_analog=(sum((data_analog-negdata_analog).^2))/numcases;
        %         err_analog=(sum((data_analog(:,ipix)-negdata_analog(:,ipix)).^2))/numcases;
        
        %         errsum = err + errsum;
        errsum_analog = err_analog + errsum_analog;
        %         if rem(batch,600)==0
        %             figure(1);
        %             dispims(negdata',28,28);
        %             drawnow
        %         end
    end
    
    
    %     errmean_analog2=errsum_analog(ipix_a)/numbatches;
    %     err2t=(errmean_analog(ipix_a)-errmean_analog2);
    %     err3 = err2t./errmean_analog(ipix_a);
    %     err2_rec=[err2_rec, err3];
    
    %%%%%%%%%%%
    errmean_analog2=errsum_analog/numbatches;
    %     err2t=(errmean_analog-errmean_analog2);
    err2t=errmean_analog2-errmean_analog;
    
    err3 = err2t./errmean_analog;
    %     err2_rec=[err2_rec, err3(ipix_a)];
    
    
    %%%%
    %Remove extra pixel
    
    
    Ire= find(err3(ipix_a)< 0.2937);
    
    
    Nse=10;
    if Ire
        count_r = count_r + length(Ire);%#removed features
        
        
        numdims=numdims-length(Ire);%size(ind_a,2);
        
        %fprintf(1, 'ipix_o is %3.0f \n', ipix_o)
        %fprintf(1, ' #removed pixels is %3.0f \n', 784-numdims)
        
        Nse=Ne-length(Ire);%number of selected
        
        batchdata(:,ipix_a(Ire),:)=[];
        vishid(ipix_a(Ire),:)=[];
        visbiases(ipix_a(Ire))=[];
        
        vishidinc(ipix_a(Ire),:)=[];
        visbiasinc (ipix_a(Ire))=[];
        
        errmean_analog(ipix_a(Ire))=[];
        
        
        %         err3(ipix_a(Ire))=[];
        F_t(ipix_a(Ire))=[];%set the tested item to 1
        errmean_analog2(ipix_a(Ire))=[];
        
        ind_re=[ind_re, ind_r(ipix_a(Ire))];%record the indix of removed item
        ind_r(ipix_a(Ire))=[];
        %%%%%%%%%%%%%%%%%%%%%%%%%%5
        
        %%%learning
        %         if (count_r>=10 && maxepoch<60)
        %             count_r=0;
        %             maxepoch=maxepoch+1;
        %             epoch=epoch+1;
        %             rbm% train with reduced data
        %             %update errors:'errmean_analog' with redussed dimension
        %             pvh0
        %         end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        
        
        
    end
    % finding the next group of pixel to test by seeting zero, ipix_a:
    i_F=find(F_t==1);
    %     [b, inde]=sort(err3(i_F));
    [b, inde]=sort(errmean_analog2(i_F));
    
    
    ipix_a=i_F(inde(1:min(Ne,length(inde))));
    
   
    
end%ipix
end_tim=toc

ind_re=sort(ind_re);


save fullmnistvh vishid visbiases hidbiases epoch

%%%remove: save the new data
% switch lower(selection_method)
%     case 'mnist'
        load digit0; D(:,ind_re)=[]; save ('digit0','D');
        
        load digit1; D(:,ind_re)=[]; save ('digit1','D');
        
        load digit2; D(:,ind_re)=[]; save ('digit2','D');
        
        load digit3; D(:,ind_re)=[]; save ('digit3','D');
        
        load digit4; D(:,ind_re)=[]; save ('digit4','D');
        load digit5; D(:,ind_re)=[]; save ('digit5','D');
        load digit6; D(:,ind_re)=[]; save ('digit6','D');
        load digit7; D(:,ind_re)=[]; save ('digit7','D');
        load digit8; D(:,ind_re)=[]; save ('digit8','D');
        load digit9; D(:,ind_re)=[]; save ('digit9','D');
        
        load test0;D(:,ind_re)=[]; save ('test0','D');
        load test1;D(:,ind_re)=[]; save ('test1','D');
        load test2;D(:,ind_re)=[]; save ('test2','D');
        load test3;D(:,ind_re)=[]; save ('test3','D');
        load test4;D(:,ind_re)=[]; save ('test4','D');
        load test5;D(:,ind_re)=[]; save ('test5','D');
        load test6;D(:,ind_re)=[]; save ('test6','D');
        load test7;D(:,ind_re)=[]; save ('test7','D');
        load test8;D(:,ind_re)=[]; save ('test8','D');
        load test9;D(:,ind_re)=[]; save ('test9','D');
%     case 'dexter'
%         load ('dexter_train.mat')
%         digitdata(:,ind_re)=[];
%         save('dexter_train.mat', 'classes', 'digitdata')
%         
%         load('dexter_validation.mat')
%         val_digitdata(:,ind_re) = [];
%         save('dexter_validation.mat', 'val_classes', 'val_digitdata')
        
%     otherwise
%         %         fprintf('Unknown Data')
%         filname=[filenamSave '_train.mat'];
%         load(filname)
%         X_train(:, ind_re)=[];
%         save(filname, 'Y_train','X_train')
% 
%         
%         filname=[filenamSave '_validation.mat'];
%         load(filname)
%         X_valid(:,ind_re)=[];
%         save(filname, 'Y_valid','X_valid');
%         
        
        
% end
