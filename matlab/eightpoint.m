function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
pts1 = pts1 / M;
pts2 = pts2 / M;

A = double(zeros(8, 9));
for i = 1: size(pts1, 1)
    x1 = pts1(i, 1);
    y1 = pts1(i, 2);
    x2 = pts2(i, 1);
    y2 = pts2(i, 2);
    A(i, :) = [x2 * x1, x2 * y1, x2, y2 * x1, y2 * y1, y2, x1, y1, 1];
end

[~, ~, V] = svd(A);
F = reshape(V(:, 9), 3, 3);
[U, S, V] = svd(F);
S(3, 3) = 0;
F = U * S * V';
F = refineF(F, pts1, pts2);
scale = eye(3) ./ M;
scale(3, 3) = 1;
F = scale' * F * scale;




