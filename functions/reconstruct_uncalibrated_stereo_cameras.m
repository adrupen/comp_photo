% function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras(F); 
%
% Method: Calculate the first and second uncalibrated camera matrix
%         from the F-matrix. 
% 
% Input:  F - Fundamental matrix with the last singular value 0 
%
% Output:   cams is a 3x4x2 array, where cams(:,:,1) is the first and 
%           cams(:,:,2) is the second camera matrix.
%
%           cam_centers is a 4x2 array, where (:,1) is the first and (:,2) 
%           the second camera center.

function [cams, cam_centers] = reconstruct_uncalibrated_stereo_cameras( F )


%------------------------------
% TODO: FILL IN THIS PART

cams = zeros(3, 4, 2);

% Ma
cams(:,:,1) = [eye(3), zeros(3,1)];

[~, ~, V] = svd(F');

h = V(:,end);

S = [ 0, -1,  1;
      1,  0, -1;
     -1,  1,  0];

% Mb
cams(:,:,2) = [S*F, h];

cam_centers = zeros(4,2);

[~, ~, Va] = svd(cams(:,:,1));
cam_centers(:,1) = Va(:,end);

[~, ~, Vb] = svd(cams(:,:,2));
cam_centers(:,2) = Vb(:,end);


