%% Script to estimate b at each site using bootstrap

clear

all_names = {'A1', 'C1', 'dpnmr_leque_east', 'dpnmr_leque_west', ...
  'dpnmr_larned_east', 'dpnmr_larned_west', 'dpnmr_larned_lwph'}; 

figureson = 1;

for k = 1:length(all_names)
    name = all_names{k}
    
    [d, K, T2ML, phi, z, SumEch, logK, logT2ML, logPhi, SumEch_3s, SumEch_twm, ...
    SumEch_twm_3s] = loadnmrdata2(name); 
    
    logSumEch = log10(SumEch); 
    
    %% Bootstrap
    % Randomly sample data with replacement, solve the subset for the
    % best-fitting parameter values, and repeat many times. 

    % m assumed 0; 
    n = 2; 
    m = 4; 
    Nboot =  2000; % number of bootstrap samples

    % Takes [log10(T2ML), log10(K)] or [log10(T2ML), log10(phi), log10(K)] as a
    % single matrix
    % [b_boot, n_boot, m_boot] = bootstrap_fun([lt,lp, kk], Nboot);         % m, n can vary
    % [b_boot, n_boot, m_boot] = bootstrap_fun([lt, lp, kk], Nboot, n);        % m can vary
    % [b_boot, n_boot, m_boot] = bootstrap_fun_mb([logT2ML, logK], Nboot);    % n can vary
     [b_boot, n_boot, m_boot] = bootstrap_fun([logT2ML, logPhi, logK], Nboot, n, m);   % m, n fixed

    if figureson ==1 
        bs = log10(b_boot); 
        graph_correlations([bs, n_boot], 2, {'log_{10}(b)', 'n'}, 1, 0)
    end
    
    
    meanb(k) = mean(b_boot)
    sortb = sort(b_boot); 
    blo(k) = sortb(50)
    bhi(k) = sortb(1950)
    
end