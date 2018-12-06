% Version 1.000
%
% Code provided by Ruslan Salakhutdinov
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


clc
clear all
close all
load('demo_pix-data')

% save('demo_pix-data')
fprintf(1, ' start to removed pixels by rbm_test9 \n')

[numcases numdims numbatches]=size(batchdata);
% poshidprobs = zeros(numcases,numhid);

%%%%%%% p(h|v), -log(P(vi=1|h)):poshidprobs_rec/ in: numdims
pvh

% save fullmnistvh vishid visbiases hidbiases %epoch
%%  remove diferent pixels
err2_rec=[];

% related to Removing extra pix
batchdata0=batchdata;
visbiases0=visbiases;
vishid0=vishid;
numdims0=numdims;
ind_re=[];
% ind_a0=[1:numdims];
% ind_a=ind_a0; %indix of adding
%%%
% numdims0=10
% for ipix=1:numdims0
batchdata1=batchdata0;
vishid1=vishid0;
visbiases1=visbiases0;
ipix=0;
ipix_o=0;
%learning
vishidinc0=vishidinc;
visbiasinc0=visbiasinc;
%%%MBF
delta_rec=[];
%%%%
%
while ipix < numdims
    % for ipix=1:numdims
    ipix=ipix+1;
    ipix_o=ipix_o+1;
    poshidprobs = zeros(numcases,numhid);
    %     errsum=0;
    errsum_analog=zeros(1,numdims);
    %MBF
    delta=0;
    %%%
    for batch = 1:numbatches,
        visbias = repmat(visbiases,numcases,1);
        hidbias = repmat(2*hidbiases,numcases,1);
        %%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data = batchdata(:,:,batch);
        data_analog=data;
        data = data > rand(numcases,numdims);
        %%%%
        poshidprobs = 1./(1 + exp(-data*(2*vishid) - hidbias));%p(h|v-)
        
        %MBF
        KL = sum((poshidprobs_rec(:,:,batch) .* (log(poshidprobs_rec(:,:,batch))-log(poshidprobs)))')';
        delta=delta+sum(negdata_analog_rec(:,batch).*KL)/numcases;
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
    %MBF
    delta=delta/numbatches;
    delta_rec=[delta_rec, delta]
    %%%
    %     figure(2); plot(errsum_analog/numbatches)
    errmean_analog2=errsum_analog(ipix)/numbatches;
    
    
    %%remove extra pixel
    %
    %     err2t=(errmean_analog(ipix_o)-errmean_analog2);
    %     err2_rec=[err2_rec, err2t/errmean_analog(ipix_o)];
    
    err2t=(errmean_analog(ipix)-errmean_analog2);%irad:by removing a pixel the original error should be updated atleast after each training
    err2_rec=[err2_rec, err2t/errmean_analog(ipix)];
    %%%%%Remove extra pixel
    
    % %     if err2_rec(ipix_o)>0
    
    if delta< 135.1908
        
        ind_re=[ind_re ipix_o];
        numdims=numdims-1;%size(ind_a,2);
        fprintf(1, 'ipix_o is %3.0f \n', ipix_o)
        fprintf(1, ' #removed pixels is %3.0f \n', 784-numdims)
        
        batchdata(:,ipix,:)=[];
        vishid(ipix,:)=[];
        visbiases(ipix)=[];
        
        vishidinc(ipix,:)=[];
        visbiasinc (ipix)=[];
        
        ipix=ipix-1;
        
        
        %%%learning
        if (mod(size(ind_re,2),10)==0) && maxepoch<60
            %             vishidinc=vishidinc0;
            %             vishidinc(ind_re, :)=[];
            %             visbiasinc=visbiasinc0;%irad:
            %             visbiasinc (ind_re)=[];
            
            maxepoch=maxepoch+1;
            epoch=epoch+1;
            rbm% train with reduced data
        end
        
        %%%%%%% p(h|v), -log(P(vi=1|h)):poshidprobs_rec/ in: numdims
        pvh
        
    end
    
    %%%%
    
    
end%ipix
%  vishidinc(ind_re, :) = [];
%  visbiasinc (ind_re) = [];
% vishidinc=vishidinc0;
% vishidinc(ind_re, :)=[];
% visbiasinc=visbiasinc0;
% visbiasinc (ind_re)=[];
save fullmnistvh vishid visbiases hidbiases epoch

%%%remove: save the new data

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
% ind_re=find(errsum_rec<errsum0);
%
% rbm_re
% save('ab7','err2_rec','errsum_rec')
