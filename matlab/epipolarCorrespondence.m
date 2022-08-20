function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

n = size(pts1, 1);
pts2 = zeros(n, 2);

w = 8;

kw = 2*w+1;
kernel = fspecial('gaussian', [kw, kw], 5);

for k = 1: n
    minl2 = inf;
    
    v(1) = pts1(k, 1);
    v(2) = pts1(k, 2);
    v(3) = 1;

    l = F * v';
    s = sqrt(l(1)^2+l(2)^2);
    l = l / s;
    
    x1 = pts1(k, 1);
    y1 = pts1(k, 2);
    
    % bound window inside the images.
    x1s = int32(max(x1 - w, 1));
    x1e = int32(min(x1 + w, size(im1, 2)));
    y1s = int32(max(y1 - w, 1));
    y1e = int32(min(y1 + w, size(im1, 1)));
    subim1 = double(im1(y1s:y1e, x1s:x1e));
    
    % use larger slope so we can search for more points
    if abs(l(1)) > abs(l(2))
        e = size(im2, 1);
        for y2 = 1:e
            % define line function respect to y
            x2 = -(l(2) * y2 + l(3))/l(1);
            if x2 < 1 || x2 > size(im2, 2)
                continue
            end
            % get L2 norm
            l2 = findL2(subim1, kernel, x2, y2, w, im2);
            
            if l2 < minl2
                minl2 = l2;
                bestx = x2;
                besty = y2;
            end
        end
        
    else
        e = size(im2, 2);
        for x2 = 1:e
            % define line function respect to x
            y2 = -(l(1) * x2 + l(3))/l(2);
            if y2 < 1 || y2 > size(im2, 1)
                continue
            end
            % get L2 norm
            l2 = findL2(subim1, kernel, x2, y2, w, im2);
            
            if l2 < minl2
                minl2 = l2;
                bestx = x2;
                besty = y2;
            end
        end
    end
    
    
    pts2(k, :) = [bestx, besty];
    
end

function l2 = findL2(subim1, kernel, x2, y2, w, im2)
% bound window inside the images.
x2s = int32(max(x2 - w, 1));
x2e = int32(min(x2 + w, size(im2, 2)));
y2s = int32(max(y2 - w, 1));
y2e = int32(min(y2 + w, size(im2, 1)));

% crop window
subim2 = double(im2(y2s:y2e, x2s:x2e));

% if size match, claculate L2 norm
if size(subim1, 1) ~= size(subim2, 1) || size(subim1, 2) ~= size(subim2, 2) 
    l2 = inf;
else
    l2 = norm(kernel .* (subim1 - subim2));
end
