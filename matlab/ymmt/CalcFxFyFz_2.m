% ポテンシャルからFx,Fy,Fzを計算し、保存
function CalcFxFyFz_2(X, Y, Z, U, range, range_N,slice_x, slice_y, slice_z, saveName, movefileName) %c_0は媒質の音速, fは音波の周波数, rho_pは微小物体の密度, rho_0は媒質の密度, V_pは微小物体の体積
    %各パラメータ設定
    delta_x = 2*range/range_N*10^(-3); delta_y = 2*range/range_N*10^(-3); delta_z = 2*range/range_N*10^(-3);
    
    
    %Forceの計算
    % matlabのgradientを使用してみる
    [F_x, F_y, F_z] =  gradient(U,delta_x,delta_y,delta_z);
    F_x = -F_x; F_y = -F_y; F_z = -F_z;
    figure
    xslice_plot = slice(X,Y,Z,F_x,slice_x, slice_y, []);
    title('F_x by potential U');
    ax = gca;
    ax.XLabel.String = 'x-axis [mm]';
    ax.YLabel.String = 'y-axis [mm]';
    ax.ZLabel.String = 'z-axis [mm]';
    set(ax,'FontSize', 20); set(xslice_plot,'LineStyle','none');
    colorbar
    volumeData = get(xslice_plot,'CData'); volumeData = cell2mat(volumeData); %cell からdoubleに変換
    minVolumeData = min(min(volumeData)); maxVolumeData = max(max(volumeData));
    set(ax, 'CLim', [minVolumeData maxVolumeData]);
%     name =strcat('Fx_',saveName,'.fig'); saveas(gcf,name); movefile(name, movefileName); 
    saveSimuFig('Fx','',movefileName,'');
    
    figure
    yslice_plot = slice(X,Y,Z,F_y,slice_x, slice_y, []);
    title('F_y by potential U');
    ax = gca;
    ax.XLabel.String = 'x-axis [mm]';
    ax.YLabel.String = 'y-axis [mm]';
    ax.ZLabel.String = 'z-axis [mm]';
    set(ax,'FontSize', 20); set(yslice_plot,'LineStyle','none'); 
    colorbar
    volumeData = get(yslice_plot,'CData'); volumeData = cell2mat(volumeData); %cell からdoubleに変換
    minVolumeData = min(min(volumeData)); maxVolumeData = max(max(volumeData));
    set(ax, 'CLim', [minVolumeData maxVolumeData]);
    %name =strcat('Fy_',saveName,'.fig'); saveas(gcf,name); movefile(name, movefileName);
    saveSimuFig('Fy','',movefileName,'');
    
    figure
    zslice_plot = slice(X,Y,Z,F_z,slice_x, slice_y, []);
    title('F_z by potential U');
    ax = gca;
    ax.XLabel.String = 'x-axis [mm]';
    ax.YLabel.String = 'y-axis [mm]';
    ax.ZLabel.String = 'z-axis [mm]';
    set(ax,'FontSize', 20); set(zslice_plot,'LineStyle','none');
    colorbar
    volumeData = get(zslice_plot,'CData'); volumeData = cell2mat(volumeData); %cell からdoubleに変換
    minVolumeData = min(min(volumeData)); maxVolumeData = max(max(volumeData));
    set(ax, 'CLim', [minVolumeData maxVolumeData]);
%     name =strcat('Fz_',saveName,'.fig'); saveas(gcf,name); movefile(name, movefileName);
    saveSimuFig('Fz','',movefileName,'');
   
end