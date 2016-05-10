function [curve, shape] = generate_curve(points ,start_x, peak_x, peak_height)
%% generate "real" curve
% start_x and peak_x should be given as a percentage (decimal) between 0-1
% noise_level can be any positive number
% points is basically the sampling frequency

points = points - 1;

args = 0:pi/points:pi;
curve = sin(args)';
noise = zeros(points+1, 1);
shape = ones(points+1, 1);
start_x = ceil(start_x * points);
peak_x = ceil(peak_x * points);

slope_up = (peak_height - 1)/(peak_x - start_x);
slope_down = (1 - peak_height)/((length(args)-peak_x) );

for i = 1:points
    random = rand;
    new_random = randn;
    
    if ( i > start_x && i <= peak_x)       
        shape(i) = slope_up*(i - start_x);
    elseif (i > peak_x && i <= length(args) )
        shape(i) = shape(peak_x) + slope_down*(i - peak_x);
    end
    if (shape(i) < 1)
        shape(i) = 1;
    end
    
    
    if (random >= 0.5)        
        new_random = -new_random;        
    end
    noise(i) = new_random;
end

%noise = noise.*shape;
curve = curve.*shape;
curve = adjust_noise(curve, .02);
%curve_noise = curve + noise;
%figure;
%plot(curve_noise);

end
%% now sample the curve at set intervals to create data curve
%now I have generated data sets of photon counts at each time interval and
%the idea now is to generate sets with more or less sampling, in other
%words different values of "points". This represents the sampling
%frequency. If the curve is sampled less, we are less likely to have
%actually observed the true peak. Then run these through xcorr and do some
%other stuff




