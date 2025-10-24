function [] = plot2dtype2(iset)
% plot2dtype2(iset)
% Representation interval type-2 fuzzy set

xaxis = (iset.X{1})';
upper = (iset.LU{1}(:,2))';
lower = (iset.LU{1}(:,1))';
%
grey_color = 0.8;
grey = grey_color*ones(1,3);
xfill = [xaxis fliplr(xaxis)];
yfill = [upper fliplr(lower)];
%
fill(xfill,yfill,grey); hold on
plot(xaxis,upper,'r','LineWidth',2); hold on
plot(xaxis,lower,'b','LineWidth',2); hold on
