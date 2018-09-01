function plotboundary1d(xx, yy, peak)
% PLOTBOUNDARY1D - Plot decision boundaries with 1-D data
%
% xx - data point which should be a row vector
% yy - a row vector to indicate which class the data is
% peak - a maximum value of discriminant function

temp = -0.1 * peak; % set the position for plotting the region line

hold on % hold on the current figure
previousClass = yy(1); % for initialization
for n = 1:length(xx), % loop for each data point
    S = setColor(yy(n)); % set the color for this class
    plot(xx(n), temp, S); % plot the region line for this data
    
    if yy(n) ~= previousClass, % detect the boundaries
        % suppose the boundary 'lie' at the midpoint
        mid = 0.5 * (xx(n-1) + xx(n));
        stem([mid, mid], [temp, peak], 'k:.'); % plot the boundaries
        previousClass = yy(n); % update the variable 'previousClass'
    end
end
hold off % hold off the current figure
return

function S = setColor(n)
% SETCOLOR - Set which color will be used to present the point.

color_table = ['k';'b';'g';'r';'c';'m';'y'];
icolor = mod(n,7) + 1;
S = [color_table(icolor), 'o'];
return
