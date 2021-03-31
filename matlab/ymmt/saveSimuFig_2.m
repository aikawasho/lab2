% 変数は保存しない
function saveSimuFig_2(saveName, suffix, movefilename) 
    %フォルダに画像やfigファイルを保存
    view(90,0)
    name =strcat('YZ_',saveName,suffix); 
    set(gcf, 'PaperPositionMode','auto');
    print(name,'-dpng','-r0'); %全体
    movefile(strcat(name,'.png'), movefilename);
    
%     zlim([0 range])
%     print(strcat('kakuninup_z',num2str(nameIndex)),'-dpng','-r0'); %上部のみ
%     movefile(strcat('kakuninup_z',num2str(nameIndex),'.png'), movefilename);
    
    name =strcat('Fig_',saveName,suffix,'.fig'); 
    saveas(gcf,name);
    movefile(name, movefilename);
    
    %name = strcat('P_',saveName,suffix,'.mat'); 
    %save(name,'P');
    %movefile(name, movefilename);
    
    close all;

end