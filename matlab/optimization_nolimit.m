global wall_z
global c0
global f
global omega
global k
global a
global im_z
global sp_x
global sp_y
global sp_z
global tp
global wx
global wy
global wz
global wp
global reflect_on
global reverse


global theta_sp_num
wp = 1;
wx = 1;
wy = 1;
wz = 1;

close all

%トラップ位置
tp = [0,0,-12.5];
%力表示するかどうか
force_on = 1;
%反射有りかどうか
reflect_on = 1;
%位相反転するかどうか
reverse = 1;
%アレイ位置表示するかどうk
pos_mark = 1;
%壁の位置
wall_z = -15;
%位相を読み込むかどうか
load_on = 0;
%位相保存するかどうか
save_phi = 0;
%グラフ表示するか
graph = 1;
%読み込みファイルパス
file_name = './phase/20201013/now15.0.mat';
delta_x = 1;
delta_y = 1;
delta_z = 1;
x = (-20:delta_x:20);
y = (-20:delta_y:20);
z = (wall_z:delta_z:wall_z+40);
[X,Y,Z] = meshgrid(x,y,z);

c0 = 346*1000;
f = 40000;
omega = 2*pi*f;
k = omega/c0;

%ピストンの半径
a =4.5;
%アレイ半径
zahyo = load('./zahyo/20200720_180.mat');

%スピーカ位置
sp_x = zahyo.X;
sp_y = zahyo.Y;
sp_z = zahyo.Z;

%縦に並ぶトランデューサの数
theta_sp_num = 8;
%鏡z座標
im_z = wall_z-abs(sp_z-wall_z);

if load_on == 0
    phi0 = zeros(length(sp_x),1);
    options = optimoptions(@fmincon,'Display','iter','FunvalCheck','on','MaxFunctionEvaluations',3000,'PlotFcn','optimplotfval');
    % filename = 'PlotFcns0818_1'+string(tp)+'.fig';
    fun = @object_fun2;
    [phix,fval] = fminunc(fun,phi0,options);
    % saveas(gcf,filename)
elseif load_on == 1
    phix = load(file_name);
    phix = phix.phix;
else
    phix = zeros(theta_sp_num,1);
end

if save_phi == 1
    save(sprintf('./phase/20201028/ww-15%.1f.mat', tp(3)),'phix');
%     save('./phase/20201013/gradation.mat','phix');
end

% % グラデーション
% phix = zeros(8,1);
% for m = 1:8
%     
%     phix(m) = -pi/8*(8-m);
% end
%     
if graph == 1
    ph_n = 1;
    P = zeros(size(X));
    qc = zeros(length(sp_x),3);

    figure (2)
    hold on
for n = 1:length(sp_x)

        xx = 0;
        if reverse  == 1
            if sp_y(n) < 0 
                xx =1;
            end
        end

        P_im = 0;

        P0 = theory_p(k,a,X,Y,Z,sp_x(n),sp_y(n),sp_z(n),0);


        if reflect_on ==1
            P_im = theory_p(k,a,X,Y,Z,sp_x(n),sp_y(n),im_z(n),wall_z*2);
        end

        ISO = phix(n);
        P = P+(P0+P_im)*exp(1j*ISO);


         if pos_mark ==1

            tmp = mod(ISO,2*pi);

             if tmp < pi
                 qc = [1-tmp/pi,0,0]; %赤
             else
                 qc = [(tmp-pi)/pi,(tmp-pi)/pi,1];  %青
             end

             q = quiver3(sp_x(n),sp_y(n),sp_z(n),-sp_x(n),-sp_y(n),-sp_z(n),0.05);
             q.LineWidth = 5;
             q.Color = qc;
         end


end



    Power = 20*log10(abs(P));

    xslice =0;
    yslice =[];
    zslice = wall_z;

    U = poten_cal(P,delta_x,delta_y,delta_z,c0,omega);
    slice(X,Y,Z,U,xslice,yslice,zslice)

    view(90,0)
    xlabel('x (mm)','FontSize',30);
    ylabel('y (mm)','FontSize',30);
    zlabel('z (mm)','FontSize',30);
    % caxis([-0.04,0.04])
    ax = gca;
    ax.FontSize = 15;
    title("Potential field")
    shading interp
    c = colorbar;
    c.Label.String = 'The Gor’kov potential';
%     caxis([0 0.5])
    axis equal

    if force_on == 1
        [F_x0, F_y0, F_z0] =  gradient(U,delta_x,delta_y,delta_z);
        span = 2;
        F_x0 = -F_x0(1:span:end,1:span:end,1:span:end); F_y0 = -F_y0(1:span:end,1:span:end,1:span:end); F_z0 = -F_z0(1:span:end,1:span:end,1:span:end);

        F_x0 = F_x0/max(max(max(F_x0)));
        F_x0(abs(F_x0)<0.5) = 0;

        F_y0 = F_y0/max(max(max(F_y0)));
        F_y0(abs(F_y0)<0.5) = 0;


        F_z0 = F_z0/max(max(max(F_z0)));
        F_z0(abs(F_z0)<0.5) = 0;

        quiver3(X(1:span:end,1:span:end,1:span:end),Y(1:span:end,1:span:end,1:span:end),Z(1:span:end,1:span:end,1:span:end),real(F_x0),real(F_y0),real(F_z0),1,"red")
    end
    hold off

    figure(3)
    slice(X,Y,Z,Power,xslice,yslice,zslice)
    view(90,0)
    ax = gca;
    ax.FontSize = 30;
    xlabel('x (mm)','FontSize',30);
    ylabel('y (mm)','FontSize',30);
    zlabel('z (mm)','FontSize',30);
    title("Amplitude field")
    c = colorbar;
    c.Label.String = 'Sound pressure level(dB)';
    % caxis([-10,10])
    shading interp
    axis equal

     L = 6*del2(U);
     L_cent = reshape(L(21,21,:),length(z),1);
     figure(4)

     plot(L_cent)
end