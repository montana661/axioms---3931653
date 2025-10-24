%T1 Ejemplo

%   T1 Ejemplo



clearvars;
close all;


%Case 3
Input1 = 0.22;
Input2 = 0.33;


x = newfistype1('T1_Aggregator','mamdani','singleton','min','max','min','max','centroid');

% Add the first input variable
x=addvartype1(x,'input','Entrada1',[0 1]);

% Add the second input variable
x=addvartype1(x,'input','Entrada2',[0 1]);



%Number of divisions = Number of Input MF per module input.
v = 3;

%Operación para dividir el espacio equitativamente entre las v divisiones.
espacioMF = 1/v;


x=addmftype1(x,'input',1,'Low','gaussmf',[0.2 espacioMF*0.5]);
x=addmftype1(x,'input',1,'Medium','gaussmf',[0.2 espacioMF*1.5]);
x=addmftype1(x,'input',1,'High','gaussmf',[0.2 espacioMF*2.5]);

figure;
plotmftype1(x,'input',1)


x=addmftype1(x,'input',2,'Low','gaussmf',[0.2 espacioMF*0.5]);
x=addmftype1(x,'input',2,'Medium','gaussmf',[0.2 espacioMF*1.5]);
x=addmftype1(x,'input',2,'High','gaussmf',[0.2 espacioMF*2.5]);


figure;
plotmftype1(x,'input',2)

% Add the output variable
x=addvartype1(x,'output','Salida',[0 1]);

%Number of classes = Number of Output MF  (...Analizar mejor...)
x=addmftype1(x,'output',1,'Low','gaussmf',[0.2 espacioMF*0.5]);
x=addmftype1(x,'output',1,'Medium','gaussmf',[0.2 espacioMF*1.5]);
x=addmftype1(x,'output',1,'High','gaussmf',[0.2 espacioMF*2.5]);


figure;
plotmftype1(x,'output',1)

% Add the rules
ruleList=[ ...
1 1 1 1 1 
1 2 1 1 1 
2 1 1 1 1
2 3 2 1 1 
3 2 2 1 1 
3 3 2 1 1 ];
x=addruletype1(x,ruleList);



writefistype1(x,'T1_FuzzySystem.fis');

x = readfistype1('T1_FuzzySystem.fis');



figure;
gensurftype1(x);


%Evaluate Fis
output = evalfistype1([Input1 Input2],x);
