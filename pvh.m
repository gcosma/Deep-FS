%%%%%%% p(h|v), -log(P(vi=1|h)):poshidprobs_rec/ in numdims
poshidprobs=[];
poshidprobs_rec=[];
% errsum=0;
errsum_analog=zeros(size(1,numdims));
negdata_analog_rec=[];
for batch = 1:numbatches,
    %  fprintf(1,'epoch %d batch %d\r',epoch,batch);
    visbias = repmat(visbiases,numcases,1);
    hidbias = repmat(2*hidbiases,numcases,1);
    %%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data = batchdata(:,:,batch);
    data_analog=data;
    data = data > rand(numcases,numdims);
    poshidprobs = 1./(1 + exp(-data*(2*vishid) - hidbias));%p(h|v)
    %MBF
    poshidprobs_rec(:,:,batch)=poshidprobs;%%p(h|v)
    %   batchposhidprobs(:,:,batch)=poshidprobs;
    %   posprods    = data' * poshidprobs;
    %   poshidact   = sum(poshidprobs);
    %   posvisact = sum(data);
    %%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    poshidstates = poshidprobs > rand(numcases,numhid);
    negdata = 1./(1 + exp(-poshidstates*vishid' - visbias));%P(vi=1?h)
    negdata_analog=negdata;
    % MBF
    %negdata_analog_rec(:,:,batch)=negdata;%P(vi=1?h)
%     negdata_analog_rec(:,batch)=-sum(log(negdata)');%-log(P(vi=1|h))
    negdata_analog_rec(:,batch)=-sum(log(negdata)')/numdims;%-log(P(vi=1|h))

    %%%
    %     negdata = negdata > rand(numcases,numdims);
    %   neghidprobs = 1./(1 + exp(-negdata*(2*vishid) - hidbias));
    %   negprods  = negdata'*neghidprobs;
    %   neghidact = sum(neghidprobs);
    %   negvisact = sum(negdata);
    
    %%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     err= sum(sum( (data-negdata).^2 ));
    err_analog=sum((data_analog-negdata_analog).^2)/numcases;
    
    %     errsum = err + errsum;
    errsum_analog = err_analog + errsum_analog;
    %     if rem(batch,600)==0
    %         figure(1);
    %         dispims(negdata',28,28);
    %         drawnow
    %     end
end
%   fprintf(1, 'epoch %4i error %6.1f  \n', epoch, errsum);
% fprintf(1, 'error %6.1f  \n', errsum);
% errsum0=errsum;

errmean_analog=errsum_analog/numbatches;
