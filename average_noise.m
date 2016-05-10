function a = average_noise(a, window)
% evenly distributes photons in each window so as to average out the
% effects of the gaussian noise.
% window is the percentage of the curve length to be used for each window

len = length(a);
window = round(window * len);
if window < 100
    disp('window is less than 100');
    a = 0;
    return;
end
window_start = 1;
photons = 0;

for i = 1:len
    photons = photons + a(i);
    
    if mod(i, window) == 0        
         
        avg_density = photons/window;
        a(window_start:i) = 0;        
        f1 = floor(1/avg_density);
        f2 = ceil(1/avg_density);
        density = 0;
        index = window_start;
        current_sum = 0;
        
        for j = 1:photons
            if (density < avg_density)
                a(index + f1 - 1) = a(index + f1 - 1) + 1;
                index = index + f1;
            else
                a(index + f2 - 1) = a(index + f2 - 1) + 1;
                index = index + f2;
            end
            current_sum = current_sum + 1;
            density = current_sum/(index - window_start);
            
            if (index >= window_start + window)                
                break;
            end
        end
        
        window_start = i + 1; 
        photons = 0;
    end        
end