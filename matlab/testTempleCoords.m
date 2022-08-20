% A test script using templeCoords.mat
%
% Write your code here
%

% 1.
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
load('../data/someCorresp.mat');

% 2.
F = eightpoint(pts1, pts2, M);

% displayEpipolarF(im1, im2, F);
% return;

% 3.
load('../data/templeCoords.mat');
pts2 = epipolarCorrespondence(im1, im2, F, pts1);

% epipolarMatchGUI(im1, im2, F);
% return;

% 4.
load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);


% 5.
R1 = eye(3);
t1 = zeros(3, 1);
P1 = K1 * [R1, t1];
M2s = camera2(E);

% 6.
n = size(pts1, 1);
max_p_count = 0;
min_error = inf;

% 7.
for i = 1: 4
    P2i = K2 * M2s(:, :, i);
    temp_pts3d = triangulate(P1, pts1, P2i, pts2);
    
    epts2 = P2i * [temp_pts3d, ones(n, 1)]';
    epts2 = epts2 ./ epts2(3, :);
    error = norm(epts2(1:2, :)' - pts2) / n;
    
%     disp("error " + i + ": " + error);
%     
%     if error < min_error
%         min_error = error;
%         pts3d = temp_pts3d;
%         M2 = M2s(:, :, i);
%     end
    p_count = sum(temp_pts3d(:, 3) > 0);
%     disp(p_count);
    if p_count >= max_p_count
        max_p_count = p_count;
        pts3d = temp_pts3d;
        M2 = M2s(:, :, i);
    end
end
% disp("min error: " + min_error);
R2 = M2(:, 1:3);
t2 = M2(:, 4);

% 8.
plot3(pts3d(:, 1), pts3d(:, 2), pts3d(:, 3), '.')
axis equal

% 9.
% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
