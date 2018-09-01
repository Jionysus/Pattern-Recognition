function [dataRange1, dataRange2]...
    = plotdata2d(x, y, numClass, range1, range2)
% PLOTDATA2D - Plot 2D data set with N Classes
% The maximum number of class is 77.
%
% x - data point, should be 2 x L in size, where L is number of data point
% y - a row vector which indicate which class the data is
% numClass - number of classes
% range1 - range of data on first dimension , e.g. [-10, 100]
% range2 - range of data on second dimension, e.g. [-10, 100]
% This function returns 2x1 vector2s "dataRange1", and "dataRange2",
% which are the approximate ranges of data on 1st and 2nd dimension,
% respectivily.

% set the range of data and correct it to 2 nearest significant figure
% The following function is developed at the end of this program.
dataRange1 = setSigniRange(x(1,:));
dataRange2 = setSigniRange(x(2,:));

if nargin < 5, % if the number of inputs is less than 5
    range2 = dataRange2;
end
if nargin < 4, % if the number of inputs is less than 4
    range1 = dataRange1;
end
if nargin < 3, % if the number of inputs is less than 3
    numClass = max(y); % set the number of classes to the maximum value of y
end

if numClass > 77,
    error(['The number of sets is larger than 77,'...
            ' which beyong the limitation of this program!']);
    return
end

hold on % hold the current figure on
axis([range1, range2]); % set the range of axis
for n = 1:numClass, % loop for each class
    index = find(y == n); % find the index of data related to this class
    % The following function is developed at the end of this program.
    S = setColorMark(n); % set the color and mark for this class
    plot(x(1, index), x(2, index), S) % plot the data of this class
end
hold off % hold the current figure off

function S = setColorMark(n)
% SETCOLORMARK - Set which mark or color will be used
% to present the point.
if n > 77,
    error(['The number of sets is larger than 77,'...
            ' which beyond the limitation of this program!']);
    return
end

color_table = ['k';'b';'g';'r';'c';'m';'y'];
mark_table = ['<';'o';'x';'s';'+';'*';'d';'^';'v';'p';'h'];
icolor = mod(n,7) + 1;
imark = mod(n,11) + 1;
S = [color_table(icolor), mark_table(imark)];
return

function dataRange = setSigniRange(x)
% SETSIGNIRANGE - set the range of data
% and correct it to 2 nearest signigicant figure
minValue = min(x);
maxValue = max(x);
if minValue == 0, minDigit = 0; % error if log10(0), so set "minDigit" to 0
else minDigit = floor(log10(abs(minValue))); end
if maxValue == 0, maxValue = 0; % error if log10(0), so set "maxDigit" to 0
else maxDigit = floor(log10(abs(maxValue))); end
Digit = max(minDigit, maxDigit) - 1; % choose the maximum signi. fig.
minValue = round(minValue / 10^Digit - 0.5) * 10^Digit;
maxValue = round(maxValue / 10^Digit + 0.5) * 10^Digit;
dataRange = [minValue, maxValue];
return
