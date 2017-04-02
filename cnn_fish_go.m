close all;
% clear all;
clc;

global net;

% cnet = net;
% 
% net.layers{end} = struct('type', 'softmaxloss');
% tic;
% [net, info] = cnn_fish();
% toc;
% cnet.layers{end} = struct('type', 'softmax');
% 
% figure(1) ; clf ; colormap gray ;
% vl_imarraysc(squeeze(cnet.layers{1}.weights{1}),'spacing',2)
% axis equal ;
% title('filters in the first layer') ;
% load('fish10_samples1534_48_0929_me_ori.mat');
load('sample_fish10_1454_0927.mat', 'sample_fish10');
nbSample = size(sample_fish10, 1);
% label = fishSamples2(:,1:10);
fishfaces = single(reshape(sample_fish10(:, 11 : end)', 48, 48, nbSample));
[~, labels] = max(sample_fish10(:, 1 : 10)');

net.layers{end} = struct('type', 'softmax');

for i = 1 : nbSample
    res = vl_simplenn(net, fishfaces(:, :, i));
    [~, h] = max(res(10).x);
    tested(i) = h;
end

bad = find(tested ~= labels)

% save('fish10_samples1534_48_1009_train2.mat', 'net');