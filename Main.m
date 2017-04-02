% close all;
% clear all;
% clc;

global p_cnn;
global p_kf;
global nfish;
global size_sample_pool;
global trajs;
global bg_frame;
global ed_frame;
global delta_frame;
global KF_probability_sigma;
global para_p_kf;
global para_p_cnn;
global nupdate;
global img_height;
global img_width;
global bkd_img_name;
global sample_ht;
global sample_wd;
global opts;
global net;
global imdb;
global nitr;
global thr_p_cnn;
global nlayer;
global svmStruct;
global loss_thr;
global res_cnt;

%% paras
nupdate = 0;
bg_frame = 1;
ed_frame = 2000;
delta_frame = 1;
sample_ht = 48;
sample_wd = 48;
para_p_cnn = 0.5;
para_p_kf = 0.5;
nfish = 10;
nitr = 5;
loss_thr = 3;
nlayer = 10;
thr_p_cnn = 0.6;
size_sample_pool = 200 * nfish;
KF_probability_sigma = [50  0; 0 50];
meas_file = 'meas_CoreView10_1-2000_step1.mat';
bkd_img_name = 'bkd_10.bmp';

%% add path
% addpath(genpath('~/Toolbox/matcovnet/examples'));
% addpath(genpath('~/Toolbox/vlfeat'));
%% already have detection
load(meas_file);

% %% detection
% Fish_Head_Detection();

%% load SVM res
load svmStruct;

%% load CNN
% load('fish10_samples1534_48_0929_me_ori.mat', 'net');
load('fish10_samples1534_48_1009_train3.mat', 'net');

%% Build CNN
% Build_CNN();

%% tracking
Tracking();
res_cnt