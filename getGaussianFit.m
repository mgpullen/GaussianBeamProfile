function [estimates, model] = getGaussianFit(x, data, start_)

% Note that this curve fitting routine has been adapted from an example
% given in MATLAB help

% Call fminsearch with the given starting point
start_point = start_;
model = @expfun;
options = optimset('MaxFunEvals', 1e6, 'MaxIter', 1e6);
estimates = fminsearch(model, start_point, options);

% expfun accepts curve parameters as inputs, and outputs sse
    function [sse, FittedCurve] = expfun(params)
        
        % Four parameters of the Gaussian curve representing the beam 
        % intensity, position, width and the background, respectively
        A = params(1);
        x0 = params(2);
        w0 = params(3);
        C = params(4);
        
        % Use the four parameters to create the curve that gets fitted to
        % the data
        FittedCurve =  A * exp(-((x - x0) .^2 ./ (2 * w0 ^ 2))) + C;
        
        % Calculated the error or cost
        ErrorVector = FittedCurve - data;
        sse = sum(ErrorVector .^ 2);
    end
end