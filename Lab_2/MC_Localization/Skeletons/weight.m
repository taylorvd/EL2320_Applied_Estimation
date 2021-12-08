% This function calcultes the weights for each particle based on the
% observation likelihood
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar, Psi, outlier)

    Psi_final = Psi(1, find(~outlier), :);
    
    p = prod(Psi_final,2);
    
    p = p/sum(p);
    
    S_bar(4,:) = p;
 

end
