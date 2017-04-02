function CNN_identification(img_sample)

global p_cnn;
global sample_wd;
global sample_ht;
global net;
global nupdate;

% if nupdate == 1
%     vl_compilenn
% end

addpath(genpath('../matlab/mex'));

for i = 1 : size(img_sample, 3)
    res = vl_simplenn(net, img_sample(:, :, i));
%     [~, h] = max(res(10).x);
    p_cnn(:, i) = res(10).x;
end

end