% figureからデータを得る

h = gcf;
axesObjs = get(h,'Children');
dataObjs = get(axesObjs, 'Children');


% a = gca; % 現在の座標軸またはチャート
% get(a,'CLim'); % colorbar
% axesObjs2 = get(a,'Children');

% axesObj2からSurfaceオブジェクトを取り出す
% surfaceData = axesObjs2(81); %もし81番目にSurfaceObjectがあった場合
% cValue = get(surfaceData, 'CData'); %surfaceDataからカラープロット用のデータを取り出す。
% cValueMax = max(max(cValue));
% cValueMin = min(min(cValue));

% 保存してあるfigureを開いて、cLimを変更し、保存
figList = dir('*.fig');
for i = 1:length(figList)
    open(figList(i).name);
    
   
    ax = gca; % 現在の座標軸またはチャート
    set(ax, 'FontSize', 60);
    x0=10;
    y0=10;
    width=650;
    height=640;
    set(gcf,'units','points','position',[x0,y0,width,height])
    
    get(ax,'CLim'); % colorbar
    axesObjs2 = get(ax,'Children');
    surfaceData = axesObjs2(end); %もし81番目にSurfaceObjectがあった場合
    cValue = get(surfaceData, 'CData'); %surfaceDataからカラープロット用のデータを取り出す。
    cValueMax = max(max(cValue));
    cValueMin = min(min(cValue));
    cbar = colorbar;
    cbar.Label.String = 'sound pressure';
    cbar.TicksMode = 'manual'; % 値を表示しない
    cbar.Limits = [0 maxVolumeData];
    set(ax, 'CLim', [cValueMin cValueMax]);
    saveas(gcf,strcat(figList(i).name(1:end-4),'.png'));
    nameIndex = nameIndex+1;
    
    close all;
end

