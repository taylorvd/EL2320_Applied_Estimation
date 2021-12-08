% This function performs the ML data association
%           S_bar(t)                 4XM
%           z(t)                     2Xn
%           association_ground_truth 1Xn | ground truth landmark ID for
%           every measurement  1 (actually not used)
% Outputs: 
%           outlier                  1Xn    (1 means outlier, 0 means not outlier) 
%           Psi(t)                   1XnXM
%           c                        1xnxM (actually not ever used)
function [outlier, Psi, c] = associate(S_bar, z, association_ground_truth)
    if nargin < 3
        association_ground_truth = [];
    end

    global lambda_psi % threshold on average likelihood for outlier detection
    global Q % covariance matrix of the measurement model
    global M % number of particles
    global N % number of landmarks
   
   global DATA_ASSOCIATION
   global landmark_ids
    % YOUR IMPLEMENTATION

    zhat = zeros(2,M,N);
    for k = 1:N
        %every particle has its
        %own measurement to each landmark
        %('page' in 3D array = matrix of measurements for
        % each particle)
        z_hat(:,:,k) = observation_model(S_bar,k);
    end   
    
    Qinv = inv(Q);
    Qdet = det(Q);
    n = size(z,2);
    PsiTemp = zeros(n,M,N);
    Psi = zeros(n,M);
    c = ones(n,M);
    outlier = zeros(1,n);
    
    %for every model measurement
     for i=1:n
        %for every particle
        for m=1:M
        %for every landmark
            for k=1:N
                %calculate nu, innovation = model-predicted measurement
                nu=z(:,i)-z_hat(:,m,k);
                nu(2)=mod(nu(2)+pi,2*pi)-pi;
                
                %calc likelihood of every measurement of every landmark
                %fromevery particle
               
                in_exp = -0.5.*(nu)'*Qinv*(nu);
                PsiTemp(i,m,k) = (1/(2*pi*Qdet.^0.5))*exp(in_exp);
            end
             %find the most likely landmark for each particles measurement
             max_ind = find(PsiTemp(i,m,:) == max(PsiTemp(i,m,:)));
             c(i,m) = max_ind(1);
               
             Psi(i,m) = PsiTemp(i,m,c(i,m));
            
        end

        %if the most likely landmark is an outlier, remove
        outlier(i) = mean(Psi(i,:)) <= lambda_psi;
     end
    Psi=reshape(Psi,[1 n M]);
    c = reshape(c,[1 n M]);
    outlier = reshape(outlier, [1 n]);

        
   if DATA_ASSOCIATION=="Off"
       index=find([landmark_ids==association_ground_truth(i)]);
       c(1,i,:)=repmat(index,1,1,M);
       Psi(1,i,:)=psi_temp(1,index,:);
   end
end
