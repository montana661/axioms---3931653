function A=evalmftype2(x,params,type)
% EVALIMFTYPE2 Evaluate interval type-2 membership function.
% EVALIMFTYPE2 Generic interval type-2 membership function evaluation.
%
%   Synopsis
%   y = evalimftype2(x,params,type)
%   Description
%   evalimftype2 evaluates any interval type-2 membership function, where x is the variable range for
%   the interval type-2 membership function evaluation, type is a interval type-2 membership function from
%   the toolbox, and params are appropriate parameters for that function.
%   If you want to create your own custom interval type-2 membership function, evalimftype2 will
%   still work, because it will still evaluate any interval type-2 membership function whose
%   name it doesn?t recognize.
%
%   Ejemplo:
%
%   x=0:0.1:10;
%   mfparams = [2 4 6 1.5 3.5 5];
%   mftype = 'igbelltype2';
%   y=evalmftype2(x,mfparams,mftype);
%   plot2dtype2(y)
%   title('igbelltype2(x,[2 4 6 1.5 3.5 5])')
%

if (type == 1) | (strcmp(type,'igbelltype2'))
    A = igbelltype2(x, params);
    return;
elseif (type == 2) | (strcmp(type,'igbellatype2'))
    A = igbellatype2(x, params);
    return;
elseif (type == 3) | (strcmp(type,'igbellmtype2'))
    A = igbellmtype2(x, params);
    return;
elseif (type == 4) | (strcmp(type,'igbellstype2'))
    A = igbellstype2(x, params);
    return;
elseif (type == 5) | (strcmp(type,'igbellsmtype2'))
    A = igbellsmtype2(x, params);
    return;

elseif (type == 6) | (strcmp(type,'igausstype2'))
    A = igausstype2(x, params);
    return;
elseif (type == 7) | (strcmp(type,'igaussatype2'))
    A = igaussatype2(x, params);
    return;
elseif (type == 8) | (strcmp(type,'igaussmtype2'))
    A = igaussmtype2(x, params);
    return;
elseif (type == 9) | (strcmp(type,'igaussstype2'))
    A = igaussstype2(x, params);
    return;
elseif (type == 10) | (strcmp(type,'igauss2type2'))
    A = igauss2type2(x, params);
    return;
elseif (type == 11) | (strcmp(type,'isigtype2'))
    A = isigtype2(x, params);
    return;
elseif (type == 12) | (strcmp(type,'istype2'))
    A = istype2(x, params);
    return;
elseif (type == 13) | (strcmp(type,'iztype2'))
    A = iztype2(x, params);
    return;
elseif (type == 14) | (strcmp(type,'isigmtype2'))
    A = isigmtype2(x, params);
    return;
elseif (type == 15) | (strcmp(type,'idsigtype2'))
    A = idsigtype2(x, params);
    return;
elseif (type == 16) | (strcmp(type,'ipsigtype2'))
    A = ipsigtype2(x, params);
    return;
elseif (type == 17) | (strcmp(type,'itritype2'))
    A = itritype2(x, params);
    return;
elseif (type == 18) | (strcmp(type,'itristype2'))
    A = itristype2(x, params);
    return;
elseif (type == 19) | (strcmp(type,'itrapatype2'))
    A = itrapatype2(x, params);
    return;
elseif (type == 20) | (strcmp(type,'itrapstype2'))
    A = itrapstype2(x, params);
    return;
elseif (type == 21) | (strcmp(type,'ipitype2'))
    A = ipitype2(x, params);
    return;
elseif (type == 22) | (strcmp(type,'isingletype2'))
    A = isingletype2(x, params);
    return;
elseif (type == 23) | (strcmp(type,'tsigauss2type2'))
    A = tsigauss2type2(x, params);
    return;
    
else
    % Interval type-2 membership function is unknown
    % We assume it is user-defined and evaluate it here
    evalStr=[type '(x, params)'];
    A = eval(evalStr);
    return;
end
