
clear;
global c;
c = 299792458;
max_dist = 10^9;

trial_count = 1;

[observers, bursts] = randomize_coordinates(trial_count, max_dist);

%% default parameter settings:
%points = 1000;
results = 0;
noise_background = 0;
noise_transmission = 5;
sine_exp = 2;
e_exp = 1;
type = '';
save_path = 'results_12_22_many_photons.mat';

%% body

time_list = [ .064, .032, .016, .008, .004, .002, .001, 10^-4, 5*10^-5, 10^-5, 5*10^-6, 10^-6, 10^-7, 8* 10^-8, 6*10^-8, 4*10^-8, 2*10^-8];
%time_list = [4*10^-6, 10^-6,8*10^-7, 5*10^-7, 7*10^-7, 10^-7]';
%time_list = 5*10^-8;
[time_list, points_list] = translate_res_to_points(time_list, 1);

for i = 1:length(time_list)
    time_res = time_list(i);
    points = points_list(i);
    disp(time_res);
    trials = zeros(trial_count, 2);
    tic
    for j = 1:size(trials, 1);
        disp(j)        
        
        a = sample_curve_new(points, sine_exp, e_exp, noise_background, noise_transmission);
        b = sample_curve_new(points, sine_exp, e_exp, noise_background, noise_transmission);
        %a = average_noise(a, .01);
        %b = average_noise(b, .01);
        
        
        if (strcmp( type, 'coeff') )   %% run xcorr with 'coeff' arg      
            [~, dist, ~, dist_theory, corr] = simulate_glint_nopad(time_res, observers{j, 1}, observers{j, 2}, bursts{j}, a, b, 'coeff');           
            varargout{1} = corr; % this will override so only last trial corr is saved
        else
            [~, dist, ~, dist_theory, distflip] = simulate_glint_nopad(time_res, observers{j, 1}, observers{j, 2}, bursts{j}, a, b);    
        end
       
        error = abs(dist - dist_theory);
        errorflip = abs(distflip - dist_theory);                
        
        trials(j, 1) = error;         
        trials(j, 2) = errorflip;
    end
    results(i , 1) = time_res;
    results(i , 2) = mean(trials(:, 1));    
    results(i , 3) = std(trials(:, 1));    
    results(i, 4) = mean(trials(:, 2));
    results(i, 5) = std(trials(:, 2));
    
    if ( i ~= length(time_list) )
        points = points * (time_list(i)/time_list(i+1));
    else
        
    end
    disp(results(i, 2));
    
    if ( ~strcmp( save_path, '' ))
        save( save_path, 'results');        
    end
    %}   
    toc
end


