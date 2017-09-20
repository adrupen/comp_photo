% Method:   compute all normalization matrices.  
%           It is: point_norm = norm_matrix * point. The norm_points 
%           have centroid 0 and average distance = sqrt(2))
% 
%           Let N be the number of points and C the number of cameras.
%
% Input:    points2d is a 3xNxC array. Stores un-normalized homogeneous
%           coordinates for points in 2D. The data may have NaN values.
%        
% Output:   norm_mat is a 3x3xC array. Stores the normalization matrices
%           for all cameras, i.e. norm_mat(:,:,c) is the normalization
%           matrix for camera c.

function norm_mat = compute_normalization_matrices( points2d )

%-------------------------
%% TODO: FILL IN THIS PART

[h, w, cam] = size(points2d);
p_mean = zeros(3,1,cam);
n = 0;
for c = 1 : cam
    n = 0;
    for x = 1 : w
        if not(isnan(points2d(1,x,c)))
            p_mean(1,1,c) = p_mean(1,1,c) + points2d(1,x,c);
            p_mean(2,1,c) = p_mean(2,1,c) + points2d(2,x,c);
            p_mean(3,1,c) = p_mean(3,1,c) + points2d(3,x,c);
            n = n + 1;
        end
    end
    p_mean(:,:,c) = p_mean(:,:,c)./n;
end

d = zeros(cam, 1);
for c = 1 : cam
    n = 0;
    for x = 1 : w
        if not(isnan(points2d(1,x,c)))
            d(c) = d(c) + sqrt(sum(points2d(:,x,c) - p_mean(:,:,c)).^2);
            n = n + 1;
        end
    end
    d = d/n;
end

norm_mat = zeros(3,3,cam);
for c = 1 : cam
    factor = sqrt(2)/d(c);
    norm_mat(1,1,c) = 1;
    norm_mat(2,2,c) = 1;
    norm_mat(1,3,c) = -p_mean(1,1,c);
    norm_mat(2,3,c) = -p_mean(2,1,c);
    norm_mat(:,:,c) = norm_mat(:,:,c).*factor;
    norm_mat(3,3,c) = 1;
end


