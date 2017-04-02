function State_Update(fr, img_sample)

global trajs;
global meas;
global para_p_kf;
global para_p_cnn;
global p_cnn;
global p_kf;
global nupdate;
global thr_p_cnn;
global nsample;
global svmStruct;
global loss_thr;
global delta_frame;
global bg_frame;
global res_cnt;

% costMat = Inf * ones(length(trajs), length(meas{fr}.pts));

for i = 1 : length(trajs)
    trajs{i}.traj{fr}.pt = [0 0];
end

for i = 1 : length(trajs)
    [maxp, asgn(i)] = max(p_cnn(i, :));
    if fr > bg_frame && maxp < 0.4
        asgn(i) = 0;
    end
    if fr > bg_frame && asgn(i) > 0 && p_kf(i, asgn(i)) > 50 && trajs{i}.traj{fr - delta_frame}.pt(1) ~= 0
        asgn(i) = 0;
    end
end

% for i = 1 : length(trajs)
%     for j = 1 : length(meas{fr}.pts)
% %         if p_kf(i, j) > 0.6
% %             if nupdate > 0
% %                 costMat(i, j) = 1 - p_kf(i, j) * p_cnn(i, j);
% %             else
% %                 costMat(i, j) = 1 - p_kf(i, j);
% %             end
% %         else
%             if p_cnn(i, j) >= 0.5% && trajs{i}.loss_cnt >= loss_thr
%                 costMat(i, j) = 1 - p_cnn(i, j);
%             end
% %         end
%     end
% end

% costMat = max(costMat(:)) - costMat;

% [asgn, cst] = Munkres(costMat);

table = tabulate(asgn(:));
idx = find(table(:, 2) > 1);

for i = 1 : length(idx)
    if table(idx(i), 1)  > 0 && fr > bg_frame
        meas_idx = find(asgn == table(idx(i), 1));
        dis_comp = p_kf(meas_idx, table(idx(i), 1));
        [mindis, minidx] = min(dis_comp);
        asgn(meas_idx) = 0;
        asgn(meas_idx(minidx)) = table(idx(i), 1);
    end
end

for i = 1 : length(trajs)
    if asgn(i) > 0
        res_cnt = res_cnt + 1;
        trajs{i}.loss_cnt = 0;
        trajs{i}.traj{fr}.pt(1, 1 : 2) = meas{fr}.pts(asgn(i), 1 : 2);
        trajs{i}.traj{fr}.ori = meas{fr}.pts(asgn(i), 4);
    else
        if fr > bg_frame && trajs{i}.loss_cnt < loss_thr
            trajs{i}.loss_cnt = trajs{i}.loss_cnt + 1;
            trajs{i}.traj{fr}.pt(1, 1 : 2) = trajs{i}.predict_pt;
            trajs{i}.traj{fr}.ori = trajs{i}.predict_ori;
        else
            trajs{i}.traj{fr}.pt(1, 1 : 2) = [0 0];
            trajs{i}.traj{fr}.ori = 0;
        end
    end
%     plot(trajs{i}.traj{fr}.pt(2), trajs{i}.traj{fr}.pt(1), 'b.');
%     text(trajs{i}.traj{fr}.pt(2), trajs{i}.traj{fr}.pt(1), num2str(i), 'Color', 'r', 'FontSize', 12);
end

for i = 1 : length(meas{fr}.pts)
    idx = find(asgn == i);
    if (nupdate == 0 || max(p_cnn(:, i)) < thr_p_cnn) && length(idx) > 0
        img = hogcalculator(img_sample(:, :, i));
        classes = svmclassify(svmStruct, img);
        if classes == 1
            Add_Sample(img_sample, i, idx);
            imwrite(img_sample(:, :, i), ['samples_10_2/samples_', num2str(nupdate), '_', num2str(idx), '_', num2str(fr), '.bmp']);
        end
%         nsample = nsample + 1;
%         imwrite(img_sample(:, :, i), ['samples_10/samples_', num2str(nupdate), '_', num2str(idx), '_', num2str(fr), '.bmp']);
    else
        if length(idx) > 0 && rand() > 0.93
            img = hogcalculator(img_sample(:, :, i));
            if svmclassify(svmStruct, img) == 1
                Add_Sample(img_sample, i, idx);
                imwrite(img_sample(:, :, i), ['samples_10_2/samples_', num2str(nupdate), '_', num2str(idx), '_', num2str(fr), '.bmp']);
            end
        end
    end
end

end