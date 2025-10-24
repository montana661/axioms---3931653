function set = cutitnorm(w,A,stnorm)
% alpha cut

%   Juan R. Castro, 7-25-2005, 11-9-2013.
%   Copyright 2006-2013 FCQI, UABC 
%   $Revision: 1.11 $  $Date: 2012/02/15 18:24:22 $

set.X=A.X;
set.LU{1}(:,1) = feval(stnorm,w(1),A.LU{1}(:,1));
set.LU{1}(:,2) = feval(stnorm,w(2),A.LU{1}(:,2));
