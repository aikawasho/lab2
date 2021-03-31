% 改良　近似をしてその関数をもってくるというだけにした(2018/04/13)
%　 make_attenuation_list3D_3との近似の比較

function [a_func, x] = make_attenuation_list3D_3_2()
    %%減衰の計算（適当な近似）
    %ver2 では一次関数近似だったが、指数関数近似にする
    %xlist = [5.5	6	7	10	20	30	50	117	150	200	300	400	435	593	715];
    %plist = [883.8834765	714.177849	707.1067812	585.4844148	273.6503243	185.2619767	115.9655121	45.67909806	45.04270196	36.2038672	23.82949853	18.95046174	11.9501046	7.566042559	6.929646456];
    %fun = @(x,xlist)x(1)./(x(2)*xlist); %反比例 y = a/(b*x)　の関数
    xlist = [25	30	40	50	60	70	80	90	100	110	130	150	200];
    plist = [128.6934342	115.2584053	86.2670273	65.40737726	56.56854249	48.7903679	42.14356416	35.56747109	34.50681092	30.97127702	25.24371209	24.39518395	16.40487732];
    a_func = @(x,xlist)x(1)./xlist + x(2); %反比例 y = x0/x + x1　の関数
    x0 = [505,0]; %　とりあえず最初は y = 500/x + 0　とする
%     xlist = [50	117	150	200	300	400	435	593	715];
%     plist = [115.9655121	45.67909806	45.04270196	36.2038672	23.82949853	18.95046174	11.9501046	7.566042559	6.929646456];
%     fun = @(x,xlist)x(1)*xlist+x(2); %１次関数 y = a*x　の関数
%     x0 = [-1 1000]; %　とりあえず最初は y = 10e^x　とする

    x = lsqcurvefit(a_func,x0,xlist,plist); %勝手に一番良い近似をしてくれる

    % 近似の確認
%     figure
%     hold on
%     plot(xlist,plist);
%     plot(xlist,a_func(x,xlist));    
%     title('make_attenuation_list3D_3_2')
    
% 
%     %%減衰の計算（適当な近似）
%     a_list = zeros(length(X), length(Y), length(Z));
% %     for i = 1:length(X)
% %         for j = 1:length(Y)
% %             for k = 1:length(Z)
% %                 a_list(i,j,k) = fun(x,sqrt((X(i,j,k)-xx0)^2 + (Y(i,j,k)-yy0)^2 + (Z(i,j,k)-zz0)^2)); 
% %             end
% %         end
% %     end
% 
%     %距離空間
%     XYZ_D = sqrt( (X-xx0).^2 + (Y-yy0).^2 + (Z-zz0).^2 );
%     a_list = a_func(x,XYZ_D);
%     a_list = a_list ./ max(max(max(a_list))); %正規化（最大値を1にする） 
% 

end