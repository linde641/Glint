function [results, varargout] = get_results_revert(trial_count, varargin)
% varargin{1}: 'coeff' argument to be passed to simulate_glint 
% varargin{2}: save_path for results. use '' to skip saving
% varargin{3}: sine_exp for sample_curve
% varargin{4}: e_exp for sample_curve
% varargin{5}: noise_factor for sample_curve
% varargout: cell array of corr values for comparison

global c;
c = 299792458;
max_dist = 10^9;
[observers, bursts] = randomize_coordinates(trial_count, max_dist);

num_args = length(varargin);

%% default parameter settings:
points = 1000;
results = 0;
noise_factor = 0.01;
sine_exp = 2;
e_exp = 1;

%% custom parameter settings
if (num_args >= 1)
    type = varargin{1}; % can be '' to not use 
end
if (num_args >= 2)
    save_path = varargin{2};
end
if (num_args >= 3)
    sine_exp = varargin{3};
end
if (num_args >= 4)
    e_exp = varargin{4};
end
if (num_args >= 5)
    noise_factor = varargin{5};
end

%% body

time_list = [10^-3, 10^-4, 10^-5, 10^-6, 10^-7, 10^-8];% 9*10^-9, 8*10^-9, 7*10^-9, 6*10^-9, 5*10^-9];

for i = 1:length(time_list)
    time_res = time_list(i);
    disp(time_res);
    trials = zeros(trial_count, 1);
    tic
    for j = 1:length(trials);
        disp(j)        
        a = sample_curve(points, sine_exp, e_exp, noise_factor);
        b = sample_curve(points, sine_exp, e_exp, noise_factor);
        
        if (strcmp( type, 'coeff') )   %% run xcorr with 'coeff' arg      
            [~, dist, ~, dist_theory, corr] = simulate_glint_nopad(time_res, observers{j, 1}, observers{j, 2}, bursts{j}, a, b, 'coeff');           
            varargout{1} = corr; % this will override so only last trial corr is saved
        else
            [~, dist, ~, dist_theory] = simulate_glint_nopad(time_res, observers{j, 1}, observers{j, 2}, bursts{j}, a, b);    
        end
        
        error = abs(dist - dist_theory);
        trials(j) = error; 
        
    end
    results(i , 1) = time_res;
    results(i , 2) = mean(trials);    
    results(i , 3) = std(trials);    
    points = points * (time_list(i)/time_list(i+1));
    disp(results(i, 2));
    
    if ( ~strcmp( save_path, '' ))
        save( save_path, results);
    end
       
    toc
end
