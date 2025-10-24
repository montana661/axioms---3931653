function out_imftype2 = plotmftype2(fis,varType,varIndex,numPts)
%   function out_imftype2=plotmftype2(fis,varType,varIndex,numPts)
%   PLOTIMFTYPE2 Display all of the interval type-2 membership functions for a given variable.
%   PLOTIMFTYPE2(fismat,varType,varIndex) plots all of the interval type-2 membership functions
%   in the IT2FIS called fismat associated with a given variable whose type 
%   (input or output) and index are respectively given by varType and 
%   varIndex. This function can also be used with the MATLAB function
%   subplot.
%
%   out_imftype2=PLOTIMFTYPE2(fismat,varType,varIndex) returns the x and y data
%   points associated with the interval type-2 membership functions without plotting them.
%
%   PLOTIMFTYPE2(fismat,varType,varIndex,numPts) generates the same plot with
%   exactly numPts points plotted along the curve.
%

%   Juan R. Castro, 7-25-2005, 11-9-2013.
%   Copyright 2006-2013 FCQI, UABC 
%   $Revision: 1.11 $  $Date: 2012/02/15 18:24:22 $

if nargin<4, numPts=181; end
%
fisType=fis.type;
%
if ~strcmp(varType,'input') && (~strcmp(varType,'output') || strcmp(fisType,'sugeno'))
    error('No plots for Sugeno Output IT2MFs')
end
%
if strcmp(varType, 'input')
 if isfield(fis.input(varIndex), 'mf')
   numMFs=size(fis.input(varIndex).mf, 2);
 else
   numMFs = 0;
 end
 var=fis.input(varIndex);
else
 if isfield(fis.output(varIndex), 'mf')
   numMFs=size(fis.output(varIndex).mf, 2);
 else
   numMFs=0;
 end
 var=fis.output(varIndex);
end
%
y=zeros(numPts,numMFs);
%
xPts=linspace(var.range(1),var.range(2),numPts)';
x=xPts(:,ones(numMFs,1));
for mfIndex=1:numMFs    
    mfType=var.mf(mfIndex).type;
    mfParams=var.mf(mfIndex).params;
    imftype2{mfIndex}=evalmftype2(xPts',mfParams,mfType);
    y(:,mfIndex) = imftype2{mfIndex}.LU{1}(:,2);
end
%
if nargout<1
    xlabel(var.name);
    % ylabel('Degree of membership')
    for mfIndex=1:numMFs
        plot2dtype2(imftype2{mfIndex}); hold on
        centerIndex=find(y(:,mfIndex)==max(y(:,mfIndex)));
        centerIndex=floor(mean(centerIndex));
        text(x(centerIndex,mfIndex),1.05,var.mf(mfIndex).name, ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'FontSize',10)
    end
    %
    if strcmp(fis.inputsFuzzifier,'non-singleton') && (~strcmp(varType,'output'))
        xlabel(var.name);
        % ylabel('Degree of membership')
        xp = var.range(1)+(var.range(2)-var.range(1))/2;
        paramx = var.mfx.params;
        mfxparams = getmfxparam(xp,paramx,var.mfx.type);
        imfxtype2 = evalmftype2(xPts',mfxparams,var.mfx.type);
        yy = imfxtype2.LU{1}(:,2);
        plot2dctype2(imfxtype2,'g');
        %         centerIndex=find(yy(:)==max(yy(:)));
        %         centerIndex=floor(mean(centerIndex));
        %         text(x(centerIndex,mfIndex),1.05,var.mfx.name, ...
        %             'HorizontalAlignment','center', ...
        %             'VerticalAlignment','middle', ...
        %             'FontSize',10)
    end
    ylabel('Degree of membership')
    axis([var.range(1) var.range(2) 0.0 1.1])
else
    out_imftype2=imftype2;
    % for mfIndex=1:numMFs,
    % out_imftype2{mfIndex}=imftype2{mfIndex};
    % end
end
