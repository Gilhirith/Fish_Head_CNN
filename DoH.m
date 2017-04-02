function [points, img_rot, head_label] = DoH(img, nfish, img_bw_label)

    global sample_ht;
    global sample_wd;
    global sigma_array;
    
%     sample_ht = 40;
%     sample_wd = 40;
    % LoG paras
    sigma_begin = 5;
    sigma_end = 15;
    sigma_step = 1;
    sigma_array = sigma_begin : sigma_step : sigma_end;
    sigma_nb = numel(sigma_array);
    min_neighbor_dis = 20;

    [img_height img_width]  = size(img);
    % Multi Scale DoH
    snlo = zeros(img_height, img_width, sigma_nb);
    for i = 1 : sigma_nb
        sigma = sigma_array(i);
        w = 3 * sigma;
        [x y] = meshgrid(-w : w, -w : w);
        sigma2 = sigma^2;
        temp =exp(-(x.^2 + y.^2) / (2 * sigma2)) / (2 * pi * sigma2);
        mxx = temp .* (x.^2 / sigma2 - 1);
        myy = temp .* (y.^2 / sigma2 - 1);
        mxy = temp .* (x.*y / sigma2);

        dxx = imfilter(img, mxx, 'replicate');
        dyy = imfilter(img, myy, 'replicate');
        dxy = imfilter(img, mxy, 'replicate');
        snlo(:, :, i) = dxx .* dyy - dxy .^ 2;
    end

    % Find Local Maximum
    snlo_dil = imdilate(snlo, ones(3, 3, 3));
    blob_candidate_index = find(snlo == snlo_dil);
    blob_candidate_value = snlo(blob_candidate_index);
    [~, index] = sort(blob_candidate_value, 'descend');

    cnt = 1;
    k = 2;
    blob_index = blob_candidate_index(index(1));
    [lig, col, sca] = ind2sub([img_height, img_width, sigma_nb], blob_index);
    pts = [lig, col, sigma_array(sca)];
    clear head_label;
    while cnt < nfish
        blob_index = blob_candidate_index(index(k));
        k = k + 1;
        [lig, col, sca] = ind2sub([img_height, img_width, sigma_nb], blob_index);
        pt = [lig, col, sigma_array(sca)];
        dis = sum(sqrt((repmat(pt, size(pts, 1), 1) - pts).^2), 2);
        if min(dis) > min_neighbor_dis
            pts(end + 1, :) = pt;
            cnt = cnt + 1;
        end
    end

    k = 1;
    for i = 1 : size(pts, 1)
        xc = pts(i, 1);
        yc = pts(i, 2);

        sigma = pts(i, 3);
        w = 3 * sigma;
        [x y] = meshgrid(-w : w, -w : w);
        sigma2 = sigma^2;
        temp = exp(-(x.^2 + y.^2) / (2 * sigma2)) / (2 * pi * sigma2);
        mxx = temp .* (x .^ 2 / sigma2 - 1);
        myy = temp .* (y .^2 / sigma2 - 1);
        mxy = temp .* (x .* y / sigma2);

        dxx = imfilter(img, mxx, 'replicate');
        dyy = imfilter(img, myy, 'replicate');
        dxy = imfilter(img, mxy, 'replicate');

        [V, D] = eig([dxx(xc, yc), dxy(xc, yc); dxy(xc, yc), dyy(xc, yc)]);
        r = D(1, 1) / D(2, 2);
        phi = atan2(V(1, 1), V(2, 1));
        a = sigma / sqrt(r);
        b = r * a;
        rect = Get_Head_Rect(yc, xc,  -phi, 5.5 * a, 5 * b);

        minx = int32(min(rect(2, :)));
        maxx = int32(max(rect(2, :)));
        miny = int32(min(rect(1, :)));
        maxy = int32(max(rect(1, :)));
        if minx < 1
            minx = 1;
        end
        if maxx > img_height
            maxx = img_height;
        end
        if miny < 1
            miny = 1;
        end
        if maxy > img_width
            maxy = img_width;
        end
        img_small = imcomplement(img(minx : maxx, miny : maxy));
% %         if size(img_small, 1) >= sample_wd && size(img_small, 2) >= sample_ht
            img_rot{k}.img = imrotate(img_small, rad2deg(-phi), 'bilinear', 'crop');
            img_rot{k}.phi = phi;
            img_rot{k}.a = a;
            img_rot{k}.b = b;
            points(k, :) = [pts(i, :), phi];
            head_label(k) = img_bw_label(int32(xc), int32(yc));
            k = k + 1;
% %         end
%         ellipsedraw(a, b, yc, xc, pi / 2 - phi)

    %     hold off;
    %     close all;
    %     axesm mercator
%         ecc = axes2ecc(a, b);
%         [elat,elon] = ellipse1(0,0,[a axes2ecc(a, b)], phi);
    %     plotm(elat,elon,'m--')
    end
end