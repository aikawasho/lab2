function U = PotentialCalc3(X, Y, Z, P, delta_x, delta_y, delta_z,slice_x, slice_y, slice_z, c_0, f) %c_0は媒質の音速, fは音波の周波数, rho_pは微小物体の密度, rho_0は媒質の密度, V_pは微小物体の体積
    %各パラメータ設定
%     delta_x = 2*range/range_N*10^(-3); delta_y = 2*range/range_N*10^(-3); delta_z = 2*range/range_N*10^(-3);
    % [mm] -> [m]
    delta_x = delta_x*10^(-3);
    delta_y = delta_y*10^(-3);
    delta_z = delta_z*10^(-3);
    V_p = 4/3*pi*(1.5*10^(-3))^3; % 3mm球
    c_p = 5120;%金属 
    rho_0 = 1.2; %空気
    %rho_p = 1700; % 発砲ポリスチレンは密度と速度がわからないの金属とした（かなりアバウト）   
    rho_p = 11; % 発砲ポリスチレン　11kg/m^3

%     sizeX = size(P,1); sizeY = size(P,2); sizeZ = size(P,3);
%     P2 = P(2:sizeX-1,2:sizeY-1,2:sizeZ-1); % ポテンシャル計算用のために配列のサイズを調整
%     X2 = X(2:sizeX-1,2:sizeY-1,2:sizeZ-1); Y2 = Y(2:sizeX-1,2:sizeY-1,2:sizeZ-1); Z2 = Z(2:sizeX-1,2:sizeY-1,2:sizeZ-1);
%     
     
    
%     figure %テスト用
%     slice_P = slice(X,Y,Z,P,slice_x, slice_y, slice_z);
%     title('test P');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20); set(slice_P,'LineStyle','none');
    
    %中心差分(空間微分)
%     PX1 = P(1:sizeX-2,2:end-1,2:end-1); PX2 = P(3:sizeX,2:end-1,2:end-1);
%     p_x = (PX2-PX1)./(2*delta_x);
%     PY1 = P(2:end-1,1:sizeY-2,2:end-1); PY2 = P(2:end-1,3:sizeY,2:end-1);
%     p_y = (PY2-PY1)./(2*delta_y);
%     PZ1 = P(2:end-1,2:end-1,1:sizeZ-2); PZ2 = P(2:end-1,2:end-1,3:sizeZ);
%     p_z = (PZ2-PZ1)./(2*delta_z);
    [p_x, p_y, p_z] = gradient(P,delta_x,delta_y,delta_z);
    
%     figure % テスト用
%     slice(X,Y,Z,p_x,slice_x, slice_y, slice_z);
%     
    laplacianP = p_x.^2+p_y.^2+p_z.^2;
    
%     figure % テスト用
%     slice(X,Y,Z,laplacianP,slice_x, slice_y, slice_z);
%     title('test Laplacian P');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20);
    
    %ポテンシャルの計算
    omega = 2*pi*f;
    K_1 = 1/2*V_p*(1/(c_0^2*rho_0) - 1/(c_p^2*rho_p));
    K_2 = 3/2*V_p*( (rho_p-rho_0)/(omega^2*rho_0*(rho_0+2*rho_p)) );
    U = K_1*P.^2 - K_2*laplacianP;
    
%     figure % テスト用
%     s = slice(X,Y,Z,U,slice_x, slice_y, slice_z);
%     title('test Potential U');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20);
%     colorbar
    
    hold on 
    
    %Forceの計算
    % matlabのgradientを使用してみる
    [F_x, F_y, F_z] =  gradient(U,delta_x,delta_y,delta_z);
    F_x = -F_x; F_y = -F_y; F_z = -F_z;
%     figure
%     xslice_plot = slice(X,Y,Z,F_x,slice_x, slice_y, slice_z);
%     title('F_x by potential U');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20); set(xslice_plot,'LineStyle','none');
%     colorbar
    
    
    
%     figure
%     yslice_plot = slice(X,Y,Z,F_y,slice_x, slice_y, slice_z);
%     title('F_y by potential U');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20); set(yslice_plot,'LineStyle','none'); 
%     colorbar
    
%     figure
%     zslice_plot = slice(X,Y,Z,F_z,slice_x, slice_y, slice_z);
%     title('F_z by potential U');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20); set(zslice_plot,'LineStyle','none');
%     colorbar

    % ポテンシャル勾配による3次元矢印プロット
%     figure
%     quiver3(X2,Y2,Z2,F_x,F_y,F_z);
%     title('Potential gradient');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20);

    %ZeroPosiQuiver; % x=y=z=0地点でのQuiverプロット
%     ZeroPosiQuiver3;
%     %Forceの計算(自家製gradientを使用した場合)
%     F_x = -GradientCalcX_02(U, delta_x); F_y = -GradientCalcY_02(U, delta_y); F_z = -GradientCalcZ(U, delta_z);
%     figure
%     slice(X3,Y3,Z3,F_x,slice_x, slice_y, slice_z);
%     title('F_x by potential U');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20);
%     colorbar
%     
%     figure
%     slice(X3,Y3,Z3,F_y,slice_x, slice_y, slice_z);
%     title('F_y by potential U');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20);
%     colorbar
%     
%     figure
%     slice(X3,Y3,Z3,F_z,slice_x, slice_y, slice_z);
%     title('F_z by potential U');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20);
%     colorbar
end