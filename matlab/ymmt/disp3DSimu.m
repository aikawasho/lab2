%シミュレーションを表示する関数

function disp3DSimu(titleName,X,Y,Z,P)
     % simulationの表示
    figure
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(gcf,'units','points','position',[x0,y0,width,height])
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.2 .1 .7 .8]);
%     title(strcat(num2str(rad2deg(phase)),' degree'));
    title(titleName);
    hold on
    xslice = 0;
    yslice = 0;
    zslice = 0;
    ax2 = gca;
    axes(ax2);
    
    % 3Dplot
    slice_plot = slice(X,Y,Z,P,xslice,yslice,zslice);
    %volumeData = get(zslice_plot,'CData');
    %minVolumeData = min(min(volumeData));
    %maxVolumeData = max(max(volumeData));
    pbaspect([1 1 1]) % graph縦横比
    set(ax2, 'FontSize', 22);
    set(slice_plot,'LineStyle','none');  
    cbar = colorbar;
    %cbar.Label.String = 'sound pressure';
    %cbar.TicksMode = 'manual'; % 値を表示しない
    %cbar.Limits = [0 maxVolumeData];
    %set(ax2, 'CLim', [minVolumeData maxVolumeData]);
    %set(ax2, 'XLim', [-20 20]);
    %set(ax2, 'YLim', [-20 20]);
    
    %cbar.Position = [0.93 0.1000 0.0308 0.8000];
    ax = gca;
    ax.XLabel.String = 'x-axis [mm]';
    ax.YLabel.String = 'y-axis [mm]';
    ax.ZLabel.String = 'z-axis [mm]';
    set(ax,'FontSize', 22);
    
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 30 15];
    
    axes(ax2)
    view(3);

    
    
  


    % 現在の位相を表示
%     axes(ax1);
%     descr = {strcat('周波数',num2str(f),'Hz'), ...
%         strcat('波長',num2str(ramda),'mm'), ...
%         strcat('Z-position: ',num2str(z_position)), ...
%         strcat('位相: ',num2str(phase/pi),'π','(',num2str(rad2deg(phase)),'deg',')') , ...
%         strcat('反射率: ', num2str(reflectRate))
%         };
%     text(.025,0.6,descr,'FontSize',35)
%     set(ax1, 'FontSize', 35);

    
%     print(strcat('focusRowChangeView3_',num2str(Ph_num)),'-dpng','-r0');
%     
%     view(-90,0)
%     print(strcat('focusRowChangeYZ',num2str(Ph_num)),'-dpng','-r0');
%     
    j=1;
    %save(filename)
    

end