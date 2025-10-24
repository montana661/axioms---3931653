function out=addruletype2(fis,rule)
%   Purpose
%   Add a rule to an IT2FIS.
%
%   Synopsis
%   a = addruletype2(a,ruleList)
%
%   Description
%   addruletype2 has two arguments. The first argument is the IT2FIS name. The second
%   argument for addrule is a matrix of one or more rows, each of which
%   represents a given rule. The format that the rule list matrix must take is
%   very specific. If there are m inputs to a system and n outputs, there must
%   be exactly m + n + 2 columns to the rule list.
%   The first m columns refer to the inputs of the system. Each column contains
%   a number that refers to the index of the interval type-2 membership function for that
%   variable.
%   The next n columns refer to the outputs of the system. Each column contains
%   a number that refers to the index of the interval type-2 membership function for that
%   variable.
%   The m + n + 1 column contains the weight that is to be applied to the rule.
%   The weight must be a number between zero and one, and is generally left as
%   one.
%   The m + n + 2 column contains a 1 if the interval type-2 fuzzy operator for the rule's
%   antecedent is AND. It contains a 2 if the interval type-2 fuzzy operator is OR.
%   Example
%   ruleList=[
%   	1 1 1 1 1
%   	1 2 2 1 1];
%   a = addruletype2(a,ruleList);
%   If the above system a has two inputs and one output, the first rule can be
%   interpreted as: *If input 1 is MF 1 and input 2 is MF 1, then output 1 is
%   MF 1.*
%
%   See also 
%   addmftype2, addvartype2, parsrule, rmmftype2, rmvartype2, showruletype2

oldRuleList=getfistype1(fis,'ruleList');
newRuleList=[oldRuleList; rule];

fis=setfistype1(fis,'ruleList',newRuleList);

out=fis;
