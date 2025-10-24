function [] = plot2dmftype2(it2mf,options)
    %
    % ********************************************************************
    % * Copyright: Juan R. Castro, Octuber 2015                                       *
    % * UNIVERSIDAD AUTONOMA DE BAJA CALIFORNIA, UABC.                 *
    % * Facultad de Ciencias Quimicas e Ingenieria                                    *
    % * Ingenieria en Computacion, Unidad Tijuana                                   *
    % ********************************************************************
    %
    % Example:
    %
    %   x = linspace(0,10,300);
    %   mf = itritype2(x,[2 5 8 3 6 9]);
    %   plot2dmftype2(mf);
    %   plot2dmftype2(mf,1);
    %   plot2dmftype2(mf,2);
    %   plot2dmftype2(mf,3);
    %
    
    % plot 3D interval type-2 membership functions
    x = it2mf.X{1};              % primary variable
    np = length(x);
    lmf  = it2mf.LU{1}(:,1);
    umf = it2mf.LU{1}(:,2);
    fxu = ones(1,np);          % secondary grade
    if nargin <2
        % 2D-3D Grid Orange
        for k=1:length(x)
            line([x(k) x(k)],[lmf(k) umf(k)],[0 0],'Color',[0.5 0.5 0.5],'LineWidth',2); hold on
            line([x(k) x(k)],[umf(k) lmf(k)],[fxu(k) fxu(k)],'Color',[1 0.6 0.0],'LineWidth',2); hold on
        end
        % 3D line lower (blue)-Upper(red)
        plot3(x,lmf,fxu,'b','LineWidth',2.5); hold on
        plot3(x,lmf,zeros(1,np),'b','LineWidth',2.5); hold on
        plot3(x,umf,fxu,'r','LineWidth',2.5); hold on
        plot3(x,umf,zeros(1,np),'r','LineWidth',2.5); hold on
        stem3(x,lmf,fxu,'.','Color',[0.8 0.8 0.8]); hold on
        stem3(x,umf,fxu,'.','Color',[0.8 0.8 0.8]); grid on
        axis([-inf +inf 0 1 0 1]); view(0,90); box on
        xlabel('x','FontSize',14,'FontWeight','bold');
        ylabel('u','FontSize',14,'FontWeight','bold');
        zlabel('\mu(x,u)','FontSize',14,'FontWeight','bold');
        return;
    end
  
    if options == 1
        % 2D-3D Solid Dark
        for k=1:length(x)
            line([x(k) x(k) x(k) x(k) x(k)],[lmf(k) umf(k) umf(k) lmf(k) lmf(k)], ...
            [0 0 fxu(k) fxu(k) 0],'Color',[0.5 0.5 0.5],'LineWidth',2); hold on
        end
        % 2D-3D line Lower (blue) - Upper (red)
        plot3(x,lmf,fxu,'b','LineWidth',2.5); hold on
        plot3(x,lmf,zeros(1,np),'b','LineWidth',2.5); hold on
        plot3(x,umf,fxu,'r','LineWidth',2.5); hold on
        plot3(x,umf,zeros(1,np),'r','LineWidth',2.5); hold on
        stem3(x,lmf,fxu,'.','Color',[0.5 0.5 0.5]); hold on
        stem3(x,umf,fxu,'.','Color',[0.5 0.5 0.5]); grid on
        axis([-inf +inf 0 1 0 1]); view(0,90); box on
        xlabel('x','FontSize',14,'FontWeight','bold');
        ylabel('u','FontSize',14,'FontWeight','bold');
        zlabel('\mu(x,u)','FontSize',14,'FontWeight','bold');
    elseif options == 2
        % 3D Grid Orange
        for k=1:length(x)
            line([x(k) x(k)],[lmf(k) umf(k)],[0 0],'Color',[0.5 0.5 0.5],'LineWidth',2); hold on
            line([x(k) x(k)],[umf(k) lmf(k)],[fxu(k) fxu(k)],'Color',[1 0.6 0.0],'LineWidth',2); hold on
        end
        % 3D line lower (blue)-Upper(red)
        plot3(x,lmf,fxu,'b','LineWidth',2.5); hold on
        plot3(x,lmf,zeros(1,np),'b','LineWidth',2.5); hold on
        plot3(x,umf,fxu,'r','LineWidth',2.5); hold on
        plot3(x,umf,zeros(1,np),'r','LineWidth',2.5); hold on
        stem3(x,lmf,fxu,'.','Color',[0.8 0.8 0.8]); hold on
        stem3(x,umf,fxu,'.','Color',[0.8 0.8 0.8]); grid on
        axis([-inf +inf 0 1 0 1]); view(-25,70); box on
        xlabel('x','FontSize',14,'FontWeight','bold');
        ylabel('u','FontSize',14,'FontWeight','bold');
        zlabel('\mu(x,u)','FontSize',14,'FontWeight','bold');
    elseif options == 3
        % 3D Solid Dark
        for k=1:length(x)
            line([x(k) x(k) x(k) x(k) x(k)],[lmf(k) umf(k) umf(k) lmf(k) lmf(k)], ...
            [0 0 fxu(k) fxu(k) 0],'Color',[0.5 0.5 0.5],'LineWidth',2); hold on
        end
        % 3D line Lower (blue) - Upper (red)
        plot3(x,lmf,fxu,'b','LineWidth',2.5); hold on
        plot3(x,lmf,zeros(1,np),'b','LineWidth',2.5); hold on
        plot3(x,umf,fxu,'r','LineWidth',2.5); hold on
        plot3(x,umf,zeros(1,np),'r','LineWidth',2.5); hold on
        stem3(x,lmf,fxu,'.','Color',[0.5 0.5 0.5]); hold on
        stem3(x,umf,fxu,'.','Color',[0.5 0.5 0.5]); grid on
        axis([-inf +inf 0 1 0 1]); view(-25,70); box on
        xlabel('x','FontSize',14,'FontWeight','bold');
        ylabel('u','FontSize',14,'FontWeight','bold');
        zlabel('\mu(x,u)','FontSize',14,'FontWeight','bold');
    else
        error('option is unknown');
    end
end
