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
%�g���b�v�ʒu
tp = [0,0,0];
%�͕\�����邩�ǂ���
force_on = 0;
%���˗L�肩�ǂ���
reflect_on = 1;
%�ʑ����]���邩�ǂ���
reverse = 1;
%�ǂ̈ʒu
wall_z = -0;
%�ʑ���ǂݍ��ނ��ǂ���
load_on = 5;
%�ǂݍ��݃t�@�C���p�X
file_name = './phase/20200824/now_phase-10.mat';

% [CP_X,CP_Y,CP_Z] = reshape(cx,60,1),reshape(cy,60,1),reshape(cz,60,1));
c0 = 346*1000;
f = 40000;
omega = 2*pi*f;
k = omega/c0;
lamda = c0/f;
x = -20:4:20;
[cx,cy,cz] = meshgrid(x,x,x);
len = length(x)^3;
%�s�X�g���̔��a
a =4.5;
%�A���C���a
zahyo = load('./zahyo/20200720_180.mat');

%�X�s�[�J�ʒu
sp_x = zahyo.X;
sp_y = zahyo.Y;
sp_z = zahyo.Z;

%�c�ɕ��ԃg�����f���[�T�̐�
theta_sp_num = 8;
%��z���W
im_z = wall_z-abs(sp_z-wall_z);

if load_on == 0
    phi0 = zeros(theta_sp_num,1);
    options = optimoptions(@fmincon,'Display','iter','FunvalCheck','on','MaxFunctionEvaluations',3000,'PlotFcn','optimplotfval');
    % filename = 'PlotFcns0818_1'+string(tp)+'.fig';
    fun = @object_fun;
    [phix,fval] = fminunc(fun,phi0,options);
    % saveas(gcf,filename)
elseif load_on == 1
    phix = load(file_name);
    phix = phix.phix;
else
    phix = zeros(theta_sp_num,1);
end


ph_n = 1;
P = zeros(size(cx));
for n = 1:length(sp_x)
        xx = 0;
        if reverse  == 1
            if sp_y(n) < 0 
                xx =1;
            end
        end
        
        P_im = 0;
        P0 = theory_p(k,a,cx,cy,cz,sp_x(n),sp_y(n),sp_z(n),0);
        
        if reflect_on ==1
            P_im = theory_p_one(k,a,cx,cy,cz,sp_x(n),sp_y(n),im_z(n),wall_z*2);
        end
        
        ISO = phix(ph_n)+pi*xx;
        P = P+(P0+P_im)*exp(1j*ISO);

         
        if n < length(sp_x) && (sp_z(n) ~= sp_z(n+1))
            ph_n = ph_n +1;
            if ph_n == theta_sp_num+1
                ph_n = 1;
            end
        end
   
end

save("CP3.mat","P","cx","cy","cz");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ʒu�v���b�g
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delta_x = 1;
delta_y = 1;
delta_z = 1;
x = (-20:delta_x:20);
y = (-20:delta_y:20);
z = (-20 :delta_z:20);
[X,Y,Z] = meshgrid(x,y,z);

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
        
        ISO = phix(ph_n)+pi*xx;
        P = P+(P0+P_im)*exp(1j*ISO);

         
        if n < length(sp_x) && (sp_z(n) ~= sp_z(n+1))
            ph_n = ph_n +1;
            if ph_n == theta_sp_num+1
                ph_n = 1;
            end
        end
   
end

Power = 20*log10(abs(P));

xslice =0;
yslice =[];
zslice = 0;

U = poten_cal(P,delta_x,delta_y,delta_z,c0,omega);
% slice(X,Y,Z,U,xslice,yslice,zslice)

scatter3(reshape(cx,len,1),reshape(cy,len,1),reshape(cz,len,1),70,'filled')
slice(X,Y,Z,Power,xslice,yslice,zslice)
point = plot3(0,0,tp(3),'o','Color','w','MarkerSize',8,'MarkerFaceColor',[0.8,0.8,0.8]);
view(90,0)
ax = gca;
ax.FontSize = 20;
xlabel('x (mm)');
ylabel('y (mm)');
zlabel('z (mm)');
title("Amplitude field")
c = colorbar;
caxis([-10 10])
c.Label.String = 'Sound pressure level(dB)';
shading interp
axis equal
colormap hot
colorbar('off')
if force_on == 1
    [F_x0, F_y0, F_z0] =  gradient(U,delta_x,delta_y,delta_z);
    span = 2;
    F_x0 = -F_x0(1:span:end,1:span:end,1:span:end); F_y0 = -F_y0(1:span:end,1:span:end,1:span:end); F_z0 = -F_z0(1:span:end,1:span:end,1:span:end);

    F_x0 = F_x0/max(max(max(F_x0)));
    F_x0(abs(F_x0)<0.4) = 0;

    F_y0 = F_y0/max(max(max(F_y0)));
    F_y0(abs(F_y0)<0.4) = 0;


    F_z0 = F_z0/max(max(max(F_z0)));
    F_z0(abs(F_z0)<0.4) = 0;

    quiver3(X(1:span:end,1:span:end,1:span:end),Y(1:span:end,1:span:end,1:span:end),Z(1:span:end,1:span:end,1:span:end),real(F_x0),real(F_y0),real(F_z0),1,"red")
end
hold off
