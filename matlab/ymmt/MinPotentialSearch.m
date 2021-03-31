targetDir = 'G:\MATLAB\Ultrasonic\ultrasonic_simu3Dfocus\SimplePressure\hemispherical\TwinTrap\potential\potentialCalc\PotentialN151_range70_polystylene_downdirection'; %targetのディレクトリ
targetFileName = 'Fig_181004_Xpotential.fig'; %探したいファイルネーム
listing = dir(targetDir); % targetDir内にあるファイルのリスト
minDataList = zeros(1,100); YDataList = zeros(1,100); ZDataList = zeros(1,100);
degreeList = {}; degreeList2 = zeros(1,100);

ListIdx = 0;
for i = 1:length(listing)
    this_listing = listing(i);
    if this_listing.isdir == 1 %フォルダであれば入る
        disp(strcat('this is dir ', this_listing.name));
        this_listing_dir = strcat(targetDir,'\', this_listing.name); this_listing_targetFile = strcat(this_listing_dir,'\',targetFileName);
        existCheck = exist(this_listing_targetFile,'file'); %targetFileがあるかないか 
        if existCheck == 2 %targetFileがあれば入る
            ListIdx = ListIdx + 1;
            disp(strcat(targetFileName,' exists'));
            open(this_listing_targetFile); % Xpotential.figを開く
            %figからデータを取り出す
            ax = gca;
            children = get(ax,'children');
            child1=children(1); child1_Cdata = child1.CData;
            XData = child1.XData; YData = child1.YData; ZData = child1.ZData;

            figure
            x0=10; y0=10; width=650; height=500;
            set(gcf,'units','points','position',[x0,y0,width,height]);
            mesh(YData,ZData,child1_Cdata); 
            ax2 = gca; set(ax2, 'FontSize', 22);

            [potential_min,potential_min_idx] = min(child1_Cdata); [potential_min2,potential_min2_idx] = min(potential_min);
            y_idx = potential_min_idx(potential_min2_idx); z_idx = potential_min2_idx; 
            potential_min_Y = YData(y_idx, z_idx); potential_min_Z = ZData(y_idx, z_idx);
          
            minDataList(ListIdx) = potential_min2; YDataList(ListIdx) = potential_min_Y; ZDataList(ListIdx) = potential_min_Z;
            ax_title = ax.Title.String; degreeList = [degreeList, ax_title];
            ax_title2 = strsplit(ax_title,'[deg]'); ax_title2_2 = cell2mat(ax_title2(1)); degreeList2(ListIdx) = str2double(ax_title2_2); 
            
            name =strcat('Xpotential_mesh','.fig'); 
            saveas(gcf,name);
            movefile(name, this_listing_dir);
            
            close all
        end
    end
    
    
end
