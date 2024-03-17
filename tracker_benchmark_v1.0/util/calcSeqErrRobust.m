function [aveErrCoverage, aveErrCenter,errCoverage, errCenter, errNorm_Center] = calcSeqErrRobust(results, rect_anno, bounds)
seq_length = results.len;
if size(results.res,2)==10 || size(results.res,2)==8
    rectMat = results.res(:,1:8);
    pred_center = [(results.res(:,1)+results.res(:,3)+results.res(:,5)+results.res(:,7))/4, (results.res(:,2)+results.res(:,4)+results.res(:,6)+results.res(:,8))/4];
    rectMat(1,:) = rect_anno(1,:);
    GT_centerGT = [(rect_anno(:,1)+rect_anno(:,3)+rect_anno(:,5)+rect_anno(:,7))/4, (rect_anno(:,2)+rect_anno(:,4)+rect_anno(:,6)+rect_anno(:,8))/4];
end
if size(results.res,2)==4
    rectMat = results.res(:,1:4);
    pred_center = [results.res(:,1)+ results.res(:,3)/2, results.res(:,2)+results.res(:,4)/2];
    GT_centerGT = [(rect_anno(:,1)+rect_anno(:,3)+rect_anno(:,5)+rect_anno(:,7))/4, (rect_anno(:,2)+rect_anno(:,4)+rect_anno(:,6)+rect_anno(:,8))/4];
end
index = rect_anno>0;
idx=(sum(index,2)==8);
for j = 1:size(rect_anno,1)
    centerGT = [(rect_anno(j,1)+rect_anno(j,3)+rect_anno(j,5)+rect_anno(j,7))/4, (rect_anno(j,2)+rect_anno(j,4)+rect_anno(j,6)+rect_anno(j,8))/4];
    x1 = min([rect_anno(j,1),rect_anno(j,3),rect_anno(j,5),rect_anno(j,7)]);
    y1 = min([rect_anno(j,2),rect_anno(j,4),rect_anno(j,6),rect_anno(j,8)]);
    x2 = max([rect_anno(j,1),rect_anno(j,3),rect_anno(j,5),rect_anno(j,7)]);
    y2 = max([rect_anno(j,2),rect_anno(j,4),rect_anno(j,6),rect_anno(j,8)]);
    A1 = norm(rect_anno(j,1:2)-rect_anno(j,3:4),2) * norm(rect_anno(j,3:4)-rect_anno(j,5:6),2);
    A2 = (x2-x1)*(y2-y1);
    scale = sqrt(A1 / A2);
    w_zhouduichen = scale * (x2 - x1)+1;
    h_zhouduichen = scale * (y2 - y1)+1;
    target_sz_zhouduichen(j,:) = [w_zhouduichen, h_zhouduichen];
    target_sz_new_zhouduichen(j,:) = [(x2 - x1)+1, (y2 - y1)+1];
    target_xywh_new_zhouduichen(j,:) = [x1, y1, (x2 - x1)+1, (y2 - y1)+1];
    w_qingxie = norm(rect_anno(j,1:2)-rect_anno(j,3:4),2);
    h_qingxie = norm(rect_anno(j,3:4)-rect_anno(j,5:6),2);
    target_sz_qingxie(j,:) = [w_qingxie, h_qingxie];
end
if size(results.res,2)==10 || size(results.res,2)==8
    errCenter = sqrt(sum(((pred_center(1:seq_length,:) - GT_centerGT(1:seq_length,:)).^2),2));
    errNorm_Center = sqrt(sum((((pred_center(1:seq_length,:) - GT_centerGT(1:seq_length,:))./target_sz_qingxie).^2),2));
    [errCoverage, ~, ~] = calculate_overlap(rectMat, rect_anno, bounds);
    errCenter(~idx)=-1;
    aveErrCoverage = sum(errCoverage(idx))/length(idx);
    aveErrCenter = sum(errCenter(idx))/length(idx);
    errNorm_Center(~idx)=-1;
    aveErrCenter = sum(errNorm_Center(idx))/length(idx);
end
if size(results.res,2)==4
    errCenter = sqrt(sum(((pred_center(1:seq_length,:) - GT_centerGT(1:seq_length,:)).^2),2));
    errNorm_Center = sqrt(sum((((pred_center(1:seq_length,:) - GT_centerGT(1:seq_length,:))./target_sz_new_zhouduichen).^2),2));
    errCoverage = calcRectInt(rectMat(1:seq_length,:),target_xywh_new_zhouduichen(1:seq_length,:));
    errCenter(~idx)=-1;
    aveErrCoverage = sum(errCoverage(idx))/length(idx);
    aveErrCenter = sum(errCenter(idx))/length(idx);
    errNorm_Center(~idx)=-1;
    aveErrCenter = sum(errNorm_Center(idx))/length(idx);
end

