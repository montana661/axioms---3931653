fis = newfistype2('betafis_IT2','mamdani','singleton','min',...
                              'max','min','max','centroid','iwa');
                                      

%Number of divisions = Number of Input MF per module input.
v = 3;

%Operación para dividir el espacio equitativamente entre las v divisiones.
espacioMF = 1/v;

                          
% input 1
fis = addvartype2(fis,'input','Entrada1',[0 1.5]);
fis = addmftype2(fis,'input',1,'Low','itrapatype2',[0.00 0.00 0.35 0.70  0.00 0.00 0.45 0.85]);  
fis = addmftype2(fis,'input',1,'Medium','itrapatype2',[0.45 0.60 0.90 1.05  0.35 0.55 0.95 1.15]);
fis = addmftype2(fis,'input',1,'High','itrapatype2',[0.80 1.15 1.50 1.50  0.65 1.05 1.50 1.50]);

figure;
plotmftype2(fis,'input',1);

% Add the output variable
fis=addvartype2(fis,'output','Salida',[0 1.3]);


fis=addmftype2(fis,'output',1,'Low','itrapatype2',[0.00 0.00 0.35 0.70  0.00 0.00 0.45 0.85]);
fis=addmftype2(fis,'output',1,'Medium','itrapatype2',[0.45 0.60 0.90 1.05  0.35 0.55 0.95 1.15]);
fis=addmftype2(fis,'output',1,'High','itrapatype2',[0.80 1.15 1.50 1.50  0.65 1.05 1.50 1.50]);


figure;
plotmftype2(fis,'output',1)


% Add the rules
ruleList=[ ...
1 3 1 1
2 2 1 1
3 1 1 1 ];
% add rule
fis=addruletype2(fis,ruleList);

writefistype2(fis,'betafis_IT2.fis');