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

[h w] = size(points1);
alpha = [];
beta = [];

for i = 1:w
    if not(isnan(points1(1,i)) || isnan(points2(1,i)))
        alpha(i,:) = [points2(1,i) points2(2,i) points2(3,i) zeros(1,3) -1.*points2(1,i).*points1(1,i) -1.*points2(2,i).*points1(1,i) -1.*points1(1,i)];
        beta(i,:) = [zeros(1,3) points2(1,i) points2(2,i) points2(3,i) -1.*points2(1,i).*points1(2,i) -1.*points2(2,i).*points1(2,i) -1.*points1(2,i)];
    end
end

Q = vertcat(alpha, beta);

[U,S,V] = svd(Q);

H = zeros(3,3);
H(1,:) = V(1:3, end);
H(2,:) = V(4:6, end);
H(3,:) = V(7:9, end);






