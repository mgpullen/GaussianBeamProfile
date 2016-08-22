clear all;
close all;
% clc;

% Load experimental data
load CCDimages;

% Define calibration parameters
pix2um = 6.5; % CCD camera is 6.5 x 6.5 um pixels
ax = pix2um * linspace(-100, 100, 200); % CCD axis

% Estimate starting parameters of fit
% Optimised values
xStart = [185, -96, 67, 0.5];
yStart = [187, -84, 66, 0.3];

% Random values
xStart = rand(1, 4);
yStart = rand(1, 4);

% Zeros
xStart = zeros(1, 4);
yStart = zeros(1, 4);

% Calculate the length of the loop
N=100;%length(pics);

% The below loop fits Gaussian curves to both the x and y directions for 
% the CCD images. The fit parameters are returned for each image.
tic;
pbar=ProgressBar(N); % Initialise a simple progress bar
for i = 1:N
    % Report progress of loop in console
    pbar.progress;
    
    % Extract the 200 x 200 pixel CCD image
    beamProfile = pics{i};
    
    % Find peak position in CCD image
    [posX, posY] = find(beamProfile == max(max(beamProfile)));
    
    % Extract Guassian parameters along the x and y directions at the
    % positions of the maximum signal
    xParams(i, :) = getGaussianFit(ax, beamProfile(posX(1), :), xStart);
    yParams(i, :) = getGaussianFit(ax, beamProfile(:, posY(1))', yStart);
end
pbar.stop;
toc;

% Save the fitting results
% save('fittingResults.mat', 'xParams', 'yParams', 'ax');