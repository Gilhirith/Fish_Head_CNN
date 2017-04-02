function Tracking()

    global trajs;
    global bg_frame;
    global ed_frame;
    global delta_frame;
    global epoch;
    global nsample;
    global nfish;
    global meas;
    global p_kf;
    global p_cnn;
    global bkd_img_name;
    global nupdate;
    global img_original;
    global size_sample_pool;
    global sample_pool;
    global nsample;
    global nitr;
    global img_height;
    global img_width;
    global net;
    global nlayer;
    global svmStruct;
    global res_cnt;
    
    
    nupdate = 1;
    nsample = 0;
    
    vl_compilenn
    
    for i = 1 : nfish
        trajs{i}.traj{bg_frame}.pt = [0 0];
    end
    
    for itr = 1 : nitr
        res_cnt = 0;
        for fr = bg_frame : delta_frame : ed_frame
            fr
            img_original = im2double(imread(['CoreView10/CoreView_10_Master_Camera_', sprintf('%04d', fr), '.bmp']));
            [img_width, img_height] = size(img_original);
%             figure, imshow(img_original);
%             hold on;
            img_bg = im2double(imread(['CoreView10/', bkd_img_name]));
            img_original = imsubtract(img_bg, img_original);
        
            if fr == bg_frame - delta_frame
                for i = 1 : nfish
                    trajs{i}.traj{fr}.pt(1, 1 : 2) = [0 0];
                    trajs{i}.traj{fr}.ori = [0 0];
                    trajs{i}.loss_cnt = 0;
                end
                for i = 1 : length(meas{fr}.pts)
                    trajs{i}.traj{fr}.pt(1, 1 : 2) = meas{fr}.pts(i, 1 : 2);
                    trajs{i}.traj{fr}.ori = meas{fr}.pts(i, 4);
                end
            else
                if fr > bg_frame
                    State_Predict(fr);
                    cal_KF_probability(fr);
                end
                clear img_sample;
                for i = 1 : length(meas{fr}.pts)
                    img_sample(:, :, i) = Get_Head_Sample(meas{fr}.pts(i, 2), meas{fr}.pts(i, 1), meas{fr}.pts(i, 4), fr, i);
                end
                p_cnn = zeros(length(trajs), length(meas{fr}.pts));
                if nupdate > 0
                    net.layers{end} = struct('type', 'softmax') ;
                    for i = 1 : size(img_sample, 3)
                        res = vl_simplenn(net, single(img_sample(:, :, i)));
                    %     [~, h] = max(res(10).x);
                        p_cnn(:, i) = res(nlayer).x;
                    end
                end
%                 cal_CNN_probability(fr);
                State_Update(fr, img_sample);
                if nsample > size_sample_pool
                    CNN_update();
                    Update_Para();
                    nsample = 0;
                    nupdate = nupdate + 1;
                end
            end
%             saveas(gcf, ['fish10_res/itr', num2str(itr), '_', num2str(fr), '.jpg']);
%             close all;
        end
        res_cnt
        save(['fish10_1-2000_1001_cxe_train1_itr', num2str(itr), '.mat'], 'trajs');
    end
    
end