function figureHandle = ...
    plotboundary2d(u, C, numClass, prior, range1, range2)
% PLOTBOUNDARY2D - Plot the boundaries for each class against other classes
%
% u - means of classes, should be 2xL matrix, where there is L classes.
% C - Covariance matrix, should be 2x2xL matrix, where there is L classes.
% numClass - number of classes
% prior - the prior probabilities of classes.
% range1 - range of data on 1st dimension, e.g. [-10, 100]
% range2 - range of data on 2nd dimension, e.g. [-10, 100]
% This function returns a 1xL vector, which are the handle of the figure,
% L is the number of classes.

syms a b; % prepare the symbolic objects 'a' and 'b'
for class = 1:numClass, % loop for each class
    eval(['g', num2str(class), ... % implement the discriminant function
        '= -0.5 * transpose([a; b] - u(:,class))',...
        ' * inv(C(:,:,class)) * ([a; b] - u(:,class))',...
        ' - 0.5 * log(abs(det(C(:,:,class))))',...
        '+ log(prior(class));']);
end

hLength = length(findobj('Type', 'line')); % for initialization
for class = 1:numClass, % loop for each class
    figureHandle(class) = figure; hold on % store the figure handle
    for otherClass = 1:numClass, % loop for each class
        if otherClass == class,
            continue; % skip this step
        end
        eval(['g = g', num2str(class), '- g', num2str(otherClass),';']);
        if findsym(g) == 'a', % if the equation remains the variable 'a'
            midpoint = eval('0.5 * (u(1,class) + u(1,otherClass))');
            ezplot(midpoint, 'a', [range1, range2]) % plot it as vertical line
        elseif findsym(g) == 'b', % if the equation remains the variable 'b'
            midpoint = eval('0.5 * (u(2,class) + u(2,otherClass))');
            ezplot(midpoint, [range2]) % plot it as horizontal line
        else % if the equation remains both variables 'a' and 'b'
            ezplot(g, [range1, range2]) % plot the boundaries
        end
        h = findobj('Type', 'line'); % find the line handle
        set(h(1:length(h)-hLength), 'color', setColor(otherClass), ...
            'linestyle', ':'); % set the color of the line
        hLength = length(h); % store the length of the line handle
    end
    hold off
end
return

function S = setColor(n)
% SETCOLOR - Set which color will be used to present the point.

color_table = ['k';'b';'g';'r';'c';'m';'y'];
icolor = mod(n,7) + 1;
S = color_table(icolor);
return
