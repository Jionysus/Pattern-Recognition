function dataRange = plotdata1d(x, y, numClass)
% PLOTDATA1D - Plot 1D data set with N clases
%
% x - data point which should be a row vector
% y - a row vector to indicate which class the data is
% numClass - number of classes
%
% This function returns 2x1 vector2s "dataRange",
% which is the approximate range of value of the data

% set the range of data and correct it to 2 nearest significant figure
% The following function is developed at the end of this program.
dataRange = setSigniRange(x);

if nargin < 3, % if the number of inputs is less than 3
    numClass = max(y); % set the number of classes to maximum value of y
end

hold on % hold the current figure on
for n = 1:numClass, % looping for each class
    index = find (y == n); % find the index of data belonging to class n
    % The following function is developed at the end of this program.
    S = setColorMark(n); % set the color for this class
    stem(index, x(index), S) % plot the data of this class
end
hold off % hold the current figure off
return

function S = setColorMark(n)
% SETCOLORMARK - Set which mark or color will be used
% to present the point.
if n > 77,
    error(['The number of sets is larger than 77,'...
            ' which beyond the limitation of this program!']);
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
