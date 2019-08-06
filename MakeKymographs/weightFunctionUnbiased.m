function [weight] = weightFunctionUnbiased(xx,yy,pars)
    
    % Rotation matrix
    theta = pars(1);
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    
    
    % Center at the point
    xx = xx-pars(2);
    yy = yy-pars(3);
    
    % Rotate
    coords = [xx yy] * R;
    
    xx = coords(:,1);
    yy = coords(:,2);
    
    expected = 0;
    weight = abs(expected-yy) + abs(xx);
end

