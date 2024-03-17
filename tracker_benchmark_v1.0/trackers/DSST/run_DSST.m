function results=run_DSST(seq, res_path, bSaveImage)
close all;
params.padding = 1.0;         			% extra area surrounding the target
params.output_sigma_factor = 1/16;		% standard deviation for the desired translation filter output%
params.lambda = 1e-2;					% regularization weight (denoted "lambda" in the paper)
params.learning_rate = 0.025;			% tracking model learning rate (denoted "eta" in the paper)
params.number_of_scales = 33;           % number of scale levels (denoted "S" in the paper)
params.scale_step = 1.02;               % Scale increment factor (denoted "a" in the pape
params.scale_model_max_area = 512;      % the maximum size of scale examples%
params.visualization = 1;
region = seq.init_rect;
x = region(1);
y = region(2);
w = region(3);
h = region(4);
cx = x+w/2;
cy = y+h/2;
params.init_pos = floor([cy cx]);
params.target_sz = floor([h w]);
params.img_files = seq.s_frames;
params.video_path = seq.path;
results = dsst(params);
end