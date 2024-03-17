clc,clear;
base_path = 'D:\1matlabframe\2测试代码\Tracker In Matlab\DSST';%是文件夹的路径
video_path = choose_video1(base_path);

%获取文件名字
[img_files,video_path] =load_video_info1(video_path);
num_frames = numel(img_files);

bbox=cell(num_frames);
for frame = 1:num_frames
    %load image
    im = imread([video_path img_files{frame}]);
    set(gcf,'Position',get(0,'ScreenSize'))
    % 使图像自适应填满窗口
    imshow(im,'border','tight','initialmagnification','fit');
    h = imrect();
    loc = getPosition(h);
    bbox{frame}=[loc(1) loc(2) loc(3) loc(4)];
    
end
ground_truth = cat(1, bbox{:});