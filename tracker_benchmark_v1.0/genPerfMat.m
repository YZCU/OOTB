function genPerfMat(seqs, trackers, evalType, nameTrkAll, perfMatPath)
pathAnno = './anno/';
numTrk = length(trackers);
thresholdSetOverlap = 0:0.05:1;
thresholdSetError = 0:30;
thresholdSetNorm_Precision = 0:0.05:1;
rpAll=['.\results\results_OPE_ootb\'];
for idxSeq=1:length(seqs)
    s = seqs{idxSeq};
    s.len = s.endFrame - s.startFrame + 1;
    s.s_frames = cell(s.len,1);
    nz	= strcat('%0',num2str(s.nz),'d');
    for i=1:s.len
        image_no = s.startFrame + (i-1);
        id = sprintf(nz,image_no);
        s.s_frames{i} = strcat(s.path,id,'.',s.ext);
    end
    rect_anno = dlmread([seqs{1,idxSeq}.path  '../groundtruth.txt']);
    numSeg = 20;
    [subSeqs, subAnno]=splitSeqTRE(s,numSeg,rect_anno);
    nameAll=[];
    for idxTrk=1:numTrk
        t = trackers{idxTrk};
        load([rpAll s.name '_' t.name '.mat'])
        disp([s.name ' ' t.name]);
        aveCoverageAll=[];
        aveErrCenterAll=[];
        errCvgAccAvgAll = 0;
        errCntAccAvgAll = 0;
        errCoverageAll = 0;
        errCenterAll = 0;
        lenALL = 0;
        switch evalType
            case 'SRE'
                idxNum = length(results);
                anno=subAnno{1};
            case 'TRE'
                idxNum = length(results);
            case 'OPE'
                idxNum = 1;
                anno=subAnno{1};
        end
        successNumOverlap = zeros(idxNum,length(thresholdSetOverlap));
        successNumErr = zeros(idxNum,length(thresholdSetError));
        successNumNorm_Err = zeros(idxNum,length(thresholdSetNorm_Precision));
        for idx = 1:idxNum
            res = results{idx};
            if strcmp(evalType, 'TRE')
                anno=subAnno{idx};
            end
            len = size(anno,1);
            if isempty(res.res)
                break;
            end
            if ~isfield(res,'type')&&isfield(res,'transformType')
                res.type = res.transformType;
                res.res = res.res';
            end
            startFrame=seqs{1,idxSeq}.startFrame;
            endFrame=seqs{1,idxSeq}.endFrame;
            anno=anno((startFrame:endFrame),:);
            img = imread(strcat(s.path,id,'.',s.ext));
            bound = [size(img,2), size(img,1)];
            [aveCoverage, aveErrCenter, errCoverage, errCenter, errNorm_Center] = calcSeqErrRobust(res, anno, bound);
            for tIdx=1:length(thresholdSetOverlap)
                successNumOverlap(idx,tIdx) = sum(errCoverage >thresholdSetOverlap(tIdx));
            end
            for tIdx=1:length(thresholdSetError)
                successNumErr(idx,tIdx) = sum(errCenter <= thresholdSetError(tIdx));
            end
            for tIdx=1:length(thresholdSetNorm_Precision)
                successNumNorm_Err(idx,tIdx) = sum(errNorm_Center <= thresholdSetNorm_Precision(tIdx));
            end
            lenALL = lenALL + len;
        end
        if strcmp(evalType, 'OPE')
            aveSuccessRatePlot(idxTrk, idxSeq,:) = successNumOverlap/(lenALL+eps);
            aveSuccessRatePlotErr(idxTrk, idxSeq,:) = successNumErr/(lenALL+eps);
            aveSuccessRatePlotNorm_Err(idxTrk, idxSeq,:) = successNumNorm_Err/(lenALL+eps);
        else
            aveSuccessRatePlot(idxTrk, idxSeq,:) = sum(successNumOverlap)/(lenALL+eps);
            aveSuccessRatePlotErr(idxTrk, idxSeq,:) = sum(successNumErr)/(lenALL+eps);
            aveSuccessRatePlotNorm_Err(idxTrk, idxSeq,:) = sum(successNumNorm_Err)/(lenALL+eps);
        end
    end
end
dataName1=[perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_overlap_' evalType '.mat'];
save(dataName1,'aveSuccessRatePlot','nameTrkAll');
dataName2=[perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_error_' evalType '.mat'];
aveSuccessRatePlot = aveSuccessRatePlotErr;
save(dataName2,'aveSuccessRatePlot','nameTrkAll');
dataName3=[perfMatPath 'aveSuccessRatePlot_' num2str(numTrk) 'alg_norm_error_' evalType '.mat'];
aveSuccessRatePlot = aveSuccessRatePlotNorm_Err;
save(dataName3,'aveSuccessRatePlot','nameTrkAll');
