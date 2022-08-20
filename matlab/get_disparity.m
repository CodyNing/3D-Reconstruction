function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
w = (windowSize - 1) / 2;
[height, width] = size(im1);
dispM = zeros(height, width);

for y = w + 1 : height - w
    for x = w + 1 : width - w
        subim1 = double(im1(y - w: y + w, x - w: x + w));
        bestscore = 0;
        bestd = 0;
        for d = 0 : min(maxDisp, x - w - 1)
            subim2 = double(im2(y - w: y + w, x - w - d: x + w - d));
            cor = NCC(subim1, subim2);
            if cor > bestscore
                bestscore = cor;
                bestd = d;
            end
%             cor = SSD(subim1, subim2);
%             if cor < bestscore
%                 bestscore = cor;
%                 bestd = d;
%             end
        end
        dispM(y, x) = bestd;
    end
end

function sd = SSD(im1, im2)
    sd = norm(im1 - im2);

function cor = NCC(im1, im2)
    cor = sum(im1 .* im2, 'all') / sqrt(sum(im1, 'all') * sum(im2, 'all'));
