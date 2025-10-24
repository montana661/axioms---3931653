function it2mf=evalIntervalType2MF(x,mf)
    % evalIntervalType2mf: Evaluates Interval Type-2 membership functions
    % Evaluates a type-2 MF with input values x to
    % generate output values mfu and mfl, where mfu represents the evaluated
    % outputs of the upper membership functions of MF and mfl corresponds to
    % the evaluated outputs of the lower membership functions.
    [mfu,mfl] = evalmf(mf,x);
    it2mf.X{1}  = x';
    it2mf.LU{1} = [mfl' mfu'];
end
