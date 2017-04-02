function Add_sample(img_sample, meas_id, traj_id)

global nsample;
global sample_pool;
global nfish;

nsample = nsample + 1;
tp_sample = img_sample(:, :, meas_id);
sample_pool(nsample, 1 : nfish) = zeros(1, nfish);
sample_pool(nsample, traj_id) = 1;
sample_pool(nsample, nfish + 1 : nfish + length(tp_sample(:))) = reshape(tp_sample, 1, length(tp_sample(:)));



end