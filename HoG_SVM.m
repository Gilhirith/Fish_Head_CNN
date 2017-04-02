close all;
clear all;
clc;

% npos = 1454;
% 
sz1 = 0;
sz2 = 0;



data = zeros(1314, 1176); % 837 + 1051

for itr = 0 : 2
    for fish = 1 : 49
        for fr = 1 : 1 : 2221
            if exist(['pos/samples_', num2str(itr), '_', num2str(fish), '_', num2str(fr), '.bmp'])
                sz1 = sz1 + 1;
                image = im2double(imread(['pos/samples_', num2str(itr), '_', num2str(fish), '_', num2str(fr), '.bmp']));
    %             image = im2double(imread(['pos/small_fish_', num2str(fish), '_', num2str(fr), '.bmp']));
    %             image = im2bw(image, mean(image(:)));
    %             for i = 1 : 10
    %                 for j = 1 : 10
    %                     img(i, j) = mean(mean(image(4 * i - 3 : 4 * i, 4 * j - 3 : 4 * j)));
    %                 end
    %             end
    %             figure, imshow(img);
    %             img = im2bw(img, mean(img(:)));
                hog = hogcalculator(image);
                data(sz1, :) = hog(:);
            end
        end
    end
end

for itr = 0 : 2
    for fish = 1 : 49
        for fr = 1 : 1 : 2221
            if exist(['neg/samples_', num2str(itr), '_', num2str(fish), '_', num2str(fr), '.bmp'])
                sz2 = sz2 + 1;
                image = im2double(imread(['neg/samples_', num2str(itr), '_', num2str(fish), '_', num2str(fr), '.bmp']));
    %         image = im2double(imread(['neg/image_', num2str(i), '.bmp']));
    %         image = im2bw(image, mean(image(:)));
    %         for i = 1 : 10
    %             for j = 1 : 10
    %                 img(i, j) = mean(mean(image(4 * i - 3 : 4 * i, 4 * j - 3 : 4 * j)));
    %             end
    %         end
    %         figure, imshow(img);
                hog = hogcalculator(image);
                data(sz2 + sz1, :) = hog(:);
            end
        end
    end
end

label1 = ones(sz1, 1);
label2 = zeros(sz2, 1);
label = [label1', label2']';
% % 
% % [train, test] = crossvalind('holdOut', label);
% % cp = classperf(label);
% svmStruct = svmtrain(data(train, :), label(train));
svmStruct = svmtrain(data, label,  'Method', 'SMO');
save svmStruct;
% % classes = svmclassify(svmStruct, data(test, :));
% % classperf(cp, classes, test);
% % cp.CorrectRate

%% ѵ����ɺ󱣴� svmStruct���ɶ�������Ķ�����з�����������ִ������ѵ���׶δ���
load svmStruct

% for fish = 1 : 10
%     for fr = 2 : 2 : 200
%         if exist(['pos/small_fish_', num2str(fish), '_', num2str(fr), '.bmp'])
%             image = im2double(imread(['pos/small_fish_', num2str(fish), '_', num2str(fr), '.bmp']));
%             image = im2bw(image, mean(image(:)));
%             for i = 1 : 10
%                 for j = 1 : 10
%                     img(i, j) = mean(mean(image(4 * i - 3 : 4 * i, 4 * j - 3 : 4 * j)));
%                 end
%             end
%             classes = svmclassify(svmStruct, img(:)') %classes��ֵ��Ϊ������
%             break;
%         end
%     end
% end

sz = 0;

for fish = 1 : 10
    for fr = 1 : 1 : 2221
        if exist(['test_SVM/neg/samples_0_', num2str(fish), '_', num2str(fr), '.bmp'])
            sz = sz + 1;
            image = im2double(imread(['test_SVM/neg/samples_0_', num2str(fish), '_', num2str(fr), '.bmp']));
            if sz == 1 || sz == 3 || sz == 5
                figure, imshow(image);
            end
            img = hogcalculator(image);
            classes(sz) = svmclassify(svmStruct, img);
        end
    end
end

for fish = 1 : 10
    for fr = 2 : 2 : 4
        if exist(['pos/small_fish_', num2str(fish), '_', num2str(fr), '.bmp'])
            sz2 = sz2 + 1;
            image = im2double(imread(['pos/small_fish_', num2str(fish), '_', num2str(fr), '.bmp']));
            
    %         image = im2bw(image, mean(image(:)));
    %         for i = 1 : 10
    %             for j = 1 : 10
    %                 img(i, j) = mean(mean(image(4 * i - 3 : 4 * i, 4 * j - 3 : 4 * j)));
    %             end
    %         end
            img = hogcalculator(image);
            classes = svmclassify(svmStruct, img)
        end
    end
end