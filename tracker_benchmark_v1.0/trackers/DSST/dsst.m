function results = dsst(params)

% [positions, fps] = dsst(params)

% parameters
padding = params.padding;                         	%extra area surrounding the target%
output_sigma_factor = params.output_sigma_factor;	%spatial bandwidth (proportional to target)
params.scale_sigma_factor = 1/4;        % standard deviation for the desired scale filter output%
lambda = params.lambda;                             % regularization weight (denoted "lambda" in the paper)%
learning_rate = params.learning_rate;               % tracking model learning rate (denoted "eta" in the paper)
nScales = params.number_of_scales;                  % number of scale levels (denoted "S" in the paper)
scale_step = params.scale_step;                     % Scale increment factor (denoted "a" in the paper)%
scale_sigma_factor = params.scale_sigma_factor;     % standard deviation for the desired scale filter output%
scale_model_max_area = params.scale_model_max_area; % the maximum size of scale examples%

video_path = params.video_path;
img_files = params.img_files;   
pos = floor(params.init_pos);   
target_sz = floor(params.target_sz);

visualization = params.visualization;%

num_frames = numel(img_files);%p.totalfra

init_target_sz = target_sz;%

% target size att scale = 1
base_target_sz = target_sz;

% window size, taking padding into account
sz = floor(base_target_sz * (1 + padding));

% desired translation filter output (gaussian shaped), bandwidth
% proportional to target size
output_sigma = sqrt(prod(base_target_sz)) * output_sigma_factor;
[rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
y = exp(-0.5 * (((rs.^2 + cs.^2) / output_sigma^2)));
yf = single(fft2(y));


% desired scale filter output (gaussian shaped), bandwidth proportional to
% number of scales
scale_sigma = nScales/sqrt(33) * scale_sigma_factor;
ss = (1:nScales) - ceil(nScales/2);
ys = exp(-0.5 * (ss.^2) / scale_sigma^2);
ysf = single(fft(ys));

% store pre-computed translation filter cosine window
cos_window = single(hann(sz(1)) * hann(sz(2))');

% store pre-computed scale filter cosine window
if mod(nScales,2) == 0
    scale_window = single(hann(nScales+1));
    scale_window = scale_window(2:end);
else
    scale_window = single(hann(nScales));
end;

% scale factors
ss = 1:nScales;
scaleFactors = scale_step.^(ceil(nScales/2) - ss);

% compute the resize dimensions used for feature extraction in the scale
% estimation
scale_model_factor = 1;
if prod(init_target_sz) > scale_model_max_area
    scale_model_factor = sqrt(scale_model_max_area/prod(init_target_sz));
end
scale_model_sz = floor(init_target_sz * scale_model_factor);

currentScaleFactor = 1;

% to calculate precision
positions = zeros(numel(img_files), 4);

% to calculate FPS
time = 0;

% find maximum and minimum scales
im = imread(img_files{1}); %%% im = loding_cap(p.fp,p.ImgHeight,p.ImgWidth);
min_scale_factor = scale_step ^ ceil(log(max(5 ./ sz)) / log(scale_step));
max_scale_factor = scale_step ^ floor(log(min([size(im,1) size(im,2)] ./ base_target_sz)) / log(scale_step));

for frame = 1:num_frames,
    im = imread(img_files{frame}); 
    tic;
    
    if frame > 1
        xt = get_translation_sample(im, pos, sz, currentScaleFactor, cos_window);
        
        xtf = fft2(xt);
        response = real(ifft2(sum(hf_num .* xtf, 3) ./ (hf_den + lambda)));
        [row, col] = find(response == max(response(:)), 1);
        pos = pos + round((-sz/2 + [row, col]) * currentScaleFactor);
        xs = get_scale_sample(im, pos, base_target_sz, currentScaleFactor * scaleFactors, scale_window, scale_model_sz);
        xsf = fft(xs,[],2);
        scale_response = real(ifft(sum(sf_num .* xsf, 1) ./ (sf_den + lambda)));
        recovered_scale = find(scale_response == max(scale_response(:)), 1);
        
        currentScaleFactor = currentScaleFactor * scaleFactors(recovered_scale);
        if currentScaleFactor < min_scale_factor
            currentScaleFactor = min_scale_factor;
        elseif currentScaleFactor > max_scale_factor
            currentScaleFactor = max_scale_factor;
        end
    end
    xl = get_translation_sample(im, pos, sz, currentScaleFactor, cos_window);
    
    xlf = fft2(xl);
    new_hf_num = bsxfun(@times, yf, conj(xlf));
    new_hf_den = sum(xlf .* conj(xlf), 3);
    xs = get_scale_sample(im, pos, base_target_sz, currentScaleFactor * scaleFactors, scale_window, scale_model_sz);
    
    xsf = fft(xs,[],2);
    new_sf_num = bsxfun(@times, ysf, conj(xsf));
    new_sf_den = sum(xsf .* conj(xsf), 1);
    
    
    if frame == 1
        % first frame, train with a single image
        hf_den = new_hf_den;
        hf_num = new_hf_num;
        
        sf_den = new_sf_den;
        sf_num = new_sf_num;
    else
        % subsequent frames, update the model
        hf_den = (1 - learning_rate) * hf_den + learning_rate * new_hf_den;
        hf_num = (1 - learning_rate) * hf_num + learning_rate * new_hf_num;
        sf_den = (1 - learning_rate) * sf_den + learning_rate * new_sf_den;
        sf_num = (1 - learning_rate) * sf_num + learning_rate * new_sf_num;
    end
    
    % calculate the new target size
    target_sz = floor(base_target_sz * currentScaleFactor);
    
    %save position
%     positions(frame,:) = [pos target_sz];
    rect_position(frame,:) = [pos([2,1]) - floor(target_sz([2,1])/2), target_sz([2,1])];
    time = time + toc;
    
    
    %visualization
    if visualization == 0
        rect_position = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
        if frame == 1, 
            figure;
            im_handle = imshow(im);
            title('DSST');
            rect_handle = rectangle('Position',rect_position, 'EdgeColor','r');
            text_handle = text(5, 18, strcat('#',num2str(frame)), 'Color','r', 'FontWeight','bold', 'FontSize',15);
%             set(text_handle, 'color', [0 1 1]);
        else
            try  %subsequent frames, update GUI
                set(im_handle, 'CData', im)
                set(rect_handle, 'Position', rect_position)
                set(text_handle, 'string', strcat('#',num2str(frame)))
            catch
                return
            end
        end
        
        drawnow
%         pause
    end
end
 
fps = num_frames/time;
disp(['fps: ' num2str(fps)])

results.type = 'rect';
results.res = rect_position;
results.fps = fps;