function speeker_quiver3(x0,y0,z0,vx,vy,vz,qui_color,size)
    n = norm([vx vy vz]); 
    vx = vx/n*size;
    vy = vy/n*size;
    vz = vz/n*size;
    
    qui = quiver3(x0, y0, z0,...
        vx,vy,vz);
    qui.Color = qui_color;
    qui.LineWidth = 2.0;
    qui.MaxHeadSize = 6.0;
    
end