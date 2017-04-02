function cal_KF_probability(fr)

global trajs;
global meas;
global KF_probability_sigma;
global p_kf;

for i = 1 : length(trajs)
    for j = 1 : length(meas{fr}.pts)
%         p_kf(i, j) = mvnpdf([meas{fr}.pts(j, 1) meas{fr}.pts(j, 2)], [trajs{i}.predict_pt(1) trajs{i}.predict_pt(2)], KF_probability_sigma) / mvnpdf([0 0], [0 0], KF_probability_sigma);
        p_kf(i, j) = sqrt(sum(([meas{fr}.pts(j, 1) meas{fr}.pts(j, 2)] - [trajs{i}.predict_pt(1) trajs{i}.predict_pt(2)]).^2));
    end
end

end