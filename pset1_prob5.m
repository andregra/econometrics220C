clc;
N = 500;
K=5;
nreplic = 1000;

beta_hat = zeros(nreplic,1);
sigma_beta1 =  zeros(nreplic,1);
sigma_beta2 =  zeros(nreplic,1);

for T = [5,10,20];
for replic = 1:1:nreplic;
    
    x = randn(T,N*K);
    sigma = 2*abs(x);
    e = sigma.*randn(T,N*K);
    y = x + e;
    
    
    y = y - repmat(mean(y),T,1);
    x = x - repmat(mean(x),T,1);
    
    yy = y'; 
    xx = x'; 
    
    xx = xx(:); 
    yy = yy(:); 

    
    beta_hat(replic) = xx\yy;  
    e_hat = y - x*beta_hat(replic);
                                 
  
    
    sigma_beta1(replic) = sqrt((xx'*xx)^(-2)*sum( sum(x.*e_hat).^2));
    sigma_beta2(replic) = sqrt((xx'*xx)^(-2)*sum(sum ( (x.^2).*(e_hat.^2) )));
end

 disp('run of T =');
 disp(T);
%a
[mean(sigma_beta1) mean(sigma_beta2)] 

%b
[std(beta_hat)]

%c
[mean(mean(sigma_beta1)-std(beta_hat)) , std(sigma_beta1) , sqrt((mean(sigma_beta1)-std(beta_hat))^2 +std(sigma_beta1)^2)] 
[mean(mean(sigma_beta2)-std(beta_hat)) , std(sigma_beta2), sqrt((mean(sigma_beta2)-std(beta_hat))^2 +std(sigma_beta2)^2)]
%the beta 1 estimator is the better estimator by these criteria

end

%d) as T grows, the relative rmse advantage shrinks so that the two estimators
%perform similarly 

