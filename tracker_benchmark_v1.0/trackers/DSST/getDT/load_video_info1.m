function [img_files, video_path] = load_video_info1(video_path)

text_files = dir([video_path '*_frames.txt']);
f = fopen([video_path text_files(1).name]);
frames = textscan(f, '%f,%f');
fclose(f);
f = fopen([video_path text_files(1).name]);
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

