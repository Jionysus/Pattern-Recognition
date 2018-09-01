function [x, y, prior, label] = gendata(numDimension, numClass)
% GENDATA - Generate a data set with multiple dimension & multiple classes
%
% numDimension - number of dimension of each data point
% numClass - number of classes
% x - data which is D x L in size, where D is number of dimension, L is the
% number of data point
% y - a row vector which indicate which class the point is
% prior - the prior probabilities, which is a 1xN vector. N is the number
% of classes
% label - an Nx1 character array, storing the label of classes

x = [ ]; y = [ ]; label= [ ]; % for initialization
for class = 1:numClass,
    % generate number of points, mean, standard deviation randomly
    numPoints = 50 + ceil(rand * 100); % generate number of points randomly
    meanValue = ceil(rand(numDimension, 1) * 100); % generate mean randomly
    stdValue = ceil(rand(numDimension,1) * 20); % generate STD randomly
    xtemp = randn (numDimension, numPoints); % generate points randomly
    ytemp = ones (1, numPoints) * class; % indicate these points belonging this class
    for n = 1:numDimension, % loop for each dimension
        xtemp(n,:) = ... % justify all the random points to its mean and STD
            meanValue(n) + xtemp(n,:) .* stdValue(n);
    end
    % padding the data
    x = [x, xtemp];
    y = [y, ytemp];

    labeltemp = ['Class ', int2str(class)];
    label = [label; labeltemp];
end
prior = ones(1, numClass) / numClass; % generate the prior probabilities

return
