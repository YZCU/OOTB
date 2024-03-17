function [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(video_path)
text_files = dir([video_path '*_frames.txt']);
f = fopen([video_path text_files(1).name]);
frames = textscan(f, '%f,%f');
fclose(f);
text_files = dir([video_path '*_gt.txt']);
assert(~isempty(text_files), 'No initial position and ground truth (*_gt.txt) to load.')
f = fopen([video_path text_files(1).name]);
try
    ground_truth = textscan(f, '%f,%f,%f,%f', 'ReturnOnError',false);
catch
    frewind(f);
    ground_truth = textscan(f, '%f %f %f %f');
end
ground_truth = cat(2, ground_truth{:});
fclose(f);
target_sz = [ground_truth(1,4), ground_truth(1,3)];
pos = [ground_truth(1,2), ground_truth(1,1)];
ground_truth = [ground_truth(:,[2,1]) + (ground_truth(:,[4,3]) - 1) / 2 , ground_truth(:,[4,3])];
if exist([video_path num2str(frames{1}, 'IMG1/%04i.png')], 'file'),
    video_path = [video_path 'IMG1/'];
    img_files = num2str((frames{1} : frames{2})', '%04i.png');
elseif exist([video_path num2str(frames{1}, 'IMG1/%04i.jpg')], 'file'),
    video_path = [video_path 'IMG1/'];
    img_files = num2str((frames{1} : frames{2})', '%04i.jpg');
elseif exist([video_path num2str(frames{1}, 'IMG1/%04i.bmp')], 'file'),
    video_path = [video_path 'IMG1/'];
    img_files = num2str((frames{1} : frames{2})', '%04i.bmp');
else
    error('No image files to load.')
end
img_files = cellstr(img_files);

end

