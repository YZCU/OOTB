clc,clear;
base_path = 'D:\1matlabframe\2���Դ���\Tracker In Matlab\DSST';%���ļ��е�·��
video_path = choose_video1(base_path);

%��ȡ�ļ�����
[img_files,video_path] =load_video_info1(video_path);
num_frames = numel(img_files);

bbox=cell(num_frames);
for frame = 1:num_frames
    %load image
    im = imread([video_path img_files{frame}]);
    set(gcf,'Position',get(0,'ScreenSize'))
    % ʹͼ������Ӧ��������
    imshow(im,'border','tight','initialmagnification','fit');
    h = imrect();
    loc = getPosition(h);
    bbox{frame}=[loc(1) loc(2) loc(3) loc(4)];
    
end
ground_truth = cat(1, bbox{:});