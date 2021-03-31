% % first simu
% clear
% zp = 0;
% nameIndex = 1;
% range = 3*8.5;
% range_N = 101;
% movefilename = 'tR100N440'; saveName = '181224t';
% hemis_r = 100;
% xslice=0;
% yslice=0;
% zslice=0;
% sp_number = 440;
% titleName = '';
% 
% % bottleTrap_Exp(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName);
% TwinTrap_Exp(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName);

%%
clear
% cd 'G:\MATLAB\Ultrasonic\ultrasonic_simu3Dfocus_exp\BottleTrap'
zp = 0;
nameIndex = 1;
range = 3*8.5;
range_N = 101;
movefilename = 'R50N80'; saveName = '190114';
hemis_r = 95;
xslice=0;
yslice=0;
zslice=0;
sp_number = 500;
titleName = '';

% bottleTrap_Exp(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName);
% for phase = linspace(0,2*pi,30)

for phase = 0:30:360
    titleName = strcat('\phi = ',num2str(phase));
    TwinTrap_Exp_2_PhaseCtrl(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName,phase);
end
%%
% clear
% % cd 'G:\MATLAB\Ultrasonic\ultrasonic_simu3Dfocus_exp\BottleTrap'
% zp = 0;
% nameIndex = 1;
% range = 3*8.5;
% range_N = 101;
% movefilename = 'R50N11'; saveName = '190103';
% hemis_r = 50;
% xslice=0;
% yslice=0;
% zslice=0;
% sp_number = 114;
% titleName = '';
% 
% % bottleTrap_Exp(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName);
% TwinTrap_Exp_2(zp, range, range_N, hemis_r, xslice, yslice, zslice, sp_number, saveName, movefilename, titleName);