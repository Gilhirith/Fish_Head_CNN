function Fish_Head_Detection()

    global bg_frame;
    global ed_frame;
    global delta_frame;
    global bkd_img_name;
    global sample_ht;
    global sample_wd;
    global res;
    global nfish;
    global trajs;
    global meas;
    global search_radius;


    sample_ht = 48;
    sample_wd = 48;
        
    for fr = bg_frame : delta_frame : ed_frame
        fr
        img_original = im2double(imread(['CoreView_241/CoreView_241_Master_Camera_', sprintf('%05d', fr), '.bmp']));
        img_original = img_original;
%         figure, imshow(img_original);
%         hold on;
        img_bg = im2double(imread(bkd_img_name));
        img_original = imsubtract(img_bg, img_original);
        [img_height img_width]  = size(img_original);
        img_bw = im2bw(img_original, 0.2); %0.25
%         figure, imshow(img_bw);
        img_bw_label = bwlabel(img_bw);
        stats = regionprops(img_bw, 'Area');
        areas = [stats.Area];
        idx_areas = find(areas > 500);
        img_bw = ismember(img_bw_label, idx_areas);
        img_bw = imfill(img_bw, 'holes');
        se = strel('disk',1);
        img_bw = imclose(img_bw, se);
        img_bw_label = bwlabel(img_bw);

        [points, img_rot, head_label] = DoH(img_original, nfish, img_bw_label);
        meas{fr}.pts = points;

        close all;
    end

    save('meas_CoreView241_1222-2221_step1_nolimit.mat', 'meas');

end