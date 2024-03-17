function val = plotDrawSave(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName,xLabelName,yLabelName,figName,metricType)
aveSuccessRate11=[];
scrsz = get(0,'ScreenSize');
fontSize = 14;
fontSizeLegend = 5.5;
fontSizeLegend = 6.5;
switch metricType
    case 'error'
        for idxTrk=1:numTrk
            tmp=aveSuccessRatePlot(idxTrk, idxSeqSet,:);
            aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
            aa=aa(sum(aa,2)>eps,:);
            if size(idxSeqSet,1)*size(idxSeqSet,2)==1
                bb=aa;
            else
                bb=mean(aa);
            end
            rankingType = 'threshold';
            
            switch rankingType
                case 'AUC'
                    perf(idxTrk) = mean(bb);
                case 'threshold'
                    perf(idxTrk) = bb(rankIdx);
            end
        end
        [tmp,indexSort]=sort(perf,'descend');
        i=1;
        AUC=[];
        figure1 = figure;
        axes1 = axes('Parent',figure1,'FontSize',10);
        for idxTrk=indexSort(1:rankNum)
            tmp=aveSuccessRatePlot(idxTrk,idxSeqSet,:);
            aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
            aa=aa(sum(aa,2)>eps,:);
            if size(idxSeqSet,1)*size(idxSeqSet,2)==1
                bb=aa;
            else
                bb=mean(aa);
            end
            switch rankingType
                case 'AUC'
                    score = mean(bb);
                    tmp=sprintf('%.3f', score);
                case 'threshold'
                    score = bb(rankIdx);
                    tmp=sprintf('%.3f', score);
            end
            tmpName{i} = ['[' tmp '] ' nameTrkAll{idxTrk}];
            h(i) = plot(thresholdSet,bb,'color',plotDrawStyle{i}.color, 'lineStyle', plotDrawStyle{i}.lineStyle,'lineWidth', 2,'Parent',axes1);  % ¼Ó´Ö
            grid on
            hold on
            i=i+1;
        end
        legend1 = legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'Location','EastOutside');
        title(titleName,'fontsize',fontSize);
        xlabel(xLabelName,'fontsize',fontSize);
        ylabel(yLabelName,'fontsize',fontSize);
        ylim([0 1])
        yticks(0:0.1:1)
        xticks(0:2.5:30)
        saveas(gcf,figName,'png');
    case 'norm_error'
        for idxTrk=1:numTrk
            tmp=aveSuccessRatePlot(idxTrk, idxSeqSet,:);
            aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
            aa=aa(sum(aa,2)>eps,:);
            if size(idxSeqSet,1)*size(idxSeqSet,2)==1
                bb=aa;
            else
                bb=mean(aa);
            end
            switch rankingType
                case 'AUC'
                    perf(idxTrk) = mean(bb);
                case 'threshold'
                    perf(idxTrk) = bb(rankIdx);
            end
        end
        [tmp,indexSort]=sort(perf,'descend');
        i=1;
        AUC=[];
        figure1 = figure;
        axes1 = axes('Parent',figure1,'FontSize',10);
        for idxTrk=indexSort(1:rankNum)
            tmp=aveSuccessRatePlot(idxTrk,idxSeqSet,:);
            aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
            aa=aa(sum(aa,2)>eps,:);
            if size(idxSeqSet,1)*size(idxSeqSet,2)==1
                bb=aa;
            else
                bb=mean(aa);
            end
            switch rankingType
                case 'AUC'
                    score = mean(bb);
                    tmp=sprintf('%.3f', score);
                case 'threshold'
                    score = bb(rankIdx);
                    tmp=sprintf('%.3f', score);
            end
            tmpName{i} = ['[' tmp '] ' nameTrkAll{idxTrk}];
            h(i) = plot(thresholdSet,bb,'color',plotDrawStyle{i}.color, 'lineStyle', plotDrawStyle{i}.lineStyle,'lineWidth', 2,'Parent',axes1);
            grid on
            hold on
            i=i+1;
        end
        legend1 = legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'Location','EastOutside');
        title(titleName,'fontsize',fontSize);
        xlabel(xLabelName,'fontsize',fontSize);
        ylabel(yLabelName,'fontsize',fontSize);
        ylim([0 1])
        yticks(0:0.1:1)
        xticks(0:0.1:1)
        saveas(gcf,figName,'png');
    case 'overlap'
        for idxTrk=1:numTrk
            tmp=aveSuccessRatePlot(idxTrk, idxSeqSet,:);
            aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
            aa=aa(sum(aa,2)>eps,:);
            if size(idxSeqSet,1)*size(idxSeqSet,2)==1
                bb=aa;
            else
                bb=mean(aa);
            end
            switch rankingType
                case 'AUC'
                    perf(idxTrk) = mean(bb);
                case 'threshold'
                    rankIdx_overlap = 71;
                    perf(idxTrk) = bb(rankIdx_overlap);
            end
        end
        [tmp,indexSort]=sort(perf,'descend');
        i=1;
        AUC=[];
        figure1 = figure;
        axes1 = axes('Parent',figure1,'FontSize',10);
        for idxTrk=indexSort(1:rankNum)
            tmp=aveSuccessRatePlot(idxTrk,idxSeqSet,:);
            aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
            aa=aa(sum(aa,2)>eps,:);
            if size(idxSeqSet,1)*size(idxSeqSet,2)==1
                bb=aa;
            else
                bb=mean(aa);
            end
            
            switch rankingType
                case 'AUC'
                    score = mean(bb);
                    tmp=sprintf('%.3f', score);
                case 'threshold'
                    rankIdx_overlap = rankIdx ;
                    score = bb(rankIdx_overlap);
                    tmp=sprintf('%.3f', score);
            end
            tmpName{i} = ['[' tmp '] ' nameTrkAll{idxTrk}];
            h(i) = plot(thresholdSet,bb,'color',plotDrawStyle{i}.color, 'lineStyle', plotDrawStyle{i}.lineStyle,'lineWidth', 2,'Parent',axes1);
            grid on
            hold on
            i=i+1;
        end
        legend1=legend(tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'Location','EastOutside');
        title(titleName,'fontsize',fontSize);
        xlabel(xLabelName,'fontsize',fontSize);
        ylabel(yLabelName,'fontsize',fontSize);
        ylim([0 1])
        grid on
        xticks(0:0.1:1)
        hold off
        saveas(gcf,figName,'png');
end
val = str2num(tmp);
end