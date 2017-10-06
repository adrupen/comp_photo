% H = compute_rectification_matrix(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input: points1, points2 of the form (4,n) 
%        n has to be at least 5
%
% Output:  H (4,4) matrix 
% 

function H = compute_rectification_matrix( points1, points2 )

%------------------------------
% TODO: FILL IN THIS PART

[~, n] = size(points1);

W = zeros(3 * n, 16);

p1 = points1;
p2 = points2;

i = 1;

for j = 1 : 3 : 3*n
    W(j,:) = [p1(1,i), p1(2,i), p1(3,i), p1(4,i), zeros(1,8), -p1(1,i)*p2(1,i), -p1(2,i)*p2(1,i), -p1(3,i)*p2(1,i), -p1(4,i)*p2(1,i)];
    W(j+1,:) = [zeros(1,4), p1(1,i), p1(2,i), p1(3,i), p1(4,i), zeros(1,4), -p1(1,i)*p2(2,i), -p1(2,i)*p2(2,i), -p1(3,i)*p2(2,i), -p1(4,i)*p2(2,i)];
    W(j+2,:) = [zeros(1,8), p1(1,i), p1(2,i), p1(3,i), p1(4,i), -p1(1,i)*p2(3,i), -p1(2,i)*p2(3,i), -p1(3,i)*p2(3,i), -p1(4,i)*p2(3,i)];  
    i = i + 1;
end

[~, ~, V] = svd(W);

H = zeros(4,4);
H(1,:) = V(1:4, end);
H(2,:) = V(5:8, end);
H(3,:) = V(9:12, end);
H(4,:) = V(13:16, end);
end

