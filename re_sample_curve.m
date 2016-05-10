% code to re-sample a given curve at new rate 
function re_sample = re_sample_curve(curve, old_time_res, new_time_res, noise_factor)

factor = old_time_res/new_time_res;

if ( mod(factor, 1) ) %if factor isn't an integer
    disp('the ratio old_time_res/new_time_res must be an integer');
    return;
end

if ( noise_factor == 0)
    disp('noise factor cant be zero');
    return;
end

%% need to re-write for when factor == 1

re_sample = zeros(factor * length(curve), 1 );

for i=1:(length(curve) - 1)           
    rand_2 = randn;
    
    range = curve(i+1) - curve(i);
    avg = range/2 + curve(i);
    new_pt = avg + rand_2 * range/2 * noise_factor;   
    
    new_index_mapped = (i-1)*2 + 1;    
    re_sample(new_index_mapped) = curve(i); % copy the original values into their mapped places
    re_sample(new_index_mapped + 1) = new_pt; % place interpolated values in between originals
end

re_sample(new_index_mapped + 2) = curve(length(curve));
end