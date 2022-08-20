function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]

n = size(x, 2);
A = zeros(2 * n, 12);

for i = 1:n
    X_ = [X(:, i)', 1.];
    temp = [X_, zeros(1, 4), -x(1, i) .* X_;
            zeros(1, 4), X_, -x(2, i) .* X_];
    si = (i - 1) * 2 + 1;
    A(si: si+1, :) = temp;
end
[~, ~, V] = svd(A);
P = reshape(V(:, end), 4, 3)';