% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

function H = compute_homography( points1, points2 )

points1
points2
% points1 = a
% points2 = b / ref
[h1 w1] = find(isnan(points1(:,:)));
[h2 w2] = find(isnan(points2(:,:)));

if isempty(w1) && isempty(w2)
    n = max(w1(1),w2(1))-1;
elseif isempty(w1)
    n = w2(1)-1;
elseif isempty(w2)
    n = w1(1)-1;
else
    n = 0;
end

alpha = zeros(n, 9);
beta = zeros(n, 9);

% Get Alpha Vector
alpha(:,1) = points2(1,1:n);
alpha(:,2) = points2(2,:);
alpha(:,3) = points2(3,:);
alpha(:,4:6) = zeros(n, 3);
alpha(:,7) = -1.*points2(1,1:n).*points1(1,1:n);
alpha(:,8) = -1.*points2(2,1:n).*points1(1,1:n);
alpha(:,9) = -1.*points1(1,1:n);

% Get Beta Vector
beta(:,1:3) = zeros(n, 3);
beta(:,4) = points2(1,1:n);
beta(:,5) = points2(2,1:n);
beta(:,6) = points2(3,1:n);
beta(:,7) = -1.*points2(1,1:n).*points1(2,1:n);
beta(:,8) = -1.*points2(2,1:n).*points1(2,1:n);
beta(:,9) = -1.*points1(2,1:n);

Q = vertcat(alpha, beta);

[U,S,V] = svd(Q);

H = zeros(3,3);
H(1,:) = V(1:3, end);
H(2,:) = V(4:6, end);
H(3,:) = V(7:9, end);






