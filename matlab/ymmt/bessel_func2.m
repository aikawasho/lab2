% theta_list が０のときはDが無限をとってしまうので改良
function D = bessel_func2(k,a,theta_list)
    exceed_90 = double(theta_list < pi/2); % 90度超えたものは0としてしまう
    D = 2.*besselj(1,k*a.*sin(theta_list)) ./ (k*a.*sin(theta_list));
    D = exceed_90.*D;
    D(isnan(D)) = 1; % nanを含んでいる要素はinfなので1とする
end