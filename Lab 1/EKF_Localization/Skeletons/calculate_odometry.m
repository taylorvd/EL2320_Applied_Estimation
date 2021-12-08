% This function calculates the odometry information.
% Inputs:
%           e_L(t):         1X1
%           e_R(t):         1X1
%           E_T:            1X1
%           B:              1X1
%           R_L:            1X1
%           R_R:            1X1
%           delta_t:        1X1
%           mu(t-1):        3X1
% Outputs:
%           u(t):           3X1
function u = calculate_odometry(e_R, e_L, E_T, B, R_L, R_R, delta_t, mu)
    if ~delta_t
        u = [0;0;0];
        return;
    end

    w_R = (2*pi*e_R)/(E_T*delta_t);   
    w_L = (2*pi*e_L)/(E_T*delta_t);
    
    w_t = (w_R*R_R-w_L*R_L)/B;
    v_t = (w_R*R_R+w_L*R_L)/2;


    u = [v_t*delta_t*cos(mu(3));
        v_t*delta_t*sin(mu(3));
        w_t*delta_t];
     
     return;

end