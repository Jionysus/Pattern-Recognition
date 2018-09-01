% 522Lab2
% One-dimensional Pattern Space
% 1.(a)
close all    % close all figures
clear all    % clear all variables
data1d;    % load the 1-D data from the file “data1d.m”
numClass = max(y);    % number of classes found in 1(a)
numSample = length(x);    % number of samples found in 1(a)

% (b)
step = 5;    % one out of every 5 samples
for class = 1:numClass    % Get the data from one of the classes
    index = find(y == class);    % find the indices of data from the current class
    xtemp = x(index);    % put the data of the current class into 'xtemp'
    Nall(class, :) = hist(xtemp,[0:100]);    % get the bin values of the histogram
    figure; bar(Nall(class, :), 'b'); axis( [0, 100, 0, max(Nall(class, :))] )    % plot the histogram
    xlabel('Values'); ylabel('Number of elements');
    title(['Histogram of Class ', num2str(class), ' (all)'])
    %saveas(gcf, ['Histogram of Class ', num2str(class), ' (all)'], 'jpeg')
    xtemp2 = xtemp(1:step:length(xtemp));    % Extract one out of every 5 samples
    N1o5(class, :) = hist(xtemp2,[0:100]);    % get the bin values of the histogram
    figure; bar(N1o5(class, :), 'b'); axis( [0, 100, 0, max(N1o5(class, :))] )    % plot the histogram
    xlabel('Values'); ylabel('Number of elements');
    title(['Histogram of Class ', num2str(class), ' (1 out of 5)'])
end

% 2.(a)
for class = 1:numClass    % loop for each class, where numClass is the number of classes
    index = find(y == class);    % find the indices of current class's data
    xtemp = x(index);    % put the current class's data into 'xtemp'
    u(class) = mean(xtemp);    % the mean
    stddev(class) = std(xtemp);    % the standard deviation
    priori(class) = length(xtemp) / numSample;    % P(wi)
end

% (b)
numInterval = 100;    % number of intervals
maxValue = 100; minValue = 0;    % minimum and maximum values of the data
xx = minValue : (maxValue - minValue)/numInterval : maxValue;

for class = 1:numClass    % loop for each class
    % Find the probability density function (pdf) for this class
    p(class, :) = 1 / sqrt(2*pi) / stddev(class) * exp(-0.5 * ((xx - u(class))/stddev(class)).^2);
end

figure; plot(xx, p);    % plot the pdf
xlabel('x'); ylabel('p ( x | w_i )'); title('Plot of pdf of 1-D data')
legend(['Class 1'; 'Class 2'; 'Class 3'; 'Class 4'])

% 3.(a)
for class = 1:numClass    % loop for each class
    % Find the discriminant function for this class
    discriminant(class, :) = p(class, :) * priori(class);
end

fig = figure; plot(xx, discriminant)    % plot the discriminant functions
xlabel('x'); ylabel('g(x)');
title('Plot of Discriminant Functions of 1-D data')
legend(['Class 1'; 'Class 2'; 'Class 3'; 'Class 4'])

% (b)
[maxDiscri, yy] = max(discriminant);    % determine the choice 'yy'
peak = max(maxDiscri);    % find the discriminant function with maximum value
figure(fig); hold on    % call the last figure, and hold it on
plotboundary1d(xx, yy, peak)    % plot the boundaries
hold off

% (c)
% Sum of areas of the discriminant functions
total_area = sum(sum(discriminant));

% (d)
priori(2) = priori(2) + 0.1;
for i=[1,3,4]
    priori(i) = priori(i) - 0.1/3;
end
for class = 1:numClass    % loop for each class
    % Find the discriminant function for this class
    discriminant(class, :) = p(class, :) * priori(class);
end

fig2 = figure; plot(xx, discriminant)    % plot the discriminant functions
xlabel('x'); ylabel('g(x)');
title('Plot of Discriminant Functions of 1-D data (P2 +0.1)')
legend(['Class 1'; 'Class 2'; 'Class 3'; 'Class 4'])

[maxDiscri, yy] = max(discriminant);    % determine the choice 'yy'
peak = max(maxDiscri);    % find the discriminant function with maximum value
figure(fig2); hold on    % call the last figure, and hold it on
plotboundary1d(xx, yy, peak)    % plot the boundaries
hold off


% Two-dimensional Pattern Space
% 1.
close all    % close all figures
clear all    % clear all variables
data2d    % load the 2-D data from the file "data2d.m"
numClass = max(y);    % number of classes, there are ? classes
numDimension = 2;    % the dimension; it is 2
figure    % prepare to draw a figure, which is the first figure
plotdata2d(x, y);    % plot the 2-D data of different classes and return the approximate data range
xlabel('x1 (Feature 1)'); ylabel('x2 (Feature 2)')
title('2-D data'); legend(['Class 1'; 'Class 2'; 'Class 3'; 'Class 4'])

% 2.(a)
for class = 1:numClass    % loop for each class
    index = find(y == class);    % find the indices of data belonging to current class
    xtemp = x(:, index);    % put the data of the class into 'xtemp'
    % Find the mean and covariance matrix of the data
    u(:, class) = mean(xtemp, 2);    % the mean of this class
    matrix = [ ];    % for initialization
    for n = 1:numDimension    % loop for each dimension
        matrix(n,:) = xtemp(n, :) - u(n, class);
    end
    Ctemp = matrix * matrix.' / length(xtemp);    % convariance matrix
    C(:,:,class) = Ctemp;    % store the covariance matrix of this class
    priori(class) = length(y(y == class)) / length(y);    % P(wi)
end

numPoints = 50;    % set the number of points
range1(1) = 0; range2(1) = 0;
range1(2) = 100; range2(2) = 100;
x1 = range1(1) : (range1(2) - range1(1))/numPoints : range1(2);
x2 = range2(1) : (range2(2) - range2(1))/numPoints : range2(2);
[x11, x22] = ndgrid(x1, x2);
xx = [x11(:), x22(:)].';    % (:) means transforming a row vector to a column vector

% (b)
for class = 1:numClass    % loop for each class
    Ctemp = C(:, :, class);    % construct the covariance matrix of this class
    % Find the probability density function (pdf) of this class
    temp = 1 / (2*pi) * (abs(det(Ctemp)))^(-0.5);
    for n = 1:length(xx)    % loop for each data point
      tmp = xx(:, n) - u(:, class);
      ptemp(n) = temp * exp(-0.5 * tmp.' * inv(Ctemp) * tmp);
    end
    % Convert the 1D pdf, 'p', into 2-D
    p(:, :, class) = reshape(ptemp, [length(x1), length(x2)]);
end

peak = max(max(max(p)));    % find the maximum value of the pdf
figure; hold on; grid on    % hold on the 2nd figure; add major grid lines in the graph
axis([range1, range2, -peak, peak])    % set the axes of the graph
for class = 1:numClass    % loop for each class
    surfc(x11, x22, p(:, :, class))    % plot the pdf
end
xlabel('x1 (Feature 1)'); ylabel('x2 (Feature 2)'); zlabel(' p ( x | w_i )')
title('Plot of PDF of 2-D data')
hold off; view(3); rotate3d on    % set 3-D view, turn on mouse-based 3-D rotation

% 3.
for class = 1:numClass    % loop for each class
    % Find the discriminant function for this class
    discriminant(:, :, class) = p(:, :, class) * priori(class);
end

peak = max(max(max(discriminant)));    % find the maximum value of discriminant function
figure; hold on; grid on    % hold on the current figure
% add major grid lines in the graph
axis([range1, range2, -peak, peak])    % set the axes of the graph
for class = 1:numClass    % loop for each class
    surfc(x11, x22, discriminant(:, :, class))    % plot the discriminant functions
end
xlabel('x1 (Feature 1)'); ylabel('x2 (Feature 2)'); zlabel('g(x)')
title('Plot of Discriminant Functions of 2-D data')
hold off; view(3); rotate3d on    % set 3-D view, turn on mouse-based 3-D rotation

% Plot the boundaries of the classes
[maxDiscri, yy] = max(discriminant, [ ], 3);    % determine the choice 'yy'
figure; hold on    % hold the current figure on
contour(x11, x22, yy, numClass - 1)    % plot the boundaries first
plotdata2d(x, y);    % plot the data points
hold off; axis([range1, range2])    % hold the current figure off
xlabel('x1 (Feature 1)'); ylabel('x2 (Feature 2)')
title('Boundaries of 2-D data'); %legend(['Class 1'; 'Class 2'; 'Class 3'; 'Class 4'])
% Plot the boundaries of the discriminant functions
figure; hold on; axis([range1, range2])
contour(x11, x22, yy, numClass - 1)    % plot the boundaries
for class = 1:numClass    % loop for each class
    contour(x11, x22, discriminant(:, :, class))    % plot the discriminant function
end
hold off
xlabel('x1 (Feature 1)'); ylabel('x2 (Feature 2)')
title('Boundaries of the 2-D discriminant functions')

% 4.
% Plot the boundaries for each class against other classes
figureHandle = plotboundary2d(u, C, numClass, priori, range1, range2);
for class = 1:numClass    % loop for each class
    figure(figureHandle(class));    % make 'figureHandle(class)' to the current figure
    plotdata2d(x, y)    % plot data in the graph
    xlabel('x1 (Feature 1)'); ylabel('x2 (Feature 2)')
    title(['Boundaries of 2-D data of class ', num2str(class)])
    %saveas(gcf,['Boundaries of 2-D data of class ', num2str(class)],'jpeg')
end
