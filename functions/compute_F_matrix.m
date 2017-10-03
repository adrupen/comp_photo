% function F = compute_F_matrix(points1, points2);
%
% Method:   Calculate the F matrix between two views from
%           point correspondences: points2^T * F * points1 = 0
%           We use the normalize 8-point algorithm and 
%           enforce the constraint that the three singular 
%           values are: a,b,0. The data will be normalized here. 
%           Finally we will check how good the epipolar constraints:
%           points2^T * F * points1 = 0 are fullfilled.
% 
%           Requires that the number of cameras is C=2.
% 
% Input:    points2d is a 3xNxC array storing the image points.
%
% Output:   F is a 3x3 matrix where the last singular value is zero.

function F = compute_F_matrix( points2d )


%------------------------------
%% TODO: FILL IN THIS PART

[h, w, cameras] = size(points2d);

points2d_norm = zeros(h, w, cameras);

N = compute_normalization_matrices(points2d);
points2d_norm(:,:,1) = N(:,:,1) * points2d(:,:,1);
points2d_norm(:,:,2) = N(:,:,2) * points2d(:,:,2);

Y = zeros(w,9);

Y(:,1) = points2d_norm(1,:,2) .* points2d_norm(1,:,1);
Y(:,2) = points2d_norm(1,:,2) .* points2d_norm(2,:,1);
Y(:,3) = points2d_norm(1,:,2);

Y(:,4) = points2d_norm(2,:,2) .* points2d_norm(1,:,1);
Y(:,5) = points2d_norm(2,:,2) .* points2d_norm(2,:,1);
Y(:,6) = points2d_norm(2,:,2);

Y(:,7) = points2d_norm(1,:,1);
Y(:,8) = points2d_norm(2,:,1);
Y(:,9) = 1;

[~, ~, V] = svd(Y);

E = zeros(3,3);
E(1,:) = V(1:3, end);
E(2,:) = V(4:6, end);
E(3,:) = V(7:9, end);

F = N(:,:,2)' * E * N(:,:,1);

[U, S, V] = svd(F);

S(end, end) = 0;

F = U*S*V';


