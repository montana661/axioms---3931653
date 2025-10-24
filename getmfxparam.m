function mfxparams = getmfxparam(x,paramx,type)
%   getmfxparam

%   Juan R. Castro, 7-25-2005, 11-9-2013.
%   Copyright 2006-2013 FCQI, UABC 
%   $Revision: 1.11 $  $Date: 2012/02/15 18:24:22 $

if strcmp(type,'itritype2')
    mfxparams = [x-paramx(3)-paramx(1),x-paramx(3),x-paramx(3)+paramx(2),...
                 x+paramx(3)-paramx(4),x+paramx(3),x+paramx(3)+paramx(5)];
elseif strcmp(type,'itrapatype2')
    mfxparams = [x-2*paramx(3)-paramx(1),x-2*paramx(3),x+paramx(3),x+paramx(3)+paramx(2),...
                 x-paramx(3)-paramx(4),x-paramx(3),x+2*paramx(3),x+2*paramx(3)+paramx(5),paramx(6)];
elseif strcmp(type,'igaussmtype2')
    mfxparams = [paramx(1),x-paramx(2),x+paramx(2)];
elseif strcmp(type,'igaussstype2')
    mfxparams = [paramx(1),paramx(2),x];
elseif strcmp(type,'igaussatype2')
    mfxparams = [paramx(1),x,paramx(2)];
elseif strcmp(type,'igbellmtype2')
    mfxparams = [paramx(1),paramx(2),x-paramx(3),x+paramx(3)];
elseif strcmp(type,'igbellstype2')
    mfxparams = [paramx(1),paramx(2),paramx(3),x];
elseif strcmp(type,'igbellatype2')
    mfxparams = [paramx(1),paramx(2),x,paramx(3)];
elseif strcmp(type,'gaussScaleIntervalType2MF')
    mfxparams = {{[paramx(1) x]},paramx(2),paramx(3)};
else
    fprintf('mf_type = %s\n', type);
    error('Unsupported IT2MF type!');
end
