function img_new = Head_Sample_Rectification(img_new)



tp_mean = mean(img_new(:));
img_new = (img_new - mean(img_new(:))) / std(img_new(:));
idx = find(img_new >= 0.5);
img_new(idx) = tp_mean;
img_new = img_new - min(img_new(:));
img_new = img_new / max(img_new(:));


end