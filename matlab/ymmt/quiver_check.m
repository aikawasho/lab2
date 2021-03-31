% quiverの数をカウントするプログラム

ax = gca;
axChildren = ax.Children;
num_quiver = length(axChildren);

num_blue = 0; 
num_red = 0;
num_magenta = 0;
num_cyan = 0;
for i = 1:num_quiver
    thisQuiver = axChildren(i);
    thisColor = thisQuiver.Color;
    if thisColor == [0 0 1]
        num_blue = num_blue+1;
    elseif thisColor == [1 0 0]
        num_red = num_red+1;
    elseif thisColor == [1 0 1]
        num_magenta = num_magenta+1;
    elseif thisColor == [0 1 1]
        num_cyan = num_cyan+1;
    else
        warning('なぞの色のquiverもしくはquiverでは無い何かがありますよ。')
    end
end

disp('blue');
disp(num_blue);
disp('red');
disp(num_red);
disp('magenta');
disp(num_magenta);
disp('cyan');
disp(num_cyan);