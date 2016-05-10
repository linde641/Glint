function curve = adjust_noise(curve, noise_factor)
% noise_factor should be a decimal (percentage of the max value of curve)
% noise factor should usually be less than .05

range = max(curve);

for i = 1:length(curve)   
    
    rand_1 = rand();
    rand_2 = rand();
    if (rand_1 < .5)
        rand_2 = -rand_2;
    end
    
    curve(i) = curve(i) + rand_2 * noise_factor * range;
end
