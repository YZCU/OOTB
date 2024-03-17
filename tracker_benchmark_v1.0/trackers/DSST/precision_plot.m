    function precisions = precision_plot(positions, ground_truth, title, show)
        %PRECISION_PLOT
        %   Calculates precision for a series of distance thresholds (percentage of
        %   frames where the distance to the ground truth is within the threshold).
        %   The results are shown in a new figure if SHOW is true.
        %
        %   Accepts positions and ground truth as Nx2 matrices (for N frames), and
        %   a title string.
        %
        %   Joao F. Henriques, 2014
        %   http://www.isr.uc.pt/~henriques/


        max_threshold = 50;  %used for graphs in the paper
        %     max_threshold = 20;  %used for graphs in the paper

        precisions = zeros(max_threshold, 1);

        if size(positions,1) ~= size(ground_truth,1),
            % 		fprintf('%12s - Number of ground truth frames does not match number of tracked frames.\n', title)

            %just ignore any extra frames, in either results or ground truth
            n = min(size(positions,1), size(ground_truth,1));
            positions(n+1:end,:) = [];
            ground_truth(n+1:end,:) = [];
        end

        %calculate distances to ground truth over all frames
        distances = sqrt((positions(:,1) - ground_truth(:,1)).^2 + ...
            (positions(:,2) - ground_truth(:,2)).^2);
        distances(isnan(distances)) = [];

        %compute precisions
        for p = 1:max_threshold
            precisions(p) = nnz(distances <= p) / numel(distances);
        end

        %calculate the overlap in each dimension
        overlap_height = min(positions(:,1) + positions(:,3)/2, ground_truth(:,1) + ground_truth(:,3)/2) ...
            - max(positions(:,1) - positions(:,3)/2, ground_truth(:,1) - ground_truth(:,3)/2);
        overlap_width = min(positions(:,2) + positions(:,4)/2, ground_truth(:,2) + ground_truth(:,4)/2) ...
            - max(positions(:,2) - positions(:,4)/2, ground_truth(:,2) - ground_truth(:,4)/2);

        % if no overlap, set to zero
        overlap_height(overlap_height < 0) = 0;
        overlap_width(overlap_width < 0) = 0;

        % remove NaN values (should not exist any)
        valid_ind = ~isnan(overlap_height) & ~isnan(overlap_width);

        % calculate area
        overlap_area = overlap_height(valid_ind) .* overlap_width(valid_ind);
        tracked_area = positions(valid_ind,3) .* positions(valid_ind,4);
        ground_truth_area = ground_truth(valid_ind,3) .* ground_truth(valid_ind,4);

        % calculate PASCAL overlaps
        overlaps = overlap_area ./ (tracked_area + ground_truth_area - overlap_area);
        %% 自己：成功图+精度图
        %精度图
        if show == 1
            %系统
            figure( 'Name',strcat('Precisions - ',title) ,'NumberTitle','off')
            %自己
            plot(precisions, 'k-','Color', 'r','LineWidth',1)
            fenmu=max_threshold;
            legend(num2str(trapz(precisions)/fenmu));
            xlabel('Location error threshold'), ylabel('Precision');
            
        %成功图
            i=1;
            success_rate=zeros();
            sum_leg=length(overlaps);
            for t=0:0.01:1
                num=sum(sum(overlaps>t));
                success_rate(i)=num/sum_leg;
                i=i+1;
            end
            Overlay_threshold=0:0.01:1;%这个可以调整
            figure( 'Name',strcat('Success - ',title) ,'NumberTitle','off')
            plot(Overlay_threshold,success_rate, 'k-', 'LineWidth',1);
            legend(num2str(trapz(Overlay_threshold,success_rate)));
            xlabel('Overlay threshold'), ylabel('Success Rate');
        end
    end

