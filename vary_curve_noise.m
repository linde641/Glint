function curve_out = vary_curve_noise(curve, noise_factor)

curve_out = curve;
%prev_pt = curve_out(1); %set for first range computation
span = ceil(.01*length(curve_out));
low_i = 1;
high_i = ceil(span);
low_v = min(curve_out(low_i:high_i));
high_v = max(curve_out(low_i:high_i));

for i=1:(length(curve_out) - 1)           
    %disp(i)
    gaus = randn;                       
            
    if (i > span/2)
        low_i = low_i + 1;
        high_i = high_i + 1;
        low_v = min(low_v, curve(i));
        high_v = max(high_v, curve(i));
    end        
        
    %range = max(curve(indicies)) - min(curve(indicies));           
    range = ceil(high_v - low_v);
    new_pt_add = gaus * range/2 * noise_factor;   
    new_pt = curve_out(i) + new_pt_add;
    %prev_pt = curve_out(i); %saving this value for the next iteration's range computation
    curve_out(i) = new_pt;     
end