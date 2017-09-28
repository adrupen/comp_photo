% function [error_average, error_max] = check_reprojection_error(data, cam, model)
%
% Method:   Evaluates average and maximum error 
%           between the reprojected image points (cam*model) and the 
%           given image points (data), i.e. data = cam * model 
%
%           We define the error as the Euclidean distance in 2D.
%
%           Requires that the number of cameras is C=2.
%           Let N be the number of points.
%
% Input:    points2d is a 3xNxC array, storing all image points.
%
%           cameras is a 3x4xC array, where cams(:,:,1) is the first and 
%           cameras(:,:,2) is the second camera matrix.
%
%           point3d 4xN matrix of all 3d points.
%       
% Output:   
%           The average error (error_average) and maximum error (error_max)
%      

function [error_average, error_max] = check_reprojection_error( points2d, cameras, points3d )
%%
[~,n,cams] = size(points2d);

error_max = 0;
error_average = 0;
counter = 0;

for c = 1 : cams
    for i = 1 : n
        diff = homogeneous_to_cartesian(points2d(:,i,c)) - homogeneous_to_cartesian(cameras(:,:,c)*points3d(:,i));
        error = sqrt((diff(1)^2) + (diff(2)^2));
        
        error_average = error_average + error;
        counter = counter + 1;

        if(error > error_max)
            error_max = error;
        end
    end
end

error_average = error_average/counter;

