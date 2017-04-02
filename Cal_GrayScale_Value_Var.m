function y = Cal_GrayScale_Value_Var(args)
    global img_sample_SA;

    [ht, wd] = size(img_sample_SA);
    aa = int32(ht / 2);
    bb = int32(wd / 2);
    
    
    img_rot = imrotate(img_sample_SA, args(1), 'bilinear', 'crop');
    
    img_sample_tp = img_rot(aa - 24 : aa + 25, bb - 24 : bb + 25);
%     if int32(args(2)) < 0
%         img_rot = img_rot(-int32(args(2)) : end, :);
%     else
%         args(2)
%         img_rot = img_rot(1 : end - int32(args(2)), :);
%     end
    
    [new_ht, new_wd] = size(img_sample_tp);
    
    len = fix(new_ht / 2);
    y = abs(sum(sum(flipud(img_sample_tp(1 : len, :)) - img_sample_tp(len + 1 : 2 * len, :))));
    
end