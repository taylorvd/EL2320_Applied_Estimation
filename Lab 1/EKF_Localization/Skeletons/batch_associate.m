% This function performs the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           z(t)                2Xn
% Outputs: 
%           c(t)                1Xn
%           outlier             1Xn
%           nu_bar(t)           2nX1
%           H_bar(t)            2nX3
function [c, outlier, nu_bar, H_bar] = batch_associate(mu_bar, sigma_bar, z)
       
for i= 1:size(z,2) 
    
[c_a, outlier_a, nu_a, S_a, H_a] = associate(mu_bar, sigma_bar, z(:,i))

outlier(i) = outlier_a;
c(i) = c_a;

nu_bar_a = nu_a(:,c_a);
nu_bar_a(2,:) = mod(nu_bar_a(2,:)+pi,2*pi)-pi;

index = 2*i - 1;

nu_bar(index:index+1, :) = nu_bar_a;
H_bar(index:index+1,:) = H_a(:,:,c_a);


end


end