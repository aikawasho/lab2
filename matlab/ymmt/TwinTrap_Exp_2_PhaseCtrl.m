% 
% 半球状集束超音波装置をhalfhalfモードで上下で向かい合わせ、定在波をみる
% 見せるように、z軸を0-100にしたものも表示し、保存できるようにした。
% phaseの引数も入れれるようにした
% ファイルの保存先を指定できるようにした
% 実際の村田超音波集束装置と同じ数のスピーカの個数にした。
% figureの表示をdegree表示も出せるようにした。
% 下側の装置はなし
% 図を簡単に見せるため、左側の詳細はなくし、タイトルに位相を表示するようにした。
% color bar にsound pressure と表示したい。あとメモリはいらない。
% colorbar を表示されたsurfaceのマックス値で制限する
% P = zerosの位置を変更
% 列の組み合わせを変えられるようにした。(RowsCombNumで指定する(配列で)。ナンバーの指定は1から６（下から数えて）)
% avarage_Pをsaveするようにした
% rangeを引数に追加
% 時間平均するのをやめた。(時間毎に表示にした)
% 矢印の色を4種類にした
% 半球が下向き

function TwinTrap_Exp_2_PhaseCtrl(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName, phase)
  %% bottle trap用の超音波振動子配置を行う
%     sp_number = 100;
%     hemis_r = 50;
    rangez_up = 4*8.5; rangez_bottom = -4*8.5;
    rangez_N = (rangez_up-rangez_bottom)/(8.5/20);
%     range = 30; 
%     range_N = 100;
    redColorPhase = phase;
    blueColorPhase = mod(phase + pi, 2*pi);
    magentaColorPhase = 0;
    cyanColorPhase = pi;
    zp = 0;
%     RowsCombNum = [1 2 3 4];
    delta_x = 2*range/range_N;
    delta_y = 2*range/range_N;
    delta_z = (rangez_up-rangez_bottom)/range_N;
%     
    xx = linspace(-range, range, range_N); 
    yy = linspace(-range, range, range_N);
    %zz = linspace(0, 90, range_N);
    zz = linspace(rangez_bottom, rangez_up, range_N);
    

    [X,Y,Z] = meshgrid(xx,yy,zz);

    %　波のパラメータ
    f = 40000; %40kHz 
    T = 1/f;
    v = 340*1000; %340000 (mm/s)
    ramda = v/f;
    wave_number = 2*pi/ramda;

 
    %hemis_r = 40; 
    % ピストンの外径
    sp_l = 10.5;
    sp_h = 7;

    % ピストンの半径
    a = 4.7; %半径4.7mm の円形ピストン

  

    %z_position = -zp;
    z_position = zp;
    
    %焦点
    f_x = 0;
    f_y = 0;
    f_z = 0+z_position;

    if rem(sp_number,2) == 1
        warning('sp_numberが偶数ではありません！')
        pause
    end
       
    %詳しくはノート参照 スピーカの配置
    theta1 = 2*asin(sp_l/2/hemis_r); % sp一個当たりが占める角度
    l = hemis_r*cos(theta1/2);
    l2 = l-sp_h;
    hemis_r2 = sqrt(l2^2+(sp_l/2)^2);
    theta2 = 2*acos(l2/hemis_r2);
    div_theta = pi/180; % first_thetaを決めるとき1度ずつ刻むことにした
    a1 = hemis_r*theta1;
    a2 = hemis_r*(theta2-theta1)/2;

    A = a1+a2*2; % スピーカ１個当たりが占める長さ
    theta3 = 2*pi*(A/(2*pi*hemis_r));
    % スピーカの座標リストをつくる
    i = 1;
    howmany_row = floor(2*pi*hemis_r/2/A);
    row_number = 1;
    
    
    iszero = 0; 
    for first_theta = pi:-div_theta:pi/2
        rr = hemis_r*sin(first_theta); %thetaのときの中心から円までの距離
%         div4rr = 2*pi*rr/4; % 円周を4で割った
        div2rr = 2*pi*rr/2; %円周を２で割った
%         howmany_div4rr = floor(div4rr/A);%スピーカが何個入るか
        howmany_div2rr = div2rr/A;
%         if howmany_div4rr < 1
%             continue;
%         elseif howmany_div4rr == 1
%             break;
%         else howmany_div4rr > 1
%             warning('なぜかhowmany_div4rrが１以上ですよ！！');
%         end
        if howmany_div2rr < 1
            continue;
%         elseif howmany_div2rr >= 1
%         elseif howmany_div2rr >= 1.2 % 余裕を持たせるために1.2とした
        elseif howmany_div2rr >= 2.2 % 余裕を持たせるため・真ん中にレーザポインタをいれたいため
            break;
        end

    end
    
    sp_number1 = sp_number/2; 
    sp_number2 = sp_number/2;
    sum_spNum1 = 0;
    sum_spNum2 = 0;
%     for theta = first_theta:-theta1:pi/2 + theta1/2
    for theta = first_theta:-theta1:pi/2 + deg2rad(1)
%     for theta = linspace(pi,pi/2,howmany_row)
        rr = hemis_r*sin(theta); %thetaのときの中心から円までの距離
%         div4rr = 2*pi*rr/4; % 円周を4で割った
        div2rr = 2*pi*rr/2; % 円周を2で割った
%         howmany_div4rr = floor(div4rr/A);%スピーカが何個入るか
        howmany_div2rr = floor(div2rr/A);%スピーカが何個入るか
        tmp_phai = pi/(howmany_div2rr+1); %列ごとの初期配置のphai
        tmp = sum_spNum1 + howmany_div2rr*2;
        if tmp <= sp_number1
            % 通常処理
            sum_spNum1 = tmp;
%              for j = 0:3
            for j = 0:1
%                 for phai = linspace(j*pi+theta3,(j+1)*pi-theta3,howmany_div2rr)
                 for phai = linspace(j*pi+tmp_phai,(j+1)*pi-tmp_phai,howmany_div2rr)

                  x = hemis_r*sin(theta)*cos(phai);
                  y = hemis_r*sin(theta)*sin(phai);
                  z = -hemis_r*cos(theta)+z_position;
                  sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
                  sp_list(i).row_number = row_number;

    %               %組み合わせた列を色分け
    %               if ismember(row_number, RowsCombNum)
    %                   sp_list(i).qui_color = 'red'; 
    %               end
                  %半分は位相を反転
%                   if j == 2||j==3
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'red'; 
%                      else
%                          sp_list(i).qui_color = 'black';
%                      end
%                      sp_list(i).phase = pi;
%                   else
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'blue'; 
%                      else
%                         sp_list(i).qui_color = 'green';
%                      end
% 
%                   end
                  if j == 0
                      sp_list(i).qui_color = 'red';
                      sp_list(i).phase = phase;
                  elseif j == 1
                      sp_list(i).qui_color = 'blue';
                      sp_list(i).phase = phase + pi;
                  end
                  i = i+1;
                end
             end     
             row_number = row_number+1;
        else
            % 最後の列の処理
            
            break;
        end
         
        endtheta = theta;
        
%         if row_number == 4
%             howmany_div4rr = 4; % 4列目はスピーカの幅に余裕を持たせるため、4にする.
%         elseif row_number == 5
%             howmany_div4rr = 5; % 5列目はスピーカの幅に余裕を持たせるため、5にする.
%         end


        

    end
    howmany_sp = length(sp_list);
    sp_number2 = howmany_sp;
    
    sum_spNum2 = 0;
    
    for theta = endtheta-theta1:-theta1:pi/2 + deg2rad(1)
        rr = hemis_r*sin(theta); %thetaのときの中心から円までの距離
%         div4rr = 2*pi*rr/4; % 円周を4で割った
        div2rr = 2*pi*rr/2; % 円周を2で割った
%         howmany_div4rr = floor(div4rr/A);%スピーカが何個入るか
        howmany_div2rr = floor(div2rr/A);%スピーカが何個入るか
        tmp_phai = pi/(howmany_div2rr + 1);
        tmp = sum_spNum2 + howmany_div2rr*2;
        if tmp <= sum_spNum1
            % 通常処理
            sum_spNum2 = tmp;
            for j = 0:1
%                 for phai = linspace(j*pi+theta3,(j+1)*pi-theta3,howmany_div2rr)
%              for j = 0:3
%                 for phai = linspace(j*2*pi/4+theta3,(j+1)*2*pi/4-theta3,howmany_div4rr)
               for phai = linspace(j*pi+tmp_phai,(j+1)*pi-tmp_phai,howmany_div2rr)
                  x = hemis_r*sin(theta)*cos(phai);
                  y = hemis_r*sin(theta)*sin(phai);
                  z = -hemis_r*cos(theta)+z_position;
                  sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
                  sp_list(i).row_number = row_number;

    %               %組み合わせた列を色分け
    %               if ismember(row_number, RowsCombNum)
    %                   sp_list(i).qui_color = 'red'; 
    %               end
                  %半分は位相を反転
%                   if j == 2||j==3
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'red'; 
%                      else
%                          sp_list(i).qui_color = 'black';
%                      end
%                      sp_list(i).phase = pi;
%                   else
%                      if ismember(row_number, RowsCombNum)
%                         sp_list(i).qui_color = 'blue'; 
%                      else
%                         sp_list(i).qui_color = 'green';
%                      end
% 
%                   end
                  if j == 0
                      sp_list(i).qui_color = 'magenta';
                      sp_list(i).phase = 0;
                  elseif j == 1
                      sp_list(i).qui_color = 'cyan';
                      sp_list(i).phase = pi;
                  end
                  
                  i = i+1;
                end
             end  
             row_number = row_number+1;
        else
            % 最後の列の処理
            last_row_spnum = sum_spNum1 - sum_spNum2;
            div2last_row_spnum = last_row_spnum/2;
            sum_spNum2 = sum_spNum2 + last_row_spnum;
            tmp_phai = pi/(div2last_row_spnum+1);
            for j = 0:1
                for phai = linspace(pi*j+tmp_phai,(j+1)*pi-tmp_phai,div2last_row_spnum)
                    x = hemis_r*sin(theta)*cos(phai);
                      y = hemis_r*sin(theta)*sin(phai);
                      z = -hemis_r*cos(theta)+z_position;
                      sp_list(i) = UltrasonicSpeaker3D_3(x, y, z,f_x,f_y,f_z,f); 
                      sp_list(i).row_number = row_number;

        %               %組み合わせた列を色分け
        %               if ismember(row_number, RowsCombNum)
        %                   sp_list(i).qui_color = 'red'; 
        %               end
                      %半分は位相を反転
    %                   if j == 2||j==3
    %                      if ismember(row_number, RowsCombNum)
    %                         sp_list(i).qui_color = 'red'; 
    %                      else
    %                          sp_list(i).qui_color = 'black';
    %                      end
    %                      sp_list(i).phase = pi;
    %                   else
    %                      if ismember(row_number, RowsCombNum)
    %                         sp_list(i).qui_color = 'blue'; 
    %                      else
    %                         sp_list(i).qui_color = 'green';
    %                      end
    % 
    %                   end
                  if j == 0
                      sp_list(i).qui_color = 'magenta';
                      sp_list(i).phase = 0;
                  elseif j == 1
                      sp_list(i).qui_color = 'cyan';
                      sp_list(i).phase = pi;
                  end
                  
                  i = i+1;
                  
                end
            end
            
            break;
        end
    end
    
    
    
    howmany_sp = length(sp_list);
    % フォルダの有無のチェック
    foldercheck = exist(movefilename,'dir'); % もしフォルダがあれば7, なければ7以外を返す
    if foldercheck == 7
        disp(strcat('フォルダ ',movefilename,' はありました.'));
    else
        disp('フォルダはないので作ります');
        mkdir(movefilename);
    end
   

    
    h = figure('visible','off');
    
    
    x0=10;
    y0=10;
    width=650;
    height=500;
    set(h,'units','points','position',[x0,y0,width,height]);
    ax1 = axes('Position',[0 0 1 1],'Visible','off');
    ax2 = axes('Position',[.3 .2 .6 .7]);
    axes(ax2);
    
    %スピーカの場所を矢印表示
    for i = 1:howmany_sp
        speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
        hold on
    end
    set(ax2, 'FontSize', 20);
    
    ax = gca;
    ax.XLabel.String = 'x-axis [mm]';
    ax.YLabel.String = 'y-axis [mm]';
    ax.ZLabel.String = 'z-axis [mm]';
    view(90,0)
    
    axes(ax1);
    descr = {strcat('red',num2str(rad2deg(redColorPhase)),' [deg]'), ...
        strcat('blue',num2str(rad2deg(blueColorPhase)),' [deg]'), ...
        strcat('magenta',num2str(rad2deg(magentaColorPhase)),' [deg]'), ...
        strcat('cyan',num2str(rad2deg(cyanColorPhase)),' [deg]'), ...
        };
    text(.025,0.7,descr,'FontSize',18);
    name =strcat('TwinTrap_R',num2str(hemis_r),'N',num2str(howmany_sp)); 
    set(gcf, 'PaperPositionMode','auto');
    print(name,'-dpng','-r0'); %全体
    movefile(strcat(name,'.png'), movefilename);
    
%     zlim([0 range])
%     print(strcat('kakuninup_z',num2str(nameIndex)),'-dpng','-r0'); %上部のみ
%     movefile(strcat('kakuninup_z',num2str(nameIndex),'.png'), movefilename);
%     
    name =strcat('TwinTrap_R',num2str(hemis_r),'N',num2str(howmany_sp),'.fig'); 
    saveas(gcf,name);
    movefile(name, movefilename);
    
    csvwrite_spPositionColor_paraview_3; %csvfileに振動子の位置を書き出す
    
    close all
%%
    howmany_sp = length(sp_list);

    bessel = zeros(range_N,range_N,range_N,howmany_sp);
    for i = 1:howmany_sp
        sp_vector = [sp_list(i).v_x sp_list(i).v_y sp_list(i).v_z];
        vx = sp_list(i).v_x;
        vy = sp_list(i).v_y;
        vz = sp_list(i).v_z;
%         phai_list = makePhaiList2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
%             vx, vy, vz, X, Y, Z);
  phai_list = makePhaiList3(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
            vx, vy, vz, X, Y, Z);
%         bessel(:,:,:,i) = bessel_func(wave_number,a,phai_list);
         bessel(:,:,:,i) = bessel_func2(wave_number,a,phai_list);
    end
    
    coef = bessel; % 係数用の変数
    clearvars bessel phai_list

    % 音の減衰リストをつくる
    % それぞれのスピーカ用の減衰リスト
    %attenuation_list = zeros(range_N,range_N,range_N,howmany_sp);
    %[a_func, a_func_x] = make_attenuation_list3D_3_2();
    [a_func, a_func_x] = make_attenuation_list3D_3_3(); %2018/11/12　変更
    for i = 1:howmany_sp   
    %     attenuation_list(:,:,:,i) = make_attenuation_list3D_2(sp_list(i).x0, sp_list(i).y0, sp_list(i).z0, ...
    %         X,Y,Z);

        %距離空間
        XYZ_D = sqrt( (X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2 );
        a_func_result = a_func(a_func_x,XYZ_D);
        
        %attenuation_list(:,:,:,i) = a_func_result.*bessel(:,:,:,i);
        coef(:,:,:,i) = a_func_result.*coef(:,:,:,i);
    end

    % メモリ削減のため変数を削除
    clearvars bessel bessel_above XYZ_D



    %%
    % シミュレーション開始 
    % それぞれのスピーカの音圧の和を計算
    % エネルギーに変換（2乗する）
    % 時間平均にする
    j = 1;
    


    ramda = v/f;
    wave_number = 2*pi/ramda;
    
    sum_absP = zeros(range_N,range_N,range_N);

    

    %phase = pi;

    clearvars a_func_result phai_list
    

    U_sum = zeros(range_N,range_N,range_N); %各時間毎のポテンシャルを足していくためのもの 

        
        P_idx = 1;
        P_avarage= zeros(range_N,range_N,range_N);
        P_real = zeros(range_N,range_N,range_N);
        P_imag = zeros(range_N,range_N,range_N);
%         %一個目の集束超音波装置（下側）
        for i = 1:length(sp_list) % sp_listの列の数だけ（speakerの数）繰り返す
            d = sqrt((X-sp_list(i).x0).^2 + (Y-sp_list(i).y0).^2 + (Z-sp_list(i).z0).^2); % dは中心からの距離
            P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase)));
            P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase)));
%             if ismember(sp_list(i).row_number,RowsCombNum)
%                 %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(i).phase);
% %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase)));
% %                 P_imag(:,:,:) = P_imag(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase)));
%                 P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase)));
%                 P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase)));
% 
%             else
%                 %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(i).phase - phase);
% %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
% %                 P_imag(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
%                 P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
%                 P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(i).phase - phase)));
%             end               

            P_idx=P_idx+1;
        end
        
        P_avarage = (1/sqrt(2))*sqrt(P_real.^2+P_imag.^2); % Pの実行値を求める。
        %P_angle = angle(cos(P_real)+1j.*(sin(P_imag)));% 位相情報をゲットする
        P_angle = angle(P_real+1j.*(P_imag));% 位相情報をゲットする
        
        dispXYZSimu(strcat(titleName,' P-angle'),X,Y,Z,P_angle, xslice, yslice, zslice);% 位相情報を表示
        colormap(hsv);
        saveSimuFig_2('P_angle_phase',num2str(floor(rad2deg(phase))),movefilename);
%         
%         P_angle01 = (P_angle>0 & P_angle<pi); % 位相 0 ~ 180度を抽出
%         P_angle_0 = (P_angle01 == 0); %位相-180~0を抽出
%         minusOne = P_angle_0.*(-1); %位相-180~0のとこは-1
%         P_angle_negaPosi = P_angle01;
%         P_angle_negaPosi = P_angle_negaPosi+minusOne; %P_angle_negaPosiは1と-1で表された
%         dispXYZSimu(strcat(titleName,' P angle negaposi'),X,Y,Z,P_angle_negaPosi);% テスト用表示
%         P = P_avarage.*P_angle_negaPosi; 
        
        %P_avarageを表示
%         dispXYZSimu(titleName,X,Y,Z,P_avarage, xslice, yslice, zslice);
        %スピーカの場所を矢印表示
        h = figure('visible','off');
%         figure
        x0=10;
        y0=10;
        width=850;
        height=500;
        set(gcf,'units','points','position',[x0,y0,width,height])
        ax1 = axes('Position',[0 0 1 1],'Visible','off');
        ax2 = axes('Position',[.35 .2 .6 .71]);
        axes(ax2);  

        hold on
        xslice_plot = slice(X,Y,Z,P_avarage,xslice,yslice,zslice(1));
        volumeData = get(xslice_plot,'CData');
        minVolumeData = min(min(min(P_avarage)));
        maxVolumeData = max(max(max(P_avarage)));
    %     pbaspect([1 1 1]) % graph縦横比
        pbaspect([max(max(max(X)))-min(min(min(X))) max(max(max(Y)))-min(min(min(Y)))  max(max(max(Z)))-min(min(min(Z)))])
        set(ax2, 'FontSize', 20);
        set(xslice_plot,'LineStyle','none')  
        cbar = colorbar;
        %cbar.Label.String = 'sound pressure';
        %cbar.TicksMode = 'manual'; % 値を表示しない
        %cbar.Limits = [0 maxVolumeData];
        set(ax2, 'CLim', [minVolumeData(1) maxVolumeData(1)]);

        %cbar.Position = [0.93 0.1000 0.0308 0.8000];
        ax = gca;
        ax.XLabel.String = 'x-axis [mm]';
        ax.YLabel.String = 'y-axis [mm]';
        ax.ZLabel.String = 'z-axis [mm]';
        set(ax,'FontSize', 20);
        for i = 1:length(sp_list)
           speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
        end

        % 現在の位相を表示
        axes(ax1);
        descr = {strcat('red',num2str(rad2deg(redColorPhase)),' [deg]'), ...
            strcat('blue',num2str(rad2deg(blueColorPhase)),' [deg]'), ...
            strcat('magenta',num2str(rad2deg(magentaColorPhase)),' [deg]'), ...
            strcat('cyan',num2str(rad2deg(cyanColorPhase)),' [deg]'), ...
            };
        text(.025,0.7,descr,'FontSize',22)
        

        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 30 15]; 
        
        axes(ax2);
        saveSimuFig('P_avarage_phase',num2str(floor(rad2deg(phase))),movefilename,P_avarage);
        
        %ポテンシャルの計算のためのパラメータ
%         c_0 = v/1000; %[mm/s] -> [m/s]
%         slice_x = 0; slice_y = 0; slice_z = 0;
%         time_div_N = 20;
%         t_div = T/time_div_N;%ポテンシャル計算のための計算回数（周期を何回で割るか)
%         tlist = linspace(0,T-t_div,time_div_N);
%         t_i = 0;
%         for t = tlist
%             t_i = t_i + 1;
%             P_real = zeros(range_N,range_N,range_N);
%             P_imag = zeros(range_N,range_N,range_N);
%             for j = 1:length(sp_list) % sp_listの列の数だけ（speakerの数）繰り返す
%                 d = sqrt((X-sp_list(j).x0).^2 + (Y-sp_list(j).y0).^2 + (Z-sp_list(j).z0).^2); % dは中心からの距離
%                 P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,j).*real(exp(1j*(wave_number.*d - 2*pi*f*t - sp_list(j).phase)));
%                 P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,j).*imag(exp(1j*(wave_number.*d - 2*pi*f*t - sp_list(j).phase)));
% 
% %                 if ismember(sp_list(j).row_number,RowsCombNum)
% %                     %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(j).phase);
% %     %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase)));
% %     %                 P_imag(:,:,:) = P_imag(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase)));
% %                     P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase - delta_time*(i-1)))); % sin(k*d-phi-omega*t)
% %                     P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase - delta_time*(i-1))));
% % 
% %                 else
% %                     %P(:,:,:) = P(:,:,:) + attenuation_list(:,:,:,i).*sin(wave_number.*d - 2*pi*f*t - sp_list(j).phase - phase);
% %     %                 P_real(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase - phase)));
% %     %                 P_imag(:,:,:) = P_real(:,:,:) + attenuation_list(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase - phase)));
% %                     P_real(:,:,:) = P_real(:,:,:) + coef(:,:,:,i).*real(exp(1j*(wave_number.*d - sp_list(j).phase - phase - delta_time*(i-1))));
% %                     P_imag(:,:,:) = P_imag(:,:,:) + coef(:,:,:,i).*imag(exp(1j*(wave_number.*d - sp_list(j).phase - phase - delta_time*(i-1))));
% %                 end               
%             end
%             
%             P = P_imag; %P_imag(cos成分)を取り出す
%             dispXYZSimu(titleName,X,Y,Z,P, xslice, yslice, zslice);
%             saveSimuFig(strcat(saveName,'_P_time',num2str(t_i)),'',movefilename,P);
% %             U = PotentialCalc2(X,Y,Z,P,range,range_N,slice_x,slice_y,slice_z, c_0, f);
%             U = PotentialCalc3(X, Y, Z, P, delta_x, delta_y, delta_z,slice_x, slice_y, slice_z, c_0, f);
%             U_sum = U_sum+U;
% 
%             P_idx=P_idx+1;
%             
%             close all
%         end
%         abs_P = abs(P);
%         sum_absP = sum_absP + abs_P; %abs_Pをどんどん足していく
          
        
  
    
%     avarage_P = sum_absP./time_div_N;
    %titleName = strcat(titleName,' time avarage');
%     dispXSimu(titleName,X,Y,Z,avarage_P);
    %スピーカの場所を矢印表示
%     for i = 1:length(sp_list)
%        speeker_quiver3(sp_list(i).x0,sp_list(i).y0,sp_list(i).z0,sp_list(i).v_x,sp_list(i).v_y,sp_list(i).v_z,sp_list(i).qui_color,10)
%     end
%     saveSimuFig_2(strcat(saveName,'_avarage'),'',movefilename);
    
%     Potential = U_sum./time_div_N; %ポテンシャルの時間平均    
%     dispXSimu(titleName,X,Y,Z,Potential);
%     saveSimuFig_2(strcat(saveName,'_Xpotential'),'',movefilename);
%     dispYSimu(titleName,X,Y,Z,Potential);
%     saveSimuFigY(strcat(saveName,'_Ypotential'),'',movefilename,Potential);
%     dispZSimu(titleName,X,Y,Z,Potential);
%     saveSimuFigZ(strcat(saveName,'_Zpotential'),'',movefilename,Potential);
%     dispXYZSimu(titleName,X,Y,Z,Potential, xslice, yslice, zslice);
%     saveSimuFig(strcat(saveName,'_3Dpotential'),'',movefilename,Potential);
% 
% %     CalcFxFyFz_2(X,Y,Z,U,range,range_N,slice_x,slice_y,slice_z, saveName, movefilename);
%     CalcFxFyFz_3(X, Y, Z, Potential, delta_x, delta_y, delta_z ,slice_x, slice_y, slice_z, saveName, movefilename) ;
%     close all;
    
    clear
end


