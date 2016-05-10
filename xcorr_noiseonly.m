function [lag, lagcounts] = xcorr_noiseonly(points, peak, peak_pos)

a = zeros(points, 1);
lagcounts = 0;

for i=1:points
    if mod(i, 20) == 0
        a(i) = 1;        
    end
end

a(round(peak_pos*points)) = peak;

b = a;

% jitter the signal 
for i = 2:points-1
    
    if a(i) == 1        
        if rand >= .5            
            a(i+1) = 1;
        else
            a(i-1) = 1;
        end
        a(i) = 0;
    end
    if b(i) == 1
        if rand >= .5
            b(i+1) = 1;
        else
            b(i-1) = 1;
        end
        b(i) = 0;
    end
end
%}

[corr, lags] = xcorr(a, b);
lag = lags(corr == max(corr));
[rows, cols] = size(lag);
if ( rows > 1 || cols > 1)
    lagcounts = max(rows, cols);
    lag = max(abs(lag));
end

