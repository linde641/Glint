%% script to automate the testing of error as a function of shape
% basically need to generate random coordinates, run simulate_glint -coeff
% with different parameters passed for the two curves and get the errors. 
% Then I can just check if the max corr value is in a certain small range
% of values and if so keep those results, if not continue to change the
% curve parameters more and run it through simulate_glint again.

noise_factors = .01:.02:.2;
trials = 25;
results_cells = cell( length(noise_factors), 1);

for i = 1:length(noise_factors)
    disp('noise_factor:')
    disp(noise_factors(i) );
    save_path = sprintf('results_noise_factor_%i.mat', noise_factors(i)*100);
    [results] = get_results(trials, '', save_path , 2, 1, noise_factors(i) );
    results_cells{i} = results;
end