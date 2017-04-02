close all;
clear all;
clc;

% % make sample
% load('sample_fish10_1534_me_0929.mat');
% 
% sample_fish10 = zeros(1534, 2314);
% 
% for i = 1 : 1534
%     sample_fish10(i, 1 : 10) = single(train_y(1 : 10, i)');
%     sample_fish10(i, 11 : 2314) = reshape(train_x(:, :, i), 2304, 1);
% end
% 
% save('sample_fish10_1534_me.mat', 'sample_fish10');
% tic;

% % test MSER fish eye extraction
% fr = 1222;
% img_original = im2double(imread(['CoreView10/CoreView_10_Master_Camera_', sprintf('%04d', fr), '.bmp']));
% img_bg = im2double(imread(['CoreView10/bkd_10.bmp']));
% I = imsubtract(img_bg, img_original);
% idx = find(I < 0.05);
% I(idx) = 0;
% % I = imcomplement(I);
% regions = detectMSERFeatures(I, 'ThresholdDelta', 0.1, 'RegionAreaRange', [50, 250]);
% figure, imshow(I);
% hold on;
% 
% cnt = 0;
% for i = 1 : length(regions)
%     fg = 0;
%     for j = i + 1 : length(regions)
%         dis = sum(sqrt((regions(i).Location - regions(j).Location).^2));
%         if dis < 10
%             fg = 1;
%             break;
%         end
%     end
%     if fg == 0 && min(regions(i).Axes) > 20
%         tp = regions(i).Location;
%         cnt = cnt + 1;
%         plot(regions(i), 'showPixelList', true, 'showEllipses', true);
%         plot(tp(1), tp(2), 'r.');
%     end
% end
% plot(regions, 'showPixelList', true, 'showEllipses', true);


% train HoG-SVM fish head detector


% test HoG-SVM fish head detector
load svmStruct;
fr = 1;
for ori = 10 : 10 : 360
    img_original = im2double(imread(['CoreView10/CoreView_10_Master_Camera_', sprintf('%04d', fr), '.bmp']));
    img_original = img_original(1 : 2040, 1 : 2040);
    img_bg = im2double(imread(['CoreView10/bkd_10.bmp']));
    img_bg = img_bg(1 : 2040, 1 : 2040);
    I = imsubtract(img_bg, img_original);
    I1 = imrotate(I, ori, 'bilinear', 'loose');
    idx = find(I1 > 0.4);
    [ht, wd] = size(I1);
%     I1(idx) = 1;
    figure, imshow(img_original);
    hold on;
%     pt = [1277, 1063];
    
%     tpt(1) = floor((pt(1) + sind(-ori) * 2040) * cosd(-ori) - pt(2) * sind(-ori) - 0.5);
%     tpt(2) = ceil(pt(2) * cosd(-ori) + (pt(1) + sind(-ori) * 2040) * sind(-ori) + 0.5);% + cosd(-ori) * 2040;% + size(I1, 2) - size(img_original, 2);
    
%     plot(tpt(2), tpt(1), 'r.');
%     figure, imshow(I1);
%     hold on;
%     plot(pt(2), pt(1), 'r.');
%     tic;
    for i = 1 : length(idx)
        i
        pt(1) = mod(idx(i), ht);
        pt(2) = fix(idx(i) / ht);
        if pt(1) - 23 > 0 && pt(1) + 24 <= ht && pt(2) - 23 > 0 && pt(2) + 24 <= wd
            img_new = imcomplement(I1(pt(1) - 23 : pt(1) + 24, pt(2) - 23 : pt(2) + 24));
%             figure, imshow(img_new);
            tp_mean = mean(img_new(:));
            img_new = (img_new - mean(img_new(:))) / std(img_new(:));
            id = find(img_new >= mean(img_new(:)));
            img_new(id) = tp_mean;
            img_new = img_new - min(img_new(:));
            img_new = img_new / max(img_new(:));
%             figure, imshow(img_new);
            img = hogcalculator(img_new);
            classes = svmclassify(svmStruct, img);
            if classes == 1
                tpt(1) = floor((pt(1) + sind(-ori) * 2040) * cosd(-ori) - pt(2) * sind(-ori) - 0.5);
                tpt(2) = ceil(pt(2) * cosd(-ori) + (pt(1) + sind(-ori) * 2040) * sind(-ori) + 0.5);% + cosd(-ori) * 2040;% + size(I1, 2) - size(img_original, 2);
                plot(tpt(2), tpt(1), 'r.');
            end
        end
%         plot(ty, tx, 'r.');
    end
    tic;
end