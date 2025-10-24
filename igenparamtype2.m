function mf_param = igenparamtype2(data,mf_n,mf_type)
% igenparamtype2 Generate initial interval type-2 membership function parameters
%
% Example:
%
% NumData = 500;
% data = [rand(NumData,1) 10*rand(NumData,1)-5];
% NumMf = [5 7];
% MfType = str2mat('igaussmtype2','igbellmtype2');
% MfParams = igenparamtype2(data,NumMf,MfType);
% set(gcf,'Name','genparam','NumberTitle','off');
% NumInput = size(data, 2);
% range = minmax(data');
% for i = 1:NumInput,
%      subplot(NumInput, 1, i);
%      x = linspace(range(i, 1), range(i, 2), 100);
%      for j=1:NumMf(i),
%          A = evalimftype2(x,MfParams{i}(j,:),MfType(i,:));
%          plot2dtype2(A); hold on
%      end
%      xlabel(['input ' num2str(i) ' (' MfType(i, :) ')']);
% end
%
% Change this to have different default values

default_mf_n    = 2;
default_mf_type = 'igbelltype2';
if nargin <= 2
    mf_type = default_mf_type;
end
if nargin <= 1
    mf_n = default_mf_n;
end
% get dimension info
data_n = size(data,1);
in_n   = size(data, 2);
range  = [min(data)' max(data)'];
% generate mf_n and mf_type of proper sizes
if length(mf_n) == 1
    mf_n = mf_n(ones(in_n, 1), :);
end
if size(mf_type, 1) == 1 % single mf_type for all IT2MFs
    mf_type = mf_type(ones(in_n, 1), :);
end
% error checking
if length(mf_n) ~= in_n || size(mf_type, 1) ~= in_n
    error('Wrong sizes of given argument(s)!');
end
%
for i = 1:in_n
    dx = (range(i,2) - range(i, 1))/6/(mf_n(i) - 1);
    type = deblank(mf_type(i, :));
    if strcmp(type, 'igbelltype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        b = 2;
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [a(ones(mf_n(i), 1))-dx/10 b(ones(mf_n(i), 1)) c1 ...
                       a(ones(mf_n(i), 1))+dx/10 b(ones(mf_n(i), 1)) c2];
    %               
    elseif strcmp(type, 'igbellatype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        b = 2;
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        alpha = 0.85;
        mf_param{i} = [a(ones(mf_n(i), 1)) b(ones(mf_n(i), 1)) c alpha(ones(mf_n(i),1))];
    %
    elseif strcmp(type, 'igbellmtype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        b = 2;
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [a(ones(mf_n(i), 1)) b(ones(mf_n(i), 1)) c1 c2];
    %
    elseif strcmp(type, 'igbellmsttype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        b = 2;
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [a(ones(mf_n(i), 1)) b(ones(mf_n(i), 1)) c1 c2];
    %
    elseif strcmp(type, 'igbellstype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        a1 = a(ones(mf_n(i), 1))-dx ; a2 = a(ones(mf_n(i), 1))+dx;
        b = 2;
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        mf_param{i} = [a1 a2 b(ones(mf_n(i), 1)) c];
    %
    elseif strcmp(type, 'igausstype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        a = a/sqrt(2*log(2));
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [a(ones(mf_n(i), 1)) c1 a(ones(mf_n(i), 1)) c2];
    %
    elseif strcmp(type, 'igausssttype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        a = a/sqrt(2*log(2));
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [a(ones(mf_n(i), 1)) c1 a(ones(mf_n(i), 1)) c2];
    %
    elseif strcmp(type, 'igaussatype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        a = a/sqrt(2*log(2));
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        alpha = 0.85;
        mf_param{i} = [a(ones(mf_n(i), 1)) c alpha(ones(mf_n(i),1))];
    %
    elseif strcmp(type, 'igaussmtype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        a = a/sqrt(2*log(2));
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [a(ones(mf_n(i), 1)) c1 c2];
    %
    elseif strcmp(type, 'igaussmsttype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        a = a/sqrt(2*log(2));
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [a(ones(mf_n(i), 1)) c1 c2];
    %
    elseif strcmp(type, 'igaussstype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        a = a/sqrt(2*log(2));
        a1= a(ones(mf_n(i), 1))-dx*0.60; a2= a(ones(mf_n(i), 1))+dx*0.60;
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        d = zeros(mf_n(i), 1);
        mf_param{i} = [a1 a2 c];
    %
    elseif strcmp(type, 'igauss2type2')
        %
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - 0.6*a;
        c2 = c + 0.6*a;
        sigma = 0.4*a/sqrt(2*log(2))*ones(mf_n(i), 1); 
        mf_param{i} = [sigma c1-dx sigma c2-dx sigma c1+dx sigma c2+dx];
    %
    elseif strcmp(type, 'isigtype2')
        a = (range(i,2) - range(i, 1))/10/(mf_n(i) - 1);
        tmp = 10/(range(i,2) - range(i, 1))*mf_n(i)*ones(mf_n(i), 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        mf_param{i} = [tmp-dx/5 c-a tmp+dx/5 c+a];
    %
    elseif strcmp(type, 'istype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - 0.6*a;
        c2 = c + 0.6*a;
        mf_param{i} = [c1-dx c2-dx c1+dx c2+dx ];
    %
    elseif strcmp(type, 'iztype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - 0.6*a;
        c2 = c + 0.6*a;
        mf_param{i} = [c1-dx c2-dx c1+dx c2+dx ];
    %
    elseif strcmp(type, 'isigmtype2')
        a = (range(i,2) - range(i, 1))/10/(mf_n(i) - 1);
        tmp = 10/(range(i,2) - range(i, 1))*mf_n(i)*ones(mf_n(i), 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        mf_param{i} = [tmp c-a c+a];
    %
    elseif strcmp(type, 'idsigtype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        tmp = 12/(range(i,2) - range(i, 1))*mf_n(i)*ones(mf_n(i), 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - 0.6*dx; c2= c + 0.6*dx;
        mf_param{i} = [tmp c1-a tmp c1+a tmp c2-a tmp c2+a];
    %
    elseif strcmp(type, 'ipsigtype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        tmp = 10/(range(i,2) - range(i, 1))*mf_n(i)*ones(mf_n(i), 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - 0.6*dx; c2= c + 0.6*dx;
        mf_param{i} = [tmp c1-a -tmp c1+a tmp c2-a -tmp c2+a];
    %
    elseif strcmp(type, 'itritype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - dx; c2= c + dx;
        mf_param{i} = [c1-2*a c1 c1+2*a c2-2*a c2 c2+2*a];
    %
    elseif strcmp(type, 'itristype2')
        a  = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c  = linspace(range(i, 1), range(i, 2), mf_n(i))';
        sa = 1.5*dx; sc= 1.5*dx;
        mf_param{i} = [c-2*a c+2*a sa(ones(mf_n(i),1)) sc(ones(mf_n(i),1))];
    %
    elseif strcmp(type, 'itrapatype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1 = c - 0.6*dx; c2= c + 0.6*dx;
        alpha = 0.95;
        mf_param{i} = [c1-1.4*a c1-0.6*a c1+0.6*a c1+1.4*a c2-1.4*a c2-0.6*a c2+0.6*a c2+1.4*a alpha(ones(mf_n(i),1))];
    %
    elseif strcmp(type, 'itrapstype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        sa = dx;
        sd = dx;
        sn = 0.9*dx;
        ca = 0.8;    % cut-alpha
        mf_param{i} = [c-1.4*a c+1.4*a sa(ones(mf_n(i),1)) sd(ones(mf_n(i),1)) sn(ones(mf_n(i),1)) ca(ones(mf_n(i),1))];
    %    
    elseif strcmp(type, 'ipitype2')
        a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
        c = linspace(range(i, 1), range(i, 2), mf_n(i))';
        c1= c - dx; c2= c + dx;
        mf_param{i} = [c1-1.4*a c1-0.6*a c1+0.6*a c1+1.4*a c2-1.4*a c2-0.6*a c2+0.6*a c2+1.4*a];
    %    
    elseif strcmp(type, 'isingletype2')
    % a = (range(i,2) - range(i, 1))/2/(mf_n(i) - 1);
    % a = a/sqrt(2*log(2));
    c = linspace(range(i, 1), range(i, 2), mf_n(i))';
    c1 = c - dx; c2= c + dx;
    mf_param{i} = [c1 c2];

    else
        fprintf('mf_type = %s\n', type);
        error('Unsupported IT2MF type!');
    end
end
