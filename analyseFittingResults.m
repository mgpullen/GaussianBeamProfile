clear all;
close all;
clc;

% Load the fitting results from 'fitBeamProfiles.m'
load fittingResults;

% Define the measurement x-axis
dt = 5; % 5 seconds between each measurement
ts = dt * [1:size(xParams, 1)]; % time axis in seconds
tm = ts / 60; % time axis in minutes

fgcol = [157 157 157]/255;
bgcol = [051 051 051]/255;
xcol  = [240 090 096]/255;
ycol  = [090 155 211]/255;

%% Plotting the beam profile with x,y line-outs and their respective fits

% Load the CCD images
load CCDimages pics;

% Create random number between 1- 960 to select a random measurement
% Algorithm from http://au.mathworks.com/help/matlab/math/...
% floating-point-numbers-within-specific-range.html
a = 1;
b = size(xParams, 1);
r = round((b - a) .* rand(1, 1) + a);

% Extract the random CCD image from the data set
beamProfile = pics{r};

% Find peak position in CCD image
[posX, posY] = find(beamProfile == max(max(beamProfile)));

% Calculate the Gaussian fits for both spatial directions
% x-direction
xFit = xParams(r, 1) * exp(-((ax - xParams(r, 2)) .^ 2 ./ ...
    (2 * xParams(r, 3) ^ 2))) + xParams(r, 4);

% y-direction
yFit = yParams(r, 1) * exp(-((ax - yParams(r, 2)) .^ 2 ./ ...
    (2 * yParams(r, 3) ^ 2))) + yParams(r, 4);

f1 = figure;

% Plot the x-direction line-out at the first point of maximum intensity.
% Also plot the Gaussian fit to the data on top
s1 = subplot(3, 3, [2 3]);
plot(ax, beamProfile(posX(1), :) / max(beamProfile(posX(1), :)), ...
    ':', 'Color', [90 155 211]/255, 'LineWidth', 2);
hold on;
plot(ax, xFit / max(xFit), 'Color', fgcol, 'LineWidth', 2);
set(gca, 'XTick',[]);
set(gca, 'YTick',[]);
grid off;
box on;
axis([-600 600 0 1.05]);
set(gca, 'Color', bgcol);
set(gca, 'YColor', fgcol);
set(gca, 'XColor', fgcol);
set(gca, 'FontSize', 18);

% Plot the y-direction line-out at the first point of maximum intensity.
% Also plot the Gaussian fit to the data on top
s2 = subplot(3, 3, [4 7]);
plot(-beamProfile(:, posY(1)) / max(beamProfile(:, posY(1))), -ax, ...
     ':', 'Color', [90 155 211]/255, 'LineWidth', 2);
hold on;
plot(-yFit / max(yFit), -ax, 'Color', fgcol, 'LineWidth', 2);
set(gca, 'XTick',[]);
set(gca, 'YTick',[]);
grid off;
box on;
axis([-1.05 0 -600 600]);
set(gca, 'FontSize', 18);
set(gca, 'Color', bgcol);
set(gca, 'YColor', fgcol);
set(gca, 'XColor', fgcol);

% Create a heat-map of the CCD image using the 'inferno' colormap.
% https://bids.github.io/colormap/
s3 = subplot(3, 3, [5 9]);
imagesc(ax, ax, beamProfile);
colormap(inferno);
hold on;
plot(ax, ax(posX(1)) * ones(1, 200), ':', 'Color', [90 155 211]/255, ...
    'LineWidth', 2);
plot(ax(posY(1)) * ones(1, 200), ax, ':', 'Color', [90 155 211]/255, ...
    'LineWidth', 2);

set(gca,'yaxislocation','right');
xlabel('Position in x-dimension (\mum)');
ylabel('Position in y-dimension (\mum)');
axis([-600 600 -600 600]);
set(gca, 'XTick', [-600, -400, -200, 0, 200, 400, 600]);
set(gca, 'YTick', [-600, -400, -200, 0, 200, 400, 600]);
set(gca, 'FontSize', 18);
set(gca, 'Color', bgcol);
set(gca, 'YColor', fgcol);
set(gca, 'XColor', fgcol);

% Set font style and sizes as well as setting the backgrond to white
set(findall(gcf, 'type', 'text'), 'FontSize', 18);
set(0,'defaultAxesFontName', 'Calibri');
set(0,'defaultTextFontName', 'Calibri');
set(gcf,'Color', bgcol);

% Set subplots to the size I want
% Default positions as a backup
% set(s1, 'Position', [0.4108 0.7093 0.4942 0.2157]);
% set(s2, 'Position', [0.1300 0.1100 0.2134 0.5154]);
% set(s3, 'Position', [0.4108 0.1100 0.4942 0.5154]);

set(s1, 'Position', [0.4108 0.6500 0.4942 0.1500]);
set(s2, 'Position', [0.2400 0.1100 0.1500 0.5154]);
set(s3, 'Position', [0.4108 0.1100 0.4942 0.5154]);

% Reduce the margins of the figure and set the dimensions
tightfig;
set(f1, 'Units', 'centimeters', 'Position', [8.4, 8.6, 25, 23]);

% export_fig('beamProfileFits.png','-png','-r300');

%% Plotting Guassian fit results as a function of time

f2 = figure;

% Beam intensity versus time
subplot(2,2,1);
plot(tm, xParams(:, 1), 'Color', xcol);
hold on
plot(tm, yParams(:, 1), 'Color', ycol);
xlabel('Time (minutes)', ...
    'Color', fgcol);
ylabel('Relative beam intensity (arb.)', ...
    'Color', fgcol);
set(gca, 'FontSize', 18);
set(gca, 'Color', bgcol);
set(gca, 'YColor', fgcol);
set(gca, 'XColor', fgcol);

l1 = legend('x-direction', 'y-direction');
set(l1, 'Position', [0.3138 0.6309 0.1586 0.0668]);
set(l1, 'FontSize', 18);
set(l1, 'TextColor', fgcol);

% Beam position versus time
subplot(2,2,2);
plot(tm, xParams(:, 2), 'Color', xcol);
hold on
plot(tm, yParams(:, 2), 'Color', ycol);
xlabel('Time (minutes)', ...
    'Color', fgcol);
ylabel('Beam position (\mum)', ...
    'Color', fgcol);
set(gca, 'FontSize', 18);
set(gca, 'Color', bgcol);
set(gca, 'YColor', fgcol);
set(gca, 'XColor', fgcol);

% Beam width versus time
subplot(2,2,3);
plot(tm, xParams(:, 3), 'Color', xcol);
hold on
plot(tm, yParams(:, 3), 'Color', ycol);
xlabel('Time (minutes)', ...
    'Color', fgcol);
ylabel('Beam width (\mum)', ...
    'Color', fgcol);
set(gca, 'FontSize', 18);
set(gca, 'Color', bgcol);
set(gca, 'YColor', fgcol);
set(gca, 'XColor', fgcol);

% Gaussian background parameter versus time
subplot(2,2,4);
plot(tm, xParams(:, 4), 'Color', xcol);
hold on
plot(tm, yParams(:, 4), 'Color', ycol);
xlabel('Time (minutes)', ...
    'Color', fgcol);
ylabel('Background (arb.)', ...
    'Color', fgcol);
set(gca, 'FontSize', 18);
set(gca, 'Color', bgcol);
set(gca, 'YColor', fgcol);
set(gca, 'XColor', fgcol);

% Set font style and sizes as well as setting the backgrond to white
set(findall(gcf, 'type', 'text'), 'FontSize', 18, 'Color', fgcol);
set(0,'defaultAxesFontName', 'Calibri');
set(0,'defaultTextFontName', 'Calibri');
set(gcf,'Color', bgcol);

% Reduce the margins of the figure and set the dimensions
tightfig;
set(f2, 'Units', 'centimeters', 'Position', [33.6, 8.6, 25, 23]);

% export_fig('fitTimeSeries.png','-png','-r300');
