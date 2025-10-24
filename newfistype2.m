function out=newfistype2(fisName,fisType,inputsFuzzifier,andMethod,orMethod,impMethod,aggMethod,typeReductionMethod,typeReductionAlgorithm)
%   NEWFISTYPE2 Create new IT2FIS.
%   FIS=NEWFISTYPE2(FISNAME) creates a new Mamdani-style singleton IT2FIS structure
%
%   FIS=NEWFISTYPE2(FISNAME, FISTYPE) creates a singleton IT2FIS structure for a Mamdani or 
%   Sugeno-style system with the name FISNAME.
%
%   FIS=NEWFISTYPE2(FISNAME, FISTYPE, inputsFuzzifier,andMethod, orMethod, impMethod, ...
%              aggMethod, typeReductionMethod,typeReductionAlgorithm)
%   specifies the methods for AND, OR, implication, aggregation, 
%   Type-Reduction and Type-Reduction Algorithm, respectively.
%
%   See Also
%       readfistype2, writefistype2
%   Example:
%       fis = newnsfistype2('exa01','mamdani','singleton','min','max','min','max','centroid','iwa');
%

%   Juan R. Castro, 7-25-2005, 11-9-2013.
%   Copyright 2006-2013 FCQI, UABC 
%   $Revision: 1.11 $  $Date: 2012/02/15 18:24:22 $

if (nargin>=1), name=fisName; end

if (nargin<2)
    fisType='mamdani';
else 
    fisType = fisType;
end

if (nargin<3)
    inputsFuzzifier = 'singleton';
else
    inputsFuzzifier = inputsFuzzifier;    
end

if strcmp(fisType,'mamdani')
    if (nargin<4), andMethod='min'; end
    if (nargin<5), orMethod='max'; end
    if (nargin<8), typeReductionMethod='centroid'; end
    if (nargin<9), typeReductionAlgorithm='iwa'; end
end
%
if (nargin<6), impMethod='min'; end
if (nargin<7), aggMethod='max'; end
%
if strcmp(fisType,'sugeno')
    if (nargin<4), andMethod='prod'; end
    if (nargin<5), orMethod='probor'; end
    if (nargin<6), impMethod='prod'; end
    if (nargin<7), aggMethod='sum'; end
    if (nargin<8), typeReductionMethod='cos'; end
    if (nargin<9), typeReductionAlgorithm='iwa'; end
end
%
if strcmp(fisType,'mamdani'),
    if strcmp(typeReductionMethod, 'centroid'),     % Centroid type-reduction
        aggMethod='max';
    elseif strcmp(typeReductionMethod, 'csums'),    % Center-of-sums type-reduction
        aggMethod='sum';
    elseif strcmp(typeReductionMethod, 'height'),   % Height type-reduction
        aggMethod='sum';
    elseif strcmp(typeReductionMethod, 'mdheight'), % Modified height type-reduction
        aggMethod='sum';
    elseif strcmp(typeReductionMethod, 'cos')      % Center-of-sets type-reduction
        aggMethod='sum';
    else
        error('Unknown type-reduction method!');
    end
elseif strcmp(fisType,'sugeno')
    if strcmp(typeReductionMethod, 'wtaver')           % Center-of-sets type-reduction
        aggMethod='sum';

    elseif strcmp(typeReductionMethod, 'wmub') % Aproximate type-reduction
        aggMethod='sum';
    else
        error('Unknown type-reduction method!');
    end
else
    error('Unknown IT2FIS type!');
end 
%
out.name=name;
out.type=fisType;
out.inputsFuzzifier=inputsFuzzifier;
out.andMethod=andMethod;
out.orMethod=orMethod;
out.typeReductionMethod=typeReductionMethod;
out.typeReductionAlgorithm=typeReductionAlgorithm;
out.impMethod=impMethod;
out.aggMethod=aggMethod;
% Create default values for the IT2FIS structure input output and rule
out.input=[];
out.output=[];
out.rule=[];
