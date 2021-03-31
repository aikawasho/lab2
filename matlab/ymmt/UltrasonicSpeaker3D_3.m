% indexを追加

classdef UltrasonicSpeaker3D_3
   
    properties(Constant)
       PI = pi
       
    end
    
    
    properties 
       x0
       y0
       z0
       v_x
       v_y
       v_z
       
       v = 340*1000  % v[mm/s] 
       phase = 0
       frequency
       ramda = 0
       wavenum = 0
       angle_phai = 0
       angle_theta = 0
       qui_color = 'black'
       row_number = 1 %半球状にした時の列の番号
       index
    end
   
   methods
       
       function obj = UltrasonicSpeaker3D_3(x,y,z,fx,fy,fz,frequency) % fxfyfzは焦点(スピーカが向いてほしい方向)
           obj.x0 = x;
           obj.y0 = y;
           obj.z0 = z;
           obj.v_x = fx-obj.x0;
           obj.v_y = fy-obj.y0;
           obj.v_z= fz-obj.z0;
           obj.frequency = frequency;
           obj.ramda = obj.v/frequency;
           obj.wavenum = 2*pi/obj.ramda;
       end
       
       
   end
   
end