% This function performs the maximum likelihood association and outlier detection given a single measurement.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           z_i(t)              2X1
% Outputs: 
%           c(t)                1X1
%           outlier             1X1
%           nu^i(t)             2XN
%           S^i(t)              2X2XN
%           H^i(t)              2X3XN
function [c, outlier, nu, S, H] = associate(mu_bar, sigma_bar, z_i)

    % Import global variables
    global Q % measurement covariance matrix | 1X1
    global lambda_m % outlier detection threshold on mahalanobis distance | 1X1
    global map % map | 2Xn
    
    for i = 1: size(map,2)
        z_j = observation_model(mu_bar, i);
        H(:,:,i) = jacobian_observation_model(mu_bar, i, z_j); 
        S(:,:,i) = H(:,:,i)*sigma_bar*H(:,:,i)' + Q;
        nu(:,i) = z_i-z_j;
        nu(2,i) = mod(nu(2,i)+pi,2*pi)-pi;
        phi(i) = det(2*pi*S(:,:,i))^(-0.5)*exp(-0.5*(nu(:,i)'/S(:,:,i))*nu(:,i))
    end
    
    [val, c] = max(phi);
    outlier = logical((nu(:,c)'/S(:,:,c))*nu(:,c) >= lambda_m);
        
        
end