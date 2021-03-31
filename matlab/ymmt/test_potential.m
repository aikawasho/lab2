%ポテンシャルの計算
range = 50; range_N = 101; f = 40000;
xx = linspace(-range, range, range_N); 
yy = linspace(-range, range, range_N);
zz = linspace(-range, range, range_N);
[X,Y,Z] = meshgrid(xx,yy,zz);
slice_x = 0; slice_y = 0; slice_z = 0; 
delta_x = 2*range/range_N*10^(-3); delta_y = 2*range/range_N*10^(-3); delta_z = 2*range/range_N*10^(-3);
c0 = 343; c_iron = 5120; rho_0 = 1.2; rho_iron = 1700; % 発砲ポリスチレンは密度と速度がわからないの金属とした（かなりアバウト）
V_p = 4/3*pi*(1.5*10^(-3))^3; % 3mmポリスチレン
PotentialGradientQuiver(X,Y,Z,P,slice_x, slice_y, slice_z, delta_x, delta_y, delta_z, c0, c_iron,f,rho_0, rho_iron ,V_p);