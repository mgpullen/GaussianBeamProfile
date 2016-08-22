# GaussianBeamProfile
Here I provide scripts that analyse a time series of images from a CCD chip. An experiment was performed where a CCD camera was illuminated with a focussed laser beam and the signal from the array was read out by a computer every five seconds. The data consists of 960 such images (for a total acquisition time of 80 minutes).

The goal of the data analysis is to obtain time series plots of different parameters of the lasers spatial distribution. To do this I developed an algorithm that fits a Gaussian profile in both directions (x & y) of the image. The parameters of the individual fits are then extracted and stored.

The algorithm consists of two MATLAB scripts, one MATLAB function and a MATLAB workspace:

CCDimages.mat
The MATLAB workspace file with the raw CCD output saved in a cell array.

fitBeamProfiles.m
This script loads the 960 images from the CCDimages.mat MATLAB workspace. A loop over each image is performed and the function getGaussianFit.m is called each time to determine the corresponding parameters of the Guassian distribution.

getGaussianFit.m
This function accepts (x, y) data and attempts to fit a Gaussian distribution to it starting at the intial guess that is parsed as an argument. The Gaussian parameters are returned in a vector of length four.

analyseFittingResults.m
The results from fitBeamProfiles.m are loaded and two figures are plotted. The first figure shows an example heatmap of the laser distribution from a random CCD image. Line-outs at the point of maixmum intensity are presented in both dimensions alongside their corresponding best Gaussian fits. The second image presents the results of the time series analysis. The four parameters of the Gaussian fits are plotted as a function of the measurement time.
