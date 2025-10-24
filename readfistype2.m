function [out,errorStr]=readfistype2(fileName)
    %   READFISTYPE2 Load FIS from disk.
    %   FISMAT=READFISTYPE2('filename') creates a FIS matrix in the
    %   workspace corresponding to the FIS file 'filename' on disk.
    %
    %   FISMAT=READFISTYPE2 brings up a UIGETFILE dialog box to assist
    %   with the name and directory location of the file.
    %
    %   The extension '.fis' is assumed for 'filename' if it is not 
    %   already present.
    %
    %   See also WRITEFISTYPE2
    %
    %   Juan R. Castro, 7-25-2005, 11-10-2019.
    %   Copyright 2006-2019 FCQI, UABC 
    %   $Revision: 1.20 $  $Date: 2019/10/11 21:51:22 $
    %
    out=[];
    if nargin<1
       [fileName,pathName]=uigetfile('*.fis','Read FIS');
       if isequal(fileName,0) || isequal(pathName,0)
          % If fileName is zero, "cancel" was hit, or there was an error.
          errorStr='No file was loaded';
          if nargout<2
             error(errorStr);
          end
          return
       end
       fileName = [pathName fileName];
    elseif ~isstr(fileName)
       error('File name must be specified as a string.')
    end
    fileName = strtok(deblank(fileName),'.');
    if isempty(fileName)
       errorStr='Empty file name: no file was loaded';
       if nargout<2
          error(errorStr);
       end
       return
    end
    fileName=[fileName '.fis'];
    [fid,errorStr]=fopen(fileName,'r');
    if fid<0
       if nargout<2
          error(errorStr);
       end
       return
    end
    % Structure
    nextLineVar=' ';
    topic='[System]';
    while isempty(findstr(nextLineVar,topic))
       nextLineVar=LocalNextline(fid);
    end
    % These are the system defaults in case the user has omitted them
    Name='Untitled';
    Type='mamdani';
    InputsFuzzifier = 'singleton';
    AndMethod='min';
    OrMethod='max';
    ImpMethod='min';
    AggMethod='max';
    TypeReductionMethod='centroid';
    TypeReductionAlgorithm ='iwa';
    nextLineVar=' ';
    % Here we are evaluating everything up till the first "[" bracket
    % The lines we're eval-ing contain their own variable names, so
    % a lot of variables, like "Name" and so on, are getting initialized
    % invisibly
    while isempty([findstr(nextLineVar,'[Input') findstr(nextLineVar,'[Output')
          findstr(nextLineVar,'[Rules')])
       eval([nextLineVar ';']);
       nextLineVar=LocalNextline(fid);
    end
    if strcmp(Type,'sugeno')
        ImpMethod = 'prod';
        AggMethod = 'sum';
    end
    out.name=Name;
    out.type=Type;
    out.inputsFuzzifier =InputsFuzzifier;
    out.andMethod=AndMethod;
    out.orMethod=OrMethod;
    out.typeReductionMethod=TypeReductionMethod;
    out.typeReductionAlgorithm=TypeReductionAlgorithm;
    out.impMethod=ImpMethod;
    out.aggMethod=AggMethod;
    % I have to rewind here to catch the first input. This is because
    % I don't know how long the [System] comments are going to be
    frewind(fid)
    %Initialize parameters
    NumInputMFs=[];
    NumOutputMFs=[];
    InLabels=[];
    OutLabels=[];
    InRange=[];
    OutRange=[];
    InMFLabels=[];
    OutMFLabels=[];
    InMFTypes=[];
    OutMFTypes=[];
    InMFParams=[];
    OutMFParams=[];
    % Now begin with the inputs
    for varIndex=1:NumInputs
       nextLineVar=' ';
       topic='[Input';
       while isempty(findstr(nextLineVar,topic))
          nextLineVar=LocalNextline(fid);
       end
       % Input variable name
       Name=0;
       eval([LocalNextline(fid) ';'])
       if ~Name 
          error(['Name missing or out of place for input variable ' ...
                num2str(varIndex)]);
       end
       out.input(varIndex).name=Name;
       % Input variable range
       Range=0;
       eval([LocalNextline(fid) ';'])
       if ~Range 
          error(['Range missing or out of place for input variable ' ...
                num2str(varIndex)]);
       end
       out.input(varIndex).range=Range;
       % Number of membership functions
       eval([LocalNextline(fid) ';']);
       for MFIndex=1:NumMFs
          MFStr=LocalNextline(fid);
          nameStart=findstr(MFStr,'=');
          nameEnd=findstr(MFStr,':');
          MFName=eval(MFStr((nameStart+1):(nameEnd-1))); 
          typeStart=findstr(MFStr,':');
          typeEnd=findstr(MFStr,',');
          MFType=eval(MFStr((typeStart+1):(typeEnd-1)));
          MFParams=eval(MFStr((typeEnd+1):length(MFStr)));
          out.input(varIndex).mf(MFIndex).name=MFName;
          out.input(varIndex).mf(MFIndex).type=MFType;
          out.input(varIndex).mf(MFIndex).params=MFParams;
       end
       if strcmp(out.inputsFuzzifier,'non-singleton')
          MFXStr=LocalNextline(fid);
          nameStart=findstr(MFXStr,'=');
          nameEnd=findstr(MFXStr,':');
          MFXName=eval(MFXStr((nameStart+1):(nameEnd-1))); 
          typeStart=findstr(MFXStr,':');
          typeEnd=findstr(MFXStr,',');
          MFXType=eval(MFXStr((typeStart+1):(typeEnd-1)));
          MFXParams=eval(MFXStr((typeEnd+1):length(MFXStr)));
          out.input(varIndex).mfx.name=MFXName;
          out.input(varIndex).mfx.type=MFXType;
          out.input(varIndex).mfx.params=MFXParams;
       end   
    end
    % Now for the outputs
    for varIndex=1:NumOutputs
       nextLineVar=' ';
       topic='Output';
       while isempty(findstr(nextLineVar,topic))
          nextLineVar=LocalNextline(fid);
       end
       % Output variable name
       varName=LocalNextline(fid);
       varName=strrep(varName,'Name','');
       varName=eval(strrep(varName,'=',''));
       out.output(varIndex).name=varName;
       % Output variable range
       rangeStr=LocalNextline(fid);
       rangeStr=strrep(rangeStr,'Range','');
       rangeStr=strrep(rangeStr,'=','');
       out.output(varIndex).range=eval(['[' rangeStr ']']);
       NumMFsStr=LocalNextline(fid);
       NumMFsStr=strrep(NumMFsStr,'NumMFs','');
       NumMFsStr=strrep(NumMFsStr,'=','');
       NumMFs=eval(NumMFsStr);
       for MFIndex=1:NumMFs
          MFStr=LocalNextline(fid);
          nameStart=findstr(MFStr,'=');
          nameEnd=findstr(MFStr,':');
          MFName=eval(MFStr((nameStart+1):(nameEnd-1)));
          typeStart=findstr(MFStr,':');
          typeEnd=findstr(MFStr,',');
          MFType=eval(MFStr((typeStart+1):(typeEnd-1)));
          MFParams=eval(MFStr((typeEnd+1):length(MFStr)));
          out.output(varIndex).mf(MFIndex).name=MFName;
          out.output(varIndex).mf(MFIndex).type=MFType;
          out.output(varIndex).mf(MFIndex).params=MFParams;
       end
    end
    % Now assemble the whole FIS data matrix
    % If NumInputs or NumOutputs is zero, we need a space holder for the MF indices
    % Otherwise they'll just be the empty set
    if isempty(NumInputMFs), NumInputMFs=0; end
    if isempty(NumOutputMFs), NumOutputMFs=0; end
    % Now for the rules
    nextLineVar=' ';
    topic='Rules';
    while isempty(findstr(nextLineVar,topic))
       nextLineVar=LocalNextline(fid);
    end
    ruleIndex=1;
    txtRuleList=[];
    out.rule=[];
    while ~feof(fid)
       ruleStr=LocalNextline(fid);
       if ischar(ruleStr) 
        txtRuleList(ruleIndex,1:length(ruleStr))=ruleStr;
        ruleIndex=ruleIndex+1;
       end
    end
    if ~isempty(txtRuleList)& isfield(out, 'input') & isfield(out, 'output')
    % & isfield(out.input, 'mf') & isfield(out.output, 'mf') ...
    % & isfield(out.input.mf, 'name') & isfield(out.output.mf, 'name')
      out=parsruletype1(out,txtRuleList,'indexed');
    end
    fclose(fid);
end

function outLine=LocalNextline(fid)
    %   LOCALNEXTLINE Return the next non-empty line of a file.
    %	OUTLINE=LOCALNEXTLINE(FID) returns the next non-empty line in the
    %	file whose file ID is FID. The file FID must already be open.
    %	LOCALNEXTLINE skips all lines that consist only of a carriage
    %	return and it returns a -1 when the end of the file has been
    %	reached.
    %
    %	LOCALNEXTLINE ignores all lines that begin with the % comment
    %	character (the % character must be in the first column)

    outLine=fgetl(fid);

    stopFlag=0;
    while (~stopFlag)
       if length(outLine)>0
          if (~strcmp(outLine(1),'%') | (outLine ==-1))
             % This line has real content or the end of the file; stop and return outLine
             stopFlag=1;
          else
             % This line must be a comment; keep going
             outLine=fgetl(fid);
          end
       else
          % This line is of length zero
          outLine=fgetl(fid);
       end
    end
end
