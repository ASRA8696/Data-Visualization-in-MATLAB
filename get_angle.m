function [a, flag] = get_angle(x, y)
% This function returns the angle with respect to x axis on a xy plane.
% x - x coordinates, column vector.
% y - y coordinates, column vector.
% a - the angle in rad.
% flag - 1 if error, 0 if succeeds.
%


% ============ Constants. =============

LOC_SMALL_VALUE = 1e-20; % Local small value
TWO_PI          = 2 * pi;
ONE_SEC_PI      = pi / 2;

% ============ Initial argument check. ============

flag = 0;

[rX, cX] = size(x);
[rY, cY] = size(y);

if ( rX ~= rY )
    fprintf('The row numbers of x and y are not compatible.\n rX = %d, rY = %d\n', rX, rY)
    a = 0;
    return
end

if ( cX ~= 1 || cY ~= 1)
    fprintf('Only colume vectors are supported.\ncX = %d, cY = %d\n', cX, cY);
    a = 0;
    return;
end

a = zeros(rX, 1);

for I = 1:1:rX
    px = x(I,1);
    py = y(I,1);
    
    if ( abs(px) < LOC_SMALL_VALUE )
        if ( py > 0 )
            a(I,1) = ONE_SEC_PI;
        elseif ( py < 0 )
            a(I,1) = -ONE_SEC_PI;
        else
            fprintf('Error: Wrong x y. I = %d, x = %e, y = %e\n',...
                I, px, py);
            a(I,1) = 0;
            flag = 1;
        end
        
        continue;
    end
    
    if ( px >0 && py >= 0 )
        % Phase 1.
        pa = atan( py / px );
    elseif ( px < 0 && py >= 0 )
        % Phase 2.
        pa = atan( py / px) + pi;
    elseif ( px < 0 && py < 0 )
        % Phase 3.
        pa = atan( py / px ) + pi;
    elseif ( px > 0 && py < 0 )
        % Phase 4.
        pa = atan( py / px ) + TWO_PI;
    end
    
    a(I,1) = pa;
end % I