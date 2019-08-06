function [weight] = weightFunctionAngle(x,y,pars)
    
    % Rotation matrix
    theta = pars(1);
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    
    
    % Center at the point
    x = x-pars(2);
    y = y-pars(3);
    
    % Rotate
    coords = [x;y]' * R;
    
    x = coords(:,1);
    y = coords(:,2);
    
    weight = y.^2 + 0.1*(x.^2);
    weight = sum(weight);
end

