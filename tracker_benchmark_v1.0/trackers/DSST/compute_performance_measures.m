    function [distance_precision, PASCAL_precision, average_center_location_error] = ...
        compute_performance_measures(positions, ground_truth, distance_precision_threshold, PASCAL_threshold)

    % [distance_precision, PASCAL_precision, average_center_location_error] = ...
    %    compute_performance_measures(positions, ground_truth, distance_precision_threshold, PASCAL_threshold)
    %
    % For the given tracker output positions and ground truth it computes the:
    % * Distance Precision at the specified threshold (20 pixels as default if
    % omitted)
    % * PASCAL Precision at the specified threshold (0.5 as default if omitted)
    % * Average Center Location error (CLE).
    %
    % The tracker positions and ground truth must be Nx4-matrices where N is
    % the number of time steps in the tracking. Each row has to be on the form
    % [c1, c2, s1, s2] where (c1, c2) is the center coordinate and s1 and s2 
    % are the size in the first and second dimension respectively (the order of 
    % x and y does not matter here).

    if nargin < 3 || isempty(distance_precision_threshold)
        distance_precision_threshold = 20;
    end
    if nargin < 4 || isempty(PASCAL_threshold)
        PASCAL_threshold = 0.5;
    end
    distance_precision1 = zeros(distance_precision_threshold, 1);
    if size(positions,1) ~= size(ground_truth,1),
        disp('Could not calculate precisions, because the number of ground')
        disp('truth frames does not match the number of tracked frames.')
        %just ignore any extra frames, in either results or ground truth
            n = min(size(positions,1), size(ground_truth,1));
            positions(n+1:end,:) = [];
            ground_truth(n+1:end,:) = [];
    end

    %calculate distances to ground truth over all frames
    distances = sqrt((positions(:,1) - ground_truth(:,1)).^2 + ...
        (positions(:,2) - ground_truth(:,2)).^2);
    distances(isnan(distances)) = [];

    %calculate distance precision
    distance_precision = nnz(distances <= distance_precision_threshold) / numel(distances);
    for p = 1:distance_precision_threshold
    distance_precision1(p) = nnz(distances <= distance_precision_threshold) / numel(distances);
    end
    average_center_location_error = mean(distances);
    overlap_height = min(positions(:,1) + positions(:,3)/2, ground_truth(:,1) + ground_truth(:,3)/2) ...
        - max(positions(:,1) - positions(:,3)/2, ground_truth(:,1) - ground_truth(:,3)/2);
    overlap_width = min(positions(:,2) + positions(:,4)/2, ground_truth(:,2) + ground_truth(:,4)/2) ...
        - max(positions(:,2) - positions(:,4)/2, ground_truth(:,2) - ground_truth(:,4)/2);
    overlap_height(overlap_height < 0) = 0;
    overlap_width(overlap_width < 0) = 0;
    valid_ind = ~isnan(overlap_height) & ~isnan(overlap_width);

    % calculate area
    overlap_area = overlap_height(valid_ind) .* overlap_width(valid_ind);
    tracked_area = positions(valid_ind,3) .* positions(valid_ind,4);
    ground_truth_area = ground_truth(valid_ind,3) .* ground_truth(valid_ind,4);

    % calculate PASCAL overlaps
    overlaps = overlap_area ./ (tracked_area + ground_truth_area - overlap_area);
    PASCAL_precision = nnz(overlaps >= PASCAL_threshold) / numel(overlaps);
    title1='P';
    figure( 'Name',strcat('Precisions - ',title1) ,'NumberTitle','off')
    plot(distance_precision1, 'k-','Color', 'r','LineWidth',1)
    fenmu=distance_precision_threshold;
    legend(num2str(trapz(distance_precision1)/fenmu));
    xlabel('Location error threshold'), ylabel('Precision');
    i=1;
    success_rate=zeros();
    sum_leg=length(overlaps);
    for t=0:0.01:1
        num=sum(sum(overlaps>t));
        success_rate(i)=num/sum_leg;
        i=i+1;
    end
    title='s';
    Overlay_threshold=0:0.01:1;
    figure( 'Name',strcat('Success - ',title) ,'NumberTitle','off')
    plot(Overlay_threshold,success_rate, 'k-', 'LineWidth',1);
    legend(num2str(trapz(Overlay_threshold,success_rate)));
    xlabel('Overlay threshold'), ylabel('Success Rate');

    end