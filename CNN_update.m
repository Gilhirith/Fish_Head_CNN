function CNN_update(varargin)

global net;
global info;
global sample_pool;
global sample_wd;
global sample_ht;
global nfish;
global nsample;

opts.batchSize = 2 ;
opts.numEpochs = 100;
opts.continue = false ;
opts.gpus = [] ;
opts.learningRate = 0.001 ;
opts = vl_argparse(opts, varargin);

net.layers{end} = struct('type', 'softmaxloss') ;

nsample = size(sample_pool, 1);
label = sample_pool(:, 1 : nfish); 
imdb.images.id = 1 : nsample;
imdb.images.data = single(reshape(sample_pool(:, nfish + 1 : end)', sample_wd, sample_ht, 1, nsample));
[~, imdb.images.labels] = max(label');
imdb.images.set = ones(1, nsample);

kk = randperm(nsample); 
[net, info] = cnn_train(net, imdb, @getBatch, opts, 'val', kk(1 : 10 : end));

end

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:, :, :, batch) ;
labels = imdb.images.labels(1, batch) ;


end