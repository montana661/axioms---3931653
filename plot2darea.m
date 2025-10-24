function [] = plot2darea(xaxis,lower,upper,color)
% plot2darea(x,yl,yr,color)
% Representation left and right point

if nargin < 4
    grey_color = 0.8;
    color = grey_color*ones(1,3);
end
%
xfill = [xaxis fliplr(xaxis)];
yfill = [upper fliplr(lower)];
fill(xfill,yfill,color);
