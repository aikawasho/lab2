% 
% 半球状集束超音波装置をhalfhalfモードで上下で向かい合わせ、定在波をみる
% 見せるように、z軸を0-100にしたものも表示し、保存できるようにした。
% phaseの引数も入れれるようにした
% 反射率も入れれるようにした
% ファイルの保存先を指定できるようにした
% 実際の村田超音波集束装置と同じ数のスピーカの個数にした。
% figureの表示をdegree表示も出せるようにした。
% 下側の装置はなし
% 図を簡単に見せるため、左側の詳細はなくし、タイトルに位相を表示するようにした。
% color bar にsound pressure と表示したい。あとメモリはいらない。
% colorbar を表示されたsurfaceのマックス値で制限する
% P = zerosの位置を変更
% 確認のため、下側の矢印も表示することにした
% halfhalfの反射ではなくて、下側はさらに逆にするとどうなるのか

function halfhalf_tractor_half(zp, range_N, phase, nameIndex,reflectRate, movefilename)

range = 60;
%range_N = 200;

xx = linspace(-range, range, range_N); 
yy = linspace(-range, range, range_N);
%zz = linspace(0, 90, range_N);
zz = linspace(-30, 90, range_N);

[X,Y,Z] = meshgrid(xx,yy,zz);

%　波のパラメータ
f = 40000; %40kHz 
T = 1/f;
v = 340*1000; %340000 (mm/s)
ramda = v/f;
wave_number = 2*pi/ramda;

%半球の半径 5cm(50mm)
hemis_r = 50; 
% ピストンの外径
sp_l = 10;
sp_h = 7;

% ピストンの半径
a = 4.7; %半径4.7mm の円形ピストン

%% 一個目の集束超音波装置（下側）

z_position = -zp;

%焦点
f_x = 0;
f_y = 0;
f_z = 0+z_position;

%詳しくはノート参照 スピーカの配置
theta1 = 2*asin(sp_l/2/hemis_r); % sp一個当たりが占める角度
l = hemis_r*cos(theta1/2);
l2 = l-sp_h;
hemis_r2 = sqrt(l2^2+(sp_l/2)^2);
theta2 = 2*acos(l2/hemis_r2);
a1 = hemis_r*theta1;
a2 = hemis_r*(theta2-theta1)/2;

A = a1+a2*2; % スピーカ１個当たりが占める長さ
theta3 = 2*pi*(A/(2*pi*hemis_r));
% スピーカの座標リストをつくる
i = 1;
howmany_row = floor(2*pi*hemis_r/4/A);
row_number = 1;
for theta = linspace(pi,pi/2,howmany_row)
    rr = hemis_r*sin(theta); %thetaのときの中心から円までの距離
    div4rr = 2*pi*rr/4; % 円周を4で割った
    howmany_div4rr = floor(div4rr/A);%スピーカが何個入るか
    if row_number == 4
        howmany_div4rr = 4; % 4列目はスピーカの幅に余裕を持たせるため、4にする.
    elseif row_number == 5
        howmany_div4rr = 5; % 5列目はスピーカの幅に余裕を持たせるため、5にする.
    end
    
    for j = 0:3
        for phai = linspace(j*2*pi/4+theta3,(j+1)*2*pi/4-theta3,howmany_div4rr)
          
          x = hemis_r*sin(theta)*cos(phai);
          y = hemis_r*sin(theta)*sin(phai);
          z = hemis_r*cos(theta)+z_position;
          sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
          sp_list(i).row_number = row_number;
          
          if j == 0||j==1
             sp_list(i).qui_color = 'red'; 
          end
          i = i+1;
        end
    end
   
    row_number = row_number+1;
end

howmany_sp = length(sp_list);

bessel = zeros(range_N,range_N,range_N,howmany_sp);
for i = 1:howmany_sp
    sp_vector = [sp_list(i).v_x sp_list(i).v_y sp_list(i).v_z];
    vx = sp_list(i).v_x;
    vy = sp_list(i).v_y;
    vz = sp_list(i).v_z;
    phai_list = makePhaiList2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
        vx, vy, vz, X, Y, Z);
    bessel(:,:,:,i) = bessel_func(wave_number,a,phai_list);
end



% 音の減衰リストをつくる
% それぞれのスピーカ用の減衰リスト
attenuation_list = zeros(range_N,range_N,range_N,howmany_sp);
[a_func, a_func_x] = make_attenuation_list3D_3_2();
for i = 1:howmany_sp   
%     attenuation_list(:,:,:,i) = make_attenuation_list3D_2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
%         X,Y,Z);
    
    %距離空間
    XYZ_D = sqrt( (X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2 );
    a_func_result = a_func(a_func_x,XYZ_D);
    attenuation_list(:,:,:,i) = a_func_result.*bessel(:,:,:,i);
end

% メモリ削減のため変数を削除
clearvars bessel bessel_above


%% 二個目の集束超音波装置(上側）

z_position = zp;

%焦点
f_x = 0;
f_y = 0;
f_z = 0+z_position;

%詳しくはノート参照 スピーカの配置
theta1 = 2*asin(sp_l/2/hemis_r); % sp一個当たりが占める角度
l = hemis_r*cos(theta1/2);
l2 = l-sp_h;
hemis_r2 = sqrt(l2^2+(sp_l/2)^2);
theta2 = 2*acos(l2/hemis_r2);
a1 = hemis_r*theta1;
a2 = hemis_r*(theta2-theta1)/2;

A = a1+a2*2; % スピーカ１個当たりが占める長さ
theta3 = 2*pi*(A/(2*pi*hemis_r));
% スピーカの座標リストをつくる
i = 1;
howmany_row = floor(2*pi*hemis_r/4/A);
row_number = 1;
for theta = linspace(pi,pi/2,howmany_row)
    rr = hemis_r*sin(theta); %thetaのときの中心から円までの距離
    div4rr = 2*pi*rr/4; % 円周を4で割った
    howmany_div4rr = floor(div4rr/A);%スピーカが何個入るか
    if row_number == 4
        howmany_div4rr = 4; % 4列目はスピーカの幅に余裕を持たせるため、4にする.
    elseif row_number == 5
        howmany_div4rr = 5; % 5列目はスピーカの幅に余裕を持たせるため、5にする.
    end
    
    
    for j = 0:3
        for phai = linspace(j*2*pi/4+theta3,(j+1)*2*pi/4-theta3,howmany_div4rr)
          
          x = hemis_r*sin(theta)*cos(phai);
          y = hemis_r*sin(theta)*sin(phai);
          %z = hemis_r*cos(theta)+z_position;
          z = -hemis_r*cos(theta)+z_position; %　上側なので正負逆にする
          sp_list2(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
          sp_list2(i).row_number = row_number;
          if j == 0||j==1
             sp_list2(i).qui_color = 'black'; 
          else
              sp_list2(i).qui_color = 'red';
          end
          i = i+1;
        end
    end
   
    row_number = row_number+1;
end

howmany_sp = length(sp_list);

bessel = zeros(range_N,range_N,range_N,howmany_sp);
for i = 1:howmany_sp
    sp_vector = [sp_list2(i).v_x sp_list2(i).v_y sp_list2(i).v_z];
    vx = sp_list2(i).v_x;
    vy = sp_list2(i).v_y;
    vz = sp_list2(i).v_z;
    phai_list = makePhaiList2(sp_list2(i).x0, sp_list2(i).y0, sp_list2(i).z0, ...
        vx, vy, vz, X, Y, Z);
    bessel(:,:,:,i) = bessel_func(wave_number,a,phai_list);
end



% 音の減衰リストをつくる
% それぞれのスピーカ用の減衰リスト
attenuation_list2 = zeros(range_N,range_N,range_N,howmany_sp);
[a_func, a_func_x] = make_attenuation_list3D_3_2();
for i = 1:howmany_sp   
%     attenuation_list2(:,:,:,i) = make_attenuation_list23D_2(sp_list2(i).x0, sp_list2(i).y0, sp_list2(i).z0, ...
%         X,Y,Z);
    
    %距離空間
    XYZ_D = sqrt( (X-sp_list2(i).x0).^2 + (Y-sp_list2(i).y0).^2 + (Z-sp_list2(i).z0).^2 );
    a_func_result = a_func(a_func_x,XYZ_D);
    attenuation_list2(:,:,:,i) = a_func_result.*bessel(:,:,:,i);
end


% メモリ削減のため変数を削除
clearvars bessel bessel_above

%%
% シミュレーション開始 
% それぞれのスピーカの音圧の和を計算
% エネルギーに変換（2乗する）
% 時間平均にする
j = 1;
time_div_N = 10;


ramda = v/f;
wave_number = 2*pi/ramda;
T = 1/f;
time_div_N = 10;

sum_absP = zeros(range_N,range_N,range_N);

tlist = 0:T/time_div_N:T;

%phase = pi;

clearvars a_func_result phai_list

    
    for t = tlist
        
        P_idx = 1;
        P= zeros(range_N,range_N,range_N);
%         %一個目の集束超音波装置（下側）
        for i = 1:length(sp_list) % sp_listの列の数だけ（speakerの数）繰り返す
            d = sqrt((X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2); % dは中心からの距離
           
            if strcmp(sp_list(i).qui_color,'red') %矢印が赤ならば
               if sp_list(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi);
                else
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi - phase);
                end
            else
                if sp_list(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t);
                else
                    P(:,:,:) = P(:,:,:) + reflectRate * attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - phase);
                end
            end
            P_idx=P_idx+1;
        end
        
        
        %二個目の集束超音波装置(上側)
        for i = 1:length(sp_list2) % sp_listの列の数だけ（speakerの数）繰り返す
            d = sqrt((X-sp_list2(i).x0).^2 + (Y-sp_list2(i).y0).^2 + (Z-sp_list2(i).z0).^2); % dは中心からの距離

            if strcmp(sp_list2(i).qui_color,'red')
                if sp_list2(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi);
                else
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - pi - phase);
                end
            else
                if sp_list2(i).row_number <= 4
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t);
                else
                    P(:,:,:) = P(:,:,:) + attenuation_list2(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - phase);
                end 
            end
            P_idx=P_idx+1;
        end
        

        abs_P = abs(P);
        sum_absP = sum_absP + abs_P; %abs_Pをどんどん足していく
        j = j+1;
    
    end
    
    avarage_P = sum_absP./time_div_N;

    % simulationの表示
    figure
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(gcf,'units','points','position',[x0,y0,width,height])
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.2 .1 .7 .8]);
    title(strcat(num2str(rad2deg(phase)),' degree'));

    hold on
    xslice = 0;
    %yslice = 0;
    %zslice = min(zz);
    ax2 = gca;
    axes(ax2);
    slice_plot = slice(X,Y,Z,avarage_P,xslice,[],[]);
    volumeData = get(slice_plot,'CData');
    minVolumeData = min(min(volumeData));
    maxVolumeData = max(max(volumeData));
    %pbaspect([1 1 1]) % graph縦横比
    set(ax2, 'FontSize', 28);
    set(slice_plot,'LineStyle','none')  
    cbar = colorbar;
    cbar.Label.String = 'sound pressure';
    %cbar.TicksMode = 'manual'; % 値を表示しない
    %cbar.Limits = [0 maxVolumeData];
    set(ax2, 'CLim', [minVolumeData maxVolumeData]);
    
    %cbar.Position = [0.93 0.1000 0.0308 0.8000];
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 35);

    %スピーカの場所を矢印表示
    for i = 1:length(sp_list)
       speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
    end
    for i = 1:length(sp_list2)
       speeker_quiver3(sp_list2(i).x0,sp_list2(i).y0,sp_list2(i).z0,sp_list2(i).v_x,sp_list2(i).v_y,sp_list2(i).v_z,sp_list2(i).qui_color,10)
    end
  


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

    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 30 15];
    
     axes(ax2)
%     view(3);
%     print(strcat('focusRowChangeView3_',num2str(Ph_num)),'-dpng','-r0');
%     
%     view(-90,0)
%     print(strcat('focusRowChangeYZ',num2str(Ph_num)),'-dpng','-r0');
%     
    j=1;
    %save(filename)
    
    view(-90,0)
    print(strcat('kakunin_z',num2str(nameIndex)),'-dpng','-r0'); %全体
    movefile(strcat('kakunin_z',num2str(nameIndex),'.png'), movefilename);
    
    zlim([0 range])
    print(strcat('kakuninup_z',num2str(nameIndex)),'-dpng','-r0'); %上部のみ
    movefile(strcat('kakuninup_z',num2str(nameIndex),'.png'), movefilename);
    
    %% 下の矢印を消してもう一度表示
        figure
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(gcf,'units','points','position',[x0,y0,width,height])
%     ax1 = axes('Position',[0 0 1 1],'Visible','off');
%     ax2 = axes('Position',[.2 .1 .7 .8]);
    title(strcat(num2str(rad2deg(phase)),' degree'));

    hold on
    xslice = 0;
    %yslice = 0;
    %zslice = min(zz);
    ax2 = gca;
    axes(ax2);
    slice_plot = slice(X,Y,Z,avarage_P,xslice,[],[]);
    volumeData = get(slice_plot,'CData');
    minVolumeData = min(min(volumeData));
    maxVolumeData = max(max(volumeData));
    %pbaspect([1 1 1]) % graph縦横比
    set(ax2, 'FontSize', 28);
    set(slice_plot,'LineStyle','none')  
    cbar = colorbar;
    cbar.Label.String = 'sound pressure';
    %cbar.TicksMode = 'manual'; % 値を表示しない
    %cbar.Limits = [0 maxVolumeData];
    set(ax2, 'CLim', [minVolumeData maxVolumeData]);
    
    %cbar.Position = [0.93 0.1000 0.0308 0.8000];
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 35);

    %スピーカの場所を矢印表示

    for i = 1:length(sp_list2)
       speeker_quiver3(sp_list2(i).x0,sp_list2(i).y0,sp_list2(i).z0,sp_list2(i).v_x,sp_list2(i).v_y,sp_list2(i).v_z,sp_list2(i).qui_color,10)
    end
  


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

    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 30 15];
    
     axes(ax2)
%     view(3);
%     print(strcat('focusRowChangeView3_',num2str(Ph_num)),'-dpng','-r0');
%     
%     view(-90,0)
%     print(strcat('focusRowChangeYZ',num2str(Ph_num)),'-dpng','-r0');
%     
    j=1;
    %save(filename)
    
    view(-90,0)
    print(strcat('YZ_z',num2str(nameIndex)),'-dpng','-r0'); %全体
    movefile(strcat('YZ_z',num2str(nameIndex),'.png'), movefilename);
    
    zlim([0 range])
    print(strcat('YZup_z',num2str(nameIndex)),'-dpng','-r0'); %上部のみ
    movefile(strcat('YZup_z',num2str(nameIndex),'.png'), movefilename);
    
    saveas(gcf,strcat('YZup_z',num2str(nameIndex),'.fig'));
    movefile(strcat('YZup_z',num2str(nameIndex),'.fig'), movefilename);
    
    
    clear
end

