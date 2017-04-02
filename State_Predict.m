function State_Predict(fr)

global trajs;
global bg_frame;
global delta_frame;
global loss_thr;

if fr > bg_frame + delta_frame
    for i = 1 : length(trajs)
        if trajs{i}.loss_cnt < 1
            if trajs{i}.traj{fr - delta_frame}.pt(1) ~= 0 && trajs{i}.traj{fr - 2 * delta_frame}.pt(1) ~= 0
                trajs{i}.predict_pt = 2 * trajs{i}.traj{fr - delta_frame}.pt - trajs{i}.traj{fr - 2 * delta_frame}.pt;
                trajs{i}.predict_ori  = 2 * trajs{i}.traj{fr - delta_frame}.ori - trajs{i}.traj{fr - 2 * delta_frame}.ori;  
            else
                trajs{i}.predict_pt = trajs{i}.traj{fr - delta_frame}.pt;
                trajs{i}.predict_ori  = trajs{i}.traj{fr - delta_frame}.ori;  
            end
        end
    end
else
    for i = 1 : length(trajs)
        trajs{i}.predict_pt = trajs{i}.traj{fr - delta_frame}.pt;
        trajs{i}.predict_ori  = trajs{i}.traj{fr - delta_frame}.ori;
    end
end