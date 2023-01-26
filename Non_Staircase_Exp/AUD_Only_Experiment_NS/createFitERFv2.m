function [curve,params] = createFitERFv2(coh,PC)
%% I/O

% inputs
X = coh;
Y = PC;

% outputs
% curve - the fit line in an x/y point set
% params - the parameters of the function (sigma and mu in this case)

%% fit data


% defining a gaussian cdf here
fcn = @(b,x) (normcdf(x, b(1), b(2)));  % Objective Function (gaussian/normal)
%fcn = @(b,x) 1-(normcdf(x, b(1), b(2)));  % Objective Function (gaussian/normal INVERTED)
NRCF = @(b) norm(Y - fcn(b,X));       % Norm Residual Cost Function
params = fminsearch(NRCF, [1; 20]);   % Estimate Parameters using error minimization procedure

% x axis needs a lot of points for a smooth curve
Xplot = linspace(min(X), max(X));

%% plot fit and data
figure(1)
plot(X, Y, 'pg')
hold on
plot(Xplot, fcn(params,Xplot))
hold off
grid
text(-50, 0.65, sprintf('\\mu = %.1f\n\\sigma = %.1f', params))

curve = [Xplot',fcn(params,Xplot)'];
%curveinv= [Xplot',(1-curve(:,2))];

end
