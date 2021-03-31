% 改良　for文をなくし、行列計算にした

function Phailist = makePhaiList2(x0,y0,z0,vx,vy,vz,X,Y,Z)
    Phailist = zeros(length(X),length(Y),length(Z));
%    sp_vector = [vx vy vz];
%     for i = 1:length(X)
%         for j = 1:length(Y)
%             for k = 1:length(Z)
%                 xyz_vector = [X(i,j,k)-x0,Y(i,j,k)-y0,Z(i,j,k)-z0];
%                 Phailist(i,j,k) = acos(dot(sp_vector, xyz_vector)/(norm(sp_vector)*norm(xyz_vector))) ;
%             end
%         end
%     end
    norm_v = norm([vx vy vz]);
    X2 = X-x0;
    Y2 = Y-y0;
    Z2 = Z-z0;
    normXYZ = sqrt(X2.^2 + Y2.^2 + Z2.^2);
    Phailist(:,:,:) = acos((vx.*X2 + vy.*Y2 + vz.*Z2)./(norm_v.*normXYZ));
end