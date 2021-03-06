function [net, info ] = cnn_fish(varargin)

global net;

opts.batchSize = 2 ;
opts.numEpochs = 100 ;
opts.continue = false ;
opts.gpus = [] ;
opts.learningRate = 0.001 ;
opts = vl_argparse(opts, varargin);

rng('default');
rng(0) ;

% f=1/100 ;
% net.layers = {} ;
% net.layers{end+1} = struct('type', 'conv', ...
%                            'weights', {{f*randn(5,5,1,6, 'single'), zeros(1, 6, 'single')}}, ...
%                            'stride', 1, ...
%                            'pad', 0) ;
% net.layers{end+1} = struct('type', 'pool', ...
%                            'method', 'max', ...
%                            'pool', [2 2], ...
%                            'stride', 2, ...
%                            'pad', 0) ;
% net.layers{end+1} = struct('type', 'conv', ...
%                            'weights', {{f*randn(5,5,6,12, 'single'),zeros(1,12,'single')}}, ...
%                            'stride', 1, ...
%                            'pad', 0) ;
% net.layers{end+1} = struct('type', 'pool', ...
%                            'method', 'max', ...
%                            'pool', [2 2], ...
%                            'stride', 2, ...
%                            'pad', 0) ;
% net.layers{end+1} = struct('type', 'conv', ...
%                            'weights', {{f*randn(5,5,12,12, 'single'),  zeros(1,12,'single')}}, ...
%                            'stride', 1, ...
%                            'pad', 0) ;
% % net.layers{end+1} = struct('type', 'pool', ...
% %                            'method', 'max', ...
% %                            'pool', [2 2], ...
% %                            'stride', 2, ...
% %                            'pad', 0) ;
% net.layers{end+1} = struct('type', 'conv', ...
%                            'weights', {{f*randn(5,5,12,1600, 'single'), zeros(1,1600,'single')}}, ...
%                            'stride', 1, ...
%                            'pad', 0) ;
% net.layers{end+1} = struct('type', 'relu') ;
% net.layers{end+1} = struct('type', 'conv', ...
%                            'weights', {{f*randn(1,1,1600,10, 'single'), zeros(1,10,'single')}}, ...
%                            'stride', 1, ...
%                            'pad', 0) ;
% net.layers{end+1} = struct('type', 'softmaxloss') ;



load('sample_fish10_1454_0927.mat', 'sample_fish10');
nbSample = size(sample_fish10,1);
label = sample_fish10(:,1:10); 
imdb.images.id = 1:nbSample;
imdb.images.data = single(reshape(sample_fish10(:,11:end)',48,48,1,nbSample));
[~, imdb.images.labels] = max(label');
imdb.images.set = ones(1, nbSample);

kk = randperm(nbSample); 
[net, info] = cnn_train(net, imdb, @getBatch, opts, ...
                        'val', kk(1:10:end));

% --------------------------------------------------------------------
function [im, labels] = getBatch(imdb, batch)
% --------------------------------------------------------------------
im = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
