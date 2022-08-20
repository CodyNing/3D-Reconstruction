function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.

[~, ~, V] = svd(P);
c = V(:, end);
c = c ./ c(4);
c = c(1:3);

M = P(:, 1:3);

rev = [0, 0, 1; 0, 1, 0; 1, 0, 0];
Mr = rev * M;

[Qr, Rr] = Gram_Schmidt(Mr');

Q = rev * Qr';
R = rev * Rr' * rev;

K = R;
R = Q;

t = -R * c;

% https://en.wikipedia.org/wiki/QR_decomposition -> 
% Computing the QR decomposition ->
% Using the Gram–Schmidt process
function [Q, R] = Gram_Schmidt(A)

n = size(A, 1);
u = zeros(n, n);
Q = zeros(n, n);
R = zeros(n, n);
for i = 1: n
    u(:, i) = A(:, i);
    for j = 1: i - 1
        u(:, i) = u(:, i) - proj(u(:, j), A(:, i));
    end
    Q(:, i) = u(:, i) / norm(u(:, i));
    
    for j = i: n
        R(i, j) = Q(:, i)' * A(:, j);
    end
end

function res = proj(u, a)
res = (u' * a) / (u' * u) * u;
    