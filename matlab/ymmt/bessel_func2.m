% theta_list ‚ª‚O‚Ì‚Æ‚«‚ÍD‚ª–³ŒÀ‚ð‚Æ‚Á‚Ä‚µ‚Ü‚¤‚Ì‚Å‰ü—Ç
function D = bessel_func2(k,a,theta_list)
    exceed_90 = double(theta_list < pi/2); % 90“x’´‚¦‚½‚à‚Ì‚Í0‚Æ‚µ‚Ä‚µ‚Ü‚¤
    D = 2.*besselj(1,k*a.*sin(theta_list)) ./ (k*a.*sin(theta_list));
    D = exceed_90.*D;
    D(isnan(D)) = 1; % nan‚ðŠÜ‚ñ‚Å‚¢‚é—v‘f‚Íinf‚È‚Ì‚Å1‚Æ‚·‚é
end