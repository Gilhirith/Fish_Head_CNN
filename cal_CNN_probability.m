function cal_CNN_probability(fr)

global meas;
global p_cnn;
global thr_p_cnn;
global nupdate;
global trajs;
global img_sample;

for i = 1 : length(meas{fr}.pts)
    if nupdate == 0 || max(p_cnn(:, i)) < thr_p_cnn
        Add_Sample(img_sample, i);
    end
end

end