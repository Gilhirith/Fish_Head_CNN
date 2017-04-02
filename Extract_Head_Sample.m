function img_new = Extract_Head_Sample(x, y, phi, fr, id)

global sample_wd;
global sample_ht;
global img_height;
global img_width;
global img_original;
global nupdate;

rect = Get_Head_Rect(x, y, -phi, 120, 120);

minx = int32(min(rect(2, :)));
maxx = int32(max(rect(2, :)));
miny = int32(min(rect(1, :)));
maxy = int32(max(rect(1, :)));

if minx < 1
    minx = 1;
end
if maxx > img_height
    maxx = img_height;
end
if miny < 1
    miny = 1;
end
if maxy > img_width
    maxy = img_width;
end

img_ori = imcomplement(img_original(minx : maxx, miny : maxy));
img_ori = imrotate(img_ori, rad2deg(-phi), 'bilinear', 'crop');

% img_ori = SA_head_midline(img_ori);



[ht, wd] = size(img_ori);
ht_add = ht - sample_ht;
wd_add = wd - sample_wd;

img_new = ones(sample_ht, sample_wd);
if ht_add < 0
    if wd_add < 0
        img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_ori;
    else
        img_new(1 - int32(ht_add / 2) : ht - int32(ht_add / 2), :) = img_ori(:, 1 + int32(wd_add / 2) : int32(wd_add / 2) + sample_wd);
    end
else
    if wd_add < 0
        img_new(:, 1 - int32(wd_add / 2) : wd - int32(wd_add / 2)) = img_ori(1 + int32(ht_add / 2) : int32(ht_add / 2) + sample_ht, :);
    else
        img_new(:, :) = img_ori(1 + int32(ht_add / 2) : int32(ht_add / 2) + sample_ht, 1 + int32(wd_add / 2) : int32(wd_add / 2) + sample_wd);
    end
end

if mean(img_new(:, 1)) > mean(img_new(:, end))
    img_new = imrotate(img_new, 180, 'bilinear', 'crop');
end


end