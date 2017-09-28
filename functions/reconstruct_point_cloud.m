% function model = reconstruct_point_cloud(cam, data)
%
% Method:   Determines the 3D model points by triangulation
%           of a stereo camera system. We assume that the data 
%           is already normalized 
% 
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cameras(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
% 
% Output:   points3d 4xN matrix of all 3d points.


function points3d = reconstruct_point_cloud( cameras, points2d )

%cameras = cameras_synthetic;


[~, n, ~] = size(points2d);
points3d = zeros(4,n);

for p = 1 : n
    W = [points2d(1,p,1).*cameras(3,1,1)-cameras(1,1,1), points2d(1,p,1).*cameras(3,2,1)-cameras(1,2,1), points2d(1,p,1).*cameras(3,3,1)-cameras(1,3,1), points2d(1,p,1).*cameras(3,4,1)-cameras(1,4,1);
         points2d(2,p,1).*cameras(3,1,1)-cameras(2,1,1), points2d(2,p,1).*cameras(3,2,1)-cameras(2,2,1), points2d(2,p,1).*cameras(3,3,1)-cameras(2,3,1), points2d(2,p,1).*cameras(3,4,1)-cameras(2,4,1);
         points2d(1,p,2).*cameras(3,1,2)-cameras(1,1,2), points2d(1,p,2).*cameras(3,2,2)-cameras(1,2,2), points2d(1,p,2).*cameras(3,3,2)-cameras(1,3,2), points2d(1,p,2).*cameras(3,4,2)-cameras(1,4,2);
         points2d(2,p,2).*cameras(3,1,2)-cameras(2,1,2), points2d(2,p,2).*cameras(3,2,2)-cameras(2,2,2), points2d(2,p,2).*cameras(3,3,2)-cameras(2,3,2), points2d(2,p,2).*cameras(3,4,2)-cameras(2,4,2)
    ];
    [~, ~, V] = svd(W);
    %norm_factor = 1/V(end,end);
    points3d(:,p) = V(:,end);%.*norm_factor;
end





