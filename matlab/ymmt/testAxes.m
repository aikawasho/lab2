h = figure;

x0=10;
y0=10;
width=650;
height=500;
set(gcf,'units','points','position',[x0,y0,width,height]);
ax1 = axes('Position',[0 0 1 1],'Visible','off');
ax2 = axes('Position',[.3 .2 .6 .71]);
set(ax2, 'FontSize', 22);
axes(ax2);


ax = gca;
ax.XLabel.String = 'x-axis [mm]';
ax.YLabel.String = 'y-axis [mm]';
ax.ZLabel.String = 'z-axis [mm]';
view(90,0)

axes(ax1);
descr = 'I am a test';
text(.025,0.7,descr,'FontSize',22);