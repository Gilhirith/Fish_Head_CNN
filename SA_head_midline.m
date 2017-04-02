function img_rot = SA_head_midline(img)
    global img_sample_SA;
    
%     img = imread('samples_0_8_99.bmp');
    
    img_sample_SA = img;
    
    
%     figure, imshow(img_sample);
    
    ObjectiveFunction = @Cal_GrayScale_Value_Var;
    startingPoint = [0 0];
    lb = [-90 0];
    ub = [90 0];
    options = saoptimset('TolFun', 1e-5);
    [x, fval] = simulannealbnd(ObjectiveFunction, startingPoint, lb, ub, options);
%     rot = x(1);
%     x
    img_rot = imrotate(img, x(1), 'bilinear', 'crop');
%     img_sample_SA = img_rot(aa - 28 : aa + 28, bb - 28 : bb + 28);
%     figure, imshow(img_sample);
end