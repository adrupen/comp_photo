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

[width height] = size(points1);
alpha = zeros(9, width/2);
beta = zeros(9, width/2);

for i = 1:width
    alpha()
end

%-------------------------
% TODO: FILL IN THIS PART
