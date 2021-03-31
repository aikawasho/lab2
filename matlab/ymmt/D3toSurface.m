% figure‚©‚çƒf[ƒ^‚ğ“¾‚é

a = gca;
axesObjs = get(a,'Children');
surfaceData = axesObjs(end);
X = get(surfaceData,'ZData');
Y = get(surfaceData,'YData');
Z = get(surfaceData,'CData');


figure
mesh(X,Y,Z);
ax = gca;
ax.XLabel.String = 'Z-Axis [mm]';
ax.YLabel.String = 'Y-Axis [mm]';
ax.ZLabel.String = 'Sound pressure[pa]';
set(ax,'FontSize', 35);

