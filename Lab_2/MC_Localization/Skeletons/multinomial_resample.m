% This function performs multinomial re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = multinomial_resample(S_bar)

    global M % number of particles

    SbarX = S_bar(1:3,:);
 
    cdf = cumsum(S_bar(4,:));
    S = zeros(size(SbarX));
    
    for m = 1 : M
        r_m = rand(1,M);
        i = find(cdf >= r_m,1,'first');
        S(1:3,m) = SbarX(1:3,i);
    end
    S(4,:) = 1/M*ones(1,M);

end


