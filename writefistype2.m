function [fisName,pathName,errorStr]=writefistype2(fis,fileName,dlgStr)
    %   WRITEFISTYPE2 Save a NSIT2FIS to disk.
    %   WRITEFISTYPE2(NSIT2FISMAT) brings up a dialog box to assist with the 
    %   naming and directory location of the file.
    %
    %   WRITEFISTYPE2(NSIT2FISMAT,'filename') writes a IT2FIS file corresponding
    %   to the NSIT2FIS matrix NSIT2FISMAT to a disk file called 'filename'. 
    %   No dialog box is used and the file is saved to the current 
    %   directory.
    %
    %   WRITEFISTYPE2(NSIT2FISMAT,'filename','dialog') brings up a dialog box 
    %   with the default name filename.fis supplied.
    %   The extension .fis is only added to filename if it is not 
    %   already included in the name.
    %
    %   See also READFISTYPE2.

    %   Juan R. Castro, 7-25-2005, 11-10-2019.
    %   Copyright 2006-2019 FCQI, UABC 
    %   $Revision: 1.20 $  $Date: 2019/10/11 21:51:22 $

    fisName = '';
    pathName = '';
    errorStr = '';
    ni = nargin;
    no = nargout;
    ThrowError = (no<3);

    if ni<1
        errorStr='No IT2FIS matrix provided.';
        if ThrowError, error(errorStr); end
        return
    end

    if ni<2 || isempty(fileName)
       fileName = '';
    else
       fileName = [strtok(deblank(fileName),'.') '.fis'];
    end

    if ni<3
        dlgStr=' ';
    end

    % File and path names
    if (ni<2) || strcmp(dlgStr,'dialog')
       % Open dialog to get file name
       [fileName,pathName]=uiputfile('*.fis','Save IT2FIS',fileName);
       if isequal(fileName,0) || isequal(pathName,0)
          errorStr='No file name was specified';
          if ThrowError, error(errorStr); end
          return
       end
    else
       % Process specified name
       slashIndex=find(fileName==filesep,1,'last');
       if isempty(slashIndex)
          pathName = '';
       else
          pathName = fileName(1:slashIndex);
          fileName(1:slashIndex)=[];
       end
    end

    % Get FIS name
    fisName = strtok(fileName,'.');
    fis.name = fisName;

    % Write data to file
    fid=fopen([pathName fileName],'w');
    if fid==-1
        errorStr=sprintf('Unable to write to file "%s.fis"',fileName);
        if ThrowError, error(errorStr); end
        return
    end
    fprintf(fid,'[System]\n');

    str=['Name=''' fis.name '''\n'];
    fprintf(fid,str);

    % Structure

    str=['Type=''' fis.type '''\n'];
    fprintf(fid,str);

    str = ['InputsFuzzifier=''' fis.inputsFuzzifier '''\n'];
    fprintf(fid,str);

    str=['Version=2.0\n'];
    fprintf(fid,str);

    str=['NumInputs=' num2str(length(fis.input)) '\n'];
    fprintf(fid,str);

    str=['NumOutputs=' num2str(length(fis.output)) '\n'];
    fprintf(fid,str);


    str=['NumRules=' num2str(length(fis.rule)) '\n'];
    fprintf(fid,str);
    str=['AndMethod=''' fis.andMethod '''\n'];
    fprintf(fid,str);

    str=['OrMethod=''' fis.orMethod '''\n'];
    fprintf(fid,str);

    str=['ImpMethod=''' fis.impMethod '''\n'];
    fprintf(fid,str);

    str=['AggMethod=''' fis.aggMethod '''\n'];
    fprintf(fid,str);

    str=['TypeReductionMethod=''' fis.typeReductionMethod '''\n'];
    fprintf(fid,str);

    str=['TypeReductionAlgorithm=''' fis.typeReductionAlgorithm '''\n'];
    fprintf(fid,str);

    for varIndex=1:length(fis.input)
        fprintf(fid,['\n[Input' num2str(varIndex) ']\n']);
        str=['Name=''' fis.input(varIndex).name '''\n'];
        fprintf(fid,str);
        str=['Range=' mat2str(fis.input(varIndex).range) '\n'];
        fprintf(fid,str);
        str=['NumMFs=' num2str(length(fis.input(varIndex).mf)) '\n'];
        fprintf(fid,str);

        for mfIndex=1:length(fis.input(varIndex).mf)
            str=['MF' num2str(mfIndex) '=''' fis.input(varIndex).mf(mfIndex).name ''':'];
            fprintf(fid,str);
            str=['''' fis.input(varIndex).mf(mfIndex).type ''','];
            fprintf(fid,str);
            %%%
            try
                parstr = sprintf('%.15g ', fis.input(varIndex).mf(mfIndex).params);
                str = ['[' parstr(1:end-1) ']\n'];
                fprintf(fid,str);
            catch
                % fis.input(varIndex).mf.params
                str = parseCellString(fis.input(varIndex).mf(mfIndex).params);
                fprintf(fid,str);
            end
            % parstr = sprintf('%.15g ', fis.input(varIndex).mf(mfIndex).params);
            % str = ['[' parstr(1:end-1) ']\n'];
            % fprintf(fid,str);
            %%%
        end

        if strcmp(fis.inputsFuzzifier,'non-singleton')
            str=['MFX=''' fis.input(varIndex).mfx.name ''':'];
            fprintf(fid,str);
            str=['''' fis.input(varIndex).mfx.type ''','];
            fprintf(fid,str);
            %%%
            try
                parstr = sprintf('%.15g ', fis.input(varIndex).mfx.params);
                str = ['[' parstr(1:end-1) ']\n'];
                fprintf(fid,str);
            catch
                str = parseCellString(fis.input(varIndex).mfx.params);
                fprintf(fid,str);
            end
            % parstr = sprintf('%.15g ', fis.input(varIndex).mfx.params);
            % str = ['[' parstr(1:end-1) ']\n'];
            % fprintf(fid,str);
        end
    end

    for varIndex=1:length(fis.output)
        fprintf(fid,['\n[Output' num2str(varIndex) ']\n']);    
        str=['Name=''' fis.output(varIndex).name '''\n'];
        fprintf(fid,str);
        str=['Range=' mat2str(fis.output(varIndex).range) '\n'];
        fprintf(fid,str);
        str=['NumMFs=' num2str(length(fis.output(varIndex).mf)) '\n'];
        fprintf(fid,str);

        for mfIndex=1:length(fis.output(varIndex).mf)
            str=['MF' num2str(mfIndex) '=''' fis.output(varIndex).mf(mfIndex).name ''':'];
            fprintf(fid,str);
            str=['''' fis.output(varIndex).mf(mfIndex).type ''','];
            fprintf(fid,str);
            if strcmp(fis.type,'mamdani')
                % MAMDANI
                %%%
                try
                    parstr = sprintf('%.15g ', fis.output(varIndex).mf(mfIndex).params);
                    str = ['[' parstr(1:end-1) ']\n'];
                    % fprintf(fid,str);
                catch
                    str = parseCellString(fis.output(varIndex).mf(mfIndex).params);
                    % fprintf(fid,str);
                end
            else
                % TSK
                parstr = sprintf('%.15g ', fis.output(varIndex).mf(mfIndex).params);
                str = ['[' parstr(1:end-1) ']\n'];
                % fprintf(fid,str);
            end
            fprintf(fid,str);
        end
    end

    str=['\n[Rules]\n'];
    fprintf(fid,str);
    for ruleIndex=1:length(fis.rule)
        antecedent=mat2str(fis.rule(ruleIndex).antecedent);
        if length(fis.input)>1
           antecedent=antecedent(2:end-1);
        end
        consequent=mat2str(fis.rule(ruleIndex).consequent);
        if length(fis.output)>1
           consequent=consequent(2:end-1);
        end
        str=[antecedent ', ' consequent ' ('...
             mat2str(fis.rule(ruleIndex).weight) ') : '...
             mat2str(fis.rule(ruleIndex).connection)...
              '\n'];
        fprintf(fid,str);
    end

    fclose(fid);
end

function str = parseCellString(params)
    % parser cell to string params
    str = '{{';
    for k=1:length(params{1})
        par1str = sprintf('%.15g ',params{1}{k});
        str = [str,['[' par1str(1:end-1) '],']];
    end
    str = [str(1:end-1),'},'];
    par2str = sprintf('%.15g',params{2});
    str = [str,[par2str ',']];
    par3str = sprintf('%.15g ',params{3});
    str = [str,['[' par3str(1:end-1) ']']];
    str = [str,'}\n'];
end
