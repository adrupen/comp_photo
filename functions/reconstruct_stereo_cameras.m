% function [cams, cam_centers] = reconstruct_stereo_cameras(E, K1, K2, data); 
%
% Method:   Calculate the first and second camera matrix. 
%           The second camera matrix is unique up to scale. 
%           The essential matrix and 
%           the internal camera matrices are known. Furthermore one 
%           point is needed in order solve the ambiguity in the 
%           second camera matrix.
%
%           Requires that the number of cameras is C=2.
%
% Input:    E is a 3x3 essential matrix with the singular values (a,a,0).
%
%           K is a 3x3xC array storing the internal calibration matrix for
%           each camera.
%
%           points2d is a 3xC matrix, storing an image point for each camera.
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.
%

function [cams, cam_centers] = reconstruct_stereo_cameras( E, K, points2d )

%%
[U, S, V] = svd(E);
t = V(:,end);

cams = zeros(3,4,2);

cams(:,:,1) = K(:,:,1)*[eye(3,3), zeros(3,1)];

R = zeros(3,3,2);

W = [0, -1, 0;
     1,  0, 0;
     0,  0, 1];
R(:,:,1) = U*W*V';
R(:,:,2) = U*W'*V';

if det(R(:,:,1)) == -1
    R(:,:,1) = R(:,:,1).*-1;
end
if det(R(:,:,2)) == -1
    R(:,:,2) = R(:,:,2).*-1;
end

M_eval = zeros(3,4,4);
M_eval(:,:,1) = K(:,:,2)*R(:,:,1)*[eye(3,3), t];
M_eval(:,:,2) = K(:,:,2)*R(:,:,1)*[eye(3,3), -t];
M_eval(:,:,3) = K(:,:,2)*R(:,:,2)*[eye(3,3), t];
M_eval(:,:,4) = K(:,:,2)*R(:,:,2)*[eye(3,3), -t];

point3d = zeros(4,4);
% Find 3D points for all 4 cases
for p = 1 : 4
    cams(:,:,2) = M_eval(:,:,p);
    point3d(:,p) = reconstruct_point_cloud(cams, points2d);
    f = 1/point3d(4,p);
    point3d(:,p) = point3d(:,p).*f;
end

point_in_m1 = [eye(3,3), zeros(3,1)]*point3d(:,1);
point_in_m2 = R(:,:,1)*[eye(3,3), t]*point3d(:,1);

if not(point_in_m1(3,1) < 0) && not(point_in_m2(3,1) < 0)
    cams(:,:,2) = M_eval(:,:,1);
end

point_in_m1 = [eye(3,3), zeros(3,1)]*point3d(:,2);
point_in_m2 = R(:,:,1)*[eye(3,3), -t]*point3d(:,2);

if not(point_in_m1(3,1) < 0) && not(point_in_m2(3,1) < 0)
    cams(:,:,2) = M_eval(:,:,2);
end

point_in_m1 = [eye(3,3), zeros(3,1)]*point3d(:,3);
point_in_m2 = R(:,:,2)*[eye(3,3), t]*point3d(:,3);

if not(point_in_m1(3,1) < 0) && not(point_in_m2(3,1) < 0)
    cams(:,:,2) = M_eval(:,:,3);
end

point_in_m1 = [eye(3,3), zeros(3,1)]*point3d(:,4);
point_in_m2 = R(:,:,2)*[eye(3,3), -t]*point3d(:,4);

if not(point_in_m1(3,1) < 0) && not(point_in_m2(3,1) < 0)
    cams(:,:,2) = M_eval(:,:,4);
end

E_test = R(:,:,1) * [0, -t(3), t(2);
                     t(3), 0, -t(1);
                     -t(2), t(1), 0];
scalar = E./E_test;
cam_centers = [zeros(3,1), -t; 1, 1];



