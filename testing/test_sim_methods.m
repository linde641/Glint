%% script to test whether the two simulation methods (padding /no padding) give the same results
% going to generate 100 curves and generate results from both methods and
% compare them
pt_a = [100000000 100000000 0];
pt_b = [-100000000 100000000 0];    
burst = [1 0 0];
c = 299792458;
time_res = .064;
points = 50;
time = time_res * points;
[tdoa_theory, dist_theory ] = tdoa_compute(pt_a, pt_b, burst);
errors = cell(10,1);
j = 1;
trials = 50;

while time_res > 10^-6
    
    errors{j} = zeros(trials, 1);
    disp(time_res);
    
    tic
    for i = 1:trials
        disp(i);
        a = sample_curve(points, time, 2, 1);
        b = sample_curve(points, time, 2, 1);
        [tdoa_pad, dist_pad, ~,~] = simulate_glint(time_res, pt_a, pt_b, burst, a, b);
        [tdoa, dist, ~,~] = simulate_glint_nopad(time_res, pt_a, pt_b, burst, a, b);
        error_pad = abs(dist_pad - dist_theory);
        error_nopad = abs(dist - dist_theory);
        
        if (error_pad ~= error_nopad)
            errors{j}(i) = abs(error_pad - error_nopad);  
        end
    end
    toc
    j = j+1;
    time_res = time_res/4;
    points = points*4;
end

    
