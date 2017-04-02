function Update_Para()

global para_p_kf;
global para_p_cnn;
global nupdate;

para_p_cnn = 1 / (1 + exp(-(2 * nupdate - 2)));
para_p_kf = 1 - para_p_cnn;

end