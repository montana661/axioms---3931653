function mfxparams = igenparamfx(data,mf_n,mf_type)
% igenparamfx.m

%   Juan R. Castro, 7-25-2005, 11-9-2013.
%   Copyright 2006-2013 FCQI, UABC 
%   $Revision: 1.11 $  $Date: 2012/02/15 18:24:22 $

[~,n]    = size(data);
MfParams = igenparamtype2(data,mf_n,mf_type);
for i = 1:n
    type = deblank(mf_type(i, :));
    if strcmp(type,'igaussmtype2'),
       sx = median(MfParams{i}(:,1));
       dx = median(MfParams{i}(:,3)-MfParams{i}(:,2));
       mfxparams{i} = [sx dx/2];
    elseif strcmp(type,'igaussstype2'),
       sx = median(MfParams{i}(:,1:2));
       mfxparams{i} = [sx];
    else
       fprintf('mf_type = %s\n', type);
       error('Unsupported IT2MF type!');
    end
end
