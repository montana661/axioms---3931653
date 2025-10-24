function out=addvartype2(fis,varType,varName,varRange,varargin)
%   Purpose
%   Add a variable to an NSIT2FIS.
%
%   Synopsis
%   a = addvart2(a,varType,varName,varBounds)
%
%   Description
%   addvart2 has four arguments in this order:
%   the IT2FIS name
%   the type of the variable (input or output)
%   the name of the variable
%   the vector describing the limiting range for the variable
%   Indices are applied to variables in the order in which they are added, so
%   the first input variable added to a system will always be known as input
%   variable number one for that system. Input and output variables are
%   numbered independently.
%
%   See also 
%   addmftype2, addruletype2, rmmftype2, rmvartype2

%   The argument varagin = 'init' is a flag to create a default set of
%   three interval type-2 membership functions.

%   Juan R. Castro, 7-25-2005, 11-9-2013.
%   Copyright 2006-2013 FCQI, UABC 
%   $Revision: 1.11 $  $Date: 2012/02/15 18:24:22 $

out=fis;
numRules=length(fis.rule);
ux = linspace(varRange(1),varRange(2),50)';
uy = linspace(varRange(1),varRange(2),50)';

da = 0;  % A small increment to set mf parameter values

if strcmp(lower(varType),'input'),
    % Check that the input field exists
    if isfield(fis,'input')
        index = length(fis.input) + 1;
    else
        index = 1;
    end
    
    if index == 1
        out.input = struct('name',[],...
            'range',[],...
            'mf',[],'mfx',[]);
    else
        out.input(index) = struct('name',[],...
            'range',[],...
            'mf',[],'mfx',[]);
    end
    
    out.input(index).name =varName;
    out.input(index).range=varRange;
    
    if nargin == 5 && isempty(out.input(index).mf)  % **
       % Create default input interval type-2 membership functions
       out.input(index).mf = struct('name',cell(1,3),'type','igaussmtype2','params',[]);
       MfParams = igenparamtype2(ux,3,'igaussmtype2');
       for id = 1:3
           out.input(index).mf(id).name   = sprintf('mf%i',id);
           out.input(index).mf(id).params = MfParams{1}(id,:);
       end        
    end
    
    % Need to insert a new column into the current rule list
    if numRules
        % Don't bother if there aren't any rules
        for i=1:numRules
            out.rule(i).antecedent(index)=0;
        end
    end
    
elseif strcmp(lower(varType),'output')
    % Check that the output field exists
    if isfield(fis,'output')
        index = length(fis.output)+1;
    else
        index = 1;
    end
    
    if index == 1
        out.output = struct('name',[],...
            'range',[],...
            'mf',[]);
    else
        out.output(index) = struct('name',[],...
            'range',[],...
            'mf',[]);
    end
    
    out.output(index).name=varName;
    out.output(index).range=varRange;
    
   if nargin == 5 && isempty(out.output(index).mf) 
       if strcmp(fis.type,'mamdani')
           % Create default output interval type-2 membership functions
           out.output(index).mf = struct('name',cell(1,3),'type','igaussmtype2','params',[]);
           MfParams = igenparamtype2(uy,3,'igaussmtype2');          
           for id = 1:3
            out.output(index).mf(id).name   = sprintf('mf%i',id);
            out.output(index).mf(id).params = MfParams{1}(id,:);
           end
       else % It must be a Sugeno type
            % Create default output interval type-2 membership functions
            out.output(index).mf = struct('name',cell(1,3),'type','constant','params',[]);
            for id = 1:3
               out.output(index).mf(id).name   = sprintf('mf%i',id);
               out.output(index).mf(id).params = [da da]; % **
               da = da + 0.5;
            end
       end
   end
   % Need to insert a new column into the current rule list
   if numRules
        % Don't bother if there aren't any rules     
        for i=1:numRules
            out.rule(i).consequent(index)=0;
        end
   end   
    
end
