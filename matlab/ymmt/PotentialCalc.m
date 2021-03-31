function U = PotentialCalc(X, Y, Z, P,slice_x, slice_y, slice_z, delta_x, delta_y, delta_z, c_0, c_p, f, rho_0, rho_p, V_p) %c_0�͔}���̉���, f�͉��g�̎��g��, rho_p�͔������̖̂��x, rho_0�͔}���̖��x, V_p�͔������̂̑̐�
    
%     sizeX = size(P,1); sizeY = size(P,2); sizeZ = size(P,3);
%     P2 = P(2:sizeX-1,2:sizeY-1,2:sizeZ-1); % �|�e���V�����v�Z�p�̂��߂ɔz��̃T�C�Y�𒲐�
%     X2 = X(2:sizeX-1,2:sizeY-1,2:sizeZ-1); Y2 = Y(2:sizeX-1,2:sizeY-1,2:sizeZ-1); Z2 = Z(2:sizeX-1,2:sizeY-1,2:sizeZ-1);
%     
     
    
    figure %�e�X�g�p
    slice_P = slice(X,Y,Z,P,slice_x, slice_y, slice_z);
    title('test P');
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 20); set(slice_P,'LineStyle','none')
    
    %���S����(��Ԕ���)
%     PX1 = P(1:sizeX-2,2:end-1,2:end-1); PX2 = P(3:sizeX,2:end-1,2:end-1);
%     p_x = (PX2-PX1)./(2*delta_x);
%     PY1 = P(2:end-1,1:sizeY-2,2:end-1); PY2 = P(2:end-1,3:sizeY,2:end-1);
%     p_y = (PY2-PY1)./(2*delta_y);
%     PZ1 = P(2:end-1,2:end-1,1:sizeZ-2); PZ2 = P(2:end-1,2:end-1,3:sizeZ);
%     p_z = (PZ2-PZ1)./(2*delta_z);
    [p_x, p_y, p_z] = gradient(P,delta_x,delta_y,delta_z);
    
%     figure % �e�X�g�p
%     slice(X,Y,Z,p_x,slice_x, slice_y, slice_z);
%     
    laplacianP = p_x.^2+p_y.^2+p_z.^2;
    
    figure % �e�X�g�p
    slice(X,Y,Z,laplacianP,slice_x, slice_y, slice_z);
    title('test Laplacian P');
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 20);
    
    %�|�e���V�����̌v�Z
    omega = 2*pi*f;
    K_1 = 1/2*V_p*(1/(c_0^2*rho_0) - 1/(c_p^2*rho_p));
    K_2 = 3/2*V_p*( (rho_p-rho_0)/(omega^2*rho_0*(rho_0+2*rho_p)) );
    U = K_1*P.^2 - K_2*laplacianP;
    
    figure % �e�X�g�p
    s = slice(X,Y,Z,U,slice_x, slice_y, slice_z);
    title('test Potential U');
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 20);
    colorbar
    
    hold on 
    
    %Force�̌v�Z
    % matlab��gradient���g�p���Ă݂�
    [F_x, F_y, F_z] =  gradient(U,delta_x,delta_y,delta_z);
    F_x = -F_x; F_y = -F_y; F_z = -F_z;
    figure
    slice(X,Y,Z,F_x,slice_x, slice_y, slice_z);
    title('F_x by potential U');
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 20);
    colorbar
    
    
    
    figure
    slice(X,Y,Z,F_y,slice_x, slice_y, slice_z);
    title('F_y by potential U');
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 20);
    colorbar
    
    figure
    slice(X,Y,Z,F_z,slice_x, slice_y, slice_z);
    title('F_z by potential U');
    ax = gca;
    ax.XLabel.String = 'x-Axis (mm)';
    ax.YLabel.String = 'y-Axis (mm)';
    ax.ZLabel.String = 'z-Axis (mm)';
    set(ax,'FontSize', 20);
    colorbar

    % �|�e���V�������z�ɂ��3�������v���b�g
%     figure
%     quiver3(X2,Y2,Z2,F_x,F_y,F_z);
%     title('Potential gradient');
%     ax = gca;
%     ax.XLabel.String = 'x-Axis (mm)';
%     ax.YLabel.String = 'y-Axis (mm)';
%     ax.ZLabel.String = 'z-Axis (mm)';
%     set(ax,'FontSize', 20);

    %ZeroPosiQuiver; % x=y=z=0�n�_�ł�Quiver�v���b�g
%     ZeroPosiQuiver3;
%     %Force�̌v�Z(���Ɛ�gradient���g�p�����ꍇ)
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