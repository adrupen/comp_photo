% Script: uncalibrated_reconstruction.m 
%
% Method: Performs a reconstruction of two 
%         uncalibrated cameras. The Fundametal matrix determines 
%         uniquely both cameras. The point-structure is obtained 
%         by triangulation. The projective reconstruction is 
%         rectified to a metric reconstruction with knowledge 
%         about the 3D object.
%         Finally the result is stored as a VRML model 
% 

clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory

REFERENCE_VIEW      = 1;
CAMERAS             = 2;
image_names_file    = 'names_images_toyhouse.txt';

SYNTHETIC_DATA      = 1;
REAL_DATA_CLICK     = 2;
REAL_DATA_LOAD      = 3;
VERSION             = REAL_DATA_LOAD;

if VERSION == SYNTHETIC_DATA
    points2d_file = 'C:/git_repos/comp_photo/data/data_sphere.mat';
    points3d_file = 'C:/git_repos/comp_photo/data/data_sphere_reconstruction.mat';
else
    points2d_file = 'C:/git_repos/comp_photo/data/data_toyhouse.mat';
end


%% Load the 2d data

if VERSION == SYNTHETIC_DATA
    
    load( points2d_file );
    images = cell(CAMERAS,1);
    
elseif VERSION == REAL_DATA_CLICK
    
    [images image_names] = load_images_grey( image_names_file, CAMERAS ); 
    points2d = click_multi_view( images );%, CAMERAS , data, 0); % for clicking and displaying data
    save( points2d_file, 'points2d' );
    
elseif VERSION == REAL_DATA_LOAD
        
    [images,image_names] = load_images_grey( image_names_file, CAMERAS );
    load('C:/git_repos/comp_photo/data/first_five.mat');
    first_five = points2d;
    load( points2d_file );
    points2d(:,1:5,:) = first_five;
    
else
    return
end

%% Do projective reconstruction

F = compute_F_matrix( points2d );

[cameras camera_centers] = reconstruct_uncalibrated_stereo_cameras( F );

points3d = reconstruct_point_cloud( cameras, points2d );

[error_average error_max] = check_reprojection_error( points2d, cameras, points3d );
fprintf( '\n\nThe reprojection error: points2d = cameras * points3d is: \n' );
fprintf( 'Average error: %5.2fpixel; Maximum error: %5.2fpixel \n', error_average, error_max ); 


%% Rectify the projective reconstruction to a metric reconstruction

if VERSION == SYNTHETIC_DATA
    
    load( points3d_file ); % Load points3d_synthetic
    indices = [1 13 25 37 48];
    points3d_ground_truth = points3d_synthetic( :, indices );
    
else 

    % Manually provide the ground truth 3D coordinates for some points
    % in order to rectify:
  
    %------------------------------
    % FILL IN THIS PART
    indices = [1, 2, 3, 4, 5];
    unit = sqrt(sum(points3d(:,2) - points3d(:,1).^2))/ 10;
    
    points3d_ground_truth(:,1) = [0, 0, 0, 1]';
    points3d_ground_truth(:,2) = [-10, 0, 0, 1]';
    points3d_ground_truth(:,3) = [0, 0, 9, 1]';
    points3d_ground_truth(:,4) = [0, 27, 0, 1]';
    points3d_ground_truth(:,5) = [-5, 27, 15, 1]';
    
end

H = compute_rectification_matrix( points3d(:,indices), points3d_ground_truth );

% Rectify the points:

%------------------------------
% FILL IN THIS PART
%H = eye(4);
camera_centers_rec = H * camera_centers;
points3d_rec = H * points3d;

visualize_reconstruction( points3d_rec, camera_centers_rec , ...
    points2d( :, :, REFERENCE_VIEW ), images{REFERENCE_VIEW} )

