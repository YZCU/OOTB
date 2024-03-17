clc, clear, close all
warning off all;
addpath('./util');
addpath('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox');
vl_setup
addpath(('./rstEval'));
seqs=configSeqs;
trackers=configTrackers;
shiftTypeSet = {'left','right','up','down','topLeft','topRight','bottomLeft','bottomRight','scale_8','scale_9','scale_11','scale_12'};
evalType='OPE';
diary(['./tmp/' evalType '.txt']);
numSeq=length(seqs);
numTrk=length(trackers);
finalPath = ['./results/results_' evalType '_ootb/'];
if ~exist(finalPath,'dir')
    mkdir(finalPath);
end
tmpRes_path = ['./tmp/' evalType '/'];
bSaveImage=0;
if ~exist(tmpRes_path,'dir')
    mkdir(tmpRes_path);
end
pathAnno = './anno/';
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
    img = imread(s.s_frames{1});
    [imgH,imgW,ch]=size(img);
    rect_anno = dlmread([seqs{1,idxSeq}.path  '../groundtruth.txt']);
    numSeg = 20;
    [subSeqs, subAnno]=splitSeqTRE(s,numSeg,rect_anno);
    switch evalType
        case 'OPE'
            subS = subSeqs{1};
            first_anno = subS.init_rect;
            centerGT = [(first_anno(1,1)+first_anno(1,3)+first_anno(1,5)+first_anno(1,7))/4, (first_anno(1,2)+first_anno(1,4)+first_anno(1,6)+first_anno(1,8))/4];
            xy = centerGT(1,:);
            cx = xy(1);
            cy = xy(2);
            x1 = min([first_anno(1,1),first_anno(1,3),first_anno(1,5),first_anno(1,7)]);
            y1 = min([first_anno(1,2),first_anno(1,4),first_anno(1,6),first_anno(1,8)]);
            x2 = max([first_anno(1,1),first_anno(1,3),first_anno(1,5),first_anno(1,7)]);
            y2 = max([first_anno(1,2),first_anno(1,4),first_anno(1,6),first_anno(1,8)]);
            w = (x2 - x1)+1;
            h = (y2 - y1)+1;
            x = cx - w/2;
            y = cy - h/2;
            pos = [x, y];
            target_sz = [w, h];
            subS.init_rect  = [pos,target_sz];
            subSeqs=[];
            subSeqs{1} = subS;
            subA = subAnno{1};
            subAnno=[];
            subAnno{1} = subA;
        otherwise
    end
    for idxTrk=1:numTrk
        t = trackers{idxTrk};
        if exist([finalPath s.name '_' t.name '.mat'])
            load([finalPath s.name '_' t.name '.mat']);
            bfail=checkResult(results, subAnno);
            if bfail
                disp([s.name ' '  t.name]);
            end
            continue;
        end
        results = [];
        for idx=1:length(subSeqs)
            disp([num2str(idxTrk) '_' t.name ', ' num2str(idxSeq) '_' s.name ': ' num2str(idx) '/' num2str(length(subSeqs))])
            rp = [tmpRes_path s.name '_' t.name '_' num2str(idx) '/'];
            if bSaveImage&~exist(rp,'dir')
                mkdir(rp);
            end
            subS = subSeqs{idx};
            subS.name = [subS.name '_' num2str(idx)];
            funcName = ['res=run_' t.name '(subS, rp, bSaveImage);'];
            try
                switch t.name
                    case {'VR','TM','RS','PD','MS'}
                    otherwise
                        cd(['./trackers/' t.name]);
                        addpath(genpath('./'))
                end
                eval(funcName);
                switch t.name
                    case {'VR','TM','RS','PD','MS'}
                    otherwise
                        rmpath(genpath('./'))
                        cd('../../');
                end
                if isempty(res)
                    results = [];
                    break;
                end
            catch err
                disp('error');
                rmpath(genpath('./'))
                cd('../../');
                res=[];
                continue;
            end
            res.len = subS.len;
            res.annoBegin = subS.annoBegin;
            res.startFrame = subS.startFrame;
            results{idx} = res;
        end
        save([finalPath s.name '_' t.name '.mat'], 'results');
    end
end
t=clock;
t=uint8(t(2:end));
disp([num2str(t(1)) '/' num2str(t(2)) ' ' num2str(t(3)) ':' num2str(t(4)) ':' num2str(t(5))]);