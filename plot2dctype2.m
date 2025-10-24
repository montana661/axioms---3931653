function [] = plot2dctype2(iset,color)
% plot2dctype2(iset,color)
% Representation interval type-2 fuzzy set
if nargin == 1
    grey_color = 0.8;
    color = grey_color*ones(1,3);
end
%
xaxis = (iset.X{1})';
upper = (iset.LU{1}(:,2))';
lower = (iset.LU{1}(:,1))';
xfill = [xaxis fliplr(xaxis)];
yfill = [upper fliplr(lower)];
%
fill(xfill,yfill,color);
