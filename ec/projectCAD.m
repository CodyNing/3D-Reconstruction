% 1.
load('../data/PnP.mat');

% 2.
P = estimate_pose(x, X);

[K, R, t] = estimate_params(P);

% 3.
pX = [X; ones(1, size(X, 2))];
pX = P * pX;
pX = pX ./ pX(3, :);

% 4.
figure;
imshow(image);
hold on;
plot(x(1, :)', x(2, :)', 'kO', 'MarkerSize', 16, 'LineWidth', 1);
hold on;
plot(pX(1, :)', pX(2, :)', 'g.', 'MarkerSize', 16, 'LineWidth', 1);

% 5.
R3d = eye(4);
R3d(1:3, 1:3) = -R;
R3d(1:3, 4) = -t;
rvs = [cad.vertices, ones(size(cad.vertices, 1), 1)]';
rvs = R3d * rvs;
rvs = rvs';
figure;
trimesh(cad.faces, rvs(:, 1), rvs(:, 2), rvs(:, 3));

% 6.
v2d = [cad.vertices, ones(size(cad.vertices, 1), 1)]';
v2d = P * v2d;
v2d = v2d ./ v2d(3, :);
v2d = v2d';
figure;
imshow(image);
hold on;
patch(v2d(:, 1), v2d(:, 2), 'c', 'faces', cad.faces, 'EdgeColor', 'none', 'FaceAlpha', 0.2);