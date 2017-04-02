function img_sample = Get_Head_Sample(x, y, phi, fr, id)

global nupdate;

img_small = Extract_Head_Sample(x, y, phi, fr, id);

img_sample = Head_Sample_Rectification(img_small);

% imwrite(img_sample, ['samples_49/samples_', num2str(nupdate), '_', num2str(id), '_', num2str(fr), '.bmp']);


end