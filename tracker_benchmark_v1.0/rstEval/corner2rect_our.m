function rect = corner2rect_our(points)  
left = min(points(:,1:2:end),[],2);
right = max(points(:,1:2:end),[],2);
top = min(points(:,2:2:end),[],2);
bottom = max(points(:,2:2:end),[],2);
rect = [left, top, right - left + 1, bottom - top + 1];
