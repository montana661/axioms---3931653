function [output_stack,outputL_stack,outputR_stack,IRR_L,IRR_U,ORR_L,ORR_U,ARR_L,ARR_U] = evalfistype2(input_stack, fismatrix, point_n)
%     EVALNSIFISTYPE2 Performinterval type-2  fuzzy inference calculations.
%
%     [Y,Y_L,Y_R,IRR_L,IRR_U,ORR_L,ORR_U,ARR_L,ARR_U] = evalnsifistype2(U,FIS,NPts)
%  
%     Y = EVALNSIFISTYPE2(U,FIS) simulates the Interval Type-2 Fuzzy Inference System FIS for the 
%     input data U and returns the output data Y.  For a system with N 
%     input variables and L output variables, 
%        * U is a M-by-N matrix, each row being a particular input vector
%        * Y is M-by-L matrix, each row being a particular output vector.
%        * Y_L, Y_R: is M-by-L matrix, each row being a particular left and right output vector.
%     
%     Y = EVALNSIFISTYPE2(U,FIS,NPts) further specifies number of sample points
%     on which to evaluate the interval type-2 membership functions over the
%     input or output range. If this argument is not used,
%     the default value is 101 points.
%
%     [Y,Y_L,Y_R,IRR_L,IRR_U,ORR_L,ORR_U,ARR_L,ARR_U] = evalnsifistype2(U,FIS)
%     also returns the following range. variables when U is a row vector 
%     (only one set of inputs is applied):
%        * IRR_L, IRR_R: the result of evaluating the input lower and upper values
%          through the interval type-2 membership functions. This is a matrix of size Nr-by-N,
%          where Nr is the number of rules, and N is the number of input variables.
%        * ORR_L, ORR_R: the result of evaluating the output lower and upper values
%          through the interval type-2 membership functions. This is a matrix
%          of size NPts-by-Nr*L. The first Nr columns of this matrix correspond
%          to the first output, the next Nr columns correspond to the second output, and so forth.
%        * ARR_L, ARR_U: the NPts-by-L matrix of the aggregate lower and upper
%          values sampled at NPts along the output range for each output.
%  

% ********************************************************************
% * Juan Ramon Castro Rodriguez                                                       *
% * Baja California Autonomous University, UABC. Tijuana, Mexico       *
% * Departament of Computer Science.                                               *
% * Tijuana, Mexico.                                                                          *
% ********************************************************************
%
% $Revision: 1.0.0.3 $  $Date: 2013/04/03 08:14:11 $
%

ni = nargin;
if ni<2
   disp('Need at least two inputs');
   output_stack  = [];
   outputL_stack = [];
   outputR_stack = [];
   IRR_L = [];
   IRR_U = [];
   ORR_L = [];
   ORR_U = [];
   ARR_L = [];
   ARR_U = [];   
   return
end
mf_para_n = 9;
% Compute output
if ni==2
   point_n   = 101;
end
%
GLOBAL_FIS_MATRIX = fismatrix;
FIS_NAME =  fismatrix.name;  
FIS_TYPE =  fismatrix.type;
INPUTSFUZZIFIER = fismatrix.inputsFuzzifier;
FIS_TYPE(find(FIS_TYPE == 0)) = [];
IN_N  = length(fismatrix.input);
OUT_N = length(fismatrix.output);
for i=1:IN_N
    IN_MF_N(i)  = length(fismatrix.input(i).mf);
end
for i=1:OUT_N
    OUT_MF_N(i) = length(fismatrix.output(i).mf);
end
RULE_N        = length(fismatrix.rule);
AND_METHOD    = fismatrix.andMethod;
OR_METHOD     = fismatrix.orMethod;
IMP_METHOD    = fismatrix.impMethod;
AGG_METHOD    = fismatrix.aggMethod;
TYPE_REDUCTION= fismatrix.typeReductionMethod;
TR_ALGORITHM= fismatrix.typeReductionAlgorithm;
% DEFUZZ_METHOD = fismatrix.defuzzMethod;
AND_METHOD(find(AND_METHOD == 0)) = [];
OR_METHOD(find(OR_METHOD == 0)) = [];
IMP_METHOD(find(IMP_METHOD == 0)) = [];
AGG_METHOD(find(AGG_METHOD == 0)) = [];
TYPE_REDUCTION(find(TYPE_REDUCTION == 0)) = [];
%
IN_MF_TYPE  = [];
OUT_MF_TYPE = [];   
for i=1:IN_N
    in_bound(i, 1:2)=fismatrix.input(i).range;
 for j=1:length(fismatrix.input(i).mf)
        IN_MF_TYPE=strvcat(IN_MF_TYPE, fismatrix.input(i).mf(j).type);
    end
end
%
for i=1:OUT_N
    out_bound(i, 1:2)=fismatrix.output(i).range;
    for j=1:length(fismatrix.output(i).mf)
        OUT_MF_TYPE=strvcat(OUT_MF_TYPE, fismatrix.output(i).mf(j).type);
    end
end
%
BOUND = [in_bound; out_bound];
tmp = getfistype1(fismatrix, 'rulelist');
RULE_WEIGHT = tmp(:, IN_N+OUT_N+1);
AND_OR = tmp(:, IN_N+OUT_N+2);
RULE_LIST = tmp(:, 1:IN_N+OUT_N);
k=1;
totalInputMFs =sum(IN_MF_N);
totalOutputMFs=sum(OUT_MF_N);
%
IN_PARAM =zeros(totalInputMFs, mf_para_n); % default: mf_para_n=9
for i=1:IN_N
    for j=1:length(fismatrix.input(i).mf)
        temp=fismatrix.input(i).mf(j).params;
        IN_PARAM(k,1:length(temp))=temp;
        k=k+1;
    end
end
%
if strcmp(FIS_TYPE, 'sugeno')
    OUT_PARAM=zeros(totalOutputMFs,2*(IN_N+1));
else % FIS_TYPE Mamdani
    OUT_PARAM=zeros(totalOutputMFs, mf_para_n);
end
%
k=1;
for i=1:OUT_N
    for j=1:length(fismatrix.output(i).mf)
        if strcmp(fismatrix.output(i).mf(j).type, 'constant')
            temp=[zeros(size(fismatrix.input)) fismatrix.output(i).mf(j).params(1) ...
                  zeros(size(fismatrix.input)) fismatrix.output(i).mf(j).params(2)];
        else
            temp=fismatrix.output(i).mf(j).params;
        end
        OUT_PARAM(k,1:length(temp))=temp;
        k=k+1;
    end
end
%
if strcmp(FIS_TYPE, 'sugeno'),
    OUT_PARAM = OUT_PARAM(:, 1:2*(IN_N+1));
elseif strcmp(FIS_TYPE, 'mamdani'),
    OUT_PARAM = OUT_PARAM(:, 1:mf_para_n);
else
    error('Unknown FIS type!');
end
%%%%
if strcmp(INPUTSFUZZIFIER,'non-singleton'),
    IN_MFX_TYPE = [];
    INX_PARAM=zeros(IN_N, mf_para_n);
    %
    for i=1:IN_N
        IN_MFX_TYPE=strvcat(IN_MFX_TYPE, fismatrix.input(i).mfx.type);
        tmpx=fismatrix.input(i).mfx.params;
        INX_PARAM(i,1:length(tmpx))=tmpx;
    end
    % IN_TEMPLATE_MF LOWER y UPPER
    IN_TEMPLATE_MFL = zeros(sum(IN_MF_N), point_n);
    IN_TEMPLATE_MFU = zeros(sum(IN_MF_N), point_n);
    cum_mf = cumsum(IN_MF_N);
    for i = 1:sum(IN_MF_N),
        tmp = find((cum_mf-i) >= 0);
        input_index = tmp(1); % output index
        IN_X(i, :) = linspace(BOUND(input_index,1),BOUND(input_index,2), point_n);
        mftype2 = evalmftype2(IN_X(i, :),IN_PARAM(i, :), deblank(IN_MF_TYPE(i, :)));
        IN_TEMPLATE_MFL(i, :) = mftype2.LU{1}(:,1);
        IN_TEMPLATE_MFU(i, :) = mftype2.LU{1}(:,2);
    end
    %
    IN_MFL = zeros(RULE_N, point_n*IN_N);
    IN_MFU = zeros(RULE_N, point_n*IN_N);
    for i = 1:RULE_N,
        for j = 1:IN_N,
            mf_index = RULE_LIST(i,j);
            index = sum(IN_MF_N(1:j-1)) + abs(mf_index);
            if mf_index > 0,    % regular MF
                IN_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                    IN_TEMPLATE_MFL(index, :);
                IN_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                    IN_TEMPLATE_MFU(index, :);
            elseif mf_index < 0,% Linguistic hedge "NOT"
                IN_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                    1 - IN_TEMPLATE_MFU(index, :);
                IN_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                    1 - IN_TEMPLATE_MFL(index, :);
            else                % Don't care (mf_index == 0)    
                IN_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                    ones(1, point_n)*NaN;
                IN_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                    ones(1, point_n)*NaN;
            end
        end
    end
end % non-singleton
%%%%
if strcmp(FIS_TYPE, 'mamdani'),
        % OUT_TEMPLATE_MF LOWER y UPPER
        OUT_TEMPLATE_MFL = zeros(sum(OUT_MF_N), point_n);
        OUT_TEMPLATE_MFU = zeros(sum(OUT_MF_N), point_n);
        cum_mf = cumsum(OUT_MF_N);
        for i = 1:sum(OUT_MF_N),
            tmp = find((cum_mf-i) >= 0);
            output_index = tmp(1); % output index
            OUT_Y (i, :) = linspace(BOUND(IN_N+output_index,1),BOUND(IN_N+output_index,2), point_n);
            mftype2 = evalmftype2(OUT_Y (i, :),OUT_PARAM(i, :), deblank(OUT_MF_TYPE(i, :)));
            OUT_TEMPLATE_MFL(i, :) = mftype2.LU{1}(:,1);
            OUT_TEMPLATE_MFU(i, :) = mftype2.LU{1}(:,2);
        end
        %
        OUT_MFL = zeros(RULE_N, point_n*OUT_N);
        OUT_MFU = zeros(RULE_N, point_n*OUT_N);
        for i = 1:RULE_N,
            for j = 1:OUT_N,
                mf_index = RULE_LIST(i, IN_N+j);
                index = sum(OUT_MF_N(1:j-1)) + abs(mf_index);
                if mf_index > 0,    % regular MF
                    OUT_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                        OUT_TEMPLATE_MFL(index, :);
                    OUT_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                        OUT_TEMPLATE_MFU(index, :);
                elseif mf_index < 0,% Linguistic hedge "NOT"
                    OUT_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                        1 - OUT_TEMPLATE_MFU(index, :);
                    OUT_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                        1 - OUT_TEMPLATE_MFL(index, :);
                else                % Don't care (mf_index == 0)    
                    OUT_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                        ones(1, point_n)*NaN;
                    OUT_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                        ones(1, point_n)*NaN;
                end
            end
        end
        %
    if strcmp(TYPE_REDUCTION, 'cos'),
        % OUT_TEMPLATE_MF CENTROID LOWER y UPPER
        OUT_TEMPLATE_CMFL = zeros(sum(OUT_MF_N),1);
        OUT_TEMPLATE_CMFU = zeros(sum(OUT_MF_N),1);
        cum_mf = cumsum(OUT_MF_N);
        for i = 1:sum(OUT_MF_N),
            h      = (OUT_TEMPLATE_MFU(i, :)+OUT_TEMPLATE_MFL(i, :))/2;
            delta  = (OUT_TEMPLATE_MFU(i, :)-OUT_TEMPLATE_MFL(i, :))/2;
            [yl,yr]=centroid_tr(OUT_Y (i,:)',h',delta');
            OUT_TEMPLATE_CMFL(i,1) = yl;
            OUT_TEMPLATE_CMFU(i,1) = yr;
        end
        %
        OUT_CMFL = zeros(RULE_N,OUT_N);
        OUT_CMFU = zeros(RULE_N,OUT_N);
        %
        for i = 1:RULE_N,
            for j = 1:OUT_N,
                mf_index = RULE_LIST(i, IN_N+j);
                index = sum(OUT_MF_N(1:j-1)) + abs(mf_index);
                if mf_index > 0,    % regular MF                    
                    OUT_CMFL(i,j) = OUT_TEMPLATE_CMFL(index,1);
                    OUT_CMFU(i,j) = OUT_TEMPLATE_CMFU(index,1);
                elseif mf_index < 0,% Linguistic hedge "NOT"
                    OUT_CMFL(i,j) = OUT_TEMPLATE_CMFL(index,1);
                    OUT_CMFU(i,j) = OUT_TEMPLATE_CMFU(index,1);
                else                % Don't care (mf_index == 0)
                    OUT_CMFL(i,j) = NaN;
                    OUT_CMFU(i,j) = NaN;

                end
            end
        end
        %
    elseif strcmp(TYPE_REDUCTION, 'height'),
        % OUT_TEMPLATE_MF LOWER y UPPER
        % OUT_TEMPLATE_MF = zeros(sum(OUT_MF_N),1);
        OUT_TEMPLATE_CMF = zeros(sum(OUT_MF_N),1);
        cum_mf = cumsum(OUT_MF_N);
        for i = 1:sum(OUT_MF_N),
            tmp = find((cum_mf-i) >= 0);
            output_index = tmp(1); % output index
            out_mf_type = deblank(OUT_MF_TYPE(i, :));
            if strcmp(out_mf_type, 'itritype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,5))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'itristype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,1))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'itrapatype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,6)+OUT_PARAM(i,3)+OUT_PARAM(i,7))/4;
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'itrapstype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,1))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'igausstype2'),
                yh = (OUT_PARAM(i,2)+OUT_PARAM(i,4))/2;
                OUT_TEMPLATE_CMF(i,1) = yh;
            elseif strcmp(out_mf_type, 'igaussmtype2'),
                yh = (OUT_PARAM(i,2)+OUT_PARAM(i,3))/2;
                OUT_TEMPLATE_CMF(i,1) = yh;
            elseif strcmp(out_mf_type, 'igaussstype2'),
                yh = OUT_PARAM(i,3);
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'igaussatype2'),
                OUT_TEMPLATE_CMF(i,1) = OUT_PARAM(i,2);
            elseif strcmp(out_mf_type, 'igbelltype2'),
                yh  = (OUT_PARAM(i,3)+OUT_PARAM(i,6))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'igbellsmtype2'),
                yh  = (OUT_PARAM(i,4)+OUT_PARAM(i,5))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'igbellmtype2'),
                yh  = (OUT_PARAM(i,3)+OUT_PARAM(i,4))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'igbellstype2'),
                yh  = OUT_PARAM(i,4);
                OUT_TEMPLATE_CMF(i,1)   = yh;
            elseif strcmp(out_mf_type, 'igbellatype2'),
                yh  = OUT_PARAM(i,3);
                OUT_TEMPLATE_CMF(i,1)   = yh;
            else
                error('Unknown Interval Type-2 Membership Functions!');
            end
        end
        %
        OUT_CMF = zeros(RULE_N,OUT_N);
        for i = 1:RULE_N,
            for j = 1:OUT_N,
                mf_index = RULE_LIST(i, IN_N+j);
                index = sum(OUT_MF_N(1:j-1)) + abs(mf_index);
                if mf_index > 0,    % regular MF
                    OUT_CMF(i,j) = OUT_TEMPLATE_CMF(index,1);
                elseif mf_index < 0,% Linguistic hedge "NOT"
                    OUT_CMF(i,j) = OUT_TEMPLATE_CMF(index,1);
                else                % Don't care (mf_index == 0)    
                    OUT_CMF(i,j) = NaN;
                end

            end
        end
        %
    elseif strcmp(TYPE_REDUCTION, 'mdheight'),
        % OUT_TEMPLATE_MF LOWER y UPPER
        % OUT_TEMPLATE_MF = zeros(sum(OUT_MF_N),1);
        OUT_TEMPLATE_CMF   = zeros(sum(OUT_MF_N),1);
        OUT_TEMPLATE_CMFSP = zeros(sum(OUT_MF_N),1);
        cum_mf = cumsum(OUT_MF_N);
        for i = 1:sum(OUT_MF_N),
            tmp = find((cum_mf-i) >= 0);
            output_index = tmp(1); % output index
            out_mf_type = deblank(OUT_MF_TYPE(i, :));
            if strcmp(out_mf_type, 'itritype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,5))/2;
                sp1 = OUT_PARAM(i,3)-OUT_PARAM(i,1);
                sp2 = OUT_PARAM(i,6)-OUT_PARAM(i,4);
                sp  = (sp2+sp1)/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'itristype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,1))/2;
                sp1 = OUT_PARAM(i,2)+OUT_PARAM(i,4)-(OUT_PARAM(i,1)-OUT_PARAM(i,3));
                sp2 = OUT_PARAM(i,2)-OUT_PARAM(i,4)-(OUT_PARAM(i,1)+OUT_PARAM(i,3));
                sp  = (sp2+sp1)/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'itrapatype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,6)+OUT_PARAM(i,3)+OUT_PARAM(i,7))/4;
                sp1 = OUT_PARAM(i,4)-OUT_PARAM(i,1);
                sp2 = OUT_PARAM(i,8)-OUT_PARAM(i,5);
                sp  = (sp2+sp1)/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'itrapstype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,1))/2;
                sp1 = OUT_PARAM(i,2)+OUT_PARAM(i,4)-(OUT_PARAM(i,1)-OUT_PARAM(i,3));
                sp2 = OUT_PARAM(i,2)-OUT_PARAM(i,4)-(OUT_PARAM(i,1)+OUT_PARAM(i,3));
                sp  = (sp2+sp1)/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igausstype2'),
                yh  = (OUT_PARAM(i,2)+OUT_PARAM(i,4))/2;
                sp  = (OUT_PARAM(i,1)+OUT_PARAM(i,3))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igaussmtype2'),
                yh = (OUT_PARAM(i,2)+OUT_PARAM(i,3))/2;
                sp  = OUT_PARAM(i,1);
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igaussstype2'),
                yh = OUT_PARAM(i,3);
                sp = (OUT_PARAM(i,1)+OUT_PARAM(i,2))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igaussatype2'),
                yh  = OUT_PARAM(i,2);
                sp  = OUT_PARAM(i,1);
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igbelltype2'),
                yh  = (OUT_PARAM(i,3)+OUT_PARAM(i,6))/2;
                sp  = (OUT_PARAM(i,1)+OUT_PARAM(i,4))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igbellsmtype2'),
                yh  = (OUT_PARAM(i,4)+OUT_PARAM(i,5))/2;
                sp  = (OUT_PARAM(i,1)+OUT_PARAM(i,2))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igbellmtype2'),
                yh  = (OUT_PARAM(i,3)+OUT_PARAM(i,4))/2;
                sp  = OUT_PARAM(i,1);
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igbellstype2'),
                yh  = OUT_PARAM(i,4);
                sp  = (OUT_PARAM(i,1)+OUT_PARAM(i,2))/2;
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            elseif strcmp(out_mf_type, 'igbellatype2'),
                yh  = OUT_PARAM(i,3);
                sp  = OUT_PARAM(i,1);
                OUT_TEMPLATE_CMF(i,1)   = yh;
                OUT_TEMPLATE_CMFSP(i,1) = sp;
            else
                error('Unknown Interval Type-2 Membership Functions!');
            end
        end
        %
        OUT_CMF   = zeros(RULE_N,OUT_N);
        OUT_CMFSP = zeros(RULE_N,OUT_N);
        for i = 1:RULE_N,
            for j = 1:OUT_N,
                mf_index = RULE_LIST(i, IN_N+j);
                index = sum(OUT_MF_N(1:j-1)) + abs(mf_index);
                if mf_index > 0,    % regular MF
                    OUT_CMF(i,j)   = OUT_TEMPLATE_CMF(index,1);
                    OUT_CMFSP(i,j) = OUT_TEMPLATE_CMFSP(index,1);
                elseif mf_index < 0,% Linguistic hedge "NOT"
                    OUT_CMF(i,j)   = OUT_TEMPLATE_CMF(index,1);
                    OUT_CMFSP(i,j) = OUT_TEMPLATE_CMFSP(index,1);
                else                % Don't care (mf_index == 0)    
                    OUT_CMF(i,j)   = NaN;
                    OUT_CMFSP(i,j) = NaN;
                end

            end
        end
        %
    elseif strcmp(TYPE_REDUCTION, 'centroid') | strcmp(TYPE_REDUCTION, 'csums') | strcmp(TYPE_REDUCTION, 'avg')
        % OUT_TEMPLATE_MF LOWER y UPPER
        OUT_TEMPLATE_MFL = zeros(sum(OUT_MF_N), point_n);
        OUT_TEMPLATE_MFU = zeros(sum(OUT_MF_N), point_n);
        cum_mf = cumsum(OUT_MF_N);
        for i = 1:sum(OUT_MF_N),
            tmp = find((cum_mf-i) >= 0);
            output_index = tmp(1); % output index
            mftype2 = evalmftype2(linspace(BOUND(IN_N+output_index,1), ...
                      BOUND(IN_N+output_index,2), point_n), ...
                      OUT_PARAM(i, :), deblank(OUT_MF_TYPE(i, :)));
            OUT_TEMPLATE_MFL(i, :) = mftype2.LU{1}(:,1);
            OUT_TEMPLATE_MFU(i, :) = mftype2.LU{1}(:,2);
        end
        %
        OUT_MFL = zeros(RULE_N, point_n*OUT_N);
        OUT_MFU = zeros(RULE_N, point_n*OUT_N);
        for i = 1:RULE_N,
            for j = 1:OUT_N,
                mf_index = RULE_LIST(i, IN_N+j);
                index = sum(OUT_MF_N(1:j-1)) + abs(mf_index);
                if mf_index > 0,    % regular MF
                    OUT_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                        OUT_TEMPLATE_MFL(index, :);
                    OUT_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                        OUT_TEMPLATE_MFU(index, :);
                elseif mf_index < 0,% Linguistic hedge "NOT"
                    OUT_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                        1 - OUT_TEMPLATE_MFU(index, :);
                    OUT_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                        1 - OUT_TEMPLATE_MFL(index, :);
                else                % Don't care (mf_index == 0)    
                    OUT_MFL(i, (j-1)*point_n+1:j*point_n) = ...
                        ones(1, point_n)*NaN;
                    OUT_MFU(i, (j-1)*point_n+1:j*point_n) = ...
                        ones(1, point_n)*NaN;
                end
            end
        end
        %
    else
        error('Unknown Type-Reduction Method!');
    end
    
    % Allocate other matrices
    QUALIFIED_OUT_MFL = zeros(RULE_N, point_n*OUT_N);
    OVERALL_OUT_MFL   = zeros(1, point_n*OUT_N);
    QUALIFIED_OUT_MFU = zeros(RULE_N, point_n*OUT_N);
    OVERALL_OUT_MFU   = zeros(1, point_n*OUT_N);
end

% Error checking for input stack
m = size(input_stack, 1);
n = size(input_stack, 2);
if ~((n >= IN_N) | ((n == 1) & (m >= IN_N))),
    fprintf('The input stack is of size %dx%d,', m, n);
    fprintf('while expected input vector size is %d.\n', IN_N);
    error('Exiting ...');
end
if ((n == 1) & (m == IN_N))
    data_n = 1;
    input_stack = input_stack';
else
    data_n = m;
end
% Allocate output stack
output_stack  = zeros(data_n, OUT_N);
outputL_stack = zeros(data_n, OUT_N);
outputR_stack = zeros(data_n, OUT_N);

% Iteration through each row of input stack
for kkk = 1:data_n
    input = input_stack(kkk, :);
    %%%%
    if strcmp(INPUTSFUZZIFIER,'non-singleton')
        %% Interval Type-2 Fuzzy set, Q
        IN_MFXL = zeros(IN_N, point_n);
        IN_MFXU = zeros(IN_N, point_n);
        for i=1:IN_N
            IN_X(i, :) = linspace(BOUND(i,1),BOUND(i,2), point_n);
            type = deblank(IN_MFX_TYPE(i, :));         
            mfxparams = getmfxparam(input(i),INX_PARAM(i,:),type);            
            mfxtype2 = evalmftype2(IN_X(i, :),mfxparams,type);
            IN_MFXL(i, :)  = mfxtype2.LU{1}(:,1);
            IN_MFXU(i, :) = mfxtype2.LU{1}(:,2);
        end
        %
        IN_MFQ_L  = zeros(RULE_N, point_n*IN_N);
        IN_MFQ_U  = zeros(RULE_N, point_n*IN_N);
        in_mf_valueL  = zeros(RULE_N, IN_N);
        in_mf_valueU  = zeros(RULE_N, IN_N);
        for i = 1:RULE_N
            for j = 1:IN_N            
                Op1L = IN_MFXL(j, :);
                Op2L = IN_MFL(i,(j-1)*point_n+1:j*point_n);            
                IN_MFQ_L(i,(j-1)*point_n+1:j*point_n) = feval(AND_METHOD,[Op1L;Op2L]);
                in_mf_valueL(i,j) = max(IN_MFQ_L(i,(j-1)*point_n+1:j*point_n));
                Op1U = IN_MFXU(j, :);
                Op2U = IN_MFU(i,(j-1)*point_n+1:j*point_n);            
                IN_MFQ_U(i,(j-1)*point_n+1:j*point_n) = feval(AND_METHOD,[Op1U;Op2U]);
                in_mf_valueU(i,j) = max(IN_MFQ_U(i,(j-1)*point_n+1:j*point_n));
            end
        end
    elseif strcmp(INPUTSFUZZIFIER,'singleton')
        % Find in_template_mf_value
        in_template_mf_valueL = zeros(sum(IN_MF_N), 1);
        in_template_mf_valueU = zeros(sum(IN_MF_N), 1);
        cum_mf = cumsum(IN_MF_N);
        for i = 1:sum(IN_MF_N)
            tmp = find((cum_mf-i) >= 0);
            input_index = tmp(1);
            mftype2 = evalmftype2(input(input_index), IN_PARAM(i, :), deblank(IN_MF_TYPE(i, :)));
            in_template_mf_valueL(i) = mftype2.LU{1}(:,1);
            in_template_mf_valueU(i) = mftype2.LU{1}(:,2);
        end
        % Reordering to fill in_mf_value, which is an (RULE_N X IN_N) matrix.
        in_mf_valueL = zeros(RULE_N, IN_N);
        in_mf_valueU = zeros(RULE_N, IN_N);
        for i = 1:RULE_N
            for j = 1:IN_N            
                mf_index = RULE_LIST(i,j);
                index = sum(IN_MF_N(1:j-1)) + abs(mf_index);
                if mf_index > 0       % regular MF
                    in_mf_valueL(i,j) = ...
                        in_template_mf_valueL(index, :);
                    in_mf_valueU(i,j) = ...
                        in_template_mf_valueU(index, :); 
                elseif mf_index < 0 % Linguistic hedge "NOT"
                    in_mf_valueL(i,j) = ...
                        1 - in_template_mf_valueL(index, :);
                    in_mf_valueU(i,j) = ...
                        1 - in_template_mf_valueU(index, :); 
                else                        % Don't care (MF index == 0)
                    in_mf_valueL(i,j) = NaN;
                    in_mf_valueU(i,j) = NaN;
                end
            end
        end
    else
        error('Unknown Inputs Fuzzifier Method!');
    end
    %%%%
    
    % Find the firing strengths
    firing_strengthL = zeros(RULE_N, 1);
    firing_strengthU = zeros(RULE_N, 1);
    and_index = find(AND_OR == 1);
    or_index  = 1:RULE_N;
    or_index(and_index) = [];
    
    if (size(and_index,2) == 0 & size(or_index,2) == 0)
        error('Unknown Index Rule!');
    end

    if size(and_index,1) ~= 0
        for k=1:size(and_index,1)
            in_v  = find(RULE_LIST(and_index(k),1:IN_N)~=0);
            if size(in_v,2) ~= 1
                firing_strengthL(and_index(k)) = feval(AND_METHOD, in_mf_valueL(and_index(k),in_v)')';
                firing_strengthU(and_index(k)) = feval(AND_METHOD, in_mf_valueU(and_index(k),in_v)')';
            else
                firing_strengthL(and_index(k)) = in_mf_valueL(and_index(k),in_v);
                firing_strengthU(and_index(k)) = in_mf_valueU(and_index(k),in_v);
            end
        end
    end
    
    if size(or_index,2) ~= 0
        for k=1:size(or_index,2)
            in_v  = find(RULE_LIST(or_index(k),1:IN_N)~=0);
            if size(in_v,2) ~= 1
                firing_strengthL(or_index(k))  = feval(OR_METHOD, in_mf_valueL(or_index(k),in_v)')';
                firing_strengthU(or_index(k))  = feval(OR_METHOD, in_mf_valueU(or_index(k),in_v)')';
            else
                firing_strengthL(or_index(k))  = in_mf_valueL(or_index(k),in_v);
                firing_strengthU(or_index(k))  = in_mf_valueU(or_index(k),in_v);
            end
        end
    end
    
    % Recalculate firing strengths scaled by rule weights)
    firing_strengthL = firing_strengthL.*RULE_WEIGHT;
    firing_strengthU = firing_strengthU.*RULE_WEIGHT;
    
    % Find output
    if strcmp(FIS_TYPE, 'sugeno')
        output_c = OUT_PARAM(:, 1:(IN_N+1))*[input(:); 1]; % Compute center
        output_s = OUT_PARAM(:,((IN_N+1)+1):2*(IN_N+1))*abs([input(:); 1]); % Compute spread)
        % Compute OUT_TEMPLATE_MF
        out_template_mf_valueL = output_c - output_s; % Compute OUT_TEMPLATE_MF left
        out_template_mf_valueR = output_c + output_s; % Compute OUT_TEMPLATE_MF right
        % Reordering to fill out_mf_value, which is an (RULE_N X OUT_N) matrix.
        out_mf_valueL = zeros(RULE_N, OUT_N);
        out_mf_valueR = zeros(RULE_N, OUT_N);
        for i = 1:RULE_N
            for j = 1:OUT_N            
                mf_index = RULE_LIST(i,IN_N+j);
                index = sum(OUT_MF_N(1:j-1)) + abs(mf_index);
                if mf_index > 0    % regular MF
                    out_mf_valueL(i,j) = out_template_mf_valueL(index, :);
                    out_mf_valueR(i,j) = out_template_mf_valueR(index, :);
                else                % Don't care (MF index == 0)
                    out_mf_valueL(i,j) = NaN;
                    out_mf_valueR(i,j) = NaN;
                end
            end
        end
        %
        if strcmp(TYPE_REDUCTION,'wtaver')
            L_OUT = [];
            R_OUT = [];
            Y_OUT = [];
            for j=1:OUT_N
                k = find(~isnan(out_mf_valueL(:,j)));
                rule_outputL = out_mf_valueL(k,j);
                firingL      = firing_strengthL(k);
                rule_outputR = out_mf_valueR(k,j);
                firingU      = firing_strengthU(k);
                %
                c = (rule_outputR + rule_outputL)/2;
                s = (rule_outputR - rule_outputL)/2;
                h = (firingU + firingL)/2;
                delta = (firingU - firingL)/2;                
                [l_out,r_out]=typeReduction(c,s,h,delta,TYPE_REDUCTION,TR_ALGORITHM);
                %                
                y_out = (l_out+r_out)/2;
                L_OUT = [L_OUT l_out];
                R_OUT = [R_OUT r_out];
                Y_OUT = [Y_OUT y_out];
            end
            output_stack(kkk,:) =Y_OUT;
            outputL_stack(kkk,:)=L_OUT;
            outputR_stack(kkk,:)=R_OUT;
            %
        else
            error('Unknown Type-Reduction Method!');
        end
        %
    elseif strcmp(FIS_TYPE, 'mamdani')
            %
            % Transform OUT_MF to QUALIFIED_OUT_MF
            % Duplicate firing_strength.
            tmpL = firing_strengthL(:, ones(1, point_n));
            tmpU = firing_strengthU(:, ones(1, point_n));
            for k=1:RULE_N
                out_v = find(RULE_LIST(k,IN_N+1:IN_N+OUT_N)~=0);
                out_n = size(out_v,2);
                for j=1:out_n
                    if strcmp(IMP_METHOD, 'prod')       % IMP_METHOD == 'prod'
                        QUALIFIED_OUT_MFL(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n) = ...
                            tmpL(k,:).*OUT_MFL(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n);
                        QUALIFIED_OUT_MFU(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n) = ...
                            tmpU(k,:).*OUT_MFU(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n);
                    elseif strcmp(IMP_METHOD, 'min')   % IMP_METHOD == 'min'
                        QUALIFIED_OUT_MFL(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n) = ...
                            feval(IMP_METHOD, tmpL(k,:), OUT_MFL(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n));
                        QUALIFIED_OUT_MFU(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n) = ...
                            feval(IMP_METHOD, tmpU(k,:), OUT_MFU(k,(out_v(j)-1)*point_n+1:out_v(j)*point_n));
                    else    % IMP_METHOD is user-defined
                        tmp1L = feval(IMP_METHOD, [tmpL(:)'; OUT_MFL(:)']);
                        tmp1U = feval(IMP_METHOD, [tmpU(:)'; OUT_MFU(:)']);
                        QUALIFIED_OUT_MFL = reshape(tmp1L, RULE_N, point_n*OUT_N);
                        QUALIFIED_OUT_MFU = reshape(tmp1U, RULE_N, point_n*OUT_N);
                    end
                end
            end
            % AGG_METHOD = 'sum' or 'max' or 'probor' or user-defined
            OVERALL_OUT_MFL = feval(AGG_METHOD, QUALIFIED_OUT_MFL);
            OVERALL_OUT_MFU = feval(AGG_METHOD, QUALIFIED_OUT_MFU);
            %
        if strcmp(TYPE_REDUCTION, 'cos')
            %
            L_OUT = [];
            R_OUT = [];
            Y_OUT = [];
            for j=1:OUT_N
                k = find(~isnan(OUT_CMFL(:,j)));
                rule_outputL = OUT_CMFL(k,j);
                firingL      = firing_strengthL(k);
                rule_outputR = OUT_CMFU(k,j);
                firingU      = firing_strengthU(k);
                c = (rule_outputR + rule_outputL)/2;
                s = (rule_outputR - rule_outputL)/2;
                h = (firingU + firingL)/2;
                delta = (firingU - firingL)/2;                
                % [l_out,r_out]=cos_tr(z,s,w,delta);
                [l_out,r_out]=typeReduction(c,s,h,delta,TYPE_REDUCTION,TR_ALGORITHM);
                y_out = (l_out+r_out)/2;
                L_OUT = [L_OUT l_out];
                R_OUT = [R_OUT r_out];
                Y_OUT = [Y_OUT y_out];
            end
            output_stack(kkk,:) =Y_OUT;
            outputL_stack(kkk,:)=L_OUT;
            outputR_stack(kkk,:)=R_OUT;
            %
        elseif strcmp(TYPE_REDUCTION, 'height')
            %
            L_OUT = [];
            R_OUT = [];
            Y_OUT = [];
            for j=1:OUT_N
                k = find(~isnan(OUT_CMF(:,j)));
                c = OUT_CMF(k,j);
                s = zeros(size(c));
                firingL = firing_strengthL(k);
                firingU = firing_strengthU(k);
                h        = (firingU + firingL)/2;
                delta   = (firingU - firingL)/2;
                [l_out,r_out]=typeReduction(c,s,h,delta,TYPE_REDUCTION,TR_ALGORITHM);
                % [l_out,r_out]=height_tr(h',w',delta');
                y_out = (l_out+r_out)/2;
                L_OUT = [L_OUT l_out];
                R_OUT = [R_OUT r_out];
                Y_OUT = [Y_OUT y_out];
            end
            output_stack(kkk,:) =Y_OUT;
            outputL_stack(kkk,:)=L_OUT;
            outputR_stack(kkk,:)=R_OUT;
            %
        elseif strcmp(TYPE_REDUCTION, 'mdheight')
            %
            L_OUT = [];
            R_OUT = [];
            Y_OUT = [];
            for j=1:OUT_N
                k = find(~isnan(OUT_CMF(:,j)));
                c = OUT_CMF(k,j);
                s = zeros(size(c));
                sp      = OUT_CMFSP(k,j);
                firingL = firing_strengthL(k);
                firingU = firing_strengthU(k);
                wf = (firingU + firingL)/2;
                h = wf./(sp.^2);
                deltaf = (firingU - firingL)/2;
                delta = deltaf./(sp.^2);
                [l_out,r_out]=typeReduction(c,s,h,delta,TYPE_REDUCTION,TR_ALGORITHM);
                % [l_out,r_out]=md_height_tr(h',w',delta',sp');
                y_out = (l_out+r_out)/2;
                L_OUT = [L_OUT l_out];
                R_OUT = [R_OUT r_out];
                Y_OUT = [Y_OUT y_out];
            end
            output_stack(kkk,:) =Y_OUT;
            outputL_stack(kkk,:)=L_OUT;
            outputR_stack(kkk,:)=R_OUT;
        elseif strcmp(TYPE_REDUCTION, 'centroid')
            % The centroid type-reducer (centroid) combines output sets for different
            % rules by finding their union (AGG_METHOD = 'sum'), so that
            % the membership function of the combined output set.
            for i = 1:OUT_N
                c =(linspace(BOUND(IN_N+i,1), BOUND(IN_N+i,2), point_n))';
                s = zeros(size(c));
                CL=OVERALL_OUT_MFL(1,(i-1)*point_n+1:i*point_n);
                CU=OVERALL_OUT_MFU(1,(i-1)*point_n+1:i*point_n);
                h = ((CU+CL)/2)';
                delta = ((CU-CL)/2)';
                [l_out,r_out]=typeReduction(c,s,h,delta,TYPE_REDUCTION,TR_ALGORITHM);
                % [yl,yr]=centroid_tr(y',h',delta');
                output_stack(kkk,i) = (r_out+l_out)/2;  
                outputL_stack(kkk,i) = l_out;
                outputR_stack(kkk,i) = r_out;
            end
        elseif strcmp(TYPE_REDUCTION, 'csums')
            % The center-of-sums type-reducer (csums) combines output sets for different
            % rules by summing (AGG_METHOD = 'sum' or 'probor'), so that
            % the membership function of the combined output set.
            %
            for i = 1:OUT_N
                c =(linspace(BOUND(IN_N+i,1), BOUND(IN_N+i,2), point_n))';
                s = zeros(size(c));
                CL=OVERALL_OUT_MFL(1,(i-1)*point_n+1:i*point_n);
                CU=OVERALL_OUT_MFU(1,(i-1)*point_n+1:i*point_n);
                h      = ((CU+CL)/2)';
                delta  = ((CU-CL)/2)';
                [l_out,r_out]=typeReduction(c,s,h,delta,TYPE_REDUCTION,TR_ALGORITHM);
                % [yl,yr]=csum_tr(y,h,delta);
                output_stack(kkk,i) = (r_out+l_out)/2;  
                outputL_stack(kkk,i) = l_out;
                outputR_stack(kkk,i) = r_out;
            end
        else
            error('Unknown Type-Reduction Method!');
        end
    else
        fprintf('fis_type = %d\n', FIS_TYPE);
        error('Unknown FIS type!');
    end % if strcmp(FIS_TYPE)
end % for kkk
%
if nargout >= 4
    IRR_L = in_mf_valueL;
    IRR_U = in_mf_valueU;
end 
%
if strcmp(FIS_TYPE, 'sugeno')
    if nargout >= 5
        % Consequent
        ORR_L = out_mf_valueL;
        ORR_U = out_mf_valueR;
    end
    if nargout >= 6
        ARR_L = firing_strengthL(:, ones(1,OUT_N));
        ARR_U = firing_strengthU(:, ones(1,OUT_N));
    end
else
    if nargout >= 5
        % Consequent
        ORR_L = [];
        ORR_U = [];
        for iii = 1:OUT_N
            ORR_L = [ORR_L; QUALIFIED_OUT_MFL(:,(iii-1)*point_n+1:iii*point_n)];
            ORR_U = [ORR_U; QUALIFIED_OUT_MFU(:,(iii-1)*point_n+1:iii*point_n)];
        end
        ORR_L = ORR_L';
        ORR_U = ORR_U';
    end
    if nargout >= 6
        ARR_L = reshape(OVERALL_OUT_MFL, point_n, OUT_N);
        ARR_U = reshape(OVERALL_OUT_MFU, point_n, OUT_N);
    end
end % end evalifistype2
