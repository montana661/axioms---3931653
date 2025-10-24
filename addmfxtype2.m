function out=addmfxtype2(fis,varType,varIndex,MFLabel,MFType,MFParams)
%  Synopsis
%  a = addmfxtype2(a,varType,varIndex,mfName,mfType,mfParams)
%  
%  Description
%  A interval type-2 membership function can only be added to a variable name for an IT2FIS that 
%  already exists. Indices are assigned to interval type-2 membership functions in the order 
%  in which they are added, so the first interval type-2 membership function added to a 
%  variable will always be known as interval type-2 membership function number one for that 
%  variable. You cannot add a interval type-2 membership function to input variable number two 
%  of a system if only one input has been defined. 
%  The function requires six input arguments in this order: 
%      A MATLAB variable name of a IT2FIS structure in the workspace 
%      A string representing the type of the variable you want to add the 
%      interval type-2 membership function to (input or output)
%      The index of the variable you want to add the interval type-2 membership function to
%      A string representing the name of the new interval type-2 membership function
%      A string representing the type of the new interval type-2 membership function
%      The vector of parameters that specify the interval type-2 membership function.
%  
%  See also ADDRULETYPE2, ADDVARTYPE2, PLOTMFTYPE2, RMMFTYPE2, RMVARTYPE2

%   Juan R. Castro, 7-25-2005, 11-9-2013.
%   Copyright 2006-2013 FCQI, UABC 
%   $Revision: 1.11 $  $Date: 2012/02/15 18:24:22 $

% numInputs=length(fis.input);
% numOutputs=length(fis.output);

out=fis;
if ~isempty(fis.input)
  if strcmp(varType,'input')   
    %MFindex=length(fis.input(varIndex).mf)+1;
    out.input(varIndex).mfx.name=MFLabel;
    out.input(varIndex).mfx.type=MFType;
    out.input(varIndex).mfx.params=MFParams;    
  end
else
 disp('No Input Variable yet');
end
