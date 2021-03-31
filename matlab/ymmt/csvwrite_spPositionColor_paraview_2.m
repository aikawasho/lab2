% paraview用にスピーカの位置をcsvの書きだし
% csvの書き出し
howmany_sp = length(sp_list);
csv_w = cell(howmany_sp+1,7);
csv_w(1,:) = {'data_x', 'data_y', 'data_z', 'vector_x', 'vector_y', 'vector_z', 'color'};

csv_index = 2;
for i = 1:howmany_sp
    obj = sp_list(i);
%     if obj.qui_color == 'red'
    if strcmp(obj.qui_color, 'red')
%         csv_w(csv_index,:) = { strcat('[', num2str(obj.x0)), obj.y0, obj.z0, obj.v_x, obj.v_y, strcat(num2str(obj.v_z), '],')}; % matlabでのxy軸がparaviewではyx軸となるのでi,jを入れ替えてある
        csv_w(csv_index,:) = { strcat('[', num2str(obj.x0)), obj.y0, obj.z0, obj.v_x, obj.v_y, obj.v_z, 'red]'}; % matlabでのxy軸がparaviewではyx軸となるのでi,jを入れ替えてある
        csv_index = csv_index + 1;  
%     elseif obj.qui_color == 'blue'
    elseif strcmp(obj.qui_color, 'blue')
        csv_w(csv_index,:) = { strcat('[', num2str(obj.x0)), obj.y0, obj.z0, obj.v_x, obj.v_y, obj.v_z, 'blue]'}; % matlabでのxy軸がparaviewではyx軸となるのでi,jを入れ替えてある
        csv_index = csv_index + 1;    
    end
        
end

% for i = 1:howmany_sp
%     obj = sp_list(i);
%     if obj.qui_color == 'b'
%         csv_w(csv_index,:) = { strcat('[', num2str(obj.x0)), obj.y0, obj.z0, obj.v_x, obj.v_y, strcat(num2str(obj.v_z), '],')}; % matlabでのxy軸がparaviewではyx軸となるのでi,jを入れ替えてある
%         csv_index = csv_index + 1;  
%     end
%         
% end



csv_w_dataset = cell2dataset(csv_w);
export(csv_w_dataset,'File','TwinTrap_R100N440.csv','Delimiter',',')

